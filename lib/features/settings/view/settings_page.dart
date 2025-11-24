import 'package:flutter/material.dart';
import 'package:projek_mobile/features/privacy/view/privacy_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092); // biru abu-abu
    const Color bgColor = Color(0xFFB8C5CC);     // abu-abu terang
    const Color cardColor = Color(0xFFD9D9D9);   // abu-abu card
    const Color buttonGreen = Color(0xFF7BA87B); // hijau tombol

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan back dan title Settings
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Back
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
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
                        ),
                      ],
                    ),
                  ),

                  // Title Settings
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Spacer untuk balance layout
                  const SizedBox(width: 70),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon dan Label Setting
                    Row(
                      children: const [
                        Icon(Icons.settings, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Setting',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // CARD ACCOUNT
                    _buildSettingCard(
                      context: context,
                      title: 'Account',
                      description: 'Informasi akun, password,\ndisplay, protected mode',
                      buttonColor: buttonGreen,
                      onTap: () {
                        // TODO: navigasi ke Account settings
                      },
                    ),

                    const SizedBox(height: 16),

                    // CARD PRIVACY
                    _buildSettingCard(
                      context: context,
                      title: 'Privacy',
                      description: 'Privacy control, data usage,\nwellness dashboard',
                      buttonColor: buttonGreen,
                      onTap: () {
                        // TODO: navigasi ke Privacy settings
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PrivacyPage()
                            ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // CARD NOTIFICATIONS
                    _buildSettingCard(
                      context: context,
                      title: 'Notifications',
                      description: 'Push, email, in-app\nnotifications',
                      buttonColor: buttonGreen,
                      onTap: () {
                        // TODO: navigasi ke Notifications settings
                      },
                    ),

                    const SizedBox(height: 40),

                    // GARIS PEMBATAS
                    Center(
                      child: Container(
                        width: 200,
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat setting card
  Widget _buildSettingCard({
    required BuildContext context,
    required String title,
    required String description,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    const Color cardColor = Color(0xFFD9D9D9);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Title dengan garis bawah
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 2,
                width: double.infinity,
                color: Colors.black87,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          // Tombol Masuk
          SizedBox(
            width: 120,
            height: 40,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black54, width: 1),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}