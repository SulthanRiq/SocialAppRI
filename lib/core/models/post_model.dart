import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String? userPhoto;
  final String content;
  final String? imageBase64;
  final int likes;
  final List<String> likedBy;
  final int commentsCount;
  final List<String> topics;
  final DateTime createdAt;
  final int createdAtClient;


  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    this.userPhoto,
    required this.content,
    this.imageBase64,
    required this.likes,
    required this.likedBy,
    this.commentsCount = 0,
    this.topics = const [],
    required this.createdAt,
    required this.createdAtClient,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      userId: data['userId'],
      username: data['username'],
      userPhoto: data['userPhoto'],
      content: data['content'],
      imageBase64: data['imageBase64'],
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      commentsCount: data['commentsCount'] ?? 0,
      topics: List<String>.from(data['topics'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAtClient: data['createdAtClient'] ?? 0,

    );
  }

  String getSharePreview() {
    return '"${content.length > 50 ? '${content.substring(0, 50)}...' : content}"';
  }
}
