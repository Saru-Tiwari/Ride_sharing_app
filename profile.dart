import 'dart:convert';
import 'package:flutter/material.dart';
import 'fetched_profile_page.dart'; // Import the FetchedProfilePage class
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phnum = TextEditingController();

  Future<void> insertRecord() async {
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        phnum.text.isNotEmpty) {
      try {
        String uri = "http://10.0.2.2/login_api/insert_record.php";
        var res = await http.post(Uri.parse(uri), body: {
          "name": name.text,
          "email": email.text,
          "password": password.text,
          "phnum": phnum.text
        });

        // Debug: Print raw response
        print("Status Code: ${res.statusCode}");
        print("Response Body: ${res.body}");

        if (res.statusCode == 200) {
          var response = jsonDecode(res.body); // Decode JSON response

          if (response["success"] == "true") {
            print("Record Inserted Successfully");
            name.text = "";
            email.text = "";
            password.text = "";
            phnum.text = "";

            // Only navigate if the widget is still mounted
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FetchedProfilePage(
                      email: email
                          .text), // Pass the entered email to FetchedProfilePage
                ),
              );
            }
          } else {
            print("Failed to Insert Record: ${response["message"]}");
          }
        } else {
          print("Server Error: ${res.statusCode}");
        }
      } catch (e) {
        print("Exception: $e");
      }
    } else {
      print("Please fill all fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Profile'),
        ),
        body: Column(
          children: [
            buildTextField(name, 'Enter Name'),
            buildTextField(email, 'Enter Email'),
            buildTextField(password, 'Enter Password'),
            buildTextField(phnum, 'Enter Phone Number'),
            Container(
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: insertRecord,
                child: const Text('Insert'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String labelText) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
