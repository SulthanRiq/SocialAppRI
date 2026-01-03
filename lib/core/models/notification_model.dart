import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  like,
  comment,
  follow,
}

class NotificationModel {
  final String id;
  final String recipientId; // User yang menerima notif
  final String senderId; // User yang melakukan aksi
  final String senderUsername;
  final String? senderPhotoUrl;
  final NotificationType type;
  final String? postId; // Post yang di-like/comment
  final String? commentText; // Text comment (jika type = comment)
  final bool isRead;
  final DateTime createdAt;
  final int createdAtClient;

  NotificationModel({
    required this.id,
    required this.recipientId,
    required this.senderId,
    required this.senderUsername,
    this.senderPhotoUrl,
    required this.type,
    this.postId,
    this.commentText,
    this.isRead = false,
    required this.createdAt,
    required this.createdAtClient,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      id: doc.id,
      recipientId: data['recipientId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderUsername: data['senderUsername'] ?? '',
      senderPhotoUrl: data['senderPhotoUrl'],
      type: NotificationType.values.firstWhere(
            (e) => e.toString() == 'NotificationType.${data['type']}',
        orElse: () => NotificationType.like,
      ),
      postId: data['postId'],
      commentText: data['commentText'],
      isRead: data['isRead'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAtClient: data['createdAtClient'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recipientId': recipientId,
      'senderId': senderId,
      'senderUsername': senderUsername,
      'senderPhotoUrl': senderPhotoUrl,
      'type': type.toString().split('.').last,
      'postId': postId,
      'commentText': commentText,
      'isRead': isRead,
      'createdAt': FieldValue.serverTimestamp(),
      'createdAtClient': createdAtClient,
    };
  }

  String getMessage() {
    switch (type) {
      case NotificationType.like:
        return 'menyukai postingan Anda';
      case NotificationType.comment:
        return 'berkomentar: "${commentText ?? ''}"';
      case NotificationType.follow:
        return 'mulai mengikuti Anda';
    }
  }
}