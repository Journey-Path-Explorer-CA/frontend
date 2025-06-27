import 'package:flutter/material.dart';
import 'package:frontend/views/viewmodels/astarviewmodel.dart';
import 'package:frontend/views/viewmodels/bellmanfordviewmodel.dart';
import 'package:frontend/views/viewmodels/dijkstraviewmodel.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController startController = TextEditingController();
  final TextEditingController endController = TextEditingController();

  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text('Ingrese los datos', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: startController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese la parada inicial',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: endController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese la parada final',
              ),
            ),
            const SizedBox(height: 30),
            const Text('Elija el algoritmo a utilizar:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            AlgorithmButton(
              label: 'Dijkstra',
              description: 'Para calcular la ruta más corta.',
              onPressed: () {
                final viewModel = Provider.of<DijkstraViewModel>(context, listen: false);
                viewModel.resetValues();
                viewModel.start = startController.text;
                viewModel.end = endController.text;

                Navigator.pushNamed(context, '/dijkstra');
              },
            ),
            AlgorithmButton(
              label: 'A*',
              description: 'Para calcular la ruta óptima con heurística.',
              onPressed: () {
                final viewModel = Provider.of<AStarViewModel>(context, listen: false);
                viewModel.resetValues();
                viewModel.start = startController.text;
                viewModel.end = endController.text;

                Navigator.pushNamed(context, '/a-star');
              },
            ),
            AlgorithmButton(
              label: 'Bellman-Ford',
              description: 'Para calcular rutas con posibles pesos negativos.',
              onPressed: () {
                final viewModel = Provider.of<BellmanFordViewModel>(context, listen: false);
                viewModel.resetValues();
                viewModel.start = startController.text;
                viewModel.end = endController.text;

                Navigator.pushNamed(context, '/bellman-ford');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AlgorithmButton extends StatelessWidget {
  final String label;
  final String description;
  final VoidCallback onPressed;

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
              backgroundColor: Colors.blue,
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
