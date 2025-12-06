// lib/core/models/comment.dart
class Comment {
  final String id;
  final String username;
  final String timeAgo;
  final String comment;
  final int likes;
  final String avatarUrl;
  final String articleId;

  Comment({
    required this.id,
    required this.username,
    required this.timeAgo,
    required this.comment,
    required this.likes,
    required this.avatarUrl,
    required this.articleId,
  });

  Comment copyWith({
    String? id,
    String? username,
    String? timeAgo,
    String? comment,
    int? likes,
    String? avatarUrl,
    String? articleId,
  }) {
    return Comment(
      id: id ?? this.id,
      username: username ?? this.username,
      timeAgo: timeAgo ?? this.timeAgo,
      comment: comment ?? this.comment,
      likes: likes ?? this.likes,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      articleId: articleId ?? this.articleId,
    );
  }
}