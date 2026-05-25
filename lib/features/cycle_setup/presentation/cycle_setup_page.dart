import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lumiere_flow/features/dashboard/presentation/home_page.dart';

class CycleSetupPage extends StatefulWidget {
  const CycleSetupPage({super.key});

  @override
  State<CycleSetupPage> createState() => _CycleSetupPageState();
}

class _CycleSetupPageState extends State<CycleSetupPage> {
  DateTime? _selectedDate;
  final _cycleController = TextEditingController(text: "28");

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveCycleData() async {
    final user = FirebaseAuth.instance.currentUser;
    final cycleLengthInt = int.tryParse(_cycleController.text.trim());

    if (user == null || _selectedDate == null || cycleLengthInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields correctly"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'last_period_date': _selectedDate!.toIso8601String(),
        'cycle_length': cycleLengthInt,
      });

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
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
    _cycleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFCF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Final Step",
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFFD4A5A5)
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "When did your last period start? We need this to calculate your current phase.",
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 40),
              
              TextField(
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: _selectedDate == null 
                      ? "Last Period Date" 
                      : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  prefixIcon: const Icon(Icons.calendar_month_outlined, color: Color(0xFFD4A5A5)),
                  hintText: "Select Date",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              TextField(
                controller: _cycleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Average Cycle Length (e.g. 28 days)",
                  prefixIcon: const Icon(Icons.loop_outlined, color: Color(0xFFD4A5A5)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
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
                  onPressed: _saveCycleData,
                  child: const Text(
                    "Generate My Flow", 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}