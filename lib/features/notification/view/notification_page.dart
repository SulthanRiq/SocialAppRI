import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projek_mobile/common/widgets/custom_bottom_navbar.dart';
import 'package:projek_mobile/features/dashboard/view/dashboard_register_page.dart';
import 'package:projek_mobile/features/focs/view/focs_page.dart';
import '../../search/view/search_page.dart';
import '../../inbox/view/inbox_page.dart';
import '../controller/notification_controller.dart';
import '../../../core/models/notification_model.dart';
import '../../register/widgets/base64_image_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 3;
  late final NotificationController notificationController;

  @override
  void initState() {
    super.initState();

    // ✅ Cek apakah controller sudah ada
    if (Get.isRegistered<NotificationController>()) {
      notificationController = Get.find<NotificationController>();
      print('✅ NotificationController found');
    } else {
      notificationController = Get.put(NotificationController());
      print('⚠️ NotificationController not found, creating new instance');
    }

    // Force refresh
    Future.delayed(Duration(milliseconds: 500), () {
      notificationController.fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color topBarColor = const Color(0xFF6B95A8);
    final Color bgColor = const Color(0xFFB8C5CC);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // TOP BAR
            Container(
              height: 60,
              width: double.infinity,
              color: topBarColor,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      // Mark all as read
                      Obx(() {
                        return notificationController.unreadCount.value > 0
                            ? IconButton(
                          icon: const Icon(
                            Icons.done_all,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            notificationController.markAllAsRead();
                          },
                          tooltip: 'Tandai semua dibaca',
                        )
                            : const SizedBox.shrink();
                      }),
                      // Clear all
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'clear',
                            child: Text('Hapus Semua'),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'clear') {
                            _showClearDialog();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // CONTENT AREA
            Expanded(
              child: Obx(() {
                // Loading state
                if (notificationController.isLoading.value &&
                    notificationController.notifications.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Empty state
                if (notificationController.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 80,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada notifikasi',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Notifications list
                return RefreshIndicator(
                  onRefresh: () async {
                    notificationController.fetchNotifications();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    itemCount: notificationController.notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notificationController.notifications[index];
                      return NotificationItem(
                        notification: notif,
                        onTap: () {
                          if (!notif.isRead) {
                            notificationController.markAsRead(notif.id);
                          }
                          // TODO: Navigate to post detail
                        },
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FocsCScreen()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InboxScreen()),
            );
          }
        },
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Semua Notifikasi'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua notifikasi?',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          TextButton(
            onPressed: () {
              notificationController.clearAllNotifications();
              Navigator.pop(context);
              Get.snackbar(
                'Sukses',
                'Semua notifikasi telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead
            ? const Color(0xFFE0E0E0)
            : const Color(0xFFD0E8F2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Avatar
            Base64CircleAvatar(
              base64String: notification.senderPhotoUrl,
              radius: 24,
              backgroundColor: Colors.grey.shade400,
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      children: [
                        TextSpan(
                          text: notification.senderUsername,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${notification.getMessage()}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notification.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // Unread indicator
            if (!notification.isRead)
              Icon(
                Icons.circle,
                size: 10,
                color: Colors.blue.withOpacity(0.7),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit yang lalu';
    } else {
      return 'Baru saja';
    }
  }
}