import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Settings
            _buildSettingsCard(
              context,
              title: "Profile Settings",
              subFeatures: [
                "Edit Profile",
                "Change Profile Picture",
                "Update Password"
              ],
            ),
            // Notification Preferences
            _buildSettingsCard(
              context,
              title: "Notification Preferences",
              subFeatures: [
                "Enable/Disable Notifications",
                "Flight Updates",
                "Promotions & Offers"
              ],
            ),
            // Payment Options
            _buildSettingsCard(
              context,
              title: "Payment Options",
              subFeatures: [
                "Manage Saved Cards",
                "Add Payment Methods",
                "Transaction History"
              ],
            ),
            // Booking Preferences
            _buildSettingsCard(
              context,
              title: "Booking Preferences",
              subFeatures: [
                "Seat Preferences",
                "Frequent Flyer Numbers",
                "Language Selection"
              ],
            ),
            // Account Security
            _buildSettingsCard(
              context,
              title: "Account Security",
              subFeatures: [
                "Enable 2FA",
                "Login Devices",
                "Login Activity Logs"
              ],
            ),
            // App Theme
            _buildSettingsCard(
              context,
              title: "App Theme",
              subFeatures: ["Dark Mode", "Light Mode", "System Default"],
            ),
            // Travel History
            _buildSettingsCard(
              context,
              title: "Travel History",
              subFeatures: [
                "View Past Bookings",
                "Download Tickets",
                "Reschedule Flights"
              ],
            ),
            // Help & Support
            _buildSettingsCard(
              context,
              title: "Help & Support",
              subFeatures: ["Contact Support", "FAQs", "Report an Issue"],
            ),
            // Linked Accounts
            _buildSettingsCard(
              context,
              title: "Linked Accounts",
              subFeatures: [
                "Link Google/Apple ID",
                "Manage Logins",
                "Disconnect Accounts"
              ],
            ),
            // About & Legal
            _buildSettingsCard(
              context,
              title: "About & Legal",
              subFeatures: [
                "Version Info",
                "Terms & Conditions",
                "Privacy Policy"
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context,
      {required String title, required List<String> subFeatures}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            SizedBox(height: 8),
            ...subFeatures.map((subFeature) => ListTile(
                  title: Text(subFeature),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey),
                  onTap: () {
                    // Navigate or show toast for each feature
                  },
                )),
          ],
        ),
      ),
    );
  }
}
