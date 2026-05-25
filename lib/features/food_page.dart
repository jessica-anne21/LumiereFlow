import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/gemini_service.dart';

class FoodRecipesPage extends StatefulWidget {
  const FoodRecipesPage({super.key});

  @override
  State<FoodRecipesPage> createState() =>
      _FoodRecipesPageState();
}

class _FoodRecipesPageState
    extends State<FoodRecipesPage> {

  // =========================================
  // AI STATES
  // =========================================

  String aiResponse = "";

  bool isLoading = true;

  String currentPhase = "Loading...";
  String nutritionFocus =
      "Personalized Wellness";

  List symptoms = [];

  String skinType = "";
  String activityLevel = "";
  String mood = "calm";

  int currentDay = 1;
  int age = 22;

  // =========================================
  // INIT
  // =========================================

  @override
  void initState() {
    super.initState();

    generateAIRecommendation();
  }

  // =========================================
  // GENERATE AI
  // =========================================

  Future<void>
      generateAIRecommendation() async {

    try {

      final user =
          FirebaseAuth.instance
              .currentUser;

      if (user == null) return;

      // =========================================
      // USER DATA
      // =========================================

      final userDoc =
          await FirebaseFirestore
              .instance
              .collection('users')
              .doc(user.uid)
              .get();

      final userData =
          userDoc.data()
              as Map<String, dynamic>;

      skinType =
          userData['skin_type'] ??
              "Normal";

      activityLevel =
          userData['activity_level'] ??
              "Moderate";

      final birthDateStr =
          userData['birth_date'] ??
              "";

      // =========================================
      // CALCULATE AGE
      // =========================================

      if (birthDateStr.isNotEmpty) {

        final birthDate =
            DateTime.parse(
                birthDateStr);

        final today =
            DateTime.now();

        age =
            today.year -
                birthDate.year;

        if (today.month <
                birthDate.month ||
            (today.month ==
                    birthDate.month &&
                today.day <
                    birthDate.day)) {

          age--;
        }
      }

      // =========================================
      // PHASE LOGIC
      // =========================================

      final lastPeriodStr =
          userData[
              'last_period_date'];

      final cycleLength =
          userData[
                  'cycle_length'] ??
              28;

      if (lastPeriodStr != null) {

        final lastPeriod =
            DateTime.parse(
                lastPeriodStr);

        final difference =
            DateTime.now()
                .difference(
                    lastPeriod)
                .inDays;

        currentDay =((difference %cycleLength) + 1).toInt();

        int ovulationDay =
            cycleLength ~/ 2;

        if (currentDay >= 1 &&
            currentDay <= 5) {

          currentPhase =
              "Menstrual Phase";

        } else if (currentDay >=
                6 &&
            currentDay <
                ovulationDay) {

          currentPhase =
              "Follicular Phase";

        } else if (currentDay ==
            ovulationDay) {

          currentPhase =
              "Ovulation Phase";

        } else {

          currentPhase =
              "Luteal Phase";
        }
      }

      // =========================================
      // SYMPTOMS
      // =========================================

      final today =
          DateTime.now()
              .toIso8601String()
              .substring(0, 10);

      final symptomDoc =
          await FirebaseFirestore
              .instance
              .collection('users')
              .doc(user.uid)
              .collection(
                  'daily_logs')
              .doc(today)
              .get();

      if (symptomDoc.exists) {

        final data =
            symptomDoc.data()
                as Map<String,
                    dynamic>;

        symptoms =
            data['symptoms'] ??
                [];
      }

      // =========================================
      // MOOD
      // =========================================

      final diaryDoc =
          await FirebaseFirestore
              .instance
              .collection('users')
              .doc(user.uid)
              .collection(
                  'diary_entries')
              .doc(today)
              .get();

      if (diaryDoc.exists) {

        final data =
            diaryDoc.data()
                as Map<String,
                    dynamic>;

        final emoji =
            data['mood'] ??
                "☺️";

        final moodMap = {
          "☺️": "calm",
          "😴": "fatigued",
          "😔": "sad",
          "😡":
              "emotionally sensitive",
          "✨": "energetic",
        };

        mood =
            moodMap[emoji] ??
                "neutral";
      }

      // =========================================
      // GEMINI
      // =========================================

      final result =
          await GeminiService
              .generateWellnessRecommendation(

        phase: currentPhase,

        currentDay:
            currentDay,

        skinType: skinType,

        activityLevel:
            activityLevel,

        age: age,

        symptoms: symptoms,

        mood: mood,
      );

      setState(() {

        aiResponse = result;

        nutritionFocus =
            currentPhase ==
                    "Menstrual Phase"
                ? "Iron & Recovery"
                : currentPhase ==
                        "Follicular Phase"
                    ? "Energy & Protein"
                    : currentPhase ==
                            "Ovulation Phase"
                        ? "Antioxidant Focus"
                        : "Hormonal Balance";

        isLoading = false;
      });

    } catch (e) {

      print(e);

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================================
  // UI
  // =========================================

  @override
  Widget build(BuildContext context) {

    final Color accentColor =
        const Color(0xFFC99797);

    final Color softAccent =
        const Color(0xFFF6E9E7);

    final Color glowColor =
        const Color(0xFFE8CFCF);

    return Scaffold(
      body: Container(

        decoration:
            const BoxDecoration(

          gradient: LinearGradient(
            begin:
                Alignment.topCenter,

            end:
                Alignment.bottomCenter,

            colors: [

              Color(0xFFFFF6F5),

              Color(0xFFFDF8F7),

              Color(0xFFF8EFEF),
            ],
          ),
        ),

        child: Stack(
          children: [

            // =========================================
            // BACKGROUND
            // =========================================

            Positioned(
              top: -80,
              right: -40,

              child: Container(
                width: 220,
                height: 220,

                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,

                  color: glowColor
                      .withOpacity(
                          0.18),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              left: -60,

              child: Container(
                width: 260,
                height: 260,

                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,

                  color: softAccent
                      .withOpacity(
                          0.8),
                ),
              ),
            ),

            // =========================================
            // MAIN CONTENT
            // =========================================

            SafeArea(
              child:
                  SingleChildScrollView(

                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    // =========================================
                    // BACK BUTTON
                    // =========================================

                    Row(
                      children: [

                        Container(
                          decoration:
                              BoxDecoration(
                            color: Colors
                                .white
                                .withOpacity(
                                    0.6),

                            borderRadius:
                                BorderRadius.circular(
                                    18),

                            border:
                                Border.all(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.4),
                            ),
                          ),

                          child:
                              IconButton(

                            icon:
                                const Icon(
                              Icons
                                  .arrow_back_ios_new,

                              size: 18,
                            ),

                            color:
                                Colors.black87,

                            onPressed: () {
                              Navigator.pop(
                                  context);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 40),

                    // =========================================
                    // PHASE
                    // =========================================

                    Text(
                      currentPhase
                          .toUpperCase(),

                      style:
                          GoogleFonts
                              .manrope(
                        color:
                            accentColor,

                        fontWeight:
                            FontWeight
                                .w800,

                        letterSpacing:
                            2.5,

                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(
                        height: 14),

                    // =========================================
                    // TITLE
                    // =========================================

                    Text(
                      "Tubuhmu membutuhkan\nnutrisi dan recovery.",

                      style:
                          GoogleFonts
                              .cormorantGaramond(
                        fontSize: 46,

                        height: 1.05,

                        fontWeight:
                            FontWeight
                                .w700,

                        color: Colors
                            .black87,
                      ),
                    ),

                    const SizedBox(
                        height: 20),

                    // =========================================
                    // DESCRIPTION
                    // =========================================

                    Text(
                      "Rekomendasi nutrisi personal berdasarkan hormonal cycle, symptoms, dan emotional wellness kamu hari ini.",

                      style:
                          GoogleFonts
                              .manrope(
                        fontSize: 14,

                        height: 1.9,

                        color: Colors
                            .black54,

                        fontWeight:
                            FontWeight
                                .w500,
                      ),
                    ),

                    const SizedBox(
                        height: 45),

                    // =========================================
                    // NUTRITION FOCUS CARD
                    // =========================================

                    ClipRRect(
                      borderRadius:
                          BorderRadius
                              .circular(30),

                      child:
                          BackdropFilter(

                        filter:
                            ImageFilter
                                .blur(
                          sigmaX: 12,
                          sigmaY: 12,
                        ),

                        child: Container(

                          padding:
                              const EdgeInsets
                                  .all(26),

                          decoration:
                              BoxDecoration(

                            color: Colors
                                .white
                                .withOpacity(
                                    0.45),

                            borderRadius:
                                BorderRadius.circular(
                                    30),

                            border:
                                Border.all(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.45),
                            ),

                            boxShadow: [

                              BoxShadow(
                                color: Colors
                                    .black
                                    .withOpacity(
                                        0.03),

                                blurRadius:
                                    30,

                                offset:
                                    const Offset(
                                        0,
                                        15),
                              ),
                            ],
                          ),

                          child: Row(
                            children: [

                              Container(
                                width: 72,
                                height: 72,

                                decoration:
                                    BoxDecoration(
                                  shape: BoxShape
                                      .circle,

                                  gradient:
                                      LinearGradient(
                                    colors: [

                                      accentColor
                                          .withOpacity(
                                              0.25),

                                      glowColor
                                          .withOpacity(
                                              0.1),
                                    ],
                                  ),
                                ),

                                child: Icon(
                                  Icons
                                      .restaurant_menu_outlined,

                                  color:
                                      accentColor,

                                  size: 34,
                                ),
                              ),

                              const SizedBox(
                                  width: 22),

                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Text(
                                      "Nutrition Focus",

                                      style:
                                          GoogleFonts
                                              .manrope(
                                        fontSize:
                                            12,

                                        color: Colors
                                            .grey,

                                        fontWeight:
                                            FontWeight
                                                .w700,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            8),

                                    Text(
                                      nutritionFocus,

                                      style:
                                          GoogleFonts
                                              .cormorantGaramond(
                                        fontSize:
                                            30,

                                        height:
                                            1,

                                        fontWeight:
                                            FontWeight
                                                .w700,

                                        color: Colors
                                            .black87,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            10),

                                    Text(
                                      "Disesuaikan dengan hormonal phase dan wellness condition tubuhmu hari ini.",

                                      style:
                                          GoogleFonts
                                              .manrope(
                                        fontSize:
                                            13,

                                        height:
                                            1.7,

                                        color: Colors
                                            .black54,
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

                    const SizedBox(
                        height: 55),

                    // =========================================
                    // SECTION TITLE
                    // =========================================

                    Text(
                      "AI Nourishment Insight",

                      style:
                          GoogleFonts
                              .cormorantGaramond(
                        fontSize: 38,

                        fontWeight:
                            FontWeight
                                .w700,

                        color: Colors
                            .black87,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    Text(
                      "Personalized nutritional guidance generated specially for your hormonal wellness.",

                      style:
                          GoogleFonts
                              .manrope(
                        color:
                            Colors.black54,

                        height: 1.8,

                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(
                        height: 40),

                    // =========================================
                    // AI RESPONSE CARD
                    // =========================================

                    isLoading

                        ? const Center(
                            child:
                                CircularProgressIndicator(),
                          )

                        : ClipRRect(

                            borderRadius:
                                BorderRadius
                                    .circular(
                                        32),

                            child:
                                BackdropFilter(

                              filter:
                                  ImageFilter
                                      .blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),

                              child:
                                  Container(

                                width:
                                    double.infinity,

                                padding:
                                    const EdgeInsets
                                        .all(30),

                                decoration:
                                    BoxDecoration(

                                  color: Colors
                                      .white
                                      .withOpacity(
                                          0.45),

                                  borderRadius:
                                      BorderRadius.circular(
                                          32),

                                  border:
                                      Border.all(
                                    color: Colors
                                        .white
                                        .withOpacity(
                                            0.45),
                                  ),
                                ),

                                child: Text(

                                  aiResponse,

                                  style:
                                      GoogleFonts
                                          .manrope(
                                    fontSize:
                                        14,

                                    height:
                                        2,

                                    color: Colors
                                        .black87,
                                  ),
                                ),
                              ),
                            ),
                          ),

                    const SizedBox(
                        height: 60),
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