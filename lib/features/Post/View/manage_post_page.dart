import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/post_model.dart';
import '../../create_post/view/create_post_page.dart';
import '../../../core/controllers/post_controller.dart';
import '../../../core/controllers/auth_controller.dart';

class ManagePostPage extends StatelessWidget {
  const ManagePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092);
    const Color bgColor = Color(0xFFB8C5CC);

    final PostController postController = Get.find<PostController>();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP BAR =====
            Container(
              height: 56,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Manage Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: Obx(() {
                    final user = authController.currentUser.value;
                    if (user == null) {
                      return const Center(child: Text('User belum login'));
                    }

                    // 🔥 FILTER POST MILIK USER LOGIN
                    final userPosts = postController.posts
                        .where((post) => post.userId == user.uid)
                        .toList();

                    return Column(
                      children: [
                        // Avatar
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (user.photoUrl != null &&
                                  user.photoUrl!.isNotEmpty &&
                                  user.photoUrl!.startsWith('http'))
                                  ? NetworkImage(user.photoUrl!)
                                  : const AssetImage('assets/images/profile.jpg'),

                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Nama user
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ✅ JUMLAH POST SAJA
                        _StatItem(
                          value: userPosts.length.toString(),
                          label: 'Post',
                        ),

                        const SizedBox(height: 14),

                        // Button Buat Post
                        SizedBox(
                          width: 190,
                          height: 36,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const CreatePostScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add,
                                size: 18, color: Colors.black),
                            label: const Text(
                              'Buat Postingan',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ===== LIST POST USER =====
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Postingan Saya',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // LIST
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userPosts.length,
                          itemBuilder: (context, index) {
                            final post = userPosts[index];

                            return _UserPostItem(
                              post: post,
                              onDelete: () async {
                                await postController.deletePost(post);
                              },
                            );
                          },
                        ),

                        if (userPosts.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text(
                              'Belum ada postingan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),


                        const SizedBox(height: 24),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _UserPostItem extends StatelessWidget {
  final PostModel post;
  final VoidCallback onDelete;

  const _UserPostItem({
    required this.post,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.article, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Content
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),

            // Image (jika ada)
            if (post.imageBase64 != null &&
                post.imageBase64!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(post.imageBase64!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            // Footer
            Row(
              children: [
                const Icon(Icons.favorite_border, size: 14),
                const SizedBox(width: 4),
                Text(
                  post.likes.toString(),
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.comment, size: 14),
                const SizedBox(width: 4),
                Text(
                  post.commentsCount.toString(),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


