import 'package:flutter/material.dart';

class ProtectionSummaryCard extends StatelessWidget {
  const ProtectionSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '⚠ PROTECTION ACTIVE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• 15 toxic filtered',
                style: TextStyle(fontSize: 13),
              ),
              const Text(
                '• 13 shown (verified)',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 14),
              Center(
                child: SizedBox(
                  width: 190,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: buka halaman moderation log
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7BA87B),
                    ),
                    child: const Text(
                      'LIHAT MODERATION LOG',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'COMMENTS (13 shown)\nVerified comments only',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}