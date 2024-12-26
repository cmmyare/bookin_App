import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/pages/Home.dart';
import 'package:booking/pages/local/bookingForm.dart';
import 'package:booking/pages/local_model/LocalFlightProvider.dart';
import 'package:booking/pages/local_model/local_flight_model.dart';
import 'package:booking/pages/payment/local_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FlightListPage extends StatefulWidget {
  @override
  State<FlightListPage> createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    currentUserEmail = user?.email;
  }

  void _confirmDelete(String flightId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this flight?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('flights')
                    .doc(flightId)
                    .delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Flight deleted successfully.")),
                );
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
        actions: const [RightIcons()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Local Flights",
              style: GoogleFonts.notoSerif(
                fontSize: 20,
                color: Colors.blue[300],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('flights')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final flights = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flightDoc = flights[index];
                      final flight = FlightL.fromDocument(
                          flightDoc.data() as Map<String, dynamic>,
                          flightDoc.id);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Flight Title
                              Center(
                                child: Text(
                                  "${flight.fromCity} to ${flight.toCity}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 8),

                              // Airplane Name and Flight Number Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Airplane: ${flight.airplaneName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Flight #: ${flight.flightNumber}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              // Day and Time Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Day: ${flight.date}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Time: ${flight.time}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Price and Book Now Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "Price: \$${flight.price}",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Provider.of<LocalFlightProvider>(context,
                                              listen: false)
                                          .selectFlight(flight);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              LocalPaymentPage(
                                            flight: flight,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Book Now"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Delete Button for Admin
                              if (currentUserEmail == "dere@gmail.com" ||
                                  currentUserEmail == "zayid@gmail.com")
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _confirmDelete(flight.id),
                                  ),
                                ),
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
                // Navigation to the booking form
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingForm()),
                );
              },
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
