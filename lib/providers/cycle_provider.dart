import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'cycle_provider.g.dart';

class CycleState {
  final int currentDay;
  final String currentPhase;
  final int userAge;

  CycleState({
    required this.currentDay,
    required this.currentPhase,
    required this.userAge,
  });
}

@riverpod
class Cycle extends _$Cycle {
  @override
  Stream<CycleState> build() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value(CycleState(currentDay: 1, currentPhase: 'Menstrual Phase', userAge: 22));
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return CycleState(currentDay: 1, currentPhase: 'Menstrual Phase', userAge: 22);
      }

      final data = snapshot.data() as Map<String, dynamic>;
      
      final String birthDateStr = data['birth_date'] ?? '';
      int age = 22;
      if (birthDateStr.isNotEmpty) {
        final birthDate = DateTime.parse(birthDateStr);
        final today = DateTime.now();
        age = today.year - birthDate.year;
        if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
          age--;
        }
      }

      final String lastPeriodStr = data['last_period_date'] ?? '';
      final int cycleLength = data['cycle_length'] ?? 28;
      int currentDay = 1;

      if (lastPeriodStr.isNotEmpty) {
        final lastPeriod = DateTime.parse(lastPeriodStr);
        final today = DateTime.now();
        final difference = today.difference(lastPeriod).inDays;
        currentDay = (difference % cycleLength) + 1;
      }

      int ovulationDay = cycleLength ~/ 2; 

      String phase = 'Menstrual Phase';
      if (currentDay >= 1 && currentDay <= 5) {
        phase = 'Menstrual Phase';
      } else if (currentDay >= 6 && currentDay < ovulationDay) {
        phase = 'Follicular Phase';
      } else if (currentDay == ovulationDay) {
        phase = 'Ovulation Phase';
      } else if (currentDay > ovulationDay && currentDay <= cycleLength) {
        phase = 'Luteal Phase';
      }

      return CycleState(
        currentDay: currentDay,
        currentPhase: phase,
        userAge: age,
      );
    });
  }
}