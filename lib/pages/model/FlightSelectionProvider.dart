import 'package:flutter/material.dart';
import 'inter_flight_model.dart'; // Import the flight model

class FlightSelectionProvider with ChangeNotifier {
  Flight? _selectedFlight;

  Flight? get selectedFlight => _selectedFlight;

  void selectFlight(Flight flight) {
    _selectedFlight = flight;
    notifyListeners(); // Notify listeners when the flight is updated
  }

  void clearSelection() {
    _selectedFlight = null;
    notifyListeners();
  }
}
