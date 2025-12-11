import 'package:flutter/material.dart';
import 'package:projek_mobile/common/widgets/custom_bottom_navbar.dart';
import 'package:projek_mobile/common/widgets/post_card_widget.dart';
import 'package:projek_mobile/features/profile/view/profile.dart';
import 'package:projek_mobile/features/focs/view/focs_page.dart';
import 'package:projek_mobile/features/dashboard/view/share_view.dart';
import 'package:projek_mobile/features/dashboard/view/article_detail_view.dart';
import 'package:projek_mobile/features/dashboard/view/health_comment_view.dart';
import 'package:projek_mobile/features/dashboard/view/politics_comment_view.dart';
import '../../search/view/search_page.dart' hide CustomBottomNavBar;
import '../../notification/view/notification_page.dart' hide CustomBottomNavBar;
import '../../inbox/view/inbox_page.dart';
import '../../create_post/view/create_post_page.dart';
import 'package:share_plus/share_plus.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  int _selectedTabIndex = 0;
  late final List<Map<String, dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = _buildPostsData();
  }

  List<Map<String, dynamic>> _buildPostsData() {
    return [
      {
        'type': 'health',
        'username': '@lifestyle_daily',
        'content': 'Tips hidup sehat...',
        'imageUrl': 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80',
        'likes': '20.5k',
        'comments': '2k',
        'shares': '12',
        'isNews': false,
        'articleId': 'health_1',
        'title': 'Tips Hidup Sehat: 5 Kebiasaan yang Wajib Diterapkan',
        'fullContent': 'Menerapkan gaya hidup sehat sangat penting untuk kesejahteraan jangka panjang. Berikut adalah 5 kebiasaan sederhana yang dapat Anda terapkan setiap hari untuk meningkatkan kualitas hidup Anda.',
      },
      {
        'type': 'politics',
        'username': '@Breaking_News',
        'time': '15m',
        'content': 'Trending Now\n\n"POLITISI X KORUPSI TRILIUNAN RUPIAH !\nBukti Mengejutkan ! "',
        'subContent': '[Breaking News Image]',
        'source': 'detik.com',
        'trustScore': 'Trust: 7.5/10',
        'likes': '150.2k',
        'comments': '21,4 k',
        'shares': '',
        'isNews': true,
        'articleId': 'politics_1',
        'title': 'POLITISI X KORUPSI TRILIUNAN RUPIAH !',
        'fullContent': 'Bukti mengejutkan telah ditemukan terkait kasus korupsi yang melibatkan politisi ternama. Investigasi mendalam mengungkap skema korupsi yang merugikan negara triliunan rupiah.',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF6B95A8);
    const Color bgColor = Color(0xFFB8C5CC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              topBarColor: topBarColor,
              onProfileTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileMenuPage()),
              ),
              onAddTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreatePostScreen()),
              ),
            ),
            _TabBar(
              selectedTabIndex: _selectedTabIndex,
              onTabChanged: (index) => setState(() => _selectedTabIndex = index),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                itemCount: _posts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final post = _posts[index];
                  return _buildPostCard(context, post);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _handleNavigation,
      ),
    );
  }

  void _handleNavigation(int index) {
    setState(() => _selectedIndex = index);

    final routes = {
      1: () => const SearchScreen(),
      2: () => const FocsCScreen(),
      3: () => const NotificationScreen(),
      4: () => const InboxScreen(),
    };

    final route = routes[index];
    if (route != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => route()));
    }
  }

  Widget _buildPostCard(BuildContext context, Map<String, dynamic> post) {
    if (post['type'] == 'health') {
      return PostCard(
        avatarColor: Colors.transparent,
        username: post['username'],
        content: post['content'],
        imageUrl: post['imageUrl'],
        likes: post['likes'],
        comments: post['comments'],
        shares: post['shares'],
        isNews: post['isNews'],
        onCommentTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HealthCommentView(articleId: post['articleId']),
          ),
        ),
        // Icon share kecil langsung buka bottom sheet
        onShareIconTap: () => _showShareBottomSheet(
          context,
          title: post['title'],
          content: post['fullContent'],
        ),
      );
    } else {
      return PostCard(
        avatarColor: Colors.transparent,
        username: post['username'],
        time: post['time'],
        content: post['content'],
        subContent: post['subContent'],
        source: post['source'],
        trustScore: post['trustScore'],
        likes: post['likes'],
        comments: post['comments'],
        shares: post['shares'],
        isNews: post['isNews'],
        onReadTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailView(
              article: {
                'id': post['articleId'],
                'title': post['title'],
                'source': post['source'],
                'content': post['fullContent'],
                'imageUrl': 'https://images.unsplash.com/photo-1588681664899-f142ff2dc9b1',
                'publishedAt': post['time'],
                'trustScore': post['trustScore'],
              },
            ),
          ),
        ),
        // Icon share kecil langsung buka bottom sheet
        onShareIconTap: () => _showShareBottomSheet(
          context,
          title: post['title'],
          content: post['fullContent'],
        ),
        // Tombol "Share" besar hijau tetap ke halaman ShareView
        onShareTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ShareView(
              article: {
                'id': post['articleId'],
                'title': post['title'],
                'source': post['source'],
                'content': post['fullContent'],
              },
            ),
          ),
        ),
        onCommentTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PoliticsCommentView(articleId: post['articleId']),
          ),
        ),
      );
    }
  }

  // Method untuk menampilkan share bottom sheet
  void _showShareBottomSheet(BuildContext context, {required String title, required String content}) {
    final String shareText = '$title\n\n$content';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            const Text(
              'Share to',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Share options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: const Color(0xFF25D366),
                  text: shareText,
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.facebook,
                  label: 'Facebook',
                  color: const Color(0xFF1877F2),
                  text: shareText,
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.send,
                  label: 'Telegram',
                  color: const Color(0xFF0088CC),
                  text: shareText,
                ),
                _buildShareButton(
                  ctx: ctx,
                  icon: Icons.more_horiz,
                  label: 'More',
                  color: Colors.grey,
                  text: shareText,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton({
    required BuildContext ctx,
    required IconData icon,
    required String label,
    required Color color,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        Share.share(text);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final Color topBarColor;
  final VoidCallback onProfileTap;
  final VoidCallback onAddTap;

  const _TopBar({
    required this.topBarColor,
    required this.onProfileTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: topBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
          ),
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabChanged;

  const _TabBar({
    required this.selectedTabIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: const Color(0xFFA8B5BC),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _TabItem(
            text: 'For You',
            isSelected: selectedTabIndex == 0,
            onTap: () => onTabChanged(0),
          ),
          Image.asset(
            'assets/images/social_bear_small.png',
            height: 35,
            errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 30),
          ),
          _TabItem(
            text: 'Following',
            isSelected: selectedTabIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}