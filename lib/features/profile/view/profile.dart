import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../register/widgets/base64_image_widget.dart';
import 'package:projek_mobile/features/settings/view/settings_page.dart';
import 'package:projek_mobile/features/dashboard/view/dashboard_register_page.dart';

// IMPORT HELP PAGE
import 'package:projek_mobile/features/help/view/help_faq_page.dart';

// ✅ IMPORT POST PAGE
import 'package:projek_mobile/features/post/view/manage_post_page.dart';

class ProfileMenuPage extends StatelessWidget {
  const ProfileMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    const Color topBarColor = Color(0xFF5E8092);
    const Color cardColor = Color(0xFFE8EEF2);
    const Color accentColor = Color(0xFF36466B);
    const Color bgColor = Color(0xFFD1DEE4);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ===== TOP BAR =====
            Container(
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()),
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

            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

                    // PROFILE CARD dengan Data Dinamis
                    Obx(() {
                      final user = authController.currentUser.value;
                      final username = user?.username ?? 'User';
                      final email = user?.email ?? 'email@example.com';
                      final photoUrl = user?.photoUrl;

                      return Container(
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
                                // Avatar dengan Base64 Image
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: accentColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Base64CircleAvatar(
                                    base64String: photoUrl,
                                    radius: 30,
                                    backgroundColor: accentColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Username dengan ikon gender (opsional)
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              username,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          // Icon gender bisa ditambahkan jika ada di user model
                                          // const Icon(
                                          //   Icons.male,
                                          //   size: 18,
                                          //   color: Colors.blueAccent,
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      // Email sebagai subtitle
                                      Text(
                                        '@$username',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.black54,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black45,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(thickness: 0.7),
                            const SizedBox(height: 8),

                            // Stats (placeholder - bisa diintegrasikan dengan data real)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.bar_chart, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  '0 Posts',
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(width: 24),
                                SizedBox(
                                  height: 14,
                                  child: VerticalDivider(thickness: 0.8),
                                ),
                                SizedBox(width: 24),
                                Text(
                                  '0 Followers',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // ===== MENU LIST =====
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

                    // ✅ POST (SEKARANG BISA DIKLIK)
                    ProfileMenuItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'Post',
                      subtitle: 'Manage your posts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ManagePostPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Setting',
                      subtitle: 'Account & Privacy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    ProfileMenuItem(
                      icon: Icons.help_outline,
                      title: 'Help',
                      subtitle: 'FAQ & Support',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpFaqPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    ProfileMenuItem(
                      icon: Icons.logout,
                      title: 'Logout',
                      subtitle: '',
                      onTap: () async {
                        // Show confirmation dialog
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Logout'),
                              content: const Text('Apakah Anda yakin ingin logout?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        // Jika user confirm logout
                        if (shouldLogout == true && context.mounted) {
                          try {
                            // Call logout dari controller
                            await authController.logout();

                            // Show success message
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout berhasil'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }

                            // Navigate ke login dengan delay
                            await Future.delayed(const Duration(milliseconds: 500));

                            if (context.mounted) {
                              // Remove all routes and go to login
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login',
                                    (route) => false,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
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
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
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
        onTap: onTap ?? () {},
      ),
    );
  }
}
