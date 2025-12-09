// File: lib/features/focs/widget/post_card.dart

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String name;
  final String time;
  final String content;
  final String likes;
  final String comments;
  final String shares;
  final String avatarUrl;
  final bool hasImage;
  final String? imageUrl;
  final String? category;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTap;

  const PostCard({
    Key? key,
    required this.name,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.avatarUrl,
    this.hasImage = false,
    this.imageUrl,
    this.category,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildContent(),
            if (hasImage && imageUrl != null) ...[
              const SizedBox(height: 12),
              _buildImage(),
            ],
            const SizedBox(height: 12),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  // Header: Avatar, Name, Time, Category Badge
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
        // Category badge
        if (category != null) _buildCategoryBadge(),
      ],
    );
  }

  // Category Badge
  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getCategoryColor(category!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category!,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Content Text
  Widget _buildContent() {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black87,
        height: 1.4,
      ),
    );
  }

  // Image
  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  // Actions: Like, Comment, Share
  Widget _buildActions() {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.favorite,
          count: likes,
          onTap: onLike,
        ),
        const SizedBox(width: 20),
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          count: comments,
          onTap: onComment,
        ),
        const SizedBox(width: 20),
        _buildActionButton(
          icon: Icons.share,
          count: shares,
          onTap: onShare,
        ),
      ],
    );
  }

  // Action Button (Like, Comment, Share)
  Widget _buildActionButton({
    required IconData icon,
    required String count,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            count,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Get category color
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Colors.red.shade400;
      case 'sports':
        return Colors.blue.shade400;
      case 'food':
        return Colors.orange.shade400;
      case 'tech':
      case 'technology':
        return Colors.purple.shade400;
      case 'design':
        return Colors.pink.shade400;
      case 'business':
      case 'bussiness':
        return Colors.green.shade400;
      case 'politics':
        return Colors.brown.shade400;
      case 'science':
        return Colors.teal.shade400;
      case 'gaming':
        return Colors.cyan.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
