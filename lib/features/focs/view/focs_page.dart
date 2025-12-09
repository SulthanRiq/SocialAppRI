import 'package:flutter/material.dart';
// Import widgets
import 'package:projek_mobile/features/focs/widget/post_card.dart';
// Import topic filter
import 'package:projek_mobile/features/focs/view/topic_filter_page.dart';
// Import inbox
import 'package:projek_mobile/features/inbox/view/inbox_page.dart';
// Import comment page
import 'package:projek_mobile/features/focs/view/comment_page.dart';
import '../../dashboard/view/dashboard_register_page.dart';
import '../../notification/view/notification_page.dart';
import '../../search/view/search_page.dart';

class FocsCScreen extends StatefulWidget {
  const FocsCScreen({Key? key}) : super(key: key);

  @override
  State<FocsCScreen> createState() => _FocsCScreenState();
}

class _FocsCScreenState extends State<FocsCScreen> {
  bool isFocsMode = true;
  String selectedTab = 'Focs Mode';
  Set<String> selectedTopics = {};

  @override
  Widget build(BuildContext context) {
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
              _buildSearchBar(),
              _buildTabBar(),
              Expanded(
                child: selectedTab == 'Focs Mode'
                    ? _buildFocsModeContent()
                    : _buildReferenceContent(),
              ),
            ],
          ),
          if (isFocsMode) _buildFocusDialog(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Search Bar with Topic Button
  Widget _buildSearchBar() {
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
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildTopicButton(),
        ],
      ),
    );
  }

  // Topic Filter Button
  Widget _buildTopicButton() {
    return GestureDetector(
      onTap: () async {
        final result = await TopicFilterBottomSheet.show(
          context,
          selectedTopics: selectedTopics,
        );

        if (result != null) {
          setState(() {
            selectedTopics = result;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFB0BEC5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.add, color: Colors.grey[700]),
            const SizedBox(width: 4),
            Text(
              'Topic',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            if (selectedTopics.isNotEmpty) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${selectedTopics.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Tab Bar
  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF7A9CA8),
      child: Row(
        children: [
          _buildTab('Focs Mode', selectedTab == 'Focs Mode'),
          _buildTab('Reference', selectedTab == 'Reference'),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = title;
          });
        },
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
      ),
    );
  }

  // Focs Mode Content - Menggunakan PostCard Widget
  Widget _buildFocsModeContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PostCard(
          name: 'Martina',
          time: '1 jam',
          content: 'Morning Yall, Have a Nice DAYYY !!!',
          likes: '1.2k',
          comments: '2',
          shares: '1',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          onLike: () => _handleLike('post1'),
          onComment: () => _handleComment(
            'post1',
            userName: 'Martina',
            userAvatar: 'https://i.pravatar.cc/150?img=5',
            content: 'Morning Yall, Have a Nice DAYYY !!!',
            time: '1 jam',
            commentCount: 2,
          ),
          onShare: () => _handleShare('post1'),
          onTap: () => _openPostDetail('post1'),
        ),
        PostCard(
          name: 'Martina',
          time: '1 jam',
          content: 'Damnit i wanna explode rn...',
          likes: '856',
          comments: '5',
          shares: '3',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          hasImage: true,
          imageUrl: 'https://picsum.photos/400/300',
          onLike: () => _handleLike('post2'),
          onComment: () => _handleComment(
            'post2',
            userName: 'Martina',
            userAvatar: 'https://i.pravatar.cc/150?img=5',
            content: 'Damnit i wanna explode rn...',
            time: '1 jam',
            imageUrl: 'https://picsum.photos/400/300',
            commentCount: 5,
          ),
          onShare: () => _handleShare('post2'),
        ),
      ],
    );
  }

  // Reference Content - Menggunakan PostCard Widget
  Widget _buildReferenceContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        PostCard(
          name: 'Emma Watson',
          time: '3 jam',
          content:
              'Wanna cheat tip?  Use the Pomodoro technique with 25-minute focused sessions. Your brain needs breaks to stay sharp !!',
          likes: '2.5k',
          comments: '8',
          shares: '12',
          avatarUrl: 'https://i.pravatar.cc/150?img=10',
          category: 'Health',
          onLike: () => _handleLike('post3'),
          onComment: () => _handleComment(
            'post3',
            userName: 'Emma Watson',
            userAvatar: 'https://i.pravatar.cc/150?img=10',
            content:
                'Wanna cheat tip?  Use the Pomodoro technique with 25-minute focused sessions. Your brain needs breaks to stay sharp !!',
            time: '3 jam',
            commentCount: 8,
          ),
        ),
        PostCard(
          name: 'Zack',
          time: '8 jam',
          content: 'Again again n again, undisputed.... #gym',
          likes: '2.2k',
          comments: '4',
          shares: '31',
          avatarUrl: 'https://i.pravatar.cc/150?img=12',
          hasImage: true,
          imageUrl:
              'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400',
          category: 'Sports',
          onLike: () => _handleLike('post4'),
          onComment: () => _handleComment(
            'post4',
            userName: 'Zack',
            userAvatar: 'https://i.pravatar.cc/150?img=12',
            content: 'Again again n again, undisputed.... #gym',
            time: '8 jam',
            imageUrl:
                'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400',
            commentCount: 4,
          ),
        ),
        PostCard(
          name: 'Sarah',
          time: '5 jam',
          content: 'Healty fit checkk :)), get breadfast w me',
          likes: '17.5k',
          comments: '10',
          shares: '31',
          avatarUrl: 'https://i.pravatar.cc/150?img=25',
          hasImage: true,
          imageUrl:
              'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400',
          category: 'Food',
          onLike: () => _handleLike('post5'),
          onComment: () => _handleComment(
            'post5',
            userName: 'Sarah',
            userAvatar: 'https://i.pravatar.cc/150?img=25',
            content: 'Healty fit checkk :)), get breadfast w me',
            time: '5 jam',
            imageUrl:
                'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400',
            commentCount: 10,
          ),
        ),
      ],
    );
  }

  // Focus Mode Dialog
  Widget _buildFocusDialog() {
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
                onPressed: () {
                  setState(() {
                    isFocsMode = false;
                  });
                },
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

  // Bottom Navigation Bar
  Widget _buildBottomNavBar() {
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
          _buildNavItem(Icons.home, false, 0),
          _buildNavItem(Icons.search, false, 1),
          _buildNavItem(Icons.add_box, true, 2),
          _buildNavItem(Icons.notifications, false, 3),
          _buildNavItem(Icons.chat_bubble, false, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, int index) {
    return GestureDetector(
      onTap: () {
        if (isActive) return;

        switch (index) {
          case 0:
            // Home - Kembali ke HomePage
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomePage(),
                ),
            );
            break;
          case 1:
            // Search - TODO: Tambahkan navigasi ke SearchScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
            break;
          case 2:
            break;
          case 3:
            // Notifications - TODO: Tambahkan navigasi ke NotificationScreen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()
                ),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InboxScreen()),
            );
            break;
        }
      },
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

  // Handler Methods
  void _handleLike(String postId) {
    _showSnackBar('Liked post $postId');
    // TODO: Implement like logic
  }

  void _handleComment(
    String postId, {
    required String userName,
    required String userAvatar,
    required String content,
    required String time,
    String? imageUrl,
    required int commentCount,
  }) async {
    // Navigate to comment page
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentPage(
          postId: postId,
          postUserName: userName,
          postUserAvatar: userAvatar,
          postContent: content,
          postTime: time,
          postImageUrl: imageUrl,
          initialCommentCount: commentCount,
        ),
      ),
    );

    // Update comment count if returned
    if (result != null && result is int) {
      _showSnackBar('Comment count updated: $result');
      // TODO: Update post comment count
    }
  }

  void _handleShare(String postId) {
    _showSnackBar('Share post $postId');
    // TODO: Implement share functionality
  }

  void _openPostDetail(String postId) {
    _showSnackBar('Opening post $postId details');
    // TODO: Navigate to post detail screen
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
