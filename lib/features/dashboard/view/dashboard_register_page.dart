import 'package:flutter/material.dart';
import 'package:projek_mobile/features/inbox/view/inbox_page.dart';
import 'package:projek_mobile/features/profile/view/profile.dart';
// Import halaman Focs-C yang sudah dibuat
import 'package:projek_mobile/features/focs/view/focs_page.dart'; // Sesuaikan path ini
import 'package:projek_mobile/features/notification/view/notification_page.dart';
import 'package:projek_mobile/features/search/view/search_page.dart';
import 'package:projek_mobile/features/create_post/view/create_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index untuk bottom navigation
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8); // biru abu-abu
    final Color bgColor = const Color(0xFFB8C5CC); // abu-abu terang
    final Color cardColor = const Color(0xFFD9D9D9); // abu-abu card

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
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        child: Image.asset(
                          'assets/images/profile.png',
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person, size: 30);
                          },
                        ),
                      ),
                    ),
                  ),

                  // Tombol add (kanan)
                  GestureDetector(
                    onTap: () {
                      // TODO: buat post baru
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

            // CONTENT AREA
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 120),

                    // CARD WELCOME
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul dengan emoji
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'Hello...\nWelcome to Social APP! 🎉 🎉\n\n',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                TextSpan(
                                  text:
                                      'Mulai explore konten menarik atau buat post pertama kamu!',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 200),
                  ],
                ),
              ),
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

            // Create / Focs Mode (tombol tengah) - NAVIGASI KE FOCS-C
            _buildNavItem(
              icon: Icons.add_box,
              isSelected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                // Navigasi ke halaman Focs-C
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
              }
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
              }
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
}
