// File: lib/features/focs/view/comment_page.dart

import 'package:flutter/material.dart';
import 'package:projek_mobile/features/focs/model/comment.dart';

class CommentPage extends StatefulWidget {
  final String postId;
  final String postUserName;
  final String postUserAvatar;
  final String postContent;
  final String postTime;
  final String? postImageUrl;
  final int initialCommentCount;

  const CommentPage({
    Key? key,
    required this.postId,
    required this.postUserName,
    required this.postUserAvatar,
    required this.postContent,
    required this.postTime,
    this.postImageUrl,
    required this.initialCommentCount,
  }) : super(key: key);

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  late List<Comment> comments;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    setState(() => isLoading = true);

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Load dummy comments
    comments = Comment.dummyComments(widget.postId);

    setState(() => isLoading = false);
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final newComment = Comment(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      postId: widget.postId,
      userName: 'You',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      content: _commentController.text.trim(),
      time: 'Just now',
      timestamp: DateTime.now(),
    );

    setState(() {
      comments.insert(0, newComment);
      _commentController.clear();
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();
  }

  void _likeComment(String commentId) {
    setState(() {
      final index = comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final comment = comments[index];
        comments[index] = comment.copyWith(
          isLiked: !comment.isLiked,
          likes: comment.isLiked ? comment.likes - 1 : comment.likes + 1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0BEC5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A9CA8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, comments.length),
        ),
        title: const Text(
          'Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          // Original Post
          _buildOriginalPost(),

          // Divider
          Container(
            height: 8,
            color: const Color(0xFF9CADB5),
          ),

          // Comments List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : comments.isEmpty
                    ? _buildEmptyComments()
                    : _buildCommentsList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildCommentInput(),
    );
  }

  // Original Post Card
  Widget _buildOriginalPost() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFD9D9D9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.postUserAvatar),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.postUserName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.postTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Post Content
          Text(
            widget.postContent,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          // Post Image
          if (widget.postImageUrl != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.postImageUrl!,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 40),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Comments List
  Widget _buildCommentsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return _buildCommentItem(comments[index]);
      },
    );
  }

  // Comment Item
  Widget _buildCommentItem(Comment comment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFD9D9D9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(comment.userAvatar),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 12),

          // Comment Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username & Time
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Comment Text
                Text(
                  comment.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Like Button
                GestureDetector(
                  onTap: () => _likeComment(comment.id),
                  child: Row(
                    children: [
                      Icon(
                        comment.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 16,
                        color: comment.isLiked ? Colors.red : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.likes > 0 ? '${comment.likes}' : 'Like',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              comment.isLiked ? Colors.red : Colors.grey[600],
                          fontWeight: comment.isLiked
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Empty Comments State
  Widget _buildEmptyComments() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to comment!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Comment Input Box
  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 18,
              backgroundImage:
                  const NetworkImage('https://i.pravatar.cc/150?img=1'),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),

            // Text Field
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _addComment(),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Send Button
            GestureDetector(
              onTap: _addComment,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF7A9CA8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
