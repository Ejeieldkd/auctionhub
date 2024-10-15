import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Placeholder for EditProfileScreen, replace with your actual implementation
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  String _name = '';
  String _email = ''; // Added email field
  String _location = ''; // Changed 'place' to 'location'
  String _profilePicUrl = '';

  // Fetch profile data
  Future<void> _fetchProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          _name = data?['name'] ?? '';
          _email = data?['email'] ?? ''; // Get email from Firestore
          _location = data?['location'] ?? ''; // Get location
          _profilePicUrl = data?['profilePicUrl'] ?? ''; // Profile picture URL
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Soft background color
      appBar: AppBar(
        title: Text('AuctionHub Profile', style: TextStyle(fontSize: 24)), // Updated title
        elevation: 0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Profile Picture (Non-interactive)
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blueAccent,
              child: CircleAvatar(
                radius: 65,
                backgroundImage: _profilePicUrl.isNotEmpty
                    ? NetworkImage(_profilePicUrl)
                    : AssetImage('assets/default_profile.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            // Profile Details
            Expanded(
              child: ListView(
                children: [
                  _buildProfileDetailCard('Name', _name),
                  _buildProfileDetailCard('Email', _email), // Added email field
                  _buildProfileDetailCard('Location', _location), // Updated field name
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfileScreen()), // Navigate to Edit Profile
          );
          if (result == true) {
            // If profile was updated, refresh the profile data
            _fetchProfileData();
          }
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Function to create Profile Detail Card
  Widget _buildProfileDetailCard(String title, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            Text(
              value.isEmpty ? 'N/A' : value,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
