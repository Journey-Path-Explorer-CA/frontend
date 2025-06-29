import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:frontend/views/viewmodels/astarviewmodel.dart';
import 'package:frontend/views/viewmodels/bellmanfordviewmodel.dart';
import 'package:frontend/views/viewmodels/dijkstraviewmodel.dart';
import 'package:provider/provider.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  late List<Map<String, dynamic>> dijkstraStops = [];
  late List<Map<String, dynamic>> aStarStops = [];
  late List<Map<String, dynamic>> bellmanFordStops = [];

  double dijkstraDistance = 0.0;
  double aStarDistance = 0.0;
  double bellmanFordDistance = 0.0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dijkstraVM = Provider.of<DijkstraViewModel>(context, listen: false);
      final aStarVM = Provider.of<AStarViewModel>(context, listen: false);
      final bellmanFordVM = Provider.of<BellmanFordViewModel>(context, listen: false);

      try {
        await Future.wait([
          _fetchRoute(dijkstraVM, 'dijkstra'),
          _fetchRoute(aStarVM, 'a-star'),
          _fetchRoute(bellmanFordVM, 'bellman-ford'),
        ]);

        setState(() {
          isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching routes: $e')),
        );
        Navigator.pop(context);
      }
    });
  }

  Future<void> _fetchRoute(dynamic viewModel, String algorithm) async {
    await viewModel.fetchRoute();
    switch (algorithm) {
      case 'dijkstra':
        setState(() {
          dijkstraStops = viewModel.stops;
          dijkstraDistance = viewModel.totalDistance;
        });
        break;
      case 'a-star':
        setState(() {
          aStarStops = viewModel.stops;
          aStarDistance = viewModel.totalDistance;
        });
        break;
      case 'bellman-ford':
        setState(() {
          bellmanFordStops = viewModel.stops;
          bellmanFordDistance = viewModel.totalDistance;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Algorithm Comparison")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Algorithm Comparison",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildDistanceComparison(),
            const SizedBox(height: 20),
            const Text("Routes on Map:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildMapLegend(),
            const SizedBox(height: 10),
            Expanded(
              child: ComparisonMap(
                dijkstraStops: dijkstraStops,
                aStarStops: aStarStops,
                bellmanFordStops: bellmanFordStops,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceComparison() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Dijkstra Distance: ${dijkstraDistance.toStringAsFixed(2)} km",
            style: const TextStyle(fontSize: 16, color: Colors.blue)),
        Text("A* Distance: ${aStarDistance.toStringAsFixed(2)} km",
            style: const TextStyle(fontSize: 16, color: Colors.green)),
        Text("Bellman-Ford Distance: ${bellmanFordDistance.toStringAsFixed(2)} km",
            style: const TextStyle(fontSize: 16, color: Colors.purple)),
      ],
    );
  }

  Widget _buildMapLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem("Dijkstra", Colors.blue),
        const SizedBox(width: 20),
        _buildLegendItem("A*", Colors.green),
        const SizedBox(width: 20),
        _buildLegendItem("Bellman-Ford", Colors.purple),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}

class ComparisonMap extends StatelessWidget {
  final List<Map<String, dynamic>> dijkstraStops;
  final List<Map<String, dynamic>> aStarStops;
  final List<Map<String, dynamic>> bellmanFordStops;

  const ComparisonMap({
    super.key,
    required this.dijkstraStops,
    required this.aStarStops,
    required this.bellmanFordStops,
  });

  @override
  Widget build(BuildContext context) {
    final dijkstraPoints = dijkstraStops
        .map((stop) => LatLng(stop['stop_lat'], stop['stop_lon']))
        .toList();

    final aStarPoints = aStarStops
        .map((stop) => LatLng(stop['stop_lat'], stop['stop_lon']))
        .toList();

    final bellmanFordPoints = bellmanFordStops
        .map((stop) => LatLng(stop['stop_lat'], stop['stop_lon']))
        .toList();

    // Use the first non-empty list for initial center
    final initialCenter = dijkstraPoints.isNotEmpty
        ? dijkstraPoints.first
        : aStarPoints.isNotEmpty
        ? aStarPoints.first
        : bellmanFordPoints.first;

    return FlutterMap(
      options: MapOptions(
        center: initialCenter,
        zoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        // Dijkstra route (blue)
        if (dijkstraPoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: dijkstraPoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
        // A* route (green)
        if (aStarPoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: aStarPoints,
                strokeWidth: 4.0,
                color: Colors.green,
              ),
            ],
          ),
        // Bellman-Ford route (purple)
        if (bellmanFordPoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: bellmanFordPoints,
                strokeWidth: 4.0,
                color: Colors.purple,
              ),
            ],
          ),
        // Markers for all stops
        MarkerLayer(
          markers: [
            ...dijkstraPoints.map((point) => Marker(
              point: point,
              width: 30,
              height: 30,
              child: const Icon(Icons.location_on, color: Colors.blue),
            )),
            ...aStarPoints.map((point) => Marker(
              point: point,
              width: 30,
              height: 30,
              child: const Icon(Icons.location_on, color: Colors.green),
            )),
            ...bellmanFordPoints.map((point) => Marker(
              point: point,
              width: 30,
              height: 30,
              child: const Icon(Icons.location_on, color: Colors.purple),
            )),
          ],
        ),
      ],
    );
  }
}