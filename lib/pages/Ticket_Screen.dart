import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Ticket")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No bookings found."));
          }

          final booking = snapshot.data!.docs.first;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking Number: ${booking['bookingNumber']}",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text("Departure: ${booking['departure']}",
                        style: TextStyle(fontSize: 16)),
                    Text("Arrival: ${booking['arrival']}",
                        style: TextStyle(fontSize: 16)),
                    Text("Passengers: ${booking['passengers']}",
                        style: TextStyle(fontSize: 16)),
                    Text("Travel Date: ${booking['travelDate']}",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
