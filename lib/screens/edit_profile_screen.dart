import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _studyStreamController = TextEditingController();
  final TextEditingController _interestedStreamController = TextEditingController();

  String _profilePicUrl = '';
  final ImagePicker _picker = ImagePicker();
  File? _newProfilePic;

  // Fetch profile data
  Future<void> _fetchProfileData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        setState(() {
          _nameController.text = data?['name'] ?? '';
          _ageController.text = data?['age'] ?? '';
          _placeController.text = data?['place'] ?? '';
          _studyStreamController.text = data?['studyStream'] ?? '';
          _interestedStreamController.text = data?['interestedStream'] ?? '';
          _profilePicUrl = data?['profilePicUrl'] ?? ''; // Get profile picture URL
        });
      }
    }
  }

  // Upload profile picture to Firebase Storage
  Future<void> _uploadProfilePicture() async {
    final user = _auth.currentUser;
    if (user != null && _newProfilePic != null) {
      final storageRef = FirebaseStorage.instance.ref().child('profile_pics/${user.uid}');
      await storageRef.putFile(_newProfilePic!);

      // Get the download URL
      String downloadUrl = await storageRef.getDownloadURL();
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({'profilePicUrl': downloadUrl});

      setState(() {
        _profilePicUrl = downloadUrl;
      });
    }
  }

  // Save profile data
  Future<void> _saveProfileData() async {
    final user = _auth.currentUser;
    if (user != null && _formKey.currentState?.validate() == true) {
      // Upload new profile picture if one was selected
      if (_newProfilePic != null) {
        await _uploadProfilePicture();
      }

      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userDoc.set({
        'name': _nameController.text,
        'age': _ageController.text,
        'place': _placeController.text,
        'studyStream': _studyStreamController.text,
        'interestedStream': _interestedStreamController.text,
        'profilePicUrl': _profilePicUrl, // Save the profile picture URL
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );

      // Delay to let the SnackBar be visible before navigating back
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  // Pick a new profile picture
  Future<void> _pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfilePic = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _placeController.dispose();
    _studyStreamController.dispose();
    _interestedStreamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Picture
              Center(
                child: GestureDetector(
                  onTap: _pickProfilePicture,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _newProfilePic != null
                        ? FileImage(_newProfilePic!)
                        : (_profilePicUrl.isNotEmpty
                        ? NetworkImage(_profilePicUrl)
                        : AssetImage('assets/default_profile.png')) as ImageProvider,
                    child: Icon(Icons.camera_alt, size: 30, color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              // Age
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              // Place
              TextFormField(
                controller: _placeController,
                decoration: InputDecoration(labelText: 'Place'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your place';
                  }
                  return null;
                },
              ),
              // Stream of Study
              TextFormField(
                controller: _studyStreamController,
                decoration: InputDecoration(labelText: 'Stream of Study'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your stream of study';
                  }
                  return null;
                },
              ),
              // Interested Stream of Study
              TextFormField(
                controller: _interestedStreamController,
                decoration: InputDecoration(labelText: 'Interested Stream of Study'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your interested stream of study';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Save button
              ElevatedButton(
                onPressed: _saveProfileData,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
