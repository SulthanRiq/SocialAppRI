import 'package:flutter/material.dart';
import 'package:projek_mobile/features/privacy/view/wellness_dashboard_page.dart';
import 'daily_reminder_page.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
            // TOP BAR dengan back dan title Privacy
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Back dengan teks Settings
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title Privacy
                  const Text(
                    'Privacy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // Spacer untuk balance layout
                  const SizedBox(width: 90),
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
                    // Icon dan Label Privacy Settings
                    Row(
                      children: const [
                        Icon(Icons.lock, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Privacy Settings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Garis pembatas
                    Container(
                      height: 1.5,
                      color: Colors.black87,
                    ),

                    const SizedBox(height: 20),

                    // SECTION: Content You See
                    const Text(
                      'Content You See',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildPrivacyCard(
                      context: context,
                      cardColor: cardColor,
                      buttonColor: buttonGreen,
                      child: Column(
                        children: [
                          const Text(
                            'Atur topik & interest kamu',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Current interests:',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '• Technology, Fitness, Food',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 12),
                          _buildButton(
                            label: 'Manage Topics',
                            color: buttonGreen,
                            onTap: () {
                              // TODO: navigasi ke manage topics
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SECTION: Gentle Nudge Intervention
                    const Text(
                      'Gentle Nudge Intervention',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildPrivacyCard(
                      context: context,
                      cardColor: cardColor,
                      buttonColor: buttonGreen,
                      child: Column(
                        children: [
                          const Text(
                            'Status : Active',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Dashboard aktivitas harian dengan\ndetail tracking & wellness insights',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          _buildButton(
                            label: 'Lihat Dashboard',
                            color: buttonGreen,
                            onTap: () {
                              // TODO: navigasi ke dashboard
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const WellnessDashboardPage()
                                  ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SECTION: Set Daily Reminder
                    const Text(
                      'Set Daily Reminder',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildPrivacyCard(
                      context: context,
                      cardColor: cardColor,
                      buttonColor: buttonGreen,
                      child: Column(
                        children: [
                          const Text(
                            'Notifikasi pengingat jadwal\naktifitas & break time',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Current reminders: 1 active',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildButton(
                            label: 'Atur Reminder',
                            color: buttonGreen,
                            onTap: () {
                              // TODO: navigasi ke reminder settings
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ReminderPage()
                                  ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SECTION: Privacy Control
                    const Text(
                      'Privacy Control',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildPrivacyCard(
                      context: context,
                      cardColor: cardColor,
                      buttonColor: buttonGreen,
                      child: Column(
                        children: [
                          const Text(
                            'Kontrol semua data & permission kamu',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Last updated : 2 days ago\nPrivasy score : 78/100',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          _buildButton(
                            label: 'Kelola Privacy',
                            color: buttonGreen,
                            onTap: () {
                              // TODO: navigasi ke privacy control
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SECTION: Learn more
                    Row(
                      children: [
                        const Text(
                          '📚',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Learn more :',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Garis pembatas
                    Container(
                      height: 1,
                      color: Colors.black87,
                    ),

                    const SizedBox(height: 12),

                    // List learn more
                    _buildLearnMoreItem('Privacy Policy (Plain Explained)'),
                    _buildLearnMoreItem('Data Usage (Explained)'),
                    _buildLearnMoreItem('Your Rights'),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk privacy card
  Widget _buildPrivacyCard({
    required BuildContext context,
    required Color cardColor,
    required Color buttonColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  // Helper widget untuk tombol
  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.arrow_forward,
              size: 16,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk learn more item
  Widget _buildLearnMoreItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}