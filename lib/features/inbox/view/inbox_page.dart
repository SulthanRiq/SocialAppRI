import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/custom_bottom_navbar.dart';
import '../../dashboard/view/dashboard_register_page.dart';
import '../../search/view/search_page.dart';
import '../../focs/view/focs_page.dart';
import '../../notification/view/notification_page.dart';
import '../controller/chat_controller.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../core/models/chat_model.dart';
import 'search_user_page.dart';
import 'chat_detail_page.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  int _selectedIndex = 4;
  final chatController = Get.put(ChatController());
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    final currentUserId = authController.currentUser.value?.uid;
    if (currentUserId != null) {
      chatController.loadChatRooms(currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB8C5CC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B95A8),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.black),
            onPressed: () {
              Get.to(() => const SearchUserPage());
            },
            tooltip: 'Cari User',
          ),
        ],
      ),
      body: Obx(() {
        if (chatController.chatRooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 80,
                  color: Colors.grey[600],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pesan',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + untuk memulai chat',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: chatController.chatRooms.length,
          itemBuilder: (context, index) {
            final chatRoom = chatController.chatRooms[index];
            return _buildChatRoomItem(chatRoom);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const SearchUserPage());
        },
        backgroundColor: const Color(0xFF6B95A8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FocsCScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchScreen(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildChatRoomItem(ChatRoom chatRoom) {
    final currentUserId = authController.currentUser.value?.uid ?? '';
    final otherUserId = chatRoom.participants.firstWhere(
          (id) => id != currentUserId,
      orElse: () => '',
    );

    return FutureBuilder<ChatUser?>(
      future: chatController.getUserData(otherUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final otherUser = snapshot.data!;
        final unreadCount = chatRoom.unreadCount[currentUserId] ?? 0;
        final hasUnread = unreadCount > 0;

        return InkWell(
          onTap: () {
            Get.to(() => ChatDetailPage(
              chatRoomId: chatRoom.id,
              otherUserId: otherUserId,
            ));
          },
          child: Container(
            color: hasUnread
                ? const Color(0xFFE0E7EB)
                : const Color(0xFFCFD8DC),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: otherUser.photoUrl != null
                          ? NetworkImage(otherUser.photoUrl!)
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: otherUser.photoUrl == null
                          ? Text(
                        otherUser.username[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                          : null,
                    ),
                    if (hasUnread)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // Message Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Username
                          Expanded(
                            child: Text(
                              otherUser.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: hasUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Time
                          if (chatRoom.lastMessageTime != null)
                            Text(
                              _formatTime(chatRoom.lastMessageTime!),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: hasUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Last Message
                      if (chatRoom.lastMessage != null)
                        Row(
                          children: [
                            if (chatRoom.lastMessageSenderId == currentUserId)
                              Text(
                                'Anda: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            Expanded(
                              child: Text(
                                chatRoom.lastMessage!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  fontWeight: hasUnread
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(dateTime);
    } else {
      return DateFormat('dd/MM/yy').format(dateTime);
    }
  }
}