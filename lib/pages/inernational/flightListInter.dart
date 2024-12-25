import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/pages/Home.dart';
import 'package:booking/pages/inernational/bookingFormInter.dart';
import 'package:booking/pages/model/FlightSelectionProvider.dart';
import 'package:booking/pages/model/inter_flight_model.dart';
import 'package:booking/pages/payment/PaymentPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterFlightListPage extends StatefulWidget {
  @override
  State<InterFlightListPage> createState() => _InterFlightListPageState();
}

class _InterFlightListPageState extends State<InterFlightListPage> {
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user's email
    final user = FirebaseAuth.instance.currentUser;
    currentUserEmail = user?.email;
  }

  // Function to delete a flight from Firestore
  Future<void> deleteFlight(String flightId) async {
    try {
      await FirebaseFirestore.instance
          .collection('interFlight')
          .doc(flightId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flight deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete flight')),
      );
    }
  }

  // Function to show the confirmation dialog
  void _showDeleteDialog(String flightId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this flight?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                deleteFlight(flightId); // Perform deletion if "Yes"
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 15, left: 40),
            child: Image.asset(
              "lib/images/plane.png",
              height: 40,
              width: 40,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: const [
          // Bar icons from Components folder
          RightIcons(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available International Flights",
              style: GoogleFonts.notoSerif(
                fontSize: 16,
                color: Colors.blue[300],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('interFlight')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final flights = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flight = flights[index];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top: From-To Cities
                              Center(
                                child: Text(
                                  "${flight['fromCity']} to ${flight['toCity']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Airplane Name and Flight Number
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Airplane: ${flight['airplaneName']}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Flight: ${flight['flightNumber']}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Day and Time
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Day: ${flight['date']}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Time: ${flight['time']}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Transit City and Transit Time (if applicable)
                              if (flight['hasTransit'] == true) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Transit City: ${flight['transitCity']}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      "Transit Time: ${flight['transitTime']} hrs",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],

                              // Price and Book Now Button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                      horizontal: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "Price: \$${flight['price']}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      elevation: 2,
                                    ),
                                    onPressed: () {
                                      // Create a Flight object from Firestore data
                                      final selectedFlight = Flight(
                                        flightId: flight.id,
                                        fromCity: flight['fromCity'],
                                        toCity: flight['toCity'],
                                        airplaneName: flight['airplaneName'],
                                        flightNumber: flight['flightNumber'],
                                        date: flight['date'],
                                        time: flight['time'],
                                        hasTransit: flight['hasTransit'],
                                        transitCity:
                                            flight['transitCity'] ?? '',
                                        transitTime:
                                            flight['transitTime'] ?? '',
                                        price: flight['price'].toDouble(),
                                      );

                                      // Save the selected flight in the provider
                                      Provider.of<FlightSelectionProvider>(
                                              context,
                                              listen: false)
                                          .selectFlight(selectedFlight);

                                      // Navigate to PaymentPage
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentPage(
                                              flight: selectedFlight),
                                        ),
                                      );
                                    },
                                    child: const Text("Book Now"),
                                  ),
                                ],
                              ),

                              // Delete Button (visible only for authorized users)
                              // Delete Button (aligned to the right)
                              if (currentUserEmail == "dere@gmail.com") ...[
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _showDeleteDialog(flight.id),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: (currentUserEmail == "dere@gmail.com" ||
              currentUserEmail == "zayid@gmail.com")
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterBookingForm()),
                );
              },
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
              tooltip: "Add a Flight",
            )
          : null, // FloatingActionButton will not be displayed for other users
    );
  }
}
