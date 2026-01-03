import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/comment_model.dart';
import 'auth_controller.dart';
import '../../features/notification/controller/notification_controller.dart';
import '../models/notification_model.dart';

class CommentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>();

  // Map untuk menyimpan comments per post
  final RxMap<String, List<CommentModel>> commentsMap = <String, List<CommentModel>>{}.obs;
  final RxMap<String, StreamSubscription?> _commentSubs = <String, StreamSubscription?>{}.obs;

  RxBool isCommenting = false.obs;

  // ================= FETCH COMMENTS FOR POST
  void fetchComments(String postId) {
    // Cancel previous subscription jika ada
    _commentSubs[postId]?.cancel();

    // ✅ Initialize list jika belum ada
    if (!commentsMap.containsKey(postId)) {
      commentsMap[postId] = [];
    }

    _commentSubs[postId] = _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('createdAtClient', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
        // ✅ Handle document changes properly
        for (var change in snapshot.docChanges) {
          final comment = CommentModel.fromFirestore(change.doc);

          if (change.type == DocumentChangeType.added) {
            // Tambah comment baru jika belum ada
            final currentComments = commentsMap[postId] ?? [];
            if (!currentComments.any((c) => c.id == comment.id)) {
              commentsMap[postId] = [...currentComments, comment];
            }
          }
          else if (change.type == DocumentChangeType.modified) {
            // Update comment yang sudah ada
            final currentComments = commentsMap[postId] ?? [];
            final index = currentComments.indexWhere((c) => c.id == comment.id);
            if (index != -1) {
              currentComments[index] = comment;
              commentsMap[postId] = [...currentComments];
            }
          }
          else if (change.type == DocumentChangeType.removed) {
            // ✅ PERBAIKAN: Hapus comment dari list
            final currentComments = commentsMap[postId] ?? [];
            commentsMap[postId] = currentComments.where((c) => c.id != comment.id).toList();
            print('🗑️ Comment removed: ${comment.id}');
          }
        }
      },
      onError: (error) {
        print('❌ Error fetching comments: $error');
        // Jangan tampilkan error jika PERMISSION_DENIED (karena logout)
        // if (!error.toString().contains('PERMISSION_DENIED')) {
        //   Get.snackbar(
        //     'Error',
        //     'Gagal memuat komentar: $error',
        //     snackPosition: SnackPosition.BOTTOM,
        //   );
        // }
      },
      cancelOnError: true,
    );
  }

  // ================= GET COMMENTS FOR POST
  List<CommentModel> getCommentsForPost(String postId) {
    return commentsMap[postId] ?? [];
  }

  // ================= ADD COMMENT
  Future<void> addComment({
    required String postId,
    required String content,
  }) async {
    if (content.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Komentar tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isCommenting.value = true;

      final user = _auth.currentUser.value;
      if (user == null) throw 'User not logged in';

      // Tambah comment ke Firestore
      await _firestore.collection('comments').add({
        'postId': postId,
        'userId': user.uid,
        'username': user.username,
        'userPhoto': user.photoUrl,
        'content': content.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'createdAtClient': DateTime.now().millisecondsSinceEpoch,
      });

      // Update comment count di post
      final postDoc = await _firestore.collection('posts').doc(postId).get();
      final postData = postDoc.data();
      final postOwnerId = postData?['userId'];

      await _firestore.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(1),
      });

      // ✅ CREATE NOTIFICATION
      if (postOwnerId != null && postOwnerId != user.uid) {
        final notifController = Get.find<NotificationController>();
        await notifController.createNotification(
          recipientId: postOwnerId,
          type: NotificationType.comment,
          postId: postId,
          commentText: content.trim().length > 50
              ? '${content.trim().substring(0, 50)}...'
              : content.trim(),
        );
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambah komentar: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCommenting.value = false;
    }
  }

  // ================= DELETE COMMENT
  Future<void> deleteComment({
    required String commentId,
    required String postId,
    required String commentUserId,
  }) async {
    final user = _auth.currentUser.value;
    if (user == null || user.uid != commentUserId) {
      print('❌ Unauthorized: Cannot delete comment');
      return;
    }

    try {
      print('🗑️ Deleting comment: $commentId');

      // Hapus comment dari Firestore
      await _firestore.collection('comments').doc(commentId).delete();

      // Update comment count di post
      await _firestore.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(-1),
      });

      print('✅ Comment deleted successfully');

      Get.snackbar(
        'Sukses',
        'Komentar berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF6B95A8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Error deleting comment: $e');
      Get.snackbar(
        'Error',
        'Gagal menghapus komentar: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ================= CLEAR COMMENTS FOR POST
  void clearCommentsForPost(String postId) {
    print('🧹 Clearing comments for post: $postId');
    _commentSubs[postId]?.cancel();
    _commentSubs.remove(postId);
    commentsMap.remove(postId);
  }

  // ================= CLEAR ALL COMMENTS
  void clearAllComments() {
    print('🧹 Clearing all comments');
    for (var sub in _commentSubs.values) {
      sub?.cancel();
    }
    _commentSubs.clear();
    commentsMap.clear();
  }

  @override
  void onClose() {
    print('🔴 CommentController onClose');
    clearAllComments();
    super.onClose();
  }
}