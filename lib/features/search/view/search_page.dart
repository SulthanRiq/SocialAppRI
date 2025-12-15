import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import custom bottom navbar
import 'package:projek_mobile/common/widgets/custom_bottom_navbar.dart';
import '../../dashboard/view/dashboard_register_page.dart';
import '../../focs/view/focs_page.dart';
import '../../notification/view/notification_page.dart';
import '../../inbox/view/inbox_page.dart';
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

      // BOTTOM NAVIGATION BAR
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

  // Tab Untuk Anda
  Widget _buildUntukAndaTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Berani bermimpi besar',
          postsCount: '7,189 postingan',
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Indonesia Bersatu',
          postsCount: '1,724 postingan',
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Bebas Narkoba',
          postsCount: '1,622 postingan',
        ),
      ],
    );
  }

  // Tab Sedang Tren
  Widget _buildSedangTrenTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Berani bermimpi besar',
          postsCount: '7,189 postingan',
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Indonesia Bersatu',
          postsCount: '1,724 postingan',
        ),
        const SizedBox(height: 16),
        _buildTrendCard(
          category: 'Sedang tren dalam indonesia',
          title: 'Bebas Narkoba',
          postsCount: '1,622 postingan',
        ),
      ],
    );
  }

  // Helper widget untuk trend card
  Widget _buildTrendCard({
    required String category,
    required String title,
    required String postsCount,
  }) {
    return Container(
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
    );
  }
}

// Custom Bottom Nav Bar Widget (sementara di file ini, nanti bisa dipisah)
class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF6B95A8), // biru abu-abu
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
            isSelected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),

          // Search
          _buildNavItem(
            icon: Icons.search,
            isSelected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),

          // Create / Focs Mode (tombol tengah)
          _buildNavItem(
            icon: Icons.add_box,
            isSelected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),

          // Notifications
          _buildNavItem(
            icon: Icons.notifications,
            isSelected: selectedIndex == 3,
            onTap: () => onItemTapped(3),
          ),

          // Messages
          _buildNavItem(
            icon: Icons.chat_bubble,
            isSelected: selectedIndex == 4,
            onTap: () => onItemTapped(4),
          ),
        ],
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
}