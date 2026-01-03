import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/notification_model.dart';
import '../models/post_model.dart';
import 'auth_controller.dart';
import '../../features/notification/controller/notification_controller.dart';

class PostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _auth = Get.find<AuthController>();
  StreamSubscription? _postSub;

  // STATE
  RxList<PostModel> posts = <PostModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isPosting = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  // ================= FETCH POSTS (REALTIME)
  void fetchPosts() {
    _postSub?.cancel();
    posts.clear();
    isLoading.value = true;

    _postSub = _firestore
        .collection('posts')
        .orderBy('createdAtClient', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        isLoading.value = false;

        for (var change in snapshot.docChanges) {
          final post = PostModel.fromFirestore(change.doc);

          if (change.type == DocumentChangeType.added) {
            if (!posts.any((p) => p.id == post.id)) {
              posts.insert(0, post);
            }
          }
          else if (change.type == DocumentChangeType.modified) {
            final index = posts.indexWhere((p) => p.id == post.id);
            if (index != -1) posts[index] = post;
          }
          else if (change.type == DocumentChangeType.removed) {
            posts.removeWhere((p) => p.id == post.id);
          }
        }
      },
      onError: (error) {
        isLoading.value = false;
        // Get.snackbar(
        //   'Error',
        //   'Gagal memuat posts: $error',
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      },
    );
  }

  // ================= CREATE POST
  Future<void> createPost({
    required String content,
    File? imageFile,
    List<String> topics = const [],
  }) async {
    try {
      isPosting.value = true;

      final user = _auth.currentUser.value;
      if (user == null) throw 'User not logged in';

      String? base64Image;
      if (imageFile != null) {
        final bytes = await imageFile.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      await _firestore.collection('posts').add({
        'userId': user.uid,
        'username': user.username,
        'userPhoto': user.photoUrl,
        'content': content,
        'imageBase64': base64Image,
        'likes': 0,
        'likedBy': [],
        'commentsCount': 0,
        'topics': topics,
        'createdAt': FieldValue.serverTimestamp(),
        'createdAtClient': DateTime.now().millisecondsSinceEpoch,
      });

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal membuat post: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isPosting.value = false;
    }
  }

  // ================= LIKE / UNLIKE POST
  Future<void> toggleLike(PostModel post) async {
    final user = _auth.currentUser.value;
    if (user == null) {
      Get.snackbar(
        'Error',
        'Anda harus login terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ VALIDASI: User tidak bisa like postingan sendiri
    if (user.uid == post.userId) {
      Get.snackbar(
        'Tidak Diizinkan',
        'Anda tidak bisa like postingan sendiri',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final postRef = _firestore.collection('posts').doc(post.id);
      final isLiked = post.likedBy.contains(user.uid);

      // ✅ Toggle like/unlike
      await postRef.update({
        'likes': FieldValue.increment(isLiked ? -1 : 1),
        'likedBy': isLiked
            ? FieldValue.arrayRemove([user.uid])
            : FieldValue.arrayUnion([user.uid]),
      });

      // ✅ CREATE/DELETE NOTIFICATION
      final notifController = Get.find<NotificationController>();

      if (isLiked) {
        // Unlike: hapus notifikasi
        await notifController.deleteNotification(
          recipientId: post.userId,
          postId: post.id,
          type: NotificationType.like,
        );
      } else {
        // Like: buat notifikasi
        await notifController.createNotification(
          recipientId: post.userId,
          type: NotificationType.like,
          postId: post.id,
        );
      }

    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal melakukan like: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ✅ CEK APAKAH USER SUDAH LIKE POST
  bool isPostLikedByCurrentUser(PostModel post) {
    final user = _auth.currentUser.value;
    if (user == null) return false;
    return post.likedBy.contains(user.uid);
  }

  // ✅ CEK APAKAH POST MILIK USER SENDIRI
  bool isOwnPost(PostModel post) {
    final user = _auth.currentUser.value;
    if (user == null) return false;
    return user.uid == post.userId;
  }

  // ================= DELETE POST (OWNER ONLY)
  Future<void> deletePost(PostModel post) async {
    final user = _auth.currentUser.value;
    if (user == null || user.uid != post.userId) return;

    await _firestore.collection('posts').doc(post.id).delete();
  }

  // ================= REFRESH POSTS
  void refreshPosts() {
    fetchPosts();
  }

  // ================= CLEAR (LOGOUT)
  void clearPosts() {
    _postSub?.cancel();
    posts.clear();
  }

  @override
  void onClose() {
    _postSub?.cancel();
    super.onClose();
  }
}