import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Adminpage extends StatefulWidget {
  const Adminpage({Key? key}) : super(key: key);

  @override
  _AdminpageState createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  String _searchQuery = ""; // To store the search query

  // Function to delete a document from Firestore
  void _deletePayment(String docId, BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this record?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(docId)
                      .delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Payment record deleted successfully."),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to delete record: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Function to update the status of a payment
  void _updateStatus(
      String docId, String currentStatus, BuildContext context) async {
    if (currentStatus == "Completed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status already marked as Completed."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Users').doc(docId).update({
        'status': 'Completed', // Update status to "Completed"
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status updated to Completed."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update status: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          "Manage Users Payment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Styled Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.teal, width: 1.5),
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  labelText: "Search by Telephone",
                  labelStyle: const TextStyle(color: Colors.teal),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No payment data found."));
                }

                // Filter data based on the search query
                final userData = snapshot.data!.docs.where((doc) {
                  final telephone = doc['telephone']?.toString() ?? '';
                  return telephone.contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: userData.length,
                  itemBuilder: (context, index) {
                    final userDoc = userData[index];
                    final docId = userDoc.id;
                    final userId = userDoc['userId'] ?? "N/A";
                    final fromCity =
                        userDoc['flightDetails']['fromCity'] ?? "N/A";
                    final toCity = userDoc['flightDetails']['toCity'] ?? "N/A";
                    final airplane =
                        userDoc['flightDetails']['airplane'] ?? "N/A";
                    final time = userDoc['flightDetails']['time'] ?? "N/A";
                    final fullName = userDoc['fullName'] ?? "N/A";
                    final telephone = userDoc['telephone'] ?? "N/A";
                    final status = userDoc['status'] ?? "Pending";

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User ID: $userId",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "From: $fromCity → To: $toCity",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Airplane: $airplane",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "Time: $time",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Full Name: $fullName",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Telephone: $telephone", // Displaying telephone
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Status: $status",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: status == "Completed"
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Update Status Button
                                    IconButton(
                                      icon: const Icon(Icons.check_circle,
                                          color: Colors.green),
                                      onPressed: () =>
                                          _updateStatus(docId, status, context),
                                      tooltip: "Mark as Completed",
                                    ),
                                    // Delete Button
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _deletePayment(docId, context),
                                      tooltip: "Delete Record",
                                    ),
                                    // Notification Placeholder
                                    IconButton(
                                      icon: const Icon(
                                          Icons.notifications_active,
                                          color: Colors.blue),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                              "Notification feature coming soon!"),
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              ],
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
    );
  }
}
