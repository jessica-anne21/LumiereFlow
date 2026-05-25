import 'package:flutter/material.dart';

class GoldenRuleCard extends StatelessWidget {
  final Color accentColor;
  const GoldenRuleCard({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_outlined, color: accentColor, size: 18),
              const SizedBox(width: 10),
              const Text(
                "TODAY'S GOLDEN RULE",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Hari ini kamu sedang hari pertama menstruasi, banyaklah beristirahat dan makan makanan tinggi zat besi.",
            style: TextStyle(height: 1.6, fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}