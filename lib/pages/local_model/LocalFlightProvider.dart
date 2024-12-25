// pages/local_model/LocalFlightProvider.dart
import 'package:flutter/material.dart';
import 'package:booking/pages/local_model/local_flight_model.dart';

class LocalFlightProvider extends ChangeNotifier {
  Flight? _selectedFlight;

  Flight? get selectedFlight => _selectedFlight;

  void selectFlight(Flight flight) {
    _selectedFlight = flight;
    notifyListeners();
  }

  void clearSelection() {
    _selectedFlight = null;
    notifyListeners();
  }
}
