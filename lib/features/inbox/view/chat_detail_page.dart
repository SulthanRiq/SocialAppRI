import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../controller/chat_controller.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/models/chat_model.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatRoomId;
  final String otherUserId;

  const ChatDetailPage({
    Key? key,
    required this.chatRoomId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final chatController = Get.find<ChatController>();
  final authController = Get.find<AuthController>();
  ChatUser? otherUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    chatController.loadMessages(widget.chatRoomId);
    otherUser = await chatController.getUserData(widget.otherUserId);
    setState(() {});

    // Mark messages as read
    final currentUserId = authController.currentUser.value?.uid;
    if (currentUserId != null) {
      chatController.markMessagesAsRead(widget.chatRoomId, currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = authController.currentUser.value?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B95A8),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        title: otherUser != null
            ? Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: otherUser!.photoUrl != null
                  ? NetworkImage(otherUser!.photoUrl!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: otherUser!.photoUrl == null
                  ? Text(
                otherUser!.username[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              otherUser!.username,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
            : const Text(
          'Chat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: Obx(() {
              if (chatController.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada pesan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mulai percakapan dengan mengirim pesan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isMe = message.senderId == currentUserId;
                  final showDate = index == chatController.messages.length - 1 ||
                      !_isSameDay(
                        message.timestamp,
                        chatController.messages[index + 1].timestamp,
                      );

                  return Column(
                    children: [
                      if (showDate) _buildDateDivider(message.timestamp),
                      _buildMessageBubble(message, isMe),
                    ],
                  );
                },
              );
            }),
          ),

          // Input Area
          _buildInputArea(currentUserId),
        ],
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final messageDate = DateTime(date.year, date.month, date.day);

    String dateText;
    if (messageDate == DateTime(now.year, now.month, now.day)) {
      dateText = 'Hari ini';
    } else if (messageDate == yesterday) {
      dateText = 'Kemarin';
    } else {
      dateText = DateFormat('dd MMM yyyy').format(date);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[400])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF6B95A8) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.image)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: message.imageUrl != null
                          ? Image.network(
                        message.imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                      )
                          : message.imageBase64 != null
                          ? Image.memory(
                        base64Decode(message.imageBase64!),
                        fit: BoxFit.cover,
                      )
                          : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),
                  if (message.message.isNotEmpty &&
                      message.message != '📷 Photo')
                    Padding(
                      padding: EdgeInsets.only(
                        top: message.type == MessageType.image ? 8 : 0,
                      ),
                      child: Text(
                        message.message,
                        style: TextStyle(
                          fontSize: 15,
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(String currentUserId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Image Button
            IconButton(
              onPressed: () {
                chatController.showImageSourceDialog(
                  context,
                  chatRoomId: widget.chatRoomId,
                  senderId: currentUserId,
                  receiverId: widget.otherUserId,
                );
              },
              icon: const Icon(Icons.image, color: Color(0xFF6B95A8)),
            ),

            // Text Field
            Expanded(
              child: TextField(
                controller: chatController.messageController,
                decoration: InputDecoration(
                  hintText: 'Ketik pesan...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF6B95A8)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),

            const SizedBox(width: 8),

            // Send Button
            Obx(() => chatController.isSending.value
                ? const SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF6B95A8),
                  ),
                ),
              ),
            )
                : IconButton(
              onPressed: () {
                chatController.sendTextMessage(
                  chatRoomId: widget.chatRoomId,
                  senderId: currentUserId,
                  receiverId: widget.otherUserId,
                );
              },
              icon: const Icon(
                Icons.send,
                color: Color(0xFF6B95A8),
              ),
            )),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}