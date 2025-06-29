import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeViewModel with ChangeNotifier {
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> trips = [];
  List<Map<String, dynamic>> stops = [];

  String? selectedServiceId;
  String? selectedTripId;
  String? selectedStartStopId;
  String? selectedEndStopId;

  bool isLoadingServices = false;
  bool isLoadingTrips = false;
  bool isLoadingStops = false;

  Future<void> fetchServices() async {
    isLoadingServices = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://journey-path-explorer-ca-backend.onrender.com/calendar/services'));
      if (response.statusCode == 200) {
        services = List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load services');
      }
    } finally {
      isLoadingServices = false;
      notifyListeners();
    }
  }

  Future<void> fetchTrips(String serviceId) async {
    isLoadingTrips = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://journey-path-explorer-ca-backend.onrender.com/trips/by_service/$serviceId'));
      if (response.statusCode == 200) {
        trips = List<Map<String, dynamic>>.from(json.decode(response.body));
        selectedTripId = null;
        stops = [];
        selectedStartStopId = null;
        selectedEndStopId = null;
      } else {
        throw Exception('Failed to load trips');
      }
    } finally {
      isLoadingTrips = false;
      notifyListeners();
    }
  }

  Future<void> fetchStops(String tripId) async {
    isLoadingStops = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('https://journey-path-explorer-ca-backend.onrender.com/stop_times/by_trip/$tripId'));
      if (response.statusCode == 200) {
        stops = List<Map<String, dynamic>>.from(json.decode(response.body));
        selectedStartStopId = null;
        selectedEndStopId = null;
      } else {
        throw Exception('Failed to load stops');
      }
    } finally {
      isLoadingStops = false;
      notifyListeners();
    }
  }

  void setSelectedService(String? serviceId) {
    selectedServiceId = serviceId;
    if (serviceId != null) {
      fetchTrips(serviceId);
    } else {
      trips = [];
      stops = [];
      selectedTripId = null;
      selectedStartStopId = null;
      selectedEndStopId = null;
    }
    notifyListeners();
  }

  void setSelectedTrip(String? tripId) {
    selectedTripId = tripId;
    if (tripId != null) {
      fetchStops(tripId);
    } else {
      stops = [];
      selectedStartStopId = null;
      selectedEndStopId = null;
    }
    notifyListeners();
  }

  void setSelectedStartStop(String? stopId) {
    selectedStartStopId = stopId;
    notifyListeners();
  }

  void setSelectedEndStop(String? stopId) {
    selectedEndStopId = stopId;
    notifyListeners();
  }

  void resetSelections() {
    selectedServiceId = null;
    selectedTripId = null;
    selectedStartStopId = null;
    selectedEndStopId = null;
    services = [];
    trips = [];
    stops = [];
    notifyListeners();
  }
}