// ============================================
// FILE: lib/features/focs/widget/post_card.dart
// ============================================
import 'package:flutter/material.dart';
import '../model/post_model.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostCard({
    Key? key,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimationController;
  late Animation<double> _likeScaleAnimation;

  @override
  void initState() {
    super.initState();
    _likeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _likeAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _likeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB0BEC5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildContent(),
          if (widget.post.imageUrl != null) ...[
            const SizedBox(height: 12),
            _buildImage(),
          ],
          const SizedBox(height: 12),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(widget.post.userAvatar),
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.post.userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.post.category != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A9CA8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.post.category!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                widget.post.time,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black54),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            // TODO: Show options menu
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      widget.post.content,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        height: 1.4,
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        widget.post.imageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: const Color(0xFF7A9CA8),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Failed to load image',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        // Like Button
        _buildActionButton(
          icon: widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
          label: widget.post.formattedLikes,
          color: widget.post.isLiked ? Colors.red : Colors.black54,
          onTap: () {
            print('👍 LIKE TAPPED - Post: ${widget.post.id}');
            widget.onLike();
            if (widget.post.isLiked) {
              _likeAnimationController.forward().then((_) {
                _likeAnimationController.reverse();
              });
            }
          },
          useAnimation: widget.post.isLiked,
        ),
        const SizedBox(width: 20),

        // Comment Button
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          label: widget.post.formattedComments,
          color: Colors.black54,
          onTap: () {
            print('💬 COMMENT TAPPED - Post: ${widget.post.id}');
            widget.onComment();
          },
        ),
        const SizedBox(width: 20),

        // Share Button - DENGAN POSITION TRACKING
        Builder(
          builder: (context) {
            return _buildActionButton(
              icon: Icons.share_outlined,
              label: widget.post.formattedShares,
              color: Colors.black54,
              onTap: () {
                print('🔗 SHARE TAPPED - Post: ${widget.post.id}');

                // Dapatkan posisi button
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);
                final size = renderBox.size;

                print('Button position: $position');
                print('Button size: $size');

                // Panggil handler dengan posisi
                widget.onShare();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool useAnimation = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          useAnimation
              ? ScaleTransition(
                  scale: _likeScaleAnimation,
                  child: Icon(icon, color: color, size: 20),
                )
              : Icon(icon, color: color, size: 20),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
