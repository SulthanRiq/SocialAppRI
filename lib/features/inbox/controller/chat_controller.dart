import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/models/chat_model.dart';
import '../services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final ImagePicker _picker = ImagePicker();

  final RxList<ChatRoom> chatRooms = <ChatRoom>[].obs;
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxList<ChatUser> searchResults = <ChatUser>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  @override
  void onClose() {
    messageController.dispose();
    searchController.dispose();
    super.onClose();
  }

  // Load chat rooms untuk user
  void loadChatRooms(String userId) {
    _chatService.getChatRooms(userId).listen((rooms) {
      chatRooms.value = rooms;
    });
  }

  // Load messages untuk chat room
  void loadMessages(String chatRoomId) {
    _chatService.getMessages(chatRoomId).listen((msgs) {
      messages.value = msgs;
    });
  }

  // Kirim pesan teks
  Future<void> sendTextMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
  }) async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    try {
      isSending.value = true;
      messageController.clear();

      await _chatService.sendTextMessage(
        chatRoomId: chatRoomId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Gagal mengirim pesan: ${e.toString()}',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isSending.value = false;
    }
  }

  // Kirim pesan gambar
  Future<void> sendImageMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required ImageSource source,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      isSending.value = true;

      await _chatService.sendImageMessage(
        chatRoomId: chatRoomId,
        senderId: senderId,
        receiverId: receiverId,
        imageFile: File(pickedFile.path),
        message: messageController.text.trim(),
      );

      messageController.clear();
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Gagal mengirim gambar: ${e.toString()}',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isSending.value = false;
    }
  }

  // Show image source dialog
  Future<void> showImageSourceDialog(
      BuildContext context, {
        required String chatRoomId,
        required String senderId,
        required String receiverId,
      }) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  sendImageMessage(
                    chatRoomId: chatRoomId,
                    senderId: senderId,
                    receiverId: receiverId,
                    source: ImageSource.gallery,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  sendImageMessage(
                    chatRoomId: chatRoomId,
                    senderId: senderId,
                    receiverId: receiverId,
                    source: ImageSource.camera,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.grey),
                title: const Text('Batal'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Mencari user
  Future<void> searchUsers(String query, String currentUserId) async {
    searchQuery.value = query;

    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      isLoading.value = true;
      final results = await _chatService.searchUsers(query, currentUserId);
      searchResults.value = results;
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Gagal mencari user: ${e.toString()}',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Mulai chat dengan user
  Future<String?> startChatWithUser(String currentUserId, String otherUserId) async {
    try {
      isLoading.value = true;
      final chatRoomId = await _chatService.getOrCreateChatRoom(
        currentUserId,
        otherUserId,
      );
      return chatRoomId;
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Gagal membuat chat: ${e.toString()}',
          backgroundColor: Colors.red.shade400,
          duration: const Duration(seconds: 2),
        ),
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Mendapatkan user data
  Future<ChatUser?> getUserData(String userId) async {
    return await _chatService.getUserData(userId);
  }

  // Menandai pesan sebagai sudah dibaca
  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    await _chatService.markMessagesAsRead(chatRoomId, userId);
  }
}