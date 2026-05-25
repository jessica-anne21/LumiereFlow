import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkincareProtocolPage extends StatelessWidget {
  const SkincareProtocolPage({super.key});

  @override
  Widget build(BuildContext context) {

    const String currentPhase = "Fase Menstruasi";
    const String dayCount = "Hari ke-2";
    const String heroIngredient = "Centella Asiatica";

    final Color accentColor = const Color(0xFFC99797);
    final Color softAccent = const Color(0xFFF6E9E7);
    final Color glowColor = const Color(0xFFE8CFCF);

    final List<Map<String, String>> protocols = [
      {
        "title": "Pembersih Lembut",
        "desc":
            "Gunakan facial wash dengan pH rendah untuk membersihkan kulit tanpa merusak skin barrier yang sedang sensitif."
      },
      {
        "title": "Layering Hidrasi",
        "desc":
            "Gunakan toner dan essence yang ringan untuk membantu mengurangi rasa kering dan kulit tertarik."
      },
      {
        "title": "Perbaikan Skin Barrier",
        "desc":
            "Fokus pada kandungan menenangkan seperti Centella dan Ceramide untuk membantu mengurangi inflamasi."
      },
      {
        "title": "Nutrisi Malam Hari",
        "desc":
            "Kunci hidrasi kulit dengan moisturizer bernutrisi agar proses pemulihan kulit lebih optimal."
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF6F5),
              Color(0xFFFDF8F7),
              Color(0xFFF8EFEF),
            ],
          ),
        ),
        child: Stack(
          children: [

            Positioned(
              top: -80,
              right: -40,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glowColor.withValues(alpha: 0.18),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: softAccent.withValues(alpha: 0.8),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                            ),
                            color: Colors.black87,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    Text(
                      currentPhase.toUpperCase(),
                      style: GoogleFonts.manrope(
                        color: accentColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Kulitmu sedang menjadi\nlebih sensitif dan rapuh.",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 46,
                        height: 1.05,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Saat menstruasi, perubahan hormon dapat membuat skin barrier melemah dan kulit menjadi lebih sensitif. Fokuslah pada hidrasi, calming, dan pemulihan kulit.",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        height: 1.9,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 45),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            color: accentColor,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            dayCount,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 12,
                          sigmaY: 12,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.45),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      accentColor.withValues(alpha: 0.25),
                                      glowColor.withValues(alpha: 0.1),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.spa_outlined,
                                  color: accentColor,
                                  size: 34,
                                ),
                              ),

                              const SizedBox(width: 22),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hero Ingredient",
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      heroIngredient,
                                      style: GoogleFonts.cormorantGaramond(
                                        fontSize: 32,
                                        height: 1,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      "Membantu menenangkan inflamasi, menghidrasi kulit, dan memperkuat skin barrier saat menstruasi.",
                                      style: GoogleFonts.manrope(
                                        fontSize: 13,
                                        height: 1.7,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 55),
                    Text(
                      "Ritual Perawatan Hari Ini",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Rutinitas skincare minimalis dan menenangkan yang dirancang khusus untuk fase menstruasi.",
                      style: GoogleFonts.manrope(
                        color: Colors.black54,
                        height: 1.8,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 45),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: protocols.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 35),
                      itemBuilder: (context, index) {
                        final item = protocols[index];

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            accentColor.withValues(alpha: 0.25),
                                        blurRadius: 18,
                                      ),
                                    ],
                                  ),
                                ),

                                if (index != protocols.length - 1)
                                  Container(
                                    width: 1.5,
                                    height: 95,
                                    color:
                                        accentColor.withValues(alpha: 0.2),
                                  ),
                              ],
                            ),

                            const SizedBox(width: 24),

                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.45),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.025),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "STEP ${index + 1}",
                                      style: GoogleFonts.manrope(
                                        fontSize: 11,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w800,
                                        color: accentColor,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      item['title']!,
                                      style: GoogleFonts
                                          .cormorantGaramond(
                                        fontSize: 30,
                                        height: 1,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    Text(
                                      item['desc']!,
                                      style: GoogleFonts.manrope(
                                        fontSize: 14,
                                        height: 1.9,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}