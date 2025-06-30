import 'package:flutter/material.dart';
import 'package:frontend/views/viewmodels/astarviewmodel.dart';
import 'package:frontend/views/viewmodels/bellmanfordviewmodel.dart';
import 'package:frontend/views/viewmodels/dijkstraviewmodel.dart';
import 'package:frontend/views/viewmodels/homeviewmodel.dart';
import 'package:provider/provider.dart';

import 'ComparisonScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeViewModel>(context, listen: false).fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Journey Path Connect'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Menu', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(Icons.home, size: 28),
                  SizedBox(width: 10),
                  Text('Home', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Spacer(),
            const Divider(thickness: 2),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Row(
                children: [
                  Icon(Icons.logout, size: 28),
                  SizedBox(width: 10),
                  Text('Cerrar Sesión', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text('Seleccione los filtros', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

            // Service Dropdown
            _buildDropdown(
              value: homeViewModel.selectedServiceId,
              items: homeViewModel.services,
              hint: 'Seleccione un servicio',
              isLoading: homeViewModel.isLoadingServices,
              displayText: (item) => 'Servicio ${item['service_id']}',
              onChanged: (value) {
                homeViewModel.setSelectedService(value);
              },
            ),
            const SizedBox(height: 20),

            // Trip Dropdown
            _buildDropdown(
              value: homeViewModel.selectedTripId,
              items: homeViewModel.trips,
              hint: 'Seleccione un viaje',
              isLoading: homeViewModel.isLoadingTrips,
              displayText: (item) => '${item['trip_headsign']} (${item['trip_id']})',
              onChanged: (value) {
                homeViewModel.setSelectedTrip(value);
              },
              isEnabled: homeViewModel.selectedServiceId != null,
            ),
            const SizedBox(height: 20),

            // Start Stop Dropdown
            _buildDropdown(
              value: homeViewModel.selectedStartStopId,
              items: homeViewModel.stops,
              hint: 'Seleccione parada inicial',
              isLoading: homeViewModel.isLoadingStops,
              displayText: (item) => item['stop_name'],
              onChanged: (value) {
                homeViewModel.setSelectedStartStop(value);
              },
              isEnabled: homeViewModel.selectedTripId != null,
            ),
            const SizedBox(height: 20),

            // End Stop Dropdown
            _buildDropdown(
              value: homeViewModel.selectedEndStopId,
              items: homeViewModel.stops,
              hint: 'Seleccione parada final',
              isLoading: homeViewModel.isLoadingStops,
              displayText: (item) => item['stop_name'],
              onChanged: (value) {
                homeViewModel.setSelectedEndStop(value);
              },
              isEnabled: homeViewModel.selectedTripId != null,
            ),
            const SizedBox(height: 30),

            const Text('Elija el algoritmo a utilizar:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // Algorithm Buttons
            AlgorithmButton(
              label: 'Dijkstra',
              description: 'Para calcular la ruta más corta.',
              onPressed: homeViewModel.selectedStartStopId != null && homeViewModel.selectedEndStopId != null
                  ? () {
                final viewModel = Provider.of<DijkstraViewModel>(context, listen: false);
                viewModel.resetValues();
                viewModel.start = homeViewModel.selectedStartStopId!;
                viewModel.end = homeViewModel.selectedEndStopId!;
                Navigator.pushNamed(context, '/dijkstra');
              }
                  : null,
            ),
            AlgorithmButton(
              label: 'A*',
              description: 'Para calcular la ruta óptima con heurística.',
              onPressed: homeViewModel.selectedStartStopId != null && homeViewModel.selectedEndStopId != null
                  ? () {
                final viewModel = Provider.of<AStarViewModel>(context, listen: false);
                viewModel.resetValues();
                viewModel.start = homeViewModel.selectedStartStopId!;
                viewModel.end = homeViewModel.selectedEndStopId!;
                Navigator.pushNamed(context, '/a-star');
              }
                  : null,
            ),
            AlgorithmButton(
              label: 'Bellman-Ford',
              description: 'Para calcular rutas con posibles pesos negativos.',
              onPressed: homeViewModel.selectedStartStopId != null && homeViewModel.selectedEndStopId != null
                  ? () {
                final viewModel = Provider.of<BellmanFordViewModel>(context, listen: false);
                viewModel.resetValues();
                viewModel.start = homeViewModel.selectedStartStopId!;
                viewModel.end = homeViewModel.selectedEndStopId!;
                Navigator.pushNamed(context, '/bellman-ford');
              }
                  : null,
            ),
            AlgorithmButton(
              label: 'Compare Algorithms',
              description: 'View all routes side by side',
              onPressed: homeViewModel.selectedStartStopId != null && homeViewModel.selectedEndStopId != null
                  ? () {
                final dijkstraVM = Provider.of<DijkstraViewModel>(context, listen: false);
                final aStarVM = Provider.of<AStarViewModel>(context, listen: false);
                final bellmanFordVM = Provider.of<BellmanFordViewModel>(context, listen: false);

                dijkstraVM.resetValues();
                aStarVM.resetValues();
                bellmanFordVM.resetValues();

                dijkstraVM.start = homeViewModel.selectedStartStopId!;
                dijkstraVM.end = homeViewModel.selectedEndStopId!;
                aStarVM.start = homeViewModel.selectedStartStopId!;
                aStarVM.end = homeViewModel.selectedEndStopId!;
                bellmanFordVM.start = homeViewModel.selectedStartStopId!;
                bellmanFordVM.end = homeViewModel.selectedEndStopId!;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ComparisonScreen()),
                );
              }
                  : null,
            ),
          ],
        ),
      ),
    )
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<Map<String, dynamic>> items,
    required String hint,
    required bool isLoading,
    required String Function(Map<String, dynamic>) displayText,
    required void Function(String?) onChanged,
    bool isEnabled = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        underline: const SizedBox(),
        items: isLoading
            ? [const DropdownMenuItem(value: null, child: Center(child: CircularProgressIndicator()))]
            : items.map<DropdownMenuItem<String>>((item) {
          final itemId = item['service_id'] ?? item['trip_id'] ?? item['stop_id'];
          return DropdownMenuItem<String>(
            value: itemId,
            child: Text(displayText(item)),
          );
        }).toList(),
        onChanged: isEnabled ? onChanged : null,
      ),
    );
  }
}

class AlgorithmButton extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback? onPressed;

  const AlgorithmButton({
    required this.label,
    required this.description,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: onPressed != null ? Colors.blue : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: onPressed,
            child: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 12),
      ],
    );
  }
}