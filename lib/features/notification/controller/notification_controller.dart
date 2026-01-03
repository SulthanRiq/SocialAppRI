import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/controllers/auth_controller.dart';

class NotificationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  RxInt unreadCount = 0.obs;
  RxBool isLoading = false.obs;
  StreamSubscription? _notificationSub;

  @override
  void onInit() {
    super.onInit();
    final user = _auth.currentUser.value;
    if (user != null) {
      fetchNotifications();
    }
  }

  // ================= FETCH NOTIFICATIONS
  void fetchNotifications() {
    final user = _auth.currentUser.value;

    print('🔍 Fetching notifications for user: ${user?.uid}');
    print('🔍 User email: ${user?.email}');

    if (user == null) {
      print('❌ User is null, cannot fetch notifications');
      return;
    }

    _notificationSub?.cancel();
    isLoading.value = true;

    _notificationSub = _firestore
        .collection('notifications')
        .where('recipientId', isEqualTo: user.uid)
        .orderBy('createdAtClient', descending: true)
        .limit(50)
        .snapshots()
        .listen(
          (snapshot) {
        print('📥 Received ${snapshot.docs.length} notifications');

        List<NotificationModel> notifList = [];
        int unread = 0;

        for (var doc in snapshot.docs) {
          print('📄 Notification doc: ${doc.id}');
          print('   Data: ${doc.data()}');

          try {
            final notif = NotificationModel.fromFirestore(doc);
            notifList.add(notif);
            if (!notif.isRead) unread++;
          } catch (e) {
            print('❌ Error parsing notification: $e');
          }
        }

        print('✅ Total notifications: ${notifList.length}');
        print('✅ Unread count: $unread');

        notifications.value = notifList;
        unreadCount.value = unread;
        isLoading.value = false;
      },
      onError: (error) {
        print('❌ Error fetching notifications: $error');
        isLoading.value = false;
      },
      cancelOnError: true,
    );
  }

  // ================= CREATE NOTIFICATION
  Future<void> createNotification({
    required String recipientId,
    required NotificationType type,
    String? postId,
    String? commentText,
  }) async {
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      // Jangan buat notif untuk diri sendiri
      if (user.uid == recipientId) return;

      // Check apakah notif sudah ada (untuk like)
      // if (type == NotificationType.like && postId != null) {
      //   final existing = await _firestore
      //       .collection('notifications')
      //       .where('recipientId', isEqualTo: recipientId)
      //       .where('senderId', isEqualTo: user.uid)
      //       .where('postId', isEqualTo: postId)
      //       .where('type', isEqualTo: 'like')
      //       .limit(1)
      //       .get();
      //
      //   if (existing.docs.isNotEmpty) {
      //     print('⚠️ Like notification already exists');
      //     return;
      //   }
      // }

      await _firestore.collection('notifications').add({
        'recipientId': recipientId,
        'senderId': user.uid,
        'senderUsername': user.username,
        'senderPhotoUrl': user.photoUrl,
        'type': type.toString().split('.').last,
        'postId': postId,
        'commentText': commentText,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
        'createdAtClient': DateTime.now().millisecondsSinceEpoch,
      });

      print('✅ Notification created: $type');
    } catch (e) {
      print('❌ Error creating notification: $e');
    }
  }

  // ================= DELETE NOTIFICATION (Unlike)
  Future<void> deleteNotification({
    required String recipientId,
    required String postId,
    required NotificationType type,
  }) async {
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      final snapshot = await _firestore
          .collection('notifications')
          .where('recipientId', isEqualTo: recipientId)
          .where('senderId', isEqualTo: user.uid)
          .where('postId', isEqualTo: postId)
          .where('type', isEqualTo: type.toString().split('.').last)
          .limit(1)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
        print('✅ Notification deleted: $type');
      }
    } catch (e) {
      print('❌ Error deleting notification: $e');
    }
  }

  // ================= MARK AS READ
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      print('❌ Error marking as read: $e');
    }
  }

  // ================= MARK ALL AS READ
  Future<void> markAllAsRead() async {
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection('notifications')
          .where('recipientId', isEqualTo: user.uid)
          .where('isRead', isEqualTo: false)
          .get();

      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }

      await batch.commit();
      print('✅ All notifications marked as read');
    } catch (e) {
      print('❌ Error marking all as read: $e');
    }
  }

  // ================= CLEAR ALL NOTIFICATIONS
  Future<void> clearAllNotifications() async {
    try {
      final user = _auth.currentUser.value;
      if (user == null) return;

      final batch = _firestore.batch();
      final snapshot = await _firestore
          .collection('notifications')
          .where('recipientId', isEqualTo: user.uid)
          .get();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('✅ All notifications cleared');
    } catch (e) {
      print('❌ Error clearing notifications: $e');
    }
  }

  void clearNotifications() {
    _notificationSub?.cancel();
    notifications.clear();
    unreadCount.value = 0;
  }

  @override
  void onClose() {
    _notificationSub?.cancel();
    super.onClose();
  }
}