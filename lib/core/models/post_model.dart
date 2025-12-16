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
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAtClient: data['createdAtClient'] ?? 0,

    );
  }
}
