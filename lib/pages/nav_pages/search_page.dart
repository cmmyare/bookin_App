import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      // Fetch data from interFlight collection
      final interFlightSnapshot =
          await FirebaseFirestore.instance.collection('interFlight').get();
      final interFlightData = interFlightSnapshot.docs
          .map((doc) =>
              {...doc.data(), 'id': doc.id, 'source': 'International flight'})
          .toList();

      // Fetch data from flights collection
      final flightsSnapshot =
          await FirebaseFirestore.instance.collection('flights').get();
      final flightsData = flightsSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id, 'source': 'Local flight'})
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
                              trailing: Text(
                                "\$${flight['price'] ?? 'N/A'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
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
