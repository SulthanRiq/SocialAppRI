import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

// Import models & controllers
import '../../../core/models/post_model.dart';
import '../controller/focs_controller.dart';
import '../widget/topic_filter_bottom_sheet.dart';

// Import pages
import '../../dashboard/view/dashboard_register_page.dart';
import '../../notification/view/notification_page.dart';
import '../../search/view/search_page.dart';
import '../../inbox/view/inbox_page.dart';
import '../../register/widgets/base64_image_widget.dart';
import '../../comment/view/comment_bottom_sheet.dart';
import '../../dashboard/view/share_post_view.dart';

// Import controllers
import '../../../core/controllers/post_controller.dart';

class FocsCScreen extends StatelessWidget {
  const FocsCScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FocsController());

    return Scaffold(
      backgroundColor: const Color(0xFF7A9CA8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A9CA8),
        elevation: 0,
        title: const Text(
          'Focs - Focus Content',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          // Focus session indicator
          Obx(() {
            if (controller.isFocusSessionActive.value) {
              return Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      controller.focusTimeFormatted,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(controller),
          _buildTabBar(controller),
          Expanded(
            child: _buildContent(controller, context),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: _buildFocusButton(controller, context),
    );
  }

  // ========================================
  // SEARCH BAR
  // ========================================
  Widget _buildSearchBar(FocsController controller) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF7A9CA8),
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
                        hintText: 'Search posts...',
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

  Widget _buildTopicButton(FocsController controller) {
    return GestureDetector(
      onTap: () async {
        try {
          final context = Get.context;
          if (context == null) return;

          final result = await TopicFilterBottomSheet.show(
            context,
            selectedTopics: controller.selectedTopics,
          );

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
            Icon(Icons.filter_list, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(
              'Topics',
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
                  color: isActive ? Colors.white : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
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
  Widget _buildContent(FocsController controller, BuildContext context) {
    return Obx(() {
      // Loading state
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      }

      // Error state
      if (controller.errorMessage.value != null) {
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
                controller.errorMessage.value!,
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
        return _buildEmptyState(controller);
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
            return _buildPostCard(post, context);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(FocsController controller) {
    String message = 'Belum ada postingan';

    if (controller.searchQuery.isNotEmpty) {
      message = 'Tidak ada hasil untuk "${controller.searchQuery.value}"';
    } else if (controller.hasSelectedTopics) {
      message = 'Tidak ada post untuk topik yang dipilih.\n\nTambahkan topik saat membuat post!';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            controller.hasSelectedTopics ? Icons.filter_list_off : Icons.inbox_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (controller.hasSelectedTopics) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.setSelectedTopics({}),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF7A9CA8),
              ),
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  // ========================================
  // POST CARD
  // ========================================
  Widget _buildPostCard(PostModel post, BuildContext context) {
    final postController = Get.find<PostController>();
    final isLiked = postController.isPostLikedByCurrentUser(post);
    final isOwnPost = postController.isOwnPost(post);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // USER INFO
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

          // TOPICS CHIPS
          if (post.topics.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: post.topics.map((topic) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTopicColor(topic),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    topic,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],

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

          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 8),

          // ACTIONS
          Row(
            children: [
              // Like
              InkWell(
                onTap: isOwnPost ? null : () => postController.toggleLike(post),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isOwnPost
                            ? Colors.grey.shade400
                            : (isLiked ? Colors.red : Colors.grey.shade700),
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.likes}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Comment
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${post.commentsCount}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Share
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SharePostView(post: post),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    Icons.share_outlined,
                    color: Colors.grey.shade700,
                    size: 20,
                  ),
                ),
              ),

              const Spacer(),

              if (isOwnPost)
                Text(
                  '(Postingan Anda)',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTopicColor(String topic) {
    final colors = {
      'Technology': const Color(0xFFB8860B),
      'Sports': const Color(0xFF6B9B7F),
      'Design': const Color(0xFF9B8BB3),
      'Business': const Color(0xFF8FA870),
      'Politics': const Color(0xFF4A3A3A),
      'Science': const Color(0xFF2B5F75),
      'Health': const Color(0xFFA97676),
      'Gaming': const Color(0xFF4A8B8B),
    };
    return colors[topic] ?? Colors.grey;
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showDeleteDialog(BuildContext context, PostModel post) {
    final postController = Get.find<PostController>();

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

  // ========================================
  // FOCUS BUTTON
  // ========================================
  Widget _buildFocusButton(FocsController controller, BuildContext context) {
    return Obx(() {
      if (controller.isFocusSessionActive.value) {
        return FloatingActionButton.extended(
          onPressed: () => _showEndSessionDialog(context, controller),
          backgroundColor: Colors.red,
          icon: const Icon(Icons.stop),
          label: Text(controller.focusTimeFormatted),
        );
      } else {
        return FloatingActionButton.extended(
          onPressed: () => _showFocusSessionDialog(context, controller),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF7A9CA8),
          icon: const Icon(Icons.timer),
          label: const Text('Focus'),
        );
      }
    });
  }

  void _showFocusSessionDialog(BuildContext context, FocsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Focus Session'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose duration:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            _buildDurationOption(context, controller, 15, '15 minutes', 'Quick focus'),
            const SizedBox(height: 8),
            _buildDurationOption(context, controller, 25, '25 minutes', 'Pomodoro'),
            const SizedBox(height: 8),
            _buildDurationOption(context, controller, 45, '45 minutes', 'Deep work'),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildDurationOption(
      BuildContext context,
      FocsController controller,
      int minutes,
      String title,
      String subtitle,
      ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        controller.startFocusSession(minutes: minutes);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF7A9CA8).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timer,
                color: Color(0xFF7A9CA8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context, FocsController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Focus Session?'),
        content: Text(
          'Time remaining: ${controller.focusTimeFormatted}\n\nAre you sure you want to end this session?',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.endFocusSession();
            },
            child: const Text(
              'End Session',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ========================================
  // BOTTOM NAVIGATION BAR
  // ========================================
  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
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
      child: SafeArea(
        child: Container(
          height: 65,
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
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon,
      bool isActive,
      int index,
      BuildContext context,
      ) {
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

  void _onNavItemTapped(BuildContext context, int index) {
    if (index == 2) return; // Already on Focs page

    try {
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
          break;
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
          );
          break;
        case 3:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          );
          break;
        case 4:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InboxScreen()),
          );
          break;
      }
    } catch (e) {
      print('Navigation error: $e');
    }
  }
}