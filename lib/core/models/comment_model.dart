import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String? userPhoto;
  final String content;
  final DateTime createdAt;
  final int createdAtClient;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    this.userPhoto,
    required this.content,
    required this.createdAt,
    required this.createdAtClient,
  });

  factory CommentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return CommentModel(
      id: doc.id,
      postId: data['postId'] ?? '',
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      userPhoto: data['userPhoto'],
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAtClient: data['createdAtClient'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'username': username,
      'userPhoto': userPhoto,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
      'createdAtClient': createdAtClient,
    };
  }
}