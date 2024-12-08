import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchedProfilePage extends StatefulWidget {
  final String email; // Accept email from the ProfilePage
  const FetchedProfilePage({super.key, required this.email});

  @override
  // ignore: library_private_types_in_public_api
  _FetchedProfilePageState createState() => _FetchedProfilePageState();
}

class _FetchedProfilePageState extends State<FetchedProfilePage> {
  String name = '';
  String email = '';
  String phone = '';

  Future<void> fetchProfileData() async {
    String apiUrl =
        'http://10.0.2.2/fetch_profile.php?email=${widget.email}'; // Ensure this URL is correct
    try {
      var response = await http.get(Uri.parse(apiUrl));
      var data = jsonDecode(response.body);

      if (data['success'] == true) {
        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            name = data['name'];
            email = data['email'];
            phone = data['phone'];
          });
          // Debug: Print the fetched data to verify
          print("Fetched data: $name, $email, $phone");
        }
      } else {
        print("Error: ${data['message']}");
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  // Initialize the state and fetch profile data when the page is loaded
  @override
  void initState() {
    super.initState();
    fetchProfileData(); // Fetch user data when this page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PROFILE"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: $name", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Email: $email", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Text("Phone: $phone", style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
