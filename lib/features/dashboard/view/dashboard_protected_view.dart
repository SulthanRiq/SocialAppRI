import 'package:flutter/material.dart';
import 'package:projek_mobile/features/dashboard/view/share_view.dart';
import 'package:projek_mobile/features/dashboard/view/article_detail_view.dart';
import 'package:projek_mobile/features/dashboard/view/health_comment_view.dart';
import 'package:projek_mobile/features/dashboard/view/politics_comment_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(),
                _buildTabBar(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                    children: [
                      // === POST SESUAI MOCKUP PROTECTED MODE ===
                      PostCard(
                        avatarColor: Colors.transparent,
                        username: "Budi",
                        time: "Just now",
                        rightLabel: "Protected Mode: Max ON",
                        content:
                        "30 hari fitness journey\n\n"
                            "Hari ini aku janji ke diri sendiri: hadir setiap hari selama 30 hari. "
                            "Kalau capek, pelanin, tapi jangan berhenti. Tujuannya sederhana energi naik, "
                            "mood stabil, percaya diri tumbuh. Di akhir bulan nanti, aku pengin lihat versi "
                            "diriku yang lebih konsisten. Ikut bareng? 🙌\n"
                            "#KonsistenDulu #SehatItuInvestasi",
                        imageUrl:
                        "https://images.pexels.com/photos/799165/pexels-photo-799165.jpeg?auto=compress&cs=tinysrgb&w=800",
                        likes: "105",
                        comments: "10",
                        shares: "12",
                        isNews: false,
                        onCommentTap: () {
                          // contoh: masuk ke halaman komentar health
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HealthCommentView(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // === CARD PROTECTION ACTIVE SESUAI MOCKUP ===
                      const ProtectionSummaryCard(),

                      // kalau ingin post lain lagi, bisa ditambah di bawah sini
                      // ...
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.3),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem("For You", 0),
          const Icon(Icons.catching_pokemon, color: Colors.white54, size: 30),
          _buildTabItem("Following", 1),
        ],
      ),
    );
  }

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
              color: Colors.blue,
            )
        ],
      ),
    );
  }
}

// --- WIDGET PENDUKUNG DASHBOARD ---

class PostCard extends StatelessWidget {
  final String username, time, content, likes, comments, shares;
  final String? subContent, source, trustScore;
  final String imageUrl;
  final Color avatarColor;
  final bool isNews;
  final String? rightLabel; // teks di kanan header (misal Protected Mode)
  final VoidCallback? onReadTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onCommentTap;

  const PostCard({
    super.key,
    required this.username,
    this.time = "",
    required this.content,
    this.subContent,
    this.imageUrl = "",
    required this.likes,
    required this.comments,
    required this.shares,
    required this.avatarColor,
    this.isNews = false,
    this.source,
    this.trustScore,
    this.rightLabel,
    this.onReadTap,
    this.onShareTap,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header username + waktu + (optional) right label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (time.isNotEmpty)
                    Text(
                      " · $time",
                      style: const TextStyle(color: Colors.grey),
                    ),
                ],
              ),
              if (rightLabel != null)
                Text(
                  rightLabel!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),

          if (isNews)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: const [
                  Icon(Icons.local_fire_department,
                      color: Colors.red, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "Trending Now",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  )
                ],
              ),
            ),

          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 12),

          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 200,
                  color: Colors.grey[300],
                ),
              ),
            ),

          if (subContent != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.grey[300],
              child: Center(child: Text(subContent!)),
            ),

          if (isNews)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    source ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.lock_outline,
                      size: 14, color: Colors.grey),
                  Text(
                    " $trustScore",
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Stats Row dengan onTap untuk komentar
          GestureDetector(
            onTap: onCommentTap,
            child: Row(
              children: [
                const Icon(Icons.favorite, size: 20),
                const SizedBox(width: 4),
                Text(likes),
                const SizedBox(width: 20),
                const Icon(Icons.mode_comment_outlined, size: 20),
                const SizedBox(width: 4),
                Text(comments),
                if (shares.isNotEmpty) ...[
                  const SizedBox(width: 20),
                  const Icon(Icons.share_outlined, size: 20),
                  const SizedBox(width: 4),
                  Text(shares),
                ]
              ],
            ),
          ),

          // --- BAGIAN NAVIGASI KE SHARE DAN BACA ---
          if (isNews)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onReadTap ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FA37E),
                      ),
                      child: const Text(
                        "Baca",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onShareTap ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4C46A),
                      ),
                      child: const Text(
                        "Share",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ProtectionSummaryCard extends StatelessWidget {
  const ProtectionSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚠ PROTECTION ACTIVE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text('• 15 toxic filtered'),
              const Text('• 13 shown (verified)'),
              const SizedBox(height: 14),
              Center(
                child: SizedBox(
                  width: 190,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: buka halaman moderation log
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7BA87B),
                    ),
                    child: const Text(
                      'LIHAT MODERATION LOG',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'COMMENTS (13 shown)\nVerified comments only',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF9FB8C7),
                border: Border(
                  top: BorderSide(color: Colors.white30),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(width: 40),
                  IconButton(
                    icon: const Icon(Icons.search, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.nightlight_round, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 30),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat_bubble_outline, size: 30),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 15,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF9FB8C7),
                  width: 4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.home,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}