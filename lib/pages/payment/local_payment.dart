import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/pages/local_model/local_flight_model.dart';

class LocalPaymentPage extends StatefulWidget {
  final Flight flight;

  const LocalPaymentPage({Key? key, required this.flight}) : super(key: key);

  @override
  State<LocalPaymentPage> createState() => _LocalPaymentPageState();
}

class _LocalPaymentPageState extends State<LocalPaymentPage> {
  bool showFields = false; // To control visibility of input fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  String userId = "";
  String status = "Pending";

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  void _fetchUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid; // Set the current user ID
      });
    }
  }

  // Function to launch USSD payment
  void _launchUSSD(String ussdCode) async {
    final encodedUssd = Uri.encodeFull(ussdCode);
    final url = "tel:$encodedUssd";

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        _showFieldsWithDelay();
      } else {
        _showSnackBar("Unable to launch payment.");
      }
    } catch (e) {
      _showSnackBar("Error launching USSD: $e");
    }
  }

  void _showFieldsWithDelay() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        showFields = true; // Show input fields after delay
      });
    });
  }

  // Function to store payment details in Firebase
  Future<void> _storePaymentDetails() async {
    if (fullNameController.text.isEmpty || telephoneController.text.isEmpty) {
      _showSnackBar("All fields are required!");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection("Users").add({
        'fullName': fullNameController.text,
        'telephone': telephoneController.text,
        'userId': userId,
        'status': status,
        'flightDetails': {
          'fromCity': widget.flight.fromCity,
          'toCity': widget.flight.toCity,
          'price': widget.flight.price,
          'flightNumber': widget.flight.flightNumber,
          'airplane': widget.flight.airplaneName,
          'date': widget.flight.date,
          'time': widget.flight.time,
        },
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showSnackBar("Payment Completed! Call Center To Improve peyment");
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar("Failed to save payment details: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "${widget.flight.fromCity} to ${widget.flight.toCity}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Airplane: ${widget.flight.airplaneName}"),
                        Text("Flight #: ${widget.flight.flightNumber}"),
                      ],
                    ),
                    const SizedBox(height: 8),
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

            // Pay with e_dahab
            GestureDetector(
              onTap: () {
                _launchUSSD("*663*0619959788*${widget.flight.price}#");
              },
              child: _buildPaymentOption("Pay with e_dahab"),
            ),
            const SizedBox(height: 16),

            // Pay with EVC
            GestureDetector(
              onTap: () {
                _launchUSSD("*712*619959788*${widget.flight.price}#");
              },
              child: _buildPaymentOption("Pay with EVC"),
            ),
            const SizedBox(height: 24),

            // Input fields
            if (showFields) ...[
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: "Telephone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _storePaymentDetails,
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
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}
