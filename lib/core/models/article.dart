// lib/core/models/article.dart
class Article {
  final String id;
  final String username;
  final String time;
  final String content;
  final String? imageUrl;
  final String? source;
  final String? trustScore;
  final int likes;
  final int comments;
  final int shares;
  final bool isNews;
  final double? emotionalTrigger;
  final String? viralPotential;
  final List<String>? unverifiedClaims;

  Article({
    required this.id,
    required this.username,
    required this.time,
    required this.content,
    this.imageUrl,
    this.source,
    this.trustScore,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isNews,
    this.emotionalTrigger,
    this.viralPotential,
    this.unverifiedClaims,
  });

  Article copyWith({
    String? id,
    String? username,
    String? time,
    String? content,
    String? imageUrl,
    String? source,
    String? trustScore,
    int? likes,
    int? comments,
    int? shares,
    bool? isNews,
    double? emotionalTrigger,
    String? viralPotential,
    List<String>? unverifiedClaims,
  }) {
    return Article(
      id: id ?? this.id,
      username: username ?? this.username,
      time: time ?? this.time,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      trustScore: trustScore ?? this.trustScore,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isNews: isNews ?? this.isNews,
      emotionalTrigger: emotionalTrigger ?? this.emotionalTrigger,
      viralPotential: viralPotential ?? this.viralPotential,
      unverifiedClaims: unverifiedClaims ?? this.unverifiedClaims,
    );
  }
}