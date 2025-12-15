import 'package:flutter/material.dart';
// ✅ Import custom bottom navbar yang sudah dibuat (COMMON)
import 'package:projek_mobile/common/widgets/custom_bottom_navbar.dart';

import 'package:projek_mobile/features/dashboard/view/dashboard_register_page.dart';
import 'package:projek_mobile/features/focs/view/focs_page.dart';
import '../../search/view/search_page.dart';
import '../../inbox/view/inbox_page.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 3; // Index untuk Notifications di bottom nav

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8);
    final Color bgColor = const Color(0xFFB8C5CC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR dengan judul Notifications
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              alignment: Alignment.center,
              child: const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // CONTENT AREA
            Expanded(
              child: ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                children: const [
                  NotificationItem(
                    avatarUrl: 'https://i.pravatar.cc/150?img=1',
                    message: 'User mengikuti anda',
                    time: '2m ago',
                  ),
                  SizedBox(height: 16),
                  NotificationItem(
                    avatarUrl: 'https://i.pravatar.cc/150?img=2',
                    message: 'John Doe mengirimkan pesan',
                    time: '15m ago',
                  ),
                  SizedBox(height: 16),
                  NotificationItem(
                    avatarUrl: 'https://i.pravatar.cc/150?img=3',
                    message: 'Jane Smith menyukai postingan anda',
                    time: '1h ago',
                  ),
                  SizedBox(height: 16),
                  NotificationItem(
                    avatarUrl: 'https://i.pravatar.cc/150?img=4',
                    message: 'Alex mengomentari foto anda',
                    time: '3h ago',
                  ),
                  SizedBox(height: 16),
                  NotificationItem(
                    avatarUrl: 'https://i.pravatar.cc/150?img=5',
                    message: 'Sarah membagikan artikel anda',
                    time: '1d ago',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ✅ BOTTOM NAVIGATION BAR (pakai dari COMMON)
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Handle navigasi
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FocsCScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InboxScreen()),
            );
          }
        },
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String message;
  final String time;

  const NotificationItem({
    super.key,
    required this.avatarUrl,
    required this.message,
    this.time = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (time.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.circle,
            size: 10,
            color: Colors.blue.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
