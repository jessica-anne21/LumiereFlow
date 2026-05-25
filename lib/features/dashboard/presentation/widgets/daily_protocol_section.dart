import 'package:flutter/material.dart';
import 'package:lumiere_flow/features/skincare_page.dart';
import 'package:lumiere_flow/features/food_page.dart';

class DailyProtocolSection extends StatelessWidget {
  final Color accentColor;
  const DailyProtocolSection({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            "DAILY PROTOCOLS",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.black38),
          ),
        ),
        ProtocolTile(
          title: "Adaptive Skincare",
          subtitle: "Use Hyaluronic Acid for hydration",
          icon: Icons.spa_outlined,
          accentColor: accentColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SkincareProtocolPage()),
            );
          },
        ),
        const SizedBox(height: 14),
        ProtocolTile(
          title: "Hormonal Skin-Food",
          subtitle: "Iron-rich Beef & Spinach",
          icon: Icons.restaurant_outlined,
          accentColor: accentColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FoodRecipesPage()),
            );
          },
        ),
      ],
    );
  }
}

class ProtocolTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const ProtocolTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF2E2CE).withValues(alpha: 0.5),
          radius: 22,
          child: Icon(icon, color: const Color(0xFFD4AF37), size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87, letterSpacing: 0.3)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black38)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black26),
      ),
    );
  }
}