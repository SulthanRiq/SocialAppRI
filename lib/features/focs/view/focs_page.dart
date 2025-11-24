import 'package:flutter/material.dart';
// Import TopicFilterBottomSheet
import 'topic_filter_page.dart'; // Uncomment dan sesuaikan path

class FocsCScreen extends StatefulWidget {
  const FocsCScreen({Key? key}) : super(key: key);

  @override
  State<FocsCScreen> createState() => _FocsCScreenState();
}

class _FocsCScreenState extends State<FocsCScreen> {
  bool isFocsMode = true;
  String selectedTab = 'Focs Mode';
  Set<String> selectedTopics = {}; // Menyimpan topics yang dipilih

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
              // Search Bar
              Padding(
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
                    GestureDetector(
                      onTap: () async {
                        // Tampilkan Topic Filter Bottom Sheet
                        final result = await TopicFilterBottomSheet.show(
                          context,
                          selectedTopics: selectedTopics,
                        );

                        // Update selected topics jika ada hasil
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
                                decoration: BoxDecoration(
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
                    ),
                  ],
                ),
              ),
              // Tab Bar
              Container(
                color: const Color(0xFF7A9CA8),
                child: Row(
                  children: [
                    _buildTab('Focs Mode', selectedTab == 'Focs Mode'),
                    _buildTab('Reference', selectedTab == 'Reference'),
                  ],
                ),
              ),
              // Posts List - berbeda berdasarkan tab
              Expanded(
                child: selectedTab == 'Focs Mode'
                    ? _buildFocsModeContent()
                    : _buildReferenceContent(),
              ),
            ],
          ),
          // Focus Mode Dialog
          if (isFocsMode)
            Container(
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
            ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
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

  // Content untuk tab Focs Mode
  Widget _buildFocsModeContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPostCard(
          name: 'Martina',
          time: '1 jam',
          content: 'Morning Yall, Have a Nice DAYYY !!!',
          likes: '1.2k',
          comments: '2',
          shares: '1',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
        ),
        const SizedBox(height: 16),
        _buildPostCard(
          name: 'Martina',
          time: '1 jam',
          content: 'Damnit i wanna explode rn...',
          likes: '856',
          comments: '5',
          shares: '3',
          avatarUrl: 'https://i.pravatar.cc/150?img=5',
          hasImage: true,
          imageUrl: 'https://picsum.photos/400/300',
        ),
      ],
    );
  }

  // Content untuk tab Reference
  Widget _buildReferenceContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPostCard(
          name: 'Emma Watson',
          time: '3 jam',
          content:
              'Wanna cheat tip?  Use the Pomodoro technique with 25-minute focused sessions. Your brain needs breaks to stay sharp !!',
          likes: '2.5k',
          comments: '8',
          shares: '12',
          avatarUrl: 'https://i.pravatar.cc/150?img=10',
          category: 'Health',
        ),
        const SizedBox(height: 16),
        _buildPostCard(
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
        ),
        const SizedBox(height: 16),
        _buildPostCard(
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
        ),
      ],
    );
  }

  Widget _buildPostCard({
    required String name,
    required String time,
    required String content,
    required String likes,
    required String comments,
    required String shares,
    required String avatarUrl,
    bool hasImage = false,
    String? imageUrl,
    String? category,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Category badge (jika ada)
              if (category != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
          if (hasImage && imageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(likes, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(width: 20),
              Icon(Icons.chat_bubble_outline,
                  size: 20, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(comments, style: TextStyle(color: Colors.grey[700])),
              const SizedBox(width: 20),
              Icon(Icons.share, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(shares, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }

  // Helper untuk warna kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Colors.red.shade400;
      case 'sports':
        return Colors.blue.shade400;
      case 'food':
        return Colors.orange.shade400;
      case 'tech':
        return Colors.purple.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

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
        // Navigasi sesuai index
        if (index == 0) {
          // Kembali ke Home
          Navigator.pop(context);
        } else if (index == 4) {
          // Navigasi ke Inbox (jika sudah dibuat)
          // Navigator.push(context, MaterialPageRoute(builder: (context) => InboxScreen()));
        }
        // Tambahkan navigasi lain sesuai kebutuhan
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
}
