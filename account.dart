import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  // Make this public
  String name = " "; // Default name
  String email = " "; // Default email
  String phoneNumber = " "; // Default phone number

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? get profilePictureUrl => null;

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    emailController.text = email;
    phoneController.text = phoneNumber;
  }

  // Create profile by making a POST request to the server
  Future<void> createProfile() async {
    final url = Uri.parse('http://10.0.2.2:3000/create-profile'); // Adjust URL

    // Generate a unique user ID
    var uuid = const Uuid();
    String userId = uuid.v4(); // Generates a unique user ID

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId, // Include the generated user ID
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text, // Include phone number
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile created successfully')),
      );
      setState(() {
        name = nameController.text;
        email = emailController.text;
        phoneNumber = phoneController.text; // Update phone number
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Create Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profilePictureUrl!),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Enter your name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Enter your email'),
            ),
            TextField(
              controller: phoneController,
              decoration:
                  const InputDecoration(labelText: 'Enter your phone number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                createProfile(); // Call the function to create a profile
              },
              child: const Text("Create Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
