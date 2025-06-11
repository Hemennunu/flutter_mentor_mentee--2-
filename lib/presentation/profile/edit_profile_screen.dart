import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController(text: "User Account");
  final TextEditingController emailController = TextEditingController(text: "user@gmail.com");
  final TextEditingController bioController = TextEditingController(text: "");
  final TextEditingController occupationController = TextEditingController(text: "");
  final TextEditingController locationController = TextEditingController(text: "");
  final TextEditingController organizationController = TextEditingController(text: "");

  final List<String> skillOptions = ["Frontend", "Backend", "Fullstack", "DevOps", "Design"];
  String selectedSkill = "Design";
  bool isSkillDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F2C2C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildTextField("Name", nameController),
            const SizedBox(height: 8),
            buildTextField("Username", emailController),
            const SizedBox(height: 8),
            buildSkillDropdown(),
            const SizedBox(height: 8),
            buildTextField("Bio", bioController),
            const SizedBox(height: 8),
            buildTextField("Occupation", occupationController),
            const SizedBox(height: 8),
            buildTextField("Location", locationController),
            const SizedBox(height: 8),
            buildTextField("Organization", organizationController),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F2C2C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      // Save logic
                      Navigator.pop(context);
                    },
                    child: const Text("Save Changes"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF757575),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      // Cancel logic
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildSkillDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedSkill,
      items: skillOptions.map((skill) {
        return DropdownMenuItem<String>(
          value: skill,
          child: Text(skill),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedSkill = value;
          });
        }
      },
      decoration: const InputDecoration(
        labelText: "Skills",
        border: OutlineInputBorder(),
      ),
    );
  }
}
