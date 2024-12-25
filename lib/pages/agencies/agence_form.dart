import 'package:booking/components/Bar_iconst.dart';
import 'package:booking/pages/Home.dart'; // Replace with the actual path to your HomePage
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AgencyForm extends StatefulWidget {
  @override
  _AgencyFormState createState() => _AgencyFormState();
}

class _AgencyFormState extends State<AgencyForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final _agencyNameController = TextEditingController();
  final _hqLocationController = TextEditingController();
  final _ownerController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _registrationDateController = TextEditingController();
  final _agencyBioController = TextEditingController();

  @override
  void dispose() {
    _agencyNameController.dispose();
    _hqLocationController.dispose();
    _ownerController.dispose();
    _ownerPhoneController.dispose();
    _registrationDateController.dispose();
    _agencyBioController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'agencyName': _agencyNameController.text,
        'hqLocation': _hqLocationController.text,
        'owner': _ownerController.text,
        'ownerPhone': _ownerPhoneController.text,
        'registrationDate': _registrationDateController.text,
        'agencyBio': _agencyBioController.text,
      };

      try {
        await FirebaseFirestore.instance.collection('agencies').add(formData);

        // Clear the fields after submission
        _formKey.currentState!.reset();
        _agencyNameController.clear();
        _hqLocationController.clear();
        _ownerController.clear();
        _ownerPhoneController.clear();
        _registrationDateController.clear();
        _agencyBioController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );

        // Navigate to HomePage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false, // Remove all previous routes
        );
      } catch (e) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to submit form. Error: ${e.toString()}')),
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
            Navigator.pop(context);
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
                "Register New Agency",
                style: GoogleFonts.notoSerif(
                  fontSize: 20,
                  color: Colors.blue[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _agencyNameController,
                decoration: const InputDecoration(
                  labelText: 'Agency Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the agency name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _hqLocationController,
                decoration: const InputDecoration(
                  labelText: 'HQ Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the HQ location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ownerController,
                decoration: const InputDecoration(
                  labelText: 'Owner',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the owner\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ownerPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Owner Phone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the owner\'s phone number';
                  }
                  if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _registrationDateController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Registration Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the registration date';
                  }
                  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                    return 'Please enter a valid date in YYYY-MM-DD format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _agencyBioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Agency Bio',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the agency bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[300], // Background color
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 15), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
