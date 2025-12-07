import 'package:flutter/material.dart';

class ActivitySuggestionsPage extends StatelessWidget {
  const ActivitySuggestionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092); // biru abu-abu
    const Color bgColor = Color(0xFFB8C5CC);     // abu-abu terang
    const Color cardColor = Color(0xFFE8EEF2);   // abu-abu card terang
    const Color buttonGreen = Color(0xFF7BA87B); // hijau tombol

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan back dan title Activity Suggestions
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Back dengan teks Dashboard
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title Activity Suggestions
                  const Text(
                    'Activity\nSuggestions',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
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
                    // Header Section
                    Row(
                      children: const [
                        Icon(Icons.show_chart, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Aktivitas Rekomendasi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Berdasarkan data & preferensi',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    const SizedBox(height: 4),

                    // Garis pembatas
                    Container(
                      height: 1.5,
                      color: Colors.black87,
                    ),

                    const SizedBox(height: 20),

                    // TOP PICKS FOR YOU SECTION
                    Row(
                      children: const [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Top Picks For You',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // CARD 1: READING
                    _buildActivityCard(
                      context: context,
                      cardColor: cardColor,
                      buttonColor: buttonGreen,
                      icon: Icons.book_outlined,
                      iconColor: Colors.blue,
                      title: 'READING',
                      activityName: '"Atomic Habits" - Chapter 5',
                      duration: '15 Menit',
                      lastActivity: 'Terakhir 2 hari yang lalu',
                      impacts: [
                        _ImpactItem(
                          icon: Icons.sentiment_satisfied,
                          iconColor: Colors.blue,
                          text: 'Mood : + 2 Points',
                        ),
                        _ImpactItem(
                          icon: Icons.center_focus_strong,
                          iconColor: Colors.grey,
                          text: 'Focus : + 15 %',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // CARD 2: OUTDOOR ACTIVITY
                    _buildActivityCard(
                      context: context,
                      cardColor: cardColor,
                      buttonColor: buttonGreen,
                      icon: Icons.directions_run,
                      iconColor: Colors.black87,
                      title: 'OUTDOOR ACTIVITY',
                      activityName: 'Jalan Santai 20 Menit',
                      additionalInfo: '☀️  Weather : Perfect! 26°C',
                      lastActivity: 'Terakhir 3 hari yang lalu',
                      impacts: [
                        _ImpactItem(
                          icon: Icons.bolt,
                          iconColor: Colors.amber,
                          text: 'Energy : + 35 %',
                        ),
                        _ImpactItem(
                          icon: Icons.sentiment_very_satisfied,
                          iconColor: Colors.black87,
                          text: 'Stress : - 25 %',
                        ),
                      ],
                      playlist: 'Playlist : Chill Vibes', duration: '',
                    ),

                    const SizedBox(height: 20),

                    // OTHERS SECTION
                    Row(
                      children: const [
                        Icon(Icons.diamond_outlined, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Others : Meditation, Stretching, Hydration Break, Playing Game',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // CUSTOM ACTIVITY BUTTON
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: navigasi ke custom activity
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Custom Activity',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // GARIS PEMBATAS BAWAH
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

  // Helper widget untuk activity card
  Widget _buildActivityCard({
    required BuildContext context,
    required Color cardColor,
    required Color buttonColor,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String activityName,
    String? additionalInfo,
    required String duration,
    required String lastActivity,
    required List<_ImpactItem> impacts,
    String? playlist,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Divider
          Container(
            height: 1.5,
            color: Colors.black87,
          ),

          const SizedBox(height: 12),

          // Activity name
          Text(
            activityName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          if (additionalInfo != null) ...[
            const SizedBox(height: 6),
            Text(
              additionalInfo,
              style: const TextStyle(fontSize: 12),
            ),
          ],

          const SizedBox(height: 8),

          // Duration
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                duration,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Last activity
          Text(
            lastActivity,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),

          const SizedBox(height: 10),

          // Expected Impact
          const Text(
            'Expected Impact :',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          // Impacts
          ...impacts.map((impact) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  impact.icon,
                  color: impact.iconColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  impact.text,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          )),

          if (playlist != null) ...[
            const SizedBox(height: 6),
            Text(
              playlist,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Button Mulai Sekarang
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                // TODO: mulai aktivitas
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Mulai Sekarang',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class untuk impact item
class _ImpactItem {
  final IconData icon;
  final Color iconColor;
  final String text;

  _ImpactItem({
    required this.icon,
    required this.iconColor,
    required this.text,
  });
}