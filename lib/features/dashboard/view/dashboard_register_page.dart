// Home Page

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projek_mobile/core/controllers/post_controller.dart';
import 'package:projek_mobile/features/inbox/view/inbox_page.dart';
import 'package:projek_mobile/features/profile/view/profile.dart';
import 'package:projek_mobile/features/focs/view/focs_page.dart';
import 'package:projek_mobile/features/notification/view/notification_page.dart';
import 'package:projek_mobile/features/search/view/search_page.dart';
import 'package:projek_mobile/features/create_post/view/create_post_page.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../register/widgets/base64_image_widget.dart';
import '../../comment/view/comment_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _selectedTabIndex = 0;

  final AuthController authController = Get.find<AuthController>();
  final PostController postController = Get.find<PostController>();

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8);
    final Color bgColor = const Color(0xFFB8C5CC);
    final Color cardColor = const Color(0xFFD9D9D9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan foto profil dan tombol add
            Container(
              height: 70,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Foto profil (kiri)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileMenuPage(),
                        ),
                      );
                    },
                    child: Obx(() {
                      final user = authController.currentUser.value;
                      final photoUrl = user?.photoUrl;

                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Base64CircleAvatar(
                          base64String: photoUrl,
                          radius: 24,
                          backgroundColor: Colors.grey.shade300,
                        ),
                      );
                    }),
                  ),

                  // Tombol add (kanan)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePostScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black54,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // TAB BAR (For You, Icon, Following)
            Container(
              height: 50,
              color: const Color(0xFFA8B5BC),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tab For You
                  _buildTabItem("For You", 0),

                  // Icon tengah
                  Image.asset(
                    'assets/images/social_bear_small.png',
                    height: 35,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.pets, size: 30);
                    },
                  ),

                  // Tab Following
                  _buildTabItem("Following", 1),
                ],
              ),
            ),

            // CONTENT AREA
            Expanded(
              child: Obx(() {
                // Loading state
                if (postController.isLoading.value && postController.posts.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Empty state
                if (postController.posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada postingan',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // List of posts
                return RefreshIndicator(
                  onRefresh: () async {
                    postController.refreshPosts();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: postController.posts.length,
                    itemBuilder: (context, index) {
                      final post = postController.posts[index];
                      final isLiked = postController.isPostLikedByCurrentUser(post);
                      final isOwnPost = postController.isOwnPost(post);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // USER INFO & DELETE BUTTON
                            Row(
                              children: [
                                Base64CircleAvatar(
                                  base64String: post.userPhoto,
                                  radius: 20,
                                  backgroundColor: Colors.grey.shade400,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.username,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        _formatTime(post.createdAt),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Delete button (hanya untuk post sendiri)
                                if (isOwnPost)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    onPressed: () {
                                      _showDeleteDialog(context, post);
                                    },
                                  ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // CONTENT
                            Text(
                              post.content,
                              style: const TextStyle(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),

                            // IMAGE
                            if (post.imageBase64 != null) ...[
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  base64Decode(post.imageBase64!),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ],

                            const SizedBox(height: 12),

                            // DIVIDER
                            Divider(
                              color: Colors.grey.shade400,
                              thickness: 1,
                            ),

                            const SizedBox(height: 8),

                            // ✅ LIKE BUTTON & COUNT
                            Row(
                              children: [
                                // Like Button
                                InkWell(
                                  onTap: isOwnPost
                                      ? null
                                      : () => postController.toggleLike(post),
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isOwnPost
                                              ? Colors.grey.shade400
                                              : (isLiked
                                              ? Colors.red
                                              : Colors.grey.shade700),
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${post.likes}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // COMMENT BUTTON
                                InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => CommentBottomSheet(post: post),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.comment_outlined,
                                          color: Colors.grey.shade700,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${post.commentsCount}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Info untuk post sendiri
                                if (isOwnPost) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    '(Postingan Anda)',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: topBarColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Home
            _buildNavItem(
              icon: Icons.home,
              isSelected: _selectedIndex == 0,
              onTap: () => setState(() => _selectedIndex = 0),
            ),

            // Search
            _buildNavItem(
              icon: Icons.search,
              isSelected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
            ),

            // Create / Focs Mode
            _buildNavItem(
              icon: Icons.add_box,
              isSelected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FocsCScreen(),
                  ),
                );
              },
            ),

            // Notifications
            _buildNavItem(
              icon: Icons.notifications,
              isSelected: _selectedIndex == 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
            ),

            // Messages
            _buildNavItem(
              icon: Icons.chat_bubble,
              isSelected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InboxScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk navigation item
  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 28,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk tab item (For You / Following)
  Widget _buildTabItem(String text, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 40,
              color: Colors.black87,
            ),
        ],
      ),
    );
  }

  // ✅ FORMAT WAKTU
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }

  // ✅ DELETE DIALOG
  void _showDeleteDialog(BuildContext context, post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Postingan'),
        content: const Text('Apakah Anda yakin ingin menghapus postingan ini?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          TextButton(
            onPressed: () {
              postController.deletePost(post);
              Navigator.pop(context);
              Get.snackbar(
                'Sukses',
                'Postingan berhasil dihapus',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}