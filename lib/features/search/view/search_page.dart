import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import custom bottom navbar
import 'package:projek_mobile/common/widgets/custom_bottom_navbar.dart';
import '../../dashboard/view/dashboard_register_page.dart';
import '../../focs/view/focs_page.dart';
import '../../notification/view/notification_page.dart';
import '../../inbox/view/inbox_page.dart';
import 'trend_posts_page.dart';
import 'package:projek_mobile/features/profile/view/profile.dart';
import '../../profile/view/profile.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../register/widgets/base64_image_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedIndex = 1; // Index untuk Search di bottom nav
  int _selectedTabIndex = 0; // Index untuk tab (Untuk Anda / Sedang Tren)

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8); // biru abu-abu
    final Color bgColor = const Color(0xFFB8C5CC); // abu-abu terang
    final Color tabBarColor = const Color(0xFF9AADBA); // biru muda untuk tab bar

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan foto profil
            Obx(() {
              final user = authController.currentUser.value;
              final photoUrl = user?.photoUrl;

              return Container(
                height: 70,
                width: double.infinity,
                color: topBarColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Foto profil
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke profile
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileMenuPage(),
                          ),
                        );
                      },
                      child: Base64CircleAvatar(
                        base64String: photoUrl,
                        radius: 24,
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              );
            }),


            // SEARCH BAR
            Container(
              color: topBarColor,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),

            // TAB BAR (Untuk Anda / Sedang Tren)
            Container(
              height: 50,
              color: tabBarColor,
              child: Row(
                children: [
                  // Tab Untuk Anda
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: _selectedTabIndex == 0
                              ? const Border(
                            bottom: BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          )
                              : null,
                        ),
                        child: Text(
                          'Untuk Anda',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: _selectedTabIndex == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tab Sedang Tren
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: _selectedTabIndex == 1
                              ? const Border(
                            bottom: BorderSide(
                              color: Colors.blue,
                              width: 3,
                            ),
                          )
                              : null,
                        ),
                        child: Text(
                          'Sedang Tren',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: _selectedTabIndex == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT AREA
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildUntukAndaTab()
                  : _buildSedangTrenTab(),
            ),
          ],
        ),
      ),

      // BOTTOM NAVIGATION BAR (pakai yang dari common)
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Handle navigasi
          if (index == 0) {
            // Kembali ke Home
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (index == 2) {
            // Navigasi ke Focs/Create
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FocsCScreen(),
              ),
            );
          } else if (index == 3) {
            // Navigasi ke Notifications
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          } else if (index == 4) {
            // Navigasi ke Messages
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

  // ✅ fungsi untuk pindah ke halaman trend
  void _goToTrend(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrendPostsPage(trendTitle: title),
      ),
    );
  }

  // Tab Untuk Anda (tetap seperti punyamu)
  Widget _buildUntukAndaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Berani bermimpi besar',
          postsCount: '7,189 postingan',
          onTap: () => _goToTrend('Berani bermimpi besar'),
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Indonesia Bersatu',
          postsCount: '1,724 postingan',
          onTap: () => _goToTrend('Indonesia Bersatu'),
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Bebas Narkoba',
          postsCount: '1,622 postingan',
          onTap: () => _goToTrend('Bebas Narkoba'),
        ),
      ],
    );
  }

  // ✅ Tab Sedang Tren (sesuai gambar: 1 panel + rank #1 #2 #3 di kanan)
  Widget _buildSedangTrenTab() {
    final trends = [
      {
        'rank': '#1',
        'title': '#MAYATYAWARDS2025',
        'posts': '1,98 jt postingan',
        'goTitle': 'MAYATYAWARDS2025',
      },
      {
        'rank': '#2',
        'title': '#Berani bermimpi besar',
        'posts': '7.189 postingan',
        'goTitle': 'Berani bermimpi besar',
      },
      {
        'rank': '#3',
        'title': '#IndonesiaBebasNarkoba',
        'posts': '2.449 postingan',
        // ⚠️ sesuaikan dengan key di TrendPostsPage kamu.
        // Kalau di TrendPostsPage key-nya "Bebas Narkoba", pakai itu:
        'goTitle': 'Bebas Narkoba',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(trends.length, (i) {
              final t = trends[i];
              final bool isLast = i == trends.length - 1;

              return Column(
                children: [
                  _buildTrendingItem(
                    category: 'Sedang tren dalam indonesia',
                    title: t['title'] as String,
                    postsCount: t['posts'] as String,
                    rankText: t['rank'] as String,
                    onTap: () => _goToTrend(t['goTitle'] as String),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                        height: 14,
                        thickness: 0.8,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ✅ item untuk list trending (sesuai layout gambar)
  Widget _buildTrendingItem({
    required String category,
    required String title,
    required String postsCount,
    required String rankText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // kiri (teks)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    postsCount,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // kanan (#1 #2 #3)
            Text(
              rankText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk trend card (tetap punyamu)
  Widget _buildTrendCard({
    required String category,
    required String title,
    required String postsCount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              postsCount,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
