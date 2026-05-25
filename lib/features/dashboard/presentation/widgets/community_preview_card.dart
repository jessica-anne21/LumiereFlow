import 'package:flutter/material.dart';
import 'package:lumiere_flow/features/community/presentation/community_page.dart';

class CommunityPreviewCard extends StatelessWidget {
  final Color accentColor;
  const CommunityPreviewCard({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommunityPage()),
        );
      },
      child: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.blur_on_outlined, color: accentColor, size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      "LUMIÈRE CIRCLE",
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "COMMUNITY",
                    style: TextStyle(color: accentColor, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                )
              ],
            ),
            const SizedBox(height: 14),
            const Text(
              "Ayo gabung komunitas sekarang.",
              style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Enter Circle",
                  style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_forward, size: 14, color: accentColor),
              ],
            )
          ],
        ),
      ),
    );
  }
}