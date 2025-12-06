// lib/core/repositories/comment_repository.dart
import '../models/comment.dart';

class CommentRepository {
  final Map<String, List<Comment>> _comments = {
    '1': [
      Comment(
        id: 'c1',
        username: '@healthy_life.lj',
        timeAgo: '',
        comment: 'Sangat bermanfaat! Terima kasih tips nya 🙏',
        likes: 24,
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        articleId: '1',
      ),
      Comment(
        id: 'c2',
        username: '@fitness_mania',
        timeAgo: '30m',
        comment: 'Setuju banget! Aku juga pakai join nomor 3. sangat penting untuk kesehatan mental kita 👍',
        likes: 8,
        avatarUrl: 'https://i.pravatar.cc/150?img=2',
        articleId: '1',
      ),
      Comment(
        id: 'c3',
        username: '@nutrisi_pro',
        timeAgo: '28m',
        comment: 'Masalah ya kak Informasi! Aku sudah coba beberapa tips ini dan hasilnya luar biasa. Badan jadi lebih segar dan energi meningkat! 😊',
        likes: 35,
        avatarUrl: 'https://i.pravatar.cc/150?img=3',
        articleId: '1',
      ),
      Comment(
        id: 'c4',
        username: '@diet_sehat_id',
        timeAgo: '8m',
        comment: 'Konten seperti ini yang aku cari! Langsung save buat referensi 💚',
        likes: 16,
        avatarUrl: 'https://i.pravatar.cc/150?img=4',
        articleId: '1',
      ),
    ],
    '2': [
      Comment(
        id: 'c5',
        username: '@berita_bangsa',
        timeAgo: '2j',
        comment: 'Rakyat susah, mereka malah korupsi! Kapan Indonesia bersih koruptor? 😡',
        likes: 14,
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        articleId: '2',
      ),
      Comment(
        id: 'c6',
        username: '@suara_hati_rakyat',
        timeAgo: '2j',
        comment: 'Pemerintah harus!!! itu sangat rakyat untuk keadilan dan pendidikan! Miris banget 😭',
        likes: 24,
        avatarUrl: 'https://i.pravatar.cc/150?img=6',
        articleId: '2',
      ),
      Comment(
        id: 'c7',
        username: '@anti_korupsi_id',
        timeAgo: '37m',
        comment: 'Hukuman seumur-hidup!!! Jangan ada toleransi untuk koruptor!',
        likes: 35,
        avatarUrl: 'https://i.pravatar.cc/150?img=7',
        articleId: '2',
      ),
      Comment(
        id: 'c8',
        username: '@warga_peduli',
        timeAgo: '5m',
        comment: 'Masih ada aja oknum yang korupsi. Kapan negara ini maju kalau begini terus 😞',
        likes: 16,
        avatarUrl: 'https://i.pravatar.cc/150?img=8',
        articleId: '2',
      ),
    ],
  };

  Future<List<Comment>> getCommentsByArticleId(String articleId) async {
    await Future.delayed(Duration(milliseconds: 600));
    return _comments[articleId] ?? [];
  }

  Future<bool> addComment(String articleId, String username, String commentText) async {
    await Future.delayed(Duration(milliseconds: 500));

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      timeAgo: 'Baru saja',
      comment: commentText,
      likes: 0,
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      articleId: articleId,
    );

    if (_comments[articleId] == null) {
      _comments[articleId] = [];
    }
    _comments[articleId]!.insert(0, newComment);
    return true;
  }

  Future<bool> likeComment(String commentId) async {
    await Future.delayed(Duration(milliseconds: 300));

    for (var articleComments in _comments.values) {
      final index = articleComments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        final comment = articleComments[index];
        articleComments[index] = comment.copyWith(likes: comment.likes + 1);
        return true;
      }
    }
    return false;
  }
}