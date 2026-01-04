import 'package:cloud_firestore/cloud_firestore.dart';

// Model untuk Chat Room
class ChatRoom {
  final String id;
  final List<String> participants;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final Map<String, int> unreadCount;
  final DateTime createdAt;

  ChatRoom({
    required this.id,
    required this.participants,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    required this.unreadCount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCount': unreadCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ChatRoom.fromMap(String id, Map<String, dynamic> map) {
    return ChatRoom(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime'] != null
          ? DateTime.parse(map['lastMessageTime'])
          : null,
      lastMessageSenderId: map['lastMessageSenderId'],
      unreadCount: Map<String, int>.from(map['unreadCount'] ?? {}),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }
}

// Model untuk Chat Message
class ChatMessage {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String message;
  final MessageType type;
  final String? imageUrl;
  final String? imageBase64; // Tambahan untuk base64
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.message,
    required this.type,
    this.imageUrl,
    this.imageBase64,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'message': message,
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'imageBase64': imageBase64,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory ChatMessage.fromMap(String id, Map<String, dynamic> map) {
    return ChatMessage(
      id: id,
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      type: MessageType.values.firstWhere(
            (e) => e.toString().split('.').last == map['type'],
        orElse: () => MessageType.text,
      ),
      imageUrl: map['imageUrl'],
      imageBase64: map['imageBase64'],
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }
}

enum MessageType {
  text,
  image,
}

// Model untuk User List (untuk pencarian)
class ChatUser {
  final String uid;
  final String username;
  final String email;
  final String? photoUrl;

  ChatUser({
    required this.uid,
    required this.username,
    required this.email,
    this.photoUrl,
  });

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
    );
  }
}