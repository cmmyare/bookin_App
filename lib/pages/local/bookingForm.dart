import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/pages/local/FlightListPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for user input
  final TextEditingController _airplaneNameController = TextEditingController();
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _fromCityController = TextEditingController();
  final TextEditingController _toCityController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _initializeFlightNumber();
  }

  // Future<void> _initializeFlightNumber() async {
  //   try {
  //     // Query Firestore to get the current highest flight number
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('flights')
  //         .orderBy('flightNumber', descending: true)
  //         .limit(1)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Extract the flight number and increment it
  //       final lastFlightNumber =
  //           int.tryParse(querySnapshot.docs.first['flightNumber']) ?? 10;
  //       _flightNumberController.text = (lastFlightNumber + 1).toString();
  //     } else {
  //       // Set to 10 if there are no flights
  //       _flightNumberController.text = '10';
  //     }
  //   } catch (error) {
  //     // Handle errors and set default flight number
  //     _flightNumberController.text = '10';
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error initializing flight number: $error")),
  //     );
  //   }
  // }

  void submitBooking() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Attempt to save booking to Firebase
        await FirebaseFirestore.instance.collection('flights').add({
          'airplaneName': _airplaneNameController.text,
          'flightNumber': _flightNumberController.text,
          'fromCity': _fromCityController.text,
          'toCity': _toCityController.text,
          'date': _dayController.text,
          'time': _timeController.text,
          'price': double.parse(_priceController.text),
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Flight successfully added!")),
        );

        // Clear fields after submission
        _formKey.currentState!.reset();
        _airplaneNameController.clear();
        _flightNumberController.clear();
        _fromCityController.clear();
        _toCityController.clear();
        _dayController.clear();
        _timeController.clear();
        _priceController.clear();

        // Reinitialize flight number
        // await _initializeFlightNumber();

        // Navigate to HomePage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FlightListPage()),
          (route) => false, // Remove all previous routes
        );
      } catch (error) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add flight: $error")),
        );
      }
    }
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => FlightListPage()),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Register New Flights",
                style: GoogleFonts.notoSerif(
                  fontSize: 20,
                  color: Colors.blue[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Airplane Name
              TextFormField(
                controller: _airplaneNameController,
                decoration: const InputDecoration(labelText: "Airplane Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter airplane name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Flight Number
              TextFormField(
                controller: _flightNumberController,
                decoration: const InputDecoration(labelText: "Flight Number"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Flight number is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // From City
              TextFormField(
                controller: _fromCityController,
                decoration: const InputDecoration(labelText: "From City"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter departure city";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // To City
              TextFormField(
                controller: _toCityController,
                decoration: const InputDecoration(labelText: "To City"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter destination city";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Day
              TextFormField(
                controller: _dayController,
                decoration: const InputDecoration(labelText: "Day"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter departure day";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Time
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: "Time (HH:MM)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid time";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: submitBooking,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
