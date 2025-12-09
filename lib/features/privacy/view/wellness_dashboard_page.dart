import 'package:flutter/material.dart';
import 'package:projek_mobile/features/privacy/view/activity_suggestions_page.dart';

class WellnessDashboardPage extends StatelessWidget {
  const WellnessDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF5E8092); // biru abu-abu
    const Color bgColor = Color(0xFFB8C5CC);     // abu-abu terang
    const Color cardColor = Color(0xFFD9D9D9);   // abu-abu card
    const Color buttonRed = Color(0xFFB85C4F);   // merah tombol

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan back dan title Wellness Dashboard
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Back dengan teks Privacy
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Privacy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title Wellness Dashboard
                  const Text(
                    'Wellness\nDashboard',
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
                    // Data Aktivitas Hari Ini
                    Row(
                      children: const [
                        Icon(Icons.bar_chart, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Data Aktivitas Hari Ini',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Selasa, 28 Oktober 2025',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),

                    const SizedBox(height: 4),

                    // Garis pembatas
                    Container(
                      height: 1.5,
                      color: Colors.black87,
                    ),

                    const SizedBox(height: 20),

                    // SCREEN TIME SECTION
                    Row(
                      children: const [
                        Icon(Icons.phone_android, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Screen Time',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          // Total time dengan progress bar
                          Row(
                            children: [
                              const Text(
                                'Total : 2 Jam 15 Menit',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Progress bar
                          Stack(
                            children: [
                              Container(
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.black54,
                                    width: 1,
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.9, // 90%
                                child: Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 6),
                                  child: const Text(
                                    '90 %',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            'Target : 2 Jam 30 Menit',
                            style: TextStyle(fontSize: 12),
                          ),

                          const SizedBox(height: 12),

                          // Breakdown
                          const Text(
                            'Breakdown :',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildBreakdownItem('Scrolling : 1 Jam 45 Menit'),
                          _buildBreakdownItem('Reading : 20 Menit'),
                          _buildBreakdownItem('Messaging : 10 Menit'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // MOOD TRACKING SECTION
                    Row(
                      children: const [
                        Icon(Icons.sentiment_satisfied, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Mood Tracking',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildMoodItem('Current mood :', '😊', '6 / 10'),
                          const SizedBox(height: 8),
                          _buildMoodItem('Morning :', '😃', '7 / 10'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Trend :    Menurun  ',
                                style: TextStyle(fontSize: 12),
                              ),
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.red,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // WELLNESS INSIGHTS SECTION
                    Row(
                      children: const [
                        Icon(Icons.show_chart, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Wellness Insights',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hari dengan penggunaan > 2 Jam :',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInsightItem('Sleep Quality : - 20 %'),
                          _buildInsightItem('Mood Score : 6.2 / 10'),
                          _buildInsightItem('Productivity : - 15 %'),
                          const SizedBox(height: 12),
                          const Text(
                            'Hari dengan break activities :',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildInsightItem('Mood Score : 8.1 / 10'),
                          _buildInsightItem('Energy : + 30 %'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // RECOMMENDATION SECTION
                    Row(
                      children: const [
                        Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Recommendation : Anda diharuskan untuk istirahat sekarang juga!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // TOMBOL LIHAT ACTIVITY SUGGESTIONS
                    Center(
                      child: SizedBox(
                        width: 240,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: navigasi ke activity suggestions
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ActivitySuggestionsPage()
                                ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            elevation: 3,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Lihat Activity Suggestions',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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

  // Helper widget untuk breakdown item
  Widget _buildBreakdownItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk mood item
  Widget _buildMoodItem(String label, String emoji, String score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(width: 8),
        Text(
          emoji,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(width: 8),
        Text(
          score,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // Helper widget untuk insight item
  Widget _buildInsightItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}