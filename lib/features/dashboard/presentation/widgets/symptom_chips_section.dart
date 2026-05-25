import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomChipsSection extends StatelessWidget {
  final String? userUid;
  final String dateKey;
  final Color accentColor;

  const SymptomChipsSection({
    super.key,
    required this.userUid,
    required this.dateKey,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    if (userUid == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('daily_logs')
          .doc(dateKey)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final logData = snapshot.data!.data() as Map<String, dynamic>;
        final List<dynamic> symptoms = logData['symptoms'] ?? [];

        if (symptoms.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "TODAY'S SYMPTOMS",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.black38),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: symptoms.map((symptom) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
                    ],
                  ),
                  child: Text(
                    symptom.toString(),
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accentColor, letterSpacing: 0.3),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}