import 'package:booking/pages/agencies/agence_form.dart';
import 'package:booking/pages/agencies/firstAgency.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'agency_detail.dart'; // Import the AgencyDetail page

class DashPage extends StatefulWidget {
  DashPage({super.key});

  @override
  State<DashPage> createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    // Get the currently logged-in user's email
    final user = FirebaseAuth.instance.currentUser;
    currentUserEmail = user?.email;
  }

  // Delete function
  void _deleteAgency(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('agencies')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agency deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete agency: $e')),
      );
    }
  }

  // Confirm delete (Yes or No)
  Future<void> _confirmDelete(String documentId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this agency?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      _deleteAgency(documentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // curent user
            Text(currentUserEmail.toString()),
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available Agencies",
                  style: GoogleFonts.notoSerif(
                    fontSize: 20,
                    color: Colors.blue[300],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.blue[300],
                //     borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(20),
                //       bottomLeft: Radius.circular(20),
                //     ),
                //   ),
                //   child: IconButton(
                //     onPressed: currentUserEmail == "dere@gmail.com" ||
                //             currentUserEmail == "zayid@gmail.com"
                //         ? () => Navigator.pushReplacement(context,
                //                 MaterialPageRoute(builder: (context) {
                //               return AgencyForm();
                //             }))
                //         : null, // Disabled for other users
                //     icon: const Icon(
                //       Icons.add,
                //       color: Colors.white,
                //     ),
                //     tooltip: currentUserEmail == "dere@gmail.com"
                //         ? "Add Agency"
                //         : "Access Restricted",
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16.0),
            // StreamBuilder to fetch agencies from Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('agencies')
                    .orderBy(FieldPath.documentId, descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong!'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No agencies found.'));
                  }

                  final agencies = snapshot.data!.docs;
                  final maxIndex = agencies.length - 1; // Get the maximum index

                  return ListView.builder(
                    itemCount: agencies.length,
                    itemBuilder: (context, index) {
                      final agency = agencies[index];
                      final data = agency.data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          if (index == maxIndex) {
                            // Navigate to AgencyDetail page for the agency with the maximum index
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Go detail of this agency
                                builder: (context) => AgencyDetail(),
                              ),
                            );
                          } else {
                            // Show AlertDialog for other agencies
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    data['agencyName'] ?? 'Agency Details',
                                  ),
                                  content: Text(
                                    'Owner: ${data['owner']}\nHQ: ${data['hqLocation']}\nPhone: ${data['ownerPhone']}\nRegistered: ${data['registrationDate']}\nBio: ${data['agencyBio']}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  data['agencyName'] ?? 'Unknown Agency',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildInfoItem(
                                    icon: Icons.location_on,
                                    label: 'HQ',
                                    value: data['hqLocation'] ?? 'Not Provided',
                                  ),
                                  _buildInfoItem(
                                    icon: Icons.person,
                                    label: 'Owner',
                                    value: data['owner'] ?? 'Not Provided',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildInfoItem(
                                    icon: Icons.phone,
                                    label: 'Phone',
                                    value: data['ownerPhone'] ?? 'Not Provided',
                                  ),
                                  _buildInfoItem(
                                    icon: Icons.date_range,
                                    label: 'Registered',
                                    value: data['registrationDate'] ??
                                        'Not Provided',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.description,
                                      color: Colors.indigo),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      data['agencyBio'] ?? 'No bio available.',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              if (currentUserEmail == "dere@gmail.com" ||
                                  currentUserEmail == "zayid@gmail.com")
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed:
                                        currentUserEmail == "dere@gmail.com" ||
                                                currentUserEmail ==
                                                    "zayid@gmail.com"
                                            ? () => _confirmDelete(agency.id)
                                            : null,
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    tooltip: 'Delete Agency',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgencyForm()),
                );
              },
              backgroundColor: Colors.teal,
              child: const Icon(Icons.add),
              tooltip: "Add a Flight",
            )
          : null,
    );
  }

  // Helper function to build info items
  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: Colors.indigo, size: 18.0),
          const SizedBox(width: 4.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
