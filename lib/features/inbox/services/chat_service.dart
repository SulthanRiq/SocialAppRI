import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../../core/models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan atau membuat chat room
  Future<String> getOrCreateChatRoom(String currentUserId, String otherUserId) async {
    try {
      // Cari chat room yang sudah ada
      final existingRoom = await _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: currentUserId)
          .get();

      for (var doc in existingRoom.docs) {
        final participants = List<String>.from(doc['participants']);
        if (participants.contains(otherUserId)) {
          return doc.id;
        }
      }

      // Jika tidak ada, buat chat room baru
      final chatRoomRef = await _firestore.collection('chatRooms').add({
        'participants': [currentUserId, otherUserId],
        'lastMessage': null,
        'lastMessageTime': null,
        'lastMessageSenderId': null,
        'unreadCount': {
          currentUserId: 0,
          otherUserId: 0,
        },
        'createdAt': DateTime.now().toIso8601String(),
      });

      return chatRoomRef.id;
    } catch (e) {
      print('Error getting or creating chat room: $e');
      rethrow;
    }
  }

  // Mendapatkan stream chat rooms untuk user
  Stream<List<ChatRoom>> getChatRooms(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatRoom.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Mendapatkan stream messages untuk chat room
  Stream<List<ChatMessage>> getMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50) // Limit untuk performa
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatMessage.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  // Mengirim pesan teks
  Future<void> sendTextMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      final timestamp = DateTime.now();

      // Tambahkan pesan ke sub-collection messages
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'chatRoomId': chatRoomId,
        'senderId': senderId,
        'message': message,
        'type': 'text',
        'imageUrl': null,
        'imageBase64': null,
        'timestamp': timestamp.toIso8601String(),
        'isRead': false,
      });

      // Update chat room dengan last message
      final currentUnreadCount = await _getUnreadCount(chatRoomId, receiverId);

      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': message,
        'lastMessageTime': timestamp.toIso8601String(),
        'lastMessageSenderId': senderId,
        'unreadCount.$receiverId': currentUnreadCount + 1,
      });
    } catch (e) {
      print('Error sending text message: $e');
      rethrow;
    }
  }

  // Compress dan convert image ke base64
  Future<String?> _compressAndConvertToBase64(File imageFile) async {
    try {
      // Compress gambar untuk mengurangi size
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        minWidth: 800,
        minHeight: 800,
        quality: 70,
      );

      if (compressedBytes == null) {
        print('❌ Failed to compress image');
        return null;
      }

      // Convert ke base64
      final base64String = base64Encode(compressedBytes);

      // Check size (Firestore limit 1MB per field)
      final sizeInKB = (base64String.length * 3 / 4) / 1024;
      print('📊 Compressed image size: ${sizeInKB.toStringAsFixed(2)} KB');

      if (sizeInKB > 900) { // Limit ke 900KB untuk safety
        print('⚠️ Image too large even after compression');
        return null;
      }

      return base64String;
    } catch (e) {
      print('❌ Error compressing image: $e');
      return null;
    }
  }

  // Mengirim pesan gambar dengan Base64
  Future<void> sendImageMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required File imageFile,
    String message = '',
  }) async {
    try {
      final timestamp = DateTime.now();

      print('📤 Compressing and converting image to base64...');
      final base64Image = await _compressAndConvertToBase64(imageFile);

      if (base64Image == null) {
        throw Exception('Failed to process image. Image might be too large.');
      }

      print('✅ Image processed successfully');

      // Tambahkan pesan ke sub-collection messages
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'chatRoomId': chatRoomId,
        'senderId': senderId,
        'message': message.isEmpty ? '📷 Photo' : message,
        'type': 'image',
        'imageUrl': null,
        'imageBase64': base64Image, // Simpan base64 di Firestore
        'timestamp': timestamp.toIso8601String(),
        'isRead': false,
      });

      // Update chat room dengan last message
      final currentUnreadCount = await _getUnreadCount(chatRoomId, receiverId);

      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'lastMessage': message.isEmpty ? '📷 Photo' : message,
        'lastMessageTime': timestamp.toIso8601String(),
        'lastMessageSenderId': senderId,
        'unreadCount.$receiverId': currentUnreadCount + 1,
      });
    } catch (e) {
      print('Error sending image message: $e');
      rethrow;
    }
  }

  // Mendapatkan unread count
  Future<int> _getUnreadCount(String chatRoomId, String userId) async {
    try {
      final doc = await _firestore.collection('chatRooms').doc(chatRoomId).get();
      final data = doc.data();
      if (data != null && data['unreadCount'] != null) {
        return (data['unreadCount'][userId] ?? 0) as int;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Menandai pesan sebagai sudah dibaca
  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    try {
      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        'unreadCount.$userId': 0,
      });
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  // Mencari user
  Future<List<ChatUser>> searchUsers(String query, String currentUserId) async {
    try {
      if (query.isEmpty) return [];

      final snapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: query + '\uf8ff')
          .limit(20)
          .get();

      return snapshot.docs
          .where((doc) => doc.id != currentUserId)
          .map((doc) => ChatUser.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  // Mendapatkan user data
  Future<ChatUser?> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return ChatUser.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }
}