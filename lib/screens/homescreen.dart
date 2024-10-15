import 'package:auction_hub/screens/profile_screen.dart';
import 'package:auction_hub/screens/profile_screen.dart';
import 'package:auction_hub/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'profile_screen.dart';  // Adjust the import based on your project structure
//import 'settings_screen.dart'; // Import your settings screen

class AuctionHubHomePage extends StatefulWidget {
  @override
  _AuctionHubHomePageState createState() => _AuctionHubHomePageState();
}

class _AuctionHubHomePageState extends State<AuctionHubHomePage> {
  String _username = ''; // Variable to hold the username

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Fetch the user profile when the widget is initialized
  }

  // Fetch user profile data from Firestore
  Future<void> _fetchUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          _username = data?['name'] ?? 'User'; // Default to 'User' if no name is found
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction Hub'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to the SettingsScreen when the settings icon is tapped
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(  // Profile card at the top
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Replace with user's actual profile image
                ),
                title: Text(_username),  // Use the actual user's name
                subtitle: Text('View Profile'),
                onTap: () {
                  // Navigate to the ProfileScreen when the profile card is tapped
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search for auctions, items',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (String value) {
                  // Implement search functionality
                },
              ),
            ),
            ListTile(
              title: Text('Recommended Auctions'),
              subtitle: Text('Auctions tailored for you'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Implement navigation to recommended auctions
              },
            ),
            ListTile(
              title: Text('Browse Categories'),
              subtitle: Text('Explore items by category'),
              trailing: Icon(Icons.category),
              onTap: () {
                // Implement category navigation
              },
            ),
            // Additional widgets as required
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel),
            label: 'Auctions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Community',
          ),
        ],
        onTap: (index) {
          // Implement navigation based on the index
        },
      ),
    );
  }
}
