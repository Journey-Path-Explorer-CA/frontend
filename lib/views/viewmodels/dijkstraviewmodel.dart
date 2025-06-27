import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DijkstraViewModel with ChangeNotifier {
  String start = '';
  String end = '';

  List<Map<String, dynamic>> stops = [];

  Future<void> fetchRoute() async {
    final url = Uri.parse(
        'http://10.0.2.2:8000/dijkstra/stops?start_stop_id=$start&end_stop_id=$end');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      stops = List<Map<String, dynamic>>.from(json.decode(response.body));
      notifyListeners();
    } else {
      throw Exception('No se pudo obtener la ruta');
    }
  }
}
