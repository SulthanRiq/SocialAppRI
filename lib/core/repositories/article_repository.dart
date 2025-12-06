// lib/core/repositories/article_repository.dart
import '../models/article.dart';

class ArticleRepository {
  final List<Article> _articles = [
    Article(
      id: '1',
      username: '@lifestyle_daily',
      time: '',
      content: 'Tips hidup sehat...',
      imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80',
      likes: 20500,
      comments: 2000,
      shares: 12,
      isNews: false,
    ),
    Article(
      id: '2',
      username: '@Breaking_News',
      time: '15m',
      content: 'Trending Now\n\n"POLITISI X KORUPSI TRILIUNAN RUPIAH !\nBukti Mengejutkan ! "',
      source: 'detik.com',
      trustScore: 'Trust: 7.5/10',
      likes: 150200,
      comments: 21400,
      shares: 8900,
      isNews: true,
      emotionalTrigger: 85.0,
      viralPotential: 'High (8,900 shares/15menit)',
      unverifiedClaims: [
        '"Triliunan" - no source',
        '"Bukti" - not shown',
      ],
    ),
  ];

  Future<List<Article>> getArticles() async {
    await Future.delayed(Duration(milliseconds: 800));
    return _articles;
  }

  Future<Article?> getArticleById(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      return _articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> likeArticle(String articleId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _articles.indexWhere((a) => a.id == articleId);
    if (index != -1) {
      final article = _articles[index];
      _articles[index] = article.copyWith(likes: article.likes + 1);
      return true;
    }
    return false;
  }

  Future<bool> shareArticle(String articleId) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _articles.indexWhere((a) => a.id == articleId);
    if (index != -1) {
      final article = _articles[index];
      _articles[index] = article.copyWith(shares: article.shares + 1);
      return true;
    }
    return false;
  }

  Future<bool> incrementCommentCount(String articleId) async {
    await Future.delayed(Duration(milliseconds: 200));
    final index = _articles.indexWhere((a) => a.id == articleId);
    if (index != -1) {
      final article = _articles[index];
      _articles[index] = article.copyWith(comments: article.comments + 1);
      return true;
    }
    return false;
  }
}