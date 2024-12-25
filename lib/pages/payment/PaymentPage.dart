import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:booking/pages/model/inter_flight_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:booking/components/Bar_iconst.dart';

class PaymentPage extends StatefulWidget {
  final Flight flight;

  const PaymentPage({Key? key, required this.flight}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool showFields = false; // State to toggle input fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  String userId = "";
  String status = "Pending";

  @override
  void initState() {
    super.initState();
    // Fetch current user details
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
    }
  }

  // Simulate delay to show fields after USSD is launched
  void showPaymentFieldsWithDelay() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showFields = true;
      });
    });
  }

  // Launch USSD
  void launchUSSD(BuildContext context, String ussdCode) async {
    final encodedUssd = ussdCode.replaceAll("#", "%23").replaceAll("*", "%2A");
    final url = "tel:$encodedUssd";

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
        showPaymentFieldsWithDelay(); // Show fields after delay
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to launch USSD")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error launching USSD: $e")),
      );
    }
  }

  // Store payment details in Firebase
  Future<void> storePaymentDetails() async {
    if (fullNameController.text.isEmpty || telephoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      final flightDetails = {
        'fromCity': widget.flight.fromCity,
        'toCity': widget.flight.toCity,
        'price': widget.flight.price,
        'flightNumber': widget.flight.flightNumber,
        'date': widget.flight.date,
        'time': widget.flight.time,
        'airplane': widget.flight.airplaneName,
      };

      // Add transit details if available
      if (widget.flight.hasTransit) {
        flightDetails['transitCity'] = widget.flight.transitCity;
        flightDetails['transitTime'] = widget.flight.transitTime;
      }

      await FirebaseFirestore.instance.collection("Users").add({
        'fullName': fullNameController.text,
        'telephone': telephoneController.text, // New telephone field
        'userId': userId,
        'status': status,
        'flightDetails': flightDetails,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Payment Completed! Call Center To Improve peyment")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save payment details: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Payment Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [RightIcons()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Review Your Flight Details",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),

            // Review Flight Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "${widget.flight.fromCity} to ${widget.flight.toCity}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Airplane: ${widget.flight.airplaneName}"),
                        Text("Flight #: ${widget.flight.flightNumber}"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date: ${widget.flight.date}"),
                        Text("Time: ${widget.flight.time}"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Price: \$${widget.flight.price}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Pay with e_dahab Section
            InkWell(
              onTap: () {
                launchUSSD(context,
                    "*663*0619959788*${widget.flight.price.toString()}#");
              },
              child: _buildPaymentOption("Pay with e_dahab"),
            ),
            const SizedBox(height: 16),

            // Pay with EVC Section
            InkWell(
              onTap: () {
                launchUSSD(context,
                    "*712*619959788*${widget.flight.price.toString()}#");
              },
              child: _buildPaymentOption("Pay with EVC"),
            ),
            const SizedBox(height: 24),

            // Hidden Input Fields with Delay
            if (showFields) ...[
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: "Enter Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: "Enter Telephone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: storePaymentDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text("Proceed to Payment"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        border: Border.all(color: Colors.teal, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.payment, color: Colors.teal),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
