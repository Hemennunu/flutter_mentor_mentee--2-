import 'package:flutter/material.dart';

class EditMentorScreen extends StatefulWidget {
  const EditMentorScreen({Key? key}) : super(key: key);

  @override
  State<EditMentorScreen> createState() => _EditMentorScreenState();
}

class _EditMentorScreenState extends State<EditMentorScreen> {
  final TextEditingController nameController = TextEditingController(text: "Blen Berhanu");
  final TextEditingController emailController = TextEditingController(text: "blen@gmail.com");
  final TextEditingController bioController = TextEditingController(text: "I love coding");
  final TextEditingController occupationController = TextEditingController(text: "Software Engineer");
  final TextEditingController locationController = TextEditingController(text: "Addis Ababa, Ethiopia");
  final TextEditingController organizationController = TextEditingController(text: "Mento-Mentee Organization");
  final List<String> skillOptions = ["Frontend", "Backend", "Fullstack", "DevOps", "Design"];
  String selectedSkill = "Design";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Mentor", style: TextStyle(color: Colors.white)),
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
            buildTextField("email", emailController),
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
