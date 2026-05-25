import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumiere_flow/features/diary_page.dart';

class ActionButtons extends StatelessWidget {
  final Color accentColor;
  const ActionButtons({super.key, required this.accentColor});

  void showSymptomLogger(BuildContext context) {
    final List<Map<String, dynamic>> symptoms = [
      {'name': 'Kram Perut', 'icon': Icons.gpp_bad_outlined},
      {'name': 'Jerawat', 'icon': Icons.face_retouching_natural},
      {'name': 'Kembung', 'icon': Icons.hourglass_bottom},
      {'name': 'Lelah', 'icon': Icons.battery_alert_outlined},
      {'name': 'Pusing', 'icon': Icons.psychology_outlined},
      {'name': 'Mood Swings', 'icon': Icons.emoji_emotions_outlined},
    ];

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final dateToday = DateTime.now().toIso8601String().substring(0, 10);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFBFCF8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('daily_logs')
              .doc(dateToday)
              .snapshots(),
          builder: (context, snapshot) {
            List<String> selectedSymptoms = [];
            
            if (snapshot.hasData && snapshot.data!.exists) {
              final logData = snapshot.data!.data() as Map<String, dynamic>;
              final List<dynamic> saved = logData['symptoms'] ?? [];
              selectedSymptoms = saved.map((e) => e.toString()).toList();
            }

            return StatefulBuilder(
              builder: (context, setModalState) {
                return DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.4,
                  maxChildSize: 0.85,
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 45,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "UPDATE YOUR SYMPTOMS",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.black38),
                          ),
                          const SizedBox(height: 4),
                          const Text("Add or remove symptoms for today.", style: TextStyle(color: Colors.black54, fontSize: 14)),
                          const SizedBox(height: 24),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                            itemCount: symptoms.length,
                            itemBuilder: (context, index) {
                              final item = symptoms[index];
                              final isSelected = selectedSymptoms.contains(item['name']);

                              return InkWell(
                                onTap: () {
                                  setModalState(() {
                                    if (isSelected) {
                                      selectedSymptoms.remove(item['name']);
                                    } else {
                                      selectedSymptoms.add(item['name']);
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? accentColor.withValues(alpha: 0.06) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? accentColor : Colors.black12,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(item['icon'], color: isSelected ? accentColor : Colors.black38, size: 26),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['name'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 11, 
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          color: isSelected ? accentColor : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              onPressed: () async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .collection('daily_logs')
                                      .doc(dateToday)
                                      .set({
                                    'logged_at': DateTime.now().toIso8601String(),
                                    'symptoms': selectedSymptoms,
                                  }, SetOptions(merge: true));

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text("Symptoms updated successfully! 🌸", style: TextStyle(fontWeight: FontWeight.w500)),
                                        backgroundColor: accentColor,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString()), backgroundColor: Colors.redAccent),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "UPDATE SYMPTOMS",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: accentColor,
                backgroundColor: Colors.white,
                side: BorderSide(color: accentColor.withValues(alpha: 0.4), width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => showSymptomLogger(context),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text("LOG SYMPTOMS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.0)),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiaryPage()),
                );
              },
              icon: const Icon(Icons.mode_edit_outline, size: 18),
              label: const Text("DAILY DIARY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.0)),
            ),
          ),
        ),
      ],
    );
  }
}