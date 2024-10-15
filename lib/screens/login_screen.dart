import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_screen.dart'; // Assuming this is your register page for AuctionHub

class AuctionHubLoginScreen extends StatefulWidget {
  @override
  _AuctionHubLoginScreenState createState() => _AuctionHubLoginScreenState();
}

class _AuctionHubLoginScreenState extends State<AuctionHubLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Navigate to AuctionHub home if successful
      Navigator.of(context).pushReplacementNamed('/auctionHubHome');
    } catch (e) {
      _showMessage('Login failed. Please check your credentials.');
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showMessage('Please enter your email address.');
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      _showMessage('Password reset link sent! Check your email.');
    } catch (e) {
      _showMessage('An error occurred while trying to reset the password.');
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AuctionHub - Login'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInWithEmailPassword,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
              TextButton(
                onPressed: _resetPassword,
                child: Text('Forgot Password?'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AuctionHubRegisterPage()),
                  );
                },
                child: Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
