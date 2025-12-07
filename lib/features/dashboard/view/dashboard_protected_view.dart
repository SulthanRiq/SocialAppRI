import 'package:flutter/material.dart';
// Import widget yang sudah dibuat
import 'package:projek_mobile/common/widgets/custom_bottom_navbar.dart';
import 'package:projek_mobile/common/widgets/post_card_widget.dart';
import 'package:projek_mobile/features/Account/widgets/protection_summary_card.dart'; // NEW: Import Protection Summary Card

// Import halaman-halaman yang diperlukan (sesuaikan dengan path project Anda)
import 'package:projek_mobile/features/profile/view/profile.dart';
import 'package:projek_mobile/features/focs/view/focs_page.dart';
import 'package:projek_mobile/features/dashboard/view/share_view.dart';
import 'package:projek_mobile/features/dashboard/view/article_detail_view.dart';
import 'package:projek_mobile/features/dashboard/view/health_comment_view.dart';
import 'package:projek_mobile/features/dashboard/view/politics_comment_view.dart';
import '../../create_post/view/create_post_page.dart';
import '../../search/view/search_page.dart' hide CustomBottomNavBar;
import '../../notification/view/notification_page.dart' hide CustomBottomNavBar;
import '../../inbox/view/inbox_page.dart';

class DashboardViewProtected extends StatefulWidget {
  const DashboardViewProtected({super.key});

  @override
  State<DashboardViewProtected> createState() => _DashboardViewProtectedState();
}

class _DashboardViewProtectedState extends State<DashboardViewProtected> {
  int _selectedIndex = 0; // Index untuk bottom navigation
  int _selectedTabIndex = 0; // Index untuk tab (For You / Following)

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8); // biru abu-abu
    final Color bgColor = const Color(0xFFB8C5CC); // abu-abu terang

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
                      // Navigasi ke Profile Menu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileMenuPage(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                      // Atau gunakan AssetImage jika ada asset lokal
                      // backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),

                  // Tombol add (kanan)
                  GestureDetector(
                    onTap: () {
                      // Navigasi ke Create Post
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
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
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

                  // Icon tengah (beruang atau catching_pokemon)
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

            // CONTENT AREA dengan Posts
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                children: [
                  // POST 1: Protected Mode - Fitness Journey
                  PostCard(
                    avatarColor: Colors.transparent,
                    username: "Budi",
                    time: "Just now",
                    rightLabel: "Protected Mode: Max ON", // NEW: Label di kanan
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
                      // Navigasi ke Health Comment View dengan articleId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HealthCommentView(
                            articleId: 'fitness_1',
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // PROTECTION SUMMARY CARD
                  const ProtectionSummaryCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION BAR (menggunakan custom widget)
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          } else if (index == 2) {
            // Navigasi ke halaman Focs-C
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FocsCScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InboxScreen(),
              ),
            );
          }
        },
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
}