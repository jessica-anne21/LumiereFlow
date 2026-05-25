import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DiaryTimelinePage extends StatelessWidget {
  const DiaryTimelinePage({super.key});

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();

    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return "${date.day} ${months[date.month]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Row(
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
                  ),

                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .collection('diary_entries')
                          .orderBy(
                            'created_at',
                            descending: true,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child:
                                CircularProgressIndicator(
                              color: accentColor,
                            ),
                          );
                        }


                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text(
                                  "🤍",
                                  style: const TextStyle(
                                    fontSize: 80,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Text(
                                  "Belum Ada Emotional Diary",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts
                                      .cormorantGaramond(
                                    fontSize: 38,
                                    fontWeight:
                                        FontWeight.w700,
                                    color:
                                        Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  "Mulai tuliskan perasaan dan pengalamanmu untuk membangun emotional timeline personal.",
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      GoogleFonts.manrope(
                                    fontSize: 14,
                                    height: 1.9,
                                    color:
                                        Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final entries =
                            snapshot.data!.docs;
                        return SingleChildScrollView(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "EMOTIONAL TIMELINE",
                                style:
                                    GoogleFonts.manrope(
                                  color: accentColor,
                                  fontWeight:
                                      FontWeight.w800,
                                  letterSpacing: 2.5,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(height: 14),

                              Text(
                                "Perjalanan emosimu\ndari waktu ke waktu.",
                                style: GoogleFonts
                                    .cormorantGaramond(
                                  fontSize: 46,
                                  height: 1.05,
                                  fontWeight:
                                      FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Text(
                                "Lihat kembali pola emosi, pengalaman, dan perjalanan yang telah kamu lalui.",
                                style:
                                    GoogleFonts.manrope(
                                  fontSize: 14,
                                  height: 1.9,
                                  color:
                                      Colors.black54,
                                  fontWeight:
                                      FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 50),

                              ListView.separated(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount: entries.length,
                                separatorBuilder:
                                    (context, index) =>
                                        const SizedBox(
                                  height: 30,
                                ),
                                itemBuilder:
                                    (context, index) {
                                  final entry =
                                      entries[index];

                                  final data =
                                      entry.data()
                                          as Map<String,
                                              dynamic>;

                                  final String mood =
                                      data['mood'] ??
                                          '☺️';

                                  final String journal =
                                      data['journal'] ??
                                          '';

                                  final Timestamp
                                      timestamp =
                                      data[
                                              'created_at'] ??
                                          Timestamp.now();

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [

                                      Column(
                                        children: [
                                          Container(
                                            width: 22,
                                            height: 22,
                                            decoration:
                                                BoxDecoration(
                                              shape: BoxShape
                                                  .circle,
                                              color:
                                                  accentColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: accentColor
                                                      .withOpacity(
                                                          0.25),
                                                  blurRadius:
                                                      18,
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                mood,
                                                style:
                                                    const TextStyle(
                                                  fontSize:
                                                      10,
                                                ),
                                              ),
                                            ),
                                          ),

                                          if (index !=
                                              entries
                                                      .length -
                                                  1)
                                            Container(
                                              width: 1.5,
                                              height: 220,
                                              color: accentColor
                                                  .withOpacity(
                                                      0.2),
                                            ),
                                        ],
                                      ),

                                      const SizedBox(
                                          width: 24),

                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      32),
                                          child:
                                              BackdropFilter(
                                            filter:
                                                ImageFilter
                                                    .blur(
                                              sigmaX:
                                                  10,
                                              sigmaY:
                                                  10,
                                            ),
                                            child:
                                                Container(
                                              padding:
                                                  const EdgeInsets
                                                      .all(
                                                          26),
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
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .black
                                                        .withOpacity(
                                                            0.03),
                                                    blurRadius:
                                                        20,
                                                    offset:
                                                        const Offset(
                                                            0,
                                                            10),
                                                  ),
                                                ],
                                              ),
                                              child:
                                                  Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                children: [

                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                          horizontal:
                                                              14,
                                                          vertical:
                                                              8,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: accentColor.withOpacity(
                                                              0.12),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  16),
                                                        ),
                                                        child:
                                                            Text(
                                                          formatDate(
                                                              timestamp),
                                                          style:
                                                              GoogleFonts.manrope(
                                                            fontSize:
                                                                11,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                accentColor,
                                                          ),
                                                        ),
                                                      ),

                                                      const Spacer(),

                                                      Text(
                                                        mood,
                                                        style:
                                                            const TextStyle(
                                                          fontSize:
                                                              32,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  const SizedBox(
                                                      height:
                                                          22),
                                                  Text(
                                                    journal,
                                                    style:
                                                        GoogleFonts.manrope(
                                                      fontSize:
                                                          14,
                                                      height:
                                                          2,
                                                      color:
                                                          Colors.black87,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}