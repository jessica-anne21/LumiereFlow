import 'package:flutter/material.dart';

class CycleStatusCircle extends StatelessWidget {
  final int day;
  final String phase;
  final Color accentColor;

  const CycleStatusCircle({
    super.key, 
    required this.day, 
    required this.phase,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 25,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "DAY",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 2.5, color: Colors.black38),
          ),
          Text(
            "$day",
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w200, color: Colors.black87, height: 1.1),
          ),
          const SizedBox(height: 4),
          Text(
            phase.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(color: accentColor, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_calendar_outlined, size: 13, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  "LOG PERIOD",
                  style: TextStyle(color: accentColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}