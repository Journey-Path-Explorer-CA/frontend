import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BellmanFordViewModel with ChangeNotifier {
  String start = '';
  String end = '';
  double totalDistance = 0.0;

  List<Map<String, dynamic>> stops = [];

  Future<void> fetchRoute() async {
    final url = Uri.parse(
        'https://journey-path-explorer-ca-backend.onrender.com/bellman-ford/stops?start_stop_id=$start&end_stop_id=$end');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      stops = List<Map<String, dynamic>>.from(json.decode(response.body));
      totalDistance = await getDistance();
      notifyListeners();
    } else {
      throw Exception('No se pudo obtener la ruta');
    }
  }

  Future<double> getDistance() async {
    final url = Uri.parse(
        'https://journey-path-explorer-ca-backend.onrender.com/bellman-ford/distance?start_stop_id=$start&end_stop_id=$end');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)["total_distance"].toDouble();
    } else {
      throw Exception('No se pudo obtener la ruta');
    }
  }

  void resetValues() {
    start = '';
    end = '';
    totalDistance = 0.0;
    stops = [];
  }
}
