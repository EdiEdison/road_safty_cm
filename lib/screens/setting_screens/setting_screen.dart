import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isEditing = false;

  // Example user data
  String userName = "John Doe";
  String userEmail = "johndoe@example.com";
  String userPhone = "+1234567890";

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    nameController.text = userName;
    emailController.text = userEmail;
    phoneController.text = userPhone;
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Settings"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                if (isEditing) {
                  // Save updated info
                  userName = nameController.text;
                  userEmail = emailController.text;
                  userPhone = phoneController.text;
                }
                isEditing = !isEditing; // Toggle edit mode
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
              readOnly: !isEditing,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
              readOnly: !isEditing,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              readOnly: !isEditing,
            ),
          ],
        ),
      ),
    );
  }
}

