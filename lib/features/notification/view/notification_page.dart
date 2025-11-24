import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8C9CE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFB8C9CE),
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: const [
          NotificationItem(
            avatarUrl: 'https://i.pravatar.cc/150?img=1',
            message: 'User mengikuti anda',
          ),
          SizedBox(height: 16),
          NotificationItem(
            avatarUrl: 'https://i.pravatar.cc/150?img=2',
            message: 'John Doe mengirimkan pesan',
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String avatarUrl;
  final String message;

  const NotificationItem({
    super.key,
    required this.avatarUrl,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF5C6B73),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.search, 1),
          _buildNavItem(Icons.download, 2),
          _buildNavItem(Icons.notifications_outlined, 3),
          _buildNavItem(Icons.more_horiz, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return IconButton(
      onPressed: () {},
      icon: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.white70,
        size: 26,
      ),
    );
  }
}

// Main app untuk testing
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const NotificationScreen(),
    );
  }
}

void main() {
  runApp(const MyApp());
}