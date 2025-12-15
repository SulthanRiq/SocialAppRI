// ============================================
// FILE: lib/features/focs/view/focs_page.dart
// COPY SELURUH ISI INI DAN REPLACE FILE ANDA
// ============================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import dari feature focs
import '../widget/post_card.dart';
import '../widget/share_bottom_sheet.dart';
import '../model/post_model.dart';
import '../controller/focs_controller.dart';
import '../widget/topic_filter_bottom_sheet.dart';

// Import dari feature lain
import '../../dashboard/view/dashboard_register_page.dart';
import '../../notification/view/notification_page.dart';
import '../../search/view/search_page.dart';
import '../../inbox/view/inbox_page.dart';

class FocsCScreen extends StatelessWidget {
  const FocsCScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(FocsController());

    return Scaffold(
      backgroundColor: const Color(0xFF7A9CA8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A9CA8),
        elevation: 0,
        title: const Text(
          'Focs - C',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSearchBar(controller),
              _buildTabBar(controller),
              Expanded(
                child: _buildContent(controller),
              ),
            ],
          ),
          // Focus dialog - reactive
          Obx(() => controller.isFocsMode
              ? _buildFocusDialog(controller)
              : const SizedBox.shrink()),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // ========================================
  // SEARCH BAR
  // ========================================
  Widget _buildSearchBar(FocsController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFB0BEC5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => controller.searchPosts(value),
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Obx(() => controller.searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => controller.clearSearch(),
                    color: Colors.grey[600],
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildTopicButton(controller),
        ],
      ),
    );
  }

  // ============================================
// COPY METHOD INI DAN GANTI DI focs_page.dart
// Sekitar line 115-143
// ============================================

  Widget _buildTopicButton(FocsController controller) {
    return GestureDetector(
      onTap: () async {
        try {
          // Pastikan context valid
          final context = Get.context;
          if (context == null) {
            print('Context is null');
            return;
          }

          // Panggil TopicFilterBottomSheet
          final result = await TopicFilterBottomSheet.show(
            context,
            selectedTopics: controller.selectedTopics,
          );

          // Jika user pilih topics dan klik Done
          if (result != null) {
            controller.setSelectedTopics(result);
          }
        } catch (e) {
          print('Error showing bottom sheet: $e');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFB0BEC5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(
              'Topic',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
            Obx(() => controller.hasSelectedTopics
                ? Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Center(
                child: Text(
                  '${controller.selectedTopicsCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
  // ========================================
  // TAB BAR
  // ========================================
  Widget _buildTabBar(FocsController controller) {
    return Container(
      color: const Color(0xFF7A9CA8),
      child: Row(
        children: [
          _buildTab(controller, 'Focs Mode'),
          _buildTab(controller, 'Reference'),
        ],
      ),
    );
  }

  Widget _buildTab(FocsController controller, String title) {
    return Expanded(
      child: Obx(() {
        final isActive = controller.isTabSelected(title);
        return GestureDetector(
          onTap: () => controller.selectTab(title),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isActive ? Colors.black : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }),
    );
  }

  // ========================================
  // CONTENT
  // ========================================
  Widget _buildContent(FocsController controller) {
    return Obx(() {
      // Loading state
      if (controller.isLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }

      // Error state
      if (controller.errorMessage != null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.white.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                controller.errorMessage!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.refreshPosts(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B95A8),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final posts = controller.getCurrentPosts();

      // Empty state
      if (posts.isEmpty) {
        return _buildEmptyState(
          controller.searchQuery.isNotEmpty
              ? 'Tidak ada hasil untuk "${controller.searchQuery}"'
              : controller.hasSelectedTopics
              ? 'Tidak ada post untuk topik yang dipilih'
              : 'Belum ada postingan',
        );
      }

      // Posts list
      return RefreshIndicator(
        onRefresh: () => controller.refreshPosts(),
        color: const Color(0xFF7A9CA8),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(
              post: post,
              onLike: () => _handleLike(controller, post.id),
              onComment: () => _handleComment(controller, post.id),
              onShare: () => _handleShare(controller, post),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ========================================
  // FOCUS DIALOG
  // ========================================
  Widget _buildFocusDialog(FocsController controller) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF6BA89F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Saat ini Anda Beralih ke\nMode Fokus',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => controller.dismissFocsMode(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6D6D6),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Mengerti',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========================================
  // BOTTOM NAVIGATION BAR
  // ========================================
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF6B95A8),
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
          _buildNavItem(Icons.home, false, 0, context),
          _buildNavItem(Icons.search, false, 1, context),
          _buildNavItem(Icons.add_box, true, 2, context),
          _buildNavItem(Icons.notifications, false, 3, context),
          _buildNavItem(Icons.chat_bubble, false, 4, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, int index, BuildContext context) {
    return GestureDetector(
      onTap: () => _onNavItemTapped(context, index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
              size: 28,
            ),
            if (isActive)
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

  // ========================================
  // NAVIGATION HANDLER
  // ========================================
  void _onNavItemTapped(BuildContext context, int index) {
    print('Navbar tapped: index $index');

    if (index == 2) {
      print('Already on Focs page');
      return;
    }

    try {
      switch (index) {
        case 0:
          print('Navigating to Home');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          break;
        case 1:
          print('Navigating to Search');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
          break;
        case 3:
          print('Navigating to Notification');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NotificationScreen()
            ),
          );
          break;
        case 4:
          print('Navigating to Inbox');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InboxScreen()),
          );
          break;
        default:
          print('Unknown index: $index');
      }
    } catch (e) {
      print('Navigation error: $e');
      Get.snackbar(
        'Error',
        'Gagal navigasi: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ========================================
  // INTERACTION HANDLERS
  // ========================================
  void _handleLike(FocsController controller, String postId) {
    controller.likePost(postId);

    Get.snackbar(
      'Like',
      'Post liked!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF6B95A8),
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(16),
    );
  }

  void _handleComment(FocsController controller, String postId) {
    Get.snackbar(
      'Comment',
      'Comment feature akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF6B95A8),
      colorText: Colors.white,
    );
  }

  void _handleShare(FocsController controller, Post post) {
    ShareBottomSheet.show(
      Get.context!,
      postId: post.id,
      content: post.content,
      imageUrl: post.imageUrl,
      onShare: () {
        controller.sharePost(post.id);
      },
    );
  }
}