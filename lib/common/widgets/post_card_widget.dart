import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username, time, content, likes, comments, shares;
  final String? subContent, source, trustScore, rightLabel, imageUrl;
  final Color avatarColor;
  final bool isNews;
  final VoidCallback? onReadTap, onShareTap, onCommentTap;

  const PostCard({
    super.key,
    required this.username,
    this.time = "",
    required this.content,
    this.subContent,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.avatarColor,
    this.isNews = false,
    this.source,
    this.trustScore,
    this.rightLabel,
    this.onReadTap,
    this.onShareTap,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          if (isNews) _buildTrendingBadge(),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 12),
          if (imageUrl != null && imageUrl!.isNotEmpty) _buildImage(),
          if (subContent != null) _buildSubContent(),
          if (isNews) _buildNewsSource(),
          const SizedBox(height: 12),
          _buildStats(),
          if (isNews) _buildNewsButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (time.isNotEmpty) Text(" · $time", style: const TextStyle(color: Colors.grey)),
          ],
        ),
        if (rightLabel != null)
          Text(rightLabel!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildTrendingBadge() {
    return const Padding(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(Icons.local_fire_department, color: Colors.red, size: 16),
          SizedBox(width: 4),
          Text("Trending Now", style: TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (ctx, err, stack) => Container(
          height: 200,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 50),
        ),
      ),
    );
  }

  Widget _buildSubContent() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      color: Colors.grey[300],
      child: Center(child: Text(subContent!)),
    );
  }

  Widget _buildNewsSource() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(source ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          const Icon(Icons.lock_outline, size: 14, color: Colors.grey),
          Text(" $trustScore", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return GestureDetector(
      onTap: onCommentTap,
      child: Row(
        children: [
          const Icon(Icons.favorite, size: 20),
          const SizedBox(width: 4),
          Text(likes),
          const SizedBox(width: 20),
          const Icon(Icons.mode_comment_outlined, size: 20),
          const SizedBox(width: 4),
          Text(comments),
          if (shares.isNotEmpty) ...[
            const SizedBox(width: 20),
            const Icon(Icons.share_outlined, size: 20),
            const SizedBox(width: 4),
            Text(shares),
          ],
        ],
      ),
    );
  }

  Widget _buildNewsButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onReadTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8FA37E),
              ),
              child: const Text("Baca", style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onShareTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC4C46A),
              ),
              child: const Text("Share", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}