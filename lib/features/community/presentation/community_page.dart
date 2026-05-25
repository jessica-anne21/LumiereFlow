import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF8),

      // =========================================
      // APPBAR
      // =========================================

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: Text(
          "Lumière Circle",
          style: GoogleFonts.cormorantGaramond(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 28,
            letterSpacing: 1.2,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),

      // =========================================
      // BODY
      // =========================================

      body: Column(
        children: [

          const CommunityCategoryTabs(),

          // =========================================
          // POSTS
          // =========================================

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('community_posts')
                  .orderBy(
                    'created_at',
                    descending: true,
                  )
                  .snapshots(),

              builder: (context, snapshot) {

                // =========================================
                // LOADING
                // =========================================

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // =========================================
                // EMPTY
                // =========================================

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {

                  return Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [

                          const Text(
                            "🤍",
                            style: TextStyle(
                              fontSize: 70,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Text(
                            "Belum Ada Post",
                            style: GoogleFonts
                                .cormorantGaramond(
                              fontSize: 36,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Mulai berbagi cerita dan dukung perempuan lain di Lumière Circle ✨",
                            textAlign:
                                TextAlign.center,
                            style:
                                GoogleFonts.manrope(
                              fontSize: 14,
                              color:
                                  Colors.black54,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final posts =
                    snapshot.data!.docs;

                // =========================================
                // POSTS LIST
                // =========================================

                return ListView.separated(
                  padding:
                      const EdgeInsets.all(20),

                  itemCount: posts.length,

                  separatorBuilder:
                      (context, index) =>
                          const SizedBox(
                    height: 20,
                  ),

                  itemBuilder: (context, index) {

                    final post =
                        posts[index].data()
                            as Map<String, dynamic>;

                    return CommunityPostTile(
                      postId: posts[index].id,
                      username:
                          post['username'] ??
                              "GlowSister",
                      phase:
                          post['phase'] ??
                              "Menstrual Phase",
                      content:
                          post['content'] ?? "",
                      likes:
                          post['likes'] ?? 0,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // =========================================
      // FLOATING BUTTON
      // =========================================

      floatingActionButton:
          FloatingActionButton(
        backgroundColor:
            const Color(0xFFD4A5A5),

        elevation: 4,

        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),

        onPressed: () {

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor:
                Colors.transparent,

            builder: (_) =>
                const CreatePostSheet(),
          );
        },
      ),
    );
  }
}

// =========================================
// CATEGORY TABS
// =========================================

class CommunityCategoryTabs
    extends StatelessWidget {

  const CommunityCategoryTabs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final List<String> categories = [
      "Trending",
      "Phase Support",
      "Self-Care",
      "Nutrition",
    ];

    return Container(
      height: 50,

      margin:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),

      child: ListView.separated(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
        ),

        scrollDirection:
            Axis.horizontal,

        itemCount: categories.length,

        separatorBuilder:
            (context, index) =>
                const SizedBox(width: 12),

        itemBuilder: (context, index) {

          bool isSelected =
              index == 0;

          return Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),

            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(
                      0xFFD4A5A5)
                  : Colors.white,

              borderRadius:
                  BorderRadius.circular(
                      25),

              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : const Color(
                        0xFFFCE4EC),
              ),
            ),

            child: Center(
              child: Text(
                categories[index],

                style:
                    GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================
// COMMUNITY POST TILE
// =========================================

class CommunityPostTile
    extends StatelessWidget {

  final String postId;
  final String username;
  final String phase;
  final String content;
  final int likes;

  const CommunityPostTile({
    super.key,
    required this.postId,
    required this.username,
    required this.phase,
    required this.content,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:
          const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(25),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withOpacity(0.03),

            blurRadius: 15,

            offset:
                const Offset(0, 8),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // =========================================
          // TOP
          // =========================================

          Row(
            children: [

              CircleAvatar(
                radius: 20,

                backgroundColor:
                    const Color(
                        0xFFFCE4EC),

                child: Text(
                  username[0],

                  style: const TextStyle(
                    color:
                        Color(0xFFD4A5A5),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Text(
                      username,

                      style:
                          GoogleFonts.manrope(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    Text(
                      phase,

                      style:
                          GoogleFonts.manrope(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(
                  Icons.more_horiz,
                  size: 20,
                  color: Colors.grey,
                ),

                onPressed: () {},
              )
            ],
          ),

          const SizedBox(height: 15),

          // =========================================
          // CONTENT
          // =========================================

          Text(
            content,

            style:
                GoogleFonts.manrope(
              fontSize: 14,
              height: 1.8,
              color: Colors.black87,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 15),

          // =========================================
          // ACTIONS
          // =========================================

          Row(
            children: [

              GestureDetector(
                onTap: () async {

                  await FirebaseFirestore
                      .instance
                      .collection(
                          'community_posts')
                      .doc(postId)
                      .update({
                    'likes':
                        FieldValue.increment(
                            1),
                  });
                },

                child: _buildActionButton(
                  Icons.favorite_border,
                  "$likes",
                ),
              ),

              const SizedBox(width: 20),

              _buildActionButton(
                Icons.chat_bubble_outline,
                "0",
              ),

              const Spacer(),

              const Icon(
                Icons.bookmark_border,
                size: 20,
                color: Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String count,
  ) {

    return Row(
      children: [

        Icon(
          icon,
          size: 20,
          color: Colors.grey,
        ),

        const SizedBox(width: 6),

        Text(
          count,

          style:
              GoogleFonts.manrope(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// =========================================
// CREATE POST SHEET
// =========================================

class CreatePostSheet
    extends StatefulWidget {

  const CreatePostSheet({
    super.key,
  });

  @override
  State<CreatePostSheet>
      createState() =>
          _CreatePostSheetState();
}

class _CreatePostSheetState
    extends State<CreatePostSheet> {

  final TextEditingController
      controller =
      TextEditingController();

  bool isPosting = false;

  Future<void> createPost() async {

    final user =
        FirebaseAuth.instance
            .currentUser;

    if (user == null) return;

    if (controller.text
        .trim()
        .isEmpty) return;

    try {

      setState(() {
        isPosting = true;
      });

      // =========================================
      // GET USER DATA
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

      final username =
          userData['username'] ??
              "GlowSister";

      final phase =
          userData['current_phase'] ??
              "Menstrual Phase";

      // =========================================
      // SAVE POST
      // =========================================

      await FirebaseFirestore
          .instance
          .collection(
              'community_posts')
          .add({

        'username': username,

        'phase': phase,

        'content':
            controller.text.trim(),

        'created_at':
            Timestamp.now(),

        'likes': 0,

        'user_uid': user.uid,
      });

      if (mounted) {
        Navigator.pop(context);
      }

    } catch (e) {

      print(e);

    } finally {

      setState(() {
        isPosting = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context)
                .viewInsets
                .bottom,
      ),

      child: Container(
        padding:
            const EdgeInsets.all(24),

        decoration:
            const BoxDecoration(
          color: Color(0xFFFDFBF8),

          borderRadius:
              BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [

            Container(
              width: 50,
              height: 5,

              decoration: BoxDecoration(
                color: Colors.grey
                    .shade300,

                borderRadius:
                    BorderRadius.circular(
                        10),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Share Your Thoughts ✨",

              style:
                  GoogleFonts.cormorantGaramond(
                fontSize: 32,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: controller,

              maxLines: 6,

              style:
                  GoogleFonts.manrope(),

              decoration: InputDecoration(
                hintText:
                    "Bagikan pengalaman hormonal wellness kamu hari ini...",

                hintStyle:
                    GoogleFonts.manrope(
                  color:
                      Colors.grey,
                ),

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                          20),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                          0xFFD4A5A5),

                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 16,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                ),

                onPressed:
                    isPosting
                        ? null
                        : createPost,

                child:
                    isPosting
                        ? const CircularProgressIndicator(
                          color:
                              Colors.white,
                        )
                        : Text(
                          "Post",

                          style:
                              GoogleFonts
                                  .manrope(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}