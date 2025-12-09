// File: lib/features/focs/widget/topic_button.dart

import 'package:flutter/material.dart';

class TopicButton extends StatelessWidget {
  final String topic;
  final bool isSelected;
  final Color color;
  final Color indicatorColor;
  final VoidCallback onTap;

  const TopicButton({
    Key? key,
    required this.topic,
    required this.isSelected,
    required this.color,
    required this.indicatorColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF7A9CA8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.2 : 0.15),
              blurRadius: isSelected ? 10 : 8,
              offset: Offset(0, isSelected ? 5 : 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                topic,
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: indicatorColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: indicatorColor.withOpacity(0.5),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper: Get text color based on background
  Color _getTextColor() {
    if (!isSelected) return Colors.white;

    // Special case for dark backgrounds
    if (topic.toLowerCase() == 'politics') {
      return Colors.grey[400]!;
    }

    return Colors.white;
  }
}

// Alternative: Topic Button with Icon
class TopicButtonWithIcon extends StatelessWidget {
  final String topic;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const TopicButtonWithIcon({
    Key? key,
    required this.topic,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: color.withOpacity(0.5), width: 2)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[700],
            ),
            const SizedBox(width: 8),
            Text(
              topic,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
