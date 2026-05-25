import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lumiere_flow/providers/cycle_provider.dart';

// Import widget pecahan baru kamu di bawah ini
import 'widgets/cycle_status_circle.dart';
import 'widgets/symptom_chips_section.dart';
import 'widgets/golden_rule_card.dart';
import 'widgets/daily_protocol_section.dart';
import 'widgets/community_preview_card.dart';
import 'widgets/action_buttons.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Color getPhaseColor(String phase) {
    switch (phase) {
      case 'Follicular Phase':
        return const Color(0xFFF4F7F4);
      case 'Ovulation Phase':
        return const Color(0xFFF7F3F3);
      case 'Luteal Phase':
        return const Color(0xFFF3F5F7);
      case 'Menstrual Phase':
      default:
        return const Color(0xFFF7F3F5);
    }
  }

  Color getAppBarTextColor(String phase) {
    switch (phase) {
      case 'Follicular Phase':
        return const Color(0xFF7CB342);
      case 'Ovulation Phase':
        return const Color(0xFFAB47BC);
      case 'Luteal Phase':
        return const Color(0xFF42A5F5);
      case 'Menstrual Phase':
      default:
        return const Color(0xFFC2185B);
    }
  }

  Future<void> updatePeriodDate(BuildContext context, Color accentColor) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'last_period_date': picked.toIso8601String(),
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Period date updated successfully! ✨", style: TextStyle(fontWeight: FontWeight.w500)), 
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
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final cycleAsync = ref.watch(cycleProvider);

    final currentPhaseString = cycleAsync.value?.currentPhase ?? 'Menstrual Phase';
    final backgroundColor = getPhaseColor(currentPhaseString);
    final themeAccentColor = getAppBarTextColor(currentPhaseString);
    final dateToday = DateTime.now().toIso8601String().substring(0, 10);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
        builder: (context, snapshot) {
          String greetingName = "Sister";
          if (snapshot.hasData && snapshot.data!.exists) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            greetingName = userData['name'] ?? "Sister";
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: false,
                title: Padding(
                  padding: const EdgeInsets.only(left: 4.0, top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "WELCOME BACK",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2.0, color: Colors.black38),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        greetingName,
                        style: const TextStyle(fontWeight: FontWeight.w300, color: Colors.black87, fontSize: 24, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => updatePeriodDate(context, themeAccentColor),
                          child: cycleAsync.when(
                            data: (cycleData) => CycleStatusCircle(
                              day: cycleData.currentDay,
                              phase: cycleData.currentPhase,
                              accentColor: themeAccentColor,
                            ),
                            loading: () => Center(
                              child: CircularProgressIndicator(color: themeAccentColor, strokeWidth: 2),
                            ),
                            error: (err, stack) => CycleStatusCircle(
                              day: 1, 
                              phase: "Menstrual Phase",
                              accentColor: themeAccentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SymptomChipsSection(userUid: user?.uid, dateKey: dateToday, accentColor: themeAccentColor),
                      const SizedBox(height: 32),
                      GoldenRuleCard(accentColor: themeAccentColor),
                      const SizedBox(height: 28),
                      DailyProtocolSection(accentColor: themeAccentColor),
                      const SizedBox(height: 28),
                      CommunityPreviewCard(accentColor: themeAccentColor),
                      const SizedBox(height: 32),
                      ActionButtons(accentColor: themeAccentColor),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}