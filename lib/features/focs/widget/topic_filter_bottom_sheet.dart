import 'package:flutter/material.dart';

class TopicFilterBottomSheet extends StatefulWidget {
  final Set<String> initialSelectedTopics;

  const TopicFilterBottomSheet({
    Key? key,
    required this.initialSelectedTopics,
  }) : super(key: key);

  @override
  State<TopicFilterBottomSheet> createState() => _TopicFilterBottomSheetState();

  // Static method untuk menampilkan bottom sheet
  static Future<Set<String>?> show(
      BuildContext context, {
        required Set<String> selectedTopics,
      }) async {
    return await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (context) => TopicFilterBottomSheet(
        initialSelectedTopics: selectedTopics,
      ),
    );
  }
}

class _TopicFilterBottomSheetState extends State<TopicFilterBottomSheet> {
  late Set<String> selectedTopics;

  // Data topics dengan warna masing-masing
  final Map<String, Color> topicColors = {
    'Technology': const Color(0xFFB8860B), // Gold/Brown
    'Sports': const Color(0xFF6B9B7F), // Green
    'Design': const Color(0xFF9B8BB3), // Purple
    'Business': const Color(0xFF8FA870), // Olive green - Fixed typo
    'Politics': const Color(0xFF4A3A3A), // Dark brown
    'Science': const Color(0xFF2B5F75), // Teal blue
    'Health': const Color(0xFFA97676), // Dusty rose
    'Gaming': const Color(0xFF4A8B8B), // Turquoise
  };

  @override
  void initState() {
    super.initState();
    selectedTopics = Set<String>.from(widget.initialSelectedTopics);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFD1D1D1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Topics',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose topics to filter your content',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),

          // Topics Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.8,
                ),
                itemCount: topicColors.length,
                itemBuilder: (context, index) {
                  String topic = topicColors.keys.elementAt(index);
                  bool isSelected = selectedTopics.contains(topic);

                  return _buildTopicButton(
                    topic: topic,
                    isSelected: isSelected,
                    color: topicColors[topic]!,
                  );
                },
              ),
            ),
          ),

          // Done Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFD1D1D1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedTopics);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7A9CA8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                selectedTopics.isEmpty
                    ? 'Done'
                    : 'Done (${selectedTopics.length} selected)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicButton({
    required String topic,
    required bool isSelected,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedTopics.remove(topic);
          } else {
            selectedTopics.add(topic);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color : const Color(0xFF7A9CA8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                topic,
                style: TextStyle(
                  color: isSelected
                      ? (topic == 'Politics' ? Colors.grey[400] : Colors.white)
                      : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getIndicatorColor(topic),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper untuk warna indicator berdasarkan topic
  Color _getIndicatorColor(String topic) {
    switch (topic) {
      case 'Technology':
        return const Color(0xFFFFD700); // Yellow
      case 'Sports':
        return const Color(0xFF2F4F2F); // Dark green
      case 'Design':
        return const Color(0xFFDDA0DD); // Plum
      case 'Business': // Fixed typo
        return const Color(0xFFE8F5E9); // Light green
      case 'Politics':
        return const Color(0xFFBC8F8F); // Rosy brown
      case 'Science':
        return const Color(0xFF87CEEB); // Sky blue
      case 'Health':
        return const Color(0xFF8B0000); // Dark red
      case 'Gaming':
        return const Color(0xFFE0F2F1); // Light cyan
      default:
        return Colors.white;
    }
  }
}