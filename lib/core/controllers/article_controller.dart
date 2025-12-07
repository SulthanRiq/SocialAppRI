// lib/core/controllers/article_controller.dart
import 'package:get/get.dart';
import '../models/article.dart';
import '../repositories/article_repository.dart';

class ArticleController extends GetxController {
  final ArticleRepository _repository = ArticleRepository();

  var articles = <Article>[].obs;
  var isLoading = false.obs;
  var selectedArticle = Rx<Article?>(null);

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  Future<void> loadArticles() async {
    try {
      isLoading.value = true;
      articles.value = await _repository.getArticles();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat artikel: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getArticleById(String id) async {
    try {
      isLoading.value = true;
      selectedArticle.value = await _repository.getArticleById(id);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat detail artikel',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> likeArticle(String articleId) async {
    try {
      final success = await _repository.likeArticle(articleId);
      if (success) {
        final index = articles.indexWhere((a) => a.id == articleId);
        if (index != -1) {
          articles[index] = articles[index].copyWith(
            likes: articles[index].likes + 1,
          );
          articles.refresh();
        }
      }
    } catch (e) {
      print('Error liking article: $e');
    }
  }

  Future<void> shareArticle(String articleId) async {
    try {
      final success = await _repository.shareArticle(articleId);
      if (success) {
        final index = articles.indexWhere((a) => a.id == articleId);
        if (index != -1) {
          articles[index] = articles[index].copyWith(
            shares: articles[index].shares + 1,
          );
          articles.refresh();
        }
      }
    } catch (e) {
      print('Error sharing article: $e');
    }
  }

  Future<void> refreshArticles() async {
    await loadArticles();
  }
}