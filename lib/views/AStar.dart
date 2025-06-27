import 'package:flutter/material.dart';
import 'package:frontend/views/viewmodels/astarviewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AStar extends StatefulWidget {
  const AStar({super.key});

  @override
  State<AStar> createState() => _AStarState();
}

class _AStarState extends State<AStar> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<AStarViewModel>(context, listen: false);
      vm.fetchRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AStarViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("A*")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: viewModel.stops.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Resultado", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Distancia total: ${viewModel.totalDistance.toStringAsFixed(2)} km",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Ruta en el mapa:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: DijkstraMap(stops: viewModel.stops),
            ),
            const SizedBox(height: 20),
            const Text("Camino:", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.stops.length,
                itemBuilder: (context, index) {
                  final stop = viewModel.stops[index];
                  final stopName = stop["stop_name"];
                  final isStart = index == 0;
                  final isEnd = index == viewModel.stops.length - 1;

                  Color bgColor = Colors.white;
                  Color textColor = Colors.black;
                  if (isStart) {
                    bgColor = Colors.green;
                    textColor = Colors.white;
                  } else if (isEnd) {
                    bgColor = Colors.red;
                    textColor = Colors.white;
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      stopName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isStart || isEnd ? FontWeight.bold : FontWeight.normal,
                        color: textColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Volver"),
            )
          ],
        ),
      ),
    );
  }
}

class DijkstraMap extends StatelessWidget {
  final List<Map<String, dynamic>> stops;

  const DijkstraMap({super.key, required this.stops});

  @override
  Widget build(BuildContext context) {
    final List<LatLng> points = stops
        .map((stop) => LatLng(stop['stop_lat'], stop['stop_lon']))
        .toList();

    return FlutterMap(
      options: MapOptions(
        center: points.first,
        zoom: 14.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: points,
              strokeWidth: 4.0,
              color: Colors.red,
            ),
          ],
        ),
        MarkerLayer(
          markers: points.map((point) => Marker(
            point: point,
            width: 30,
            height: 30,
            child: const Icon(Icons.location_on, color: Colors.blue), // Cambia 'builder' por 'child'
          )).toList(),
        ),
      ],
    );
  }
}
