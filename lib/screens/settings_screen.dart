import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // Import the EditProfileScreen

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AuctionHub Settings'), // Updated title for AuctionHub
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Edit Profile'), // Updated label for profile settings
              onTap: () {
                // Navigate to the EditProfileScreen when tapped
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Change Password'),
              onTap: () {
                // Implement navigation to change password screen
              },
            ),
            Divider(),
            ListTile(
              title: Text('Notification Settings'),
              subtitle: Text('Manage auction notifications'), // Updated subtitle
              onTap: () {
                // Navigate to notification settings screen
              },
            ),
            Divider(),
            ListTile(
              title: Text('Privacy Policy'),
              onTap: () {
                // Navigate to privacy policy
              },
            ),
            Divider(),
            ListTile(
              title: Text('Terms of Service'), // Updated label for terms and conditions
              onTap: () {
                // Navigate to terms and conditions
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                // Implement logout functionality
                // Example: FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
