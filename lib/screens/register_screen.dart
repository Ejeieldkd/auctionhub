import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuctionHubRegisterPage extends StatefulWidget {
  @override
  _AuctionHubRegisterPageState createState() => _AuctionHubRegisterPageState();
}

class _AuctionHubRegisterPageState extends State<AuctionHubRegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  bool acceptTerms = false;

  Future<void> _trySubmit() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isValid! && acceptTerms) {
      _formKey.currentState?.save();
      try {
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Navigator.of(context).pushReplacementNamed('/auctionHubHome'); // Assuming AuctionHub home route
      } catch (e) {
        _showMessage('Registration failed. Please try again.');
      }
    } else if (!acceptTerms) {
      _showMessage('You must accept the terms and conditions.');
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
        title: Text('AuctionHub - Register'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                key: ValueKey('email'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Please enter a valid email address.';
                  }
                  return null;
                },
                onSaved: (value) => email = value ?? '',
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                key: ValueKey('password'),
                validator: (value) {
                  if (value == null || value.length < 7) {
                    return 'Password must be at least 7 characters long.';
                  }
                  return null;
                },
                onSaved: (value) => password = value ?? '',
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextFormField(
                key: ValueKey('firstName'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name.';
                  }
                  return null;
                },
                onSaved: (value) => firstName = value ?? '',
                decoration: InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                key: ValueKey('lastName'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name.';
                  }
                  return null;
                },
                onSaved: (value) => lastName = value ?? '',
                decoration: InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                key: ValueKey('phoneNumber'),
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length != 10) {
                    return 'Please enter a valid phone number.';
                  }
                  return null;
                },
                onSaved: (value) => phoneNumber = value ?? '',
                decoration: InputDecoration(labelText: 'Phone Number (Optional)'),
                keyboardType: TextInputType.phone,
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        acceptTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          acceptTerms = !acceptTerms;
                        });
                      },
                      child: Text('I accept the terms & conditions'),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _trySubmit,
                child: Text('Register'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/auctionHubLogin');
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
