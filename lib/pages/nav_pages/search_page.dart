import 'package:booking/pages/model/FlightSelectionProvider.dart';
import 'package:booking/pages/payment/PaymentPage.dart';
import 'package:booking/pages/payment/local_payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booking/pages/local_model/LocalFlightProvider.dart';
import 'package:booking/pages/local_model/local_flight_model.dart';
import 'package:booking/pages/payment/local_payment.dart';
import 'package:provider/provider.dart';

import 'package:booking/pages/model/FlightSelectionProvider.dart';
import 'package:booking/pages/model/inter_flight_model.dart';
// LocalPaymentPage for local flights

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allFlights = [];
  List<Map<String, dynamic>> _filteredFlights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFlights();
  }

  Future<void> _fetchFlights() async {
    try {
      // Fetch data from international flights collection
      final interFlightSnapshot =
          await FirebaseFirestore.instance.collection('interFlight').get();
      final interFlightData = interFlightSnapshot.docs
          .map((doc) => {
                ...doc.data(),
                'id': doc.id,
                'source': 'International flight',
              })
          .toList();

      // Fetch data from local flights collection
      final flightsSnapshot =
          await FirebaseFirestore.instance.collection('flights').get();
      final flightsData = flightsSnapshot.docs
          .map((doc) => {
                ...doc.data(),
                'id': doc.id,
                'source': 'Local flight',
              })
          .toList();

      // Combine both collections
      final combinedData = [...interFlightData, ...flightsData];

      setState(() {
        _allFlights = combinedData;
        _filteredFlights = combinedData;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterFlights(String query) {
    final filtered = _allFlights.where((flight) {
      final fromCity = flight['fromCity']?.toLowerCase() ?? '';
      final toCity = flight['toCity']?.toLowerCase() ?? '';
      final queryLower = query.toLowerCase();

      return fromCity.contains(queryLower) || toCity.contains(queryLower);
    }).toList();

    setState(() {
      _filteredFlights = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFlights,
              decoration: InputDecoration(
                hintText: 'Search by city (From/To)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFlights.isEmpty
                    ? const Center(
                        child: Text(
                          "No flights found.",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredFlights.length,
                        itemBuilder: (context, index) {
                          final flight = _filteredFlights[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(
                                "${flight['fromCity']} → ${flight['toCity']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Airplane: ${flight['airplaneName'] ?? 'N/A'}"),
                                  Text("Date: ${flight['date'] ?? 'N/A'}"),
                                  Text("Time: ${flight['time'] ?? 'N/A'}"),
                                  Text("Source: ${flight['source']}"),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 100, // Limit width to prevent overflow
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "\$${flight['price'] ?? 'N/A'}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (flight['source'] ==
                                        'International flight')
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            elevation: 2,
                                            minimumSize: const Size(
                                                80, 30), // Set a minimum size
                                          ),
                                          onPressed: () {
                                            final selectedFlight = Flight(
                                              flightId: flight['id'],
                                              fromCity: flight['fromCity'],
                                              toCity: flight['toCity'],
                                              airplaneName:
                                                  flight['airplaneName'],
                                              flightNumber:
                                                  flight['flightNumber'],
                                              date: flight['date'],
                                              time: flight['time'],
                                              hasTransit: flight['hasTransit'],
                                              transitCity:
                                                  flight['transitCity'] ?? '',
                                              transitTime:
                                                  flight['transitTime'] ?? '',
                                              price: double.parse(
                                                  flight['price'].toString()),
                                            );

                                            Provider.of<FlightSelectionProvider>(
                                                    context,
                                                    listen: false)
                                                .selectFlight(selectedFlight);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PaymentPage(
                                                        flight: selectedFlight),
                                              ),
                                            );
                                          },
                                          child: const Text("Book Now",
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                      ),
                                    if (flight['source'] == 'Local flight')
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(
                                                80, 30), // Set a minimum size
                                          ),
                                          onPressed: () {
                                            final selectedFlight =
                                                FlightL.fromDocument(
                                                    flight, flight['id']);

                                            Provider.of<LocalFlightProvider>(
                                                    context,
                                                    listen: false)
                                                .selectFlight(selectedFlight);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    LocalPaymentPage(
                                                        flight: selectedFlight),
                                              ),
                                            );
                                          },
                                          child: const Text("Book Now",
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
