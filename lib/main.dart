import 'package:auction_hub/screens/homescreen.dart';
import 'package:auction_hub/screens/login_screen.dart';
import 'package:auction_hub/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(AuctionHubApp());  // Run the AuctionHubApp
}

class AuctionHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuctionHub',
      theme: ThemeData(primarySwatch: Colors.blueGrey), // Theme customization for AuctionHub
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/login' : '/auctionHubHome',  // Check if user is logged in
      routes: {
        '/login': (context) => AuctionHubLoginScreen(),   // Route for login
        '/register': (context) => AuctionHubRegisterPage(),  // Route for registration
        '/auctionHubHome': (context) => AuctionHubHomePage(), // Route for the home screen
      },
    );
  }
}
