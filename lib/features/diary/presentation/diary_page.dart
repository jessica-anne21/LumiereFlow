import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere_flow/features/diary/presentation/diary_timeline_page.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final TextEditingController _journalController =
      TextEditingController();

  String selectedMood = '☺️';

  bool isSaving = false;

  final List<Map<String, String>> moods = [
    {
      "emoji": "☺️",
      "label": "Tenang",
    },
    {
      "emoji": "😴",
      "label": "Lelah",
    },
    {
      "emoji": "😔",
      "label": "Sedih",
    },
    {
      "emoji": "😡",
      "label": "Sensitif",
    },
    {
      "emoji": "✨",
      "label": "Energik",
    },
  ];

  // save to firebase
  Future<void> saveDiaryEntry() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (_journalController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Isi jurnal terlebih dahulu ✨",
          ),
        ),
      );
      return;
    }

    try {
      setState(() {
        isSaving = true;
      });

      final today =
          DateTime.now().toIso8601String().substring(0, 10);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('diary_entries')
          .doc(today)
          .set({
        'mood': selectedMood,
        'journal': _journalController.text.trim(),
        'created_at': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Diary berhasil disimpan",
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFFC99797);
    final Color softAccent = const Color(0xFFF6E9E7);
    final Color glowColor = const Color(0xFFE8CFCF);

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
                  color: glowColor.withOpacity(0.18),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -60,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: softAccent.withOpacity(0.8),
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withOpacity(0.6),
                            borderRadius:
                                BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.4),
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
                      "EMOTIONAL FLOW",
                      style: GoogleFonts.manrope(
                        color: accentColor,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2.5,
                        fontSize: 12,
                      ),
                    ),
                     const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const DiaryTimelinePage(),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.auto_awesome_motion,
                          color: accentColor,
                          size: 18,
                        ),
                        label: Text(
                          "Lihat Emotional Timeline",
                          style: GoogleFonts.manrope(
                            color: accentColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Bagaimana perasaanmu\nhari ini?",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 46,
                        height: 1.05,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Luangkan waktu sejenak untuk memahami emosi dan pikiranmu hari ini. Emotional wellness juga bagian penting dari hormonal health.",
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        height: 1.9,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 45),


                    Text(
                      "Mood Hari Ini",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: moods.map((mood) {
                          final bool isSelected =
                              selectedMood ==
                                  mood['emoji'];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedMood =
                                    mood['emoji']!;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(
                                  milliseconds: 250),
                              margin:
                                  const EdgeInsets.only(
                                right: 16,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? accentColor
                                        .withOpacity(0.16)
                                    : Colors.white
                                        .withOpacity(
                                            0.45),
                                borderRadius:
                                    BorderRadius.circular(
                                        28),
                                border: Border.all(
                                  color: isSelected
                                      ? accentColor
                                      : Colors.white
                                          .withOpacity(
                                              0.5),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(
                                            0.03),
                                    blurRadius: 15,
                                    offset:
                                        const Offset(
                                            0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    mood['emoji']!,
                                    style:
                                        const TextStyle(
                                      fontSize: 36,
                                    ),
                                  ),

                                  const SizedBox(
                                      height: 10),

                                  Text(
                                    mood['label']!,
                                    style:
                                        GoogleFonts
                                            .manrope(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      color:
                                          isSelected
                                              ? accentColor
                                              : Colors
                                                  .black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 50),

                    Text(
                      "Journal Entry",
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Container(
                          padding:
                              const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.45),
                            borderRadius:
                                BorderRadius.circular(
                                    30),
                            border: Border.all(
                              color: Colors.white
                                  .withOpacity(0.45),
                            ),
                          ),
                          child: TextField(
                            controller:
                                _journalController,
                            maxLines: 12,
                            style:
                                GoogleFonts.manrope(
                              fontSize: 14,
                              height: 1.8,
                              color: Colors.black87,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Tulis perasaan, pikiran, atau pengalamanmu hari ini...",
                              hintStyle:
                                  GoogleFonts.manrope(
                                color:
                                    Colors.black38,
                                height: 1.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                   

  
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              accentColor,
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    24),
                          ),
                        ),
                        onPressed:
                            isSaving
                                ? null
                                : saveDiaryEntry,
                        child:
                            isSaving
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.white,
                                    strokeWidth:
                                        2.5,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: [
                                    const Icon(
                                      Icons
                                          .favorite_border,
                                    ),

                                    const SizedBox(
                                        width: 10),

                                    Text(
                                      "Simpan Diary",
                                      style:
                                          GoogleFonts
                                              .manrope(
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                        fontSize:
                                            14,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),

                    const SizedBox(height: 50),
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