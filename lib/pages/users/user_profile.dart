import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  List<Map<String, dynamic>> _completedTickets = [];
  bool _isLoading = true; // State to control loading indicator

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _fetchCompletedTickets();
  }

  Future<void> _fetchCompletedTickets() async {
    final userId = _user.uid;

    try {
      // Fetch all documents where userId matches and status is Completed
      final snapshot = await FirebaseFirestore.instance
          .collection("Users")
          .where("userId", isEqualTo: userId)
          .where("status", isEqualTo: "Completed")
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _completedTickets = snapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        setState(() {
          _completedTickets = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching tickets: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> _generateAndDownloadPDF(Map<String, dynamic> ticketData) async {
    // Request storage permission
    if (!(await Permission.storage.request().isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required.")),
      );
      return;
    }

    // Load the logo image
    final logoPath = 'lib/images/plane.png';
    final logoBytes = await File(logoPath).readAsBytes();

    // Create the PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          final now = DateTime.now();
          final downloadDate = "${now.day}/${now.month}/${now.year}";

          return pw.Column(
            children: [
              // Centered Title
              pw.Center(
                child: pw.Text(
                  "Dere Agency",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.teal,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Logo Image
              pw.Center(
                child: pw.Image(
                  pw.MemoryImage(logoBytes),
                  height: 50,
                ),
              ),
              pw.SizedBox(height: 20),

              // Main Container
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey, width: 2),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                padding: const pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("BOARDING PASS",
                        style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue)),
                    pw.SizedBox(height: 12),
                    pw.Text("Passenger: ${ticketData['fullName'] ?? 'N/A'}",
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(
                        "Flight: ${ticketData['flightDetails']['flightNumber'] ?? 'N/A'}",
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(
                        "Airplane: ${ticketData['flightDetails']['airplane'] ?? 'N/A'}",
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue)),
                    pw.Text(
                        "From: ${ticketData['flightDetails']['fromCity'] ?? 'N/A'} → ${ticketData['flightDetails']['toCity'] ?? 'N/A'}",
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(
                        "Date: ${ticketData['flightDetails']['date'] ?? 'N/A'}",
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(
                        "Time: ${ticketData['flightDetails']['time'] ?? 'N/A'}",
                        style: const pw.TextStyle(fontSize: 16)),
                    pw.Text(
                        "Price: \$${ticketData['flightDetails']['price'] ?? 'N/A'}",
                        style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green)),
                  ],
                ),
              ),

              // Footer
              pw.Spacer(),
              pw.Center(
                child: pw.Text(
                  "Downloaded on $downloadDate - Dere Agency",
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF
    final directory = Directory('/storage/emulated/0/Download');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    final file = File(
        '${directory.path}/boarding_pass_${ticketData['referenceNumber']}.pdf');
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF downloaded to ${file.path}")),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticketData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 6, offset: Offset(2, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "BOARDING PASS",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
          const Divider(),
          Text("Passenger: ${ticketData['fullName'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 20)),
          Text(
            "Airplane: ${ticketData['flightDetails']['airplane'] ?? 'N/A'}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          Text(
              "Flight: ${ticketData['flightDetails']['flightNumber'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16)),
          Text(
              "From: ${ticketData['flightDetails']['fromCity'] ?? 'N/A'} → ${ticketData['flightDetails']['toCity'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16)),
          Text("Date: ${ticketData['flightDetails']['date'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16)),
          Text("Time: ${ticketData['flightDetails']['time'] ?? 'N/A'}",
              style: const TextStyle(fontSize: 16)),
          Text("Price: \$${ticketData['flightDetails']['price'] ?? 'N/A'}",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _generateAndDownloadPDF(ticketData),
              icon: const Icon(Icons.download),
              label: const Text("Download as PDF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade300,
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _user.email ?? 'No email available',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 30),
                    ..._completedTickets
                        .map((ticket) => Column(
                              children: [
                                _buildTicketCard(ticket),
                                const Divider(),
                              ],
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
    );
  }
}
