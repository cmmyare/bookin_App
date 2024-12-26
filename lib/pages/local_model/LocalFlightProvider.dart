// pages/local_model/LocalFlightProvider.dart
import 'package:flutter/material.dart';
import 'package:booking/pages/local_model/local_flight_model.dart';

class LocalFlightProvider extends ChangeNotifier {
  FlightL? _selectedFlight;

  FlightL? get selectedFlight => _selectedFlight;

  void selectFlight(FlightL flight) {
    _selectedFlight = flight;
    notifyListeners();
  }

  void clearSelection() {
    _selectedFlight = null;
    notifyListeners();
  }
}
