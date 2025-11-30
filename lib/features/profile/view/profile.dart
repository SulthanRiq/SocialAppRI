import 'package:flutter/material.dart';
import 'package:projek_mobile/features/login/view/login_page.dart';
import 'package:projek_mobile/features/settings/view/settings_page.dart'; // Import halaman settings
import 'package:projek_mobile/features/dashboard/view/dashboard_register_page.dart';

class ProfileMenuPage extends StatelessWidget {
  const ProfileMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092);
    const Color cardColor = Color(0xFFE8EEF2);
    const Color accentColor = Color(0xFF36466B);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan fungsi back
            Container(
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  // Kembali ke halaman sebelumnya
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()
                      ),
                  );
                },
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'PROFILE MENU',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // PROFILE CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Avatar
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: accentColor,
                                child: const Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Text(
                                          'Budi Santoso',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.male,
                                          size: 18,
                                          color: Colors.blueAccent,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      '@budisantoso',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(thickness: 0.7),
                          const SizedBox(height: 8),

                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.bar_chart, size: 18),
                              SizedBox(width: 4),
                              Text(
                                '2 Posts',
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(width: 24),
                              SizedBox(
                                height: 14,
                                child: VerticalDivider(thickness: 0.8),
                              ),
                              SizedBox(width: 24),
                              Text(
                                '1,2 k Followers',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // MENU LIST
                    const ProfileMenuItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Edit profile',
                    ),
                    const SizedBox(height: 12),
                    const ProfileMenuItem(
                      icon: Icons.calendar_today_outlined,
                      title: 'Daily Activity',
                      subtitle: 'Track your usage',
                    ),
                    const SizedBox(height: 12),
                    const ProfileMenuItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'Post',
                      subtitle: 'Manage your posts',
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Setting',
                      subtitle: 'Account & Privacy',
                      onTap: () {
                        // Navigasi ke Settings Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help',
                      subtitle: 'FAQ & Support',
                    ),
                    const SizedBox(height: 12),
                    ProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      subtitle: '',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                            ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap; // Tambahkan parameter onTap

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap, // onTap bersifat optional
  });

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFFE8EEF2);
    const Color accentColor = Color(0xFF36466B);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.12),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: accentColor,
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        )
            : null,
        onTap: onTap ?? () {
          // Default action jika onTap tidak diberikan
        },
      ),
    );
  }
}