import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import '../../../core/controllers/auth_controller.dart';
import 'chat_detail_page.dart';

class SearchUserPage extends StatelessWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFB8C5CC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B95A8),
        elevation: 0,
        title: const Text(
          'Cari User',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF6B95A8),
            child: TextField(
              controller: chatController.searchController,
              onChanged: (value) {
                chatController.searchUsers(
                  value,
                  authController.currentUser.value?.uid ?? '',
                );
              },
              decoration: InputDecoration(
                hintText: 'Cari username...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Search Results
          Expanded(
            child: Obx(() {
              if (chatController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6B95A8),
                  ),
                );
              }

              if (chatController.searchQuery.value.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cari user untuk memulai chat',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (chatController.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_off,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'User tidak ditemukan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: chatController.searchResults.length,
                itemBuilder: (context, index) {
                  final user = chatController.searchResults[index];
                  return _buildUserItem(
                    context,
                    user,
                    chatController,
                    authController,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(
      BuildContext context,
      user,
      ChatController chatController,
      AuthController authController,
      ) {
    return InkWell(
      onTap: () async {
        final currentUserId = authController.currentUser.value?.uid;
        if (currentUserId == null) return;

        final chatRoomId = await chatController.startChatWithUser(
          currentUserId,
          user.uid,
        );

        if (chatRoomId != null) {
          Get.to(() => ChatDetailPage(
            chatRoomId: chatRoomId,
            otherUserId: user.uid,
          ));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: user.photoUrl != null
                  ? NetworkImage(user.photoUrl!)
                  : null,
              backgroundColor: Colors.grey[300],
              child: user.photoUrl == null
                  ? Text(
                user.username[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chat_bubble_outline,
              color: Colors.grey[600],
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}