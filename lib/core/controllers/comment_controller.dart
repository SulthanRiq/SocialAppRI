// lib/core/controllers/comment_controller.dart
import 'package:get/get.dart';
import '../models/comment.dart';
import '../repositories/comment_repository.dart';

class CommentController extends GetxController {
  final CommentRepository _repository = CommentRepository();

  var comments = <Comment>[].obs;
  var isLoading = false.obs;
  var isSending = false.obs;
  var currentArticleId = ''.obs;

  Future<void> loadComments(String articleId) async {
    try {
      isLoading.value = true;
      currentArticleId.value = articleId;
      comments.value = await _repository.getCommentsByArticleId(articleId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat komentar',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(String articleId, String commentText) async {
    if (commentText.trim().isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Komentar tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    try {
      isSending.value = true;

      final username = '@current_user';
      final success = await _repository.addComment(articleId, username, commentText);

      if (success) {
        await loadComments(articleId);

        Get.snackbar(
          'Berhasil',
          'Komentar berhasil ditambahkan!',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan komentar',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }

  Future<void> likeComment(String commentId) async {
    try {
      final success = await _repository.likeComment(commentId);
      if (success) {
        final index = comments.indexWhere((c) => c.id == commentId);
        if (index != -1) {
          comments[index] = comments[index].copyWith(
            likes: comments[index].likes + 1,
          );
          comments.refresh();
        }
      }
    } catch (e) {
      print('Error liking comment: $e');
    }
  }

  void clearComments() {
    comments.clear();
    currentArticleId.value = '';
  }
}