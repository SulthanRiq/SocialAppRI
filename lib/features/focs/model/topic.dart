// File: lib/features/focs/model/topic.dart

import 'package:flutter/material.dart';

class Topic {
  final String id;
  final String name;
  final Color color;
  final Color indicatorColor;
  final bool isSelected;

  Topic({
    required this.id,
    required this.name,
    required this.color,
    required this.indicatorColor,
    this.isSelected = false,
  });

  // Copy with method
  Topic copyWith({
    String? id,
    String? name,
    Color? color,
    Color? indicatorColor,
    bool? isSelected,
  }) {
    return Topic(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.value,
      'indicatorColor': indicatorColor.value,
      'isSelected': isSelected,
    };
  }

  // From JSON
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'] as String,
      name: json['name'] as String,
      color: Color(json['color'] as int),
      indicatorColor: Color(json['indicatorColor'] as int),
      isSelected: json['isSelected'] as bool? ?? false,
    );
  }

  // ToString
  @override
  String toString() {
    return 'Topic(id: $id, name: $name, isSelected: $isSelected)';
  }

  // Static list of all topics
  static List<Topic> allTopics() {
    return [
      Topic(
        id: 'tech',
        name: 'Technology',
        color: const Color(0xFFB8860B), // Gold/Brown
        indicatorColor: const Color(0xFFFFD700), // Yellow
      ),
      Topic(
        id: 'sports',
        name: 'Sports',
        color: const Color(0xFF6B9B7F), // Green
        indicatorColor: const Color(0xFF2F4F2F), // Dark green
      ),
      Topic(
        id: 'design',
        name: 'Design',
        color: const Color(0xFF9B8BB3), // Purple
        indicatorColor: const Color(0xFFDDA0DD), // Plum
      ),
      Topic(
        id: 'business',
        name: 'Bussiness',
        color: const Color(0xFF8FA870), // Olive green
        indicatorColor: const Color(0xFFE8F5E9), // Light green
      ),
      Topic(
        id: 'politics',
        name: 'Politics',
        color: const Color(0xFF4A3A3A), // Dark brown
        indicatorColor: const Color(0xFFBC8F8F), // Rosy brown
      ),
      Topic(
        id: 'science',
        name: 'Science',
        color: const Color(0xFF2B5F75), // Teal blue
        indicatorColor: const Color(0xFF87CEEB), // Sky blue
      ),
      Topic(
        id: 'health',
        name: 'Health',
        color: const Color(0xFFA97676), // Dusty rose
        indicatorColor: const Color(0xFF8B0000), // Dark red
      ),
      Topic(
        id: 'gaming',
        name: 'Gaming',
        color: const Color(0xFF4A8B8B), // Turquoise
        indicatorColor: const Color(0xFFE0F2F1), // Light cyan
      ),
    ];
  }

  // Get topic by name
  static Topic? getTopicByName(String name) {
    try {
      return allTopics().firstWhere(
            (topic) => topic.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get color by category name (untuk post card)
  static Color getCategoryColor(String category) {
    final topic = getTopicByName(category);
    return topic?.color ?? const Color(0xFF7A9CA8);
  }
}