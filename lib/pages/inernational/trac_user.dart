import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool paymentCompleted = false;

  // Get the current user's UID
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _checkUserExists();
  }

  // Check if the user exists in Firestore
  Future<void> _checkUserExists() async {
    setState(() {
      isLoading = true;
    });

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists) {
      // User already exists, read the data
      var userData = userDoc.data() as Map<String, dynamic>;
      firstNameController.text = userData['firstName'] ?? '';
      lastNameController.text = userData['lastName'] ?? '';
      phoneController.text = userData['phoneNumber'] ?? '';
      paymentCompleted = userData['paymentStatus'] == 'paid';
    } else {
      // User does not exist, create new entry
      firstNameController.text = '';
      lastNameController.text = '';
      phoneController.text = '';
      paymentCompleted = false;
    }

    setState(() {
      isLoading = false;
    });
  }

  // Save user data to Firestore
  Future<void> _saveUserInfo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String phoneNumber = phoneController.text.trim();

      try {
        // Store or update user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set(
            {
              'userId': userId,
              'firstName': firstName,
              'lastName': lastName,
              'phoneNumber': phoneNumber,
              'paymentStatus': 'not yet', // Default value
            },
            SetOptions(
                merge: true)); // Merge to update existing document if it exists

        // Step 2: Redirect to the payment gateway (mobile payment)
        _redirectToPaymentGateway();
      } catch (e) {
        print("Error saving user info: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user information')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Redirect to mobile payment app or phone dialer (simulated)
  Future<void> _redirectToPaymentGateway() async {
    String paymentLink =
        'tel:*712*619959788*1#'; // Example: Redirecting to a USSD or mobile money service

    // This could also be a link to open a specific mobile payment app:
    // String paymentLink = 'sms:+1234567890?body=Payment request'; // Example SMS to pay

    try {
      // Use url_launcher to open the payment method on the user's phone
      if (await canLaunch(paymentLink)) {
        await launch(paymentLink);
      } else {
        throw 'Could not open payment method';
      }
    } catch (e) {
      print("Error opening payment method: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open payment gateway')),
      );
    }
  }

  // Update payment status to "paid" in Firestore
  Future<void> _updatePaymentStatus(String status) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'paymentStatus': status,
    });
  }

  // Show the appropriate button based on payment status
  Widget _showPaymentButton() {
    if (paymentCompleted) {
      return ElevatedButton(
        onPressed: _getTicket,
        child: Text('Get Ticket'),
      );
    } else {
      return Container(); // Do not show anything if payment is not completed
    }
  }

  // Logic to "Get Ticket" (this could be implemented as per your business flow)
  Future<void> _getTicket() async {
    // Your logic to get the ticket, e.g., generate a PDF, send email, etc.
    print("Ticket has been generated!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Your ticket is ready!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Profile")),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveUserInfo,
                      child: Text('Save Information'),
                    ),
                    SizedBox(height: 20),
                    _showPaymentButton(), // Show the "Get Ticket" button if payment is completed
                  ],
                ),
              ),
            ),
    );
  }
}
