import 'package:flutter/material.dart';

class ModerationLogPage extends StatelessWidget {
  const ModerationLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color topBarColor = Color(0xFF6B95A8);
    const Color bgColor = Color(0xFFCDD6DB);
    const Color cardColor = Color(0xFFE6ECEF);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: topBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Moderation log',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SUMMARY
            const Text(
              'Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            const Text('Post : 30 Hari Fitness Journey'),
            const Text('Date : 27 Oct 2024'),

            const SizedBox(height: 12),

            // SUMMARY CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Total: 28 comments'),
                  SizedBox(height: 4),
                  Text('✔ Shown: 13 (verified)',
                      style: TextStyle(color: Colors.green)),
                  Text('🚫 Filtered: 15',
                      style: TextStyle(color: Colors.red)),
                  SizedBox(height: 8),
                  Text('Breakdown:'),
                  Text('• Body shaming: 10 🚫'),
                  Text('• Hate speech: 3 🚫'),
                  Text('• Spam: 2 🚫'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // FILTERED COMMENTS
            const Text(
              '🚫 FILTERED COMMENTS:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '#1 @troll_user · 25m',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text('Status: 🚫 BLOCKED'),
                  Text('Reason: 🚫 Body Shaming'),
                  SizedBox(height: 6),
                  Text('Text (blurred):'),
                  SizedBox(height: 4),
                  Text('████████ █████ ██████'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // ACTIONS
            const Text(
              '⚙ ACTIONS:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Block users permanently'),
            const Text('• Report to platform'),
            const Text('• Download logs (CSV)'),
            const Text('• Adjust sensitivity'),
          ],
        ),
      ),
    );
  }
}
