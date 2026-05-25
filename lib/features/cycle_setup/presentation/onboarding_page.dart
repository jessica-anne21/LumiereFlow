import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumiere_flow/features/cycle_setup/presentation/cycle_setup_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _nameController = TextEditingController();
  DateTime? selectedDate;
  String? selectedSkinType;
  String? selectedFitness;

  final List<String> skinTypes = ['Dry', 'Oily', 'Combination', 'Sensitive', 'Normal'];
  final List<String> fitnessInterests = [
    'Never Exercise', 
    'Occasional (1-2x a week)', 
    'Active (3-5x a week)', 
    'Athlete (Daily)'
  ];

  String generateLumiUsername() {
    final prefixes = ['LumiSister', 'GlowSister'];
    final random = Random();
    String selectedPrefix = prefixes[random.nextInt(prefixes.length)];
    int randomNumber = random.nextInt(900) + 100;
    return "${selectedPrefix}_$randomNumber";
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFD4A5A5), 
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> saveOnboardingData() async {
    final name = _nameController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || name.isEmpty || selectedDate == null || selectedSkinType == null || selectedFitness == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    try {
      String anonymousUsername = generateLumiUsername();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'username': anonymousUsername,
        'birth_date': selectedDate!.toIso8601String(),
        'skin_type': selectedSkinType,
        'activity_level': selectedFitness,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CycleSetupPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFCF8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Lumière Flow",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD4A5A5),
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Understand your body's natural rhythm."),
                const SizedBox(height: 40),

                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFD4A5A5)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => selectDate(context),
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: selectedDate == null 
                            ? "Birth Date" 
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        prefixIcon: const Icon(Icons.calendar_today_outlined, color: Color(0xFFD4A5A5)),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                CustomDropdownField(
                  label: "Skin Type",
                  icon: Icons.face_outlined,
                  value: selectedSkinType,
                  items: skinTypes,
                  onChanged: (val) => setState(() => selectedSkinType = val),
                ),
                const SizedBox(height: 20),

                CustomDropdownField(
                  label: "Fitness Interest",
                  icon: Icons.fitness_center_outlined,
                  value: selectedFitness,
                  items: fitnessInterests,
                  onChanged: (val) => setState(() => selectedFitness = val),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4A5A5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    onPressed: saveOnboardingData,
                    child: const Text(
                      "Start My Journey",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFD4A5A5)),
          border: InputBorder.none,
        ),
        items: items.map((String item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD4A5A5)),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}