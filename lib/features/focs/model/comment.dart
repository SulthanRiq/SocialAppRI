// ============================================
// FILE: models/comment_model.dart
// ============================================
class Comment {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime timestamp;
  int likeCount;
  bool isLiked;

  Comment({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.timestamp,
    this.likeCount = 0,
    this.isLiked = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} tahun';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} bulan';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit';
    } else {
      return 'Baru saja';
    }
  }

  void toggleLike() {
    if (isLiked) {
      likeCount--;
      isLiked = false;
    } else {
      likeCount++;
      isLiked = true;
    }
  }
}