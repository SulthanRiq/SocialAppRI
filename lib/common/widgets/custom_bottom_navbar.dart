import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF6B95A8), // biru abu-abu
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home
          _buildNavItem(
            icon: Icons.home,
            isSelected: selectedIndex == 0,
            onTap: () => onItemTapped(0),
          ),

          // Search
          _buildNavItem(
            icon: Icons.search,
            isSelected: selectedIndex == 1,
            onTap: () => onItemTapped(1),
          ),

          // Create / Focs Mode (tombol tengah)
          _buildNavItem(
            icon: Icons.add_box,
            isSelected: selectedIndex == 2,
            onTap: () => onItemTapped(2),
          ),

          // Notifications
          _buildNavItem(
            icon: Icons.notifications,
            isSelected: selectedIndex == 3,
            onTap: () => onItemTapped(3),
          ),

          // Messages
          _buildNavItem(
            icon: Icons.chat_bubble,
            isSelected: selectedIndex == 4,
            onTap: () => onItemTapped(4),
          ),
        ],
      ),
    );
  }

  // Helper widget untuk navigation item
  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white70,
              size: 28,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}