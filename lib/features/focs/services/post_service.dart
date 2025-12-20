import 'dart:math';
import '../model/post_model.dart';
import '../model/comment.dart';

class PostService {
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();

  final Map<String, Post> _posts = {};

  // ✅ List komentar disimpan di sini (bukan di Post model)
  final Map<String, List<Comment>> _commentsByPostId = {};

  bool _initialized = false;

  void initializeDummyData() {
    if (_initialized) return;
    _initialized = true;

    _posts['post1'] = Post(
      id: 'post1',
      userName: 'Martina',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'Morning Yall, Have a Nice DAYYY !!!',
      time: '1 jam',
      likes: 1200,
      comments: 1, // ✅ jumlah komentar (int) tetap di model kamu
      shares: 1,
    );

    _commentsByPostId['post1'] = [
      Comment(
        id: 'c1',
        userName: 'John Doe',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        content: 'Have a great day too!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];

    _posts['post2'] = Post(
      id: 'post2',
      userName: 'Martina',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'Damnit i wanna explode rn...',
      time: '1 jam',
      imageUrl: 'https://picsum.photos/400/300',
      likes: 856,
      comments: 0,
      shares: 3,
    );

    _commentsByPostId['post2'] = [];
  }

  Post? getPost(String postId) => _posts[postId];

  // ✅ ambil list komentar untuk view
  List<Comment> getComments(String postId) {
    return List.unmodifiable(_commentsByPostId[postId] ?? []);
  }

  // ✅ jumlah komentar (int) di Post model akan di-update
  int getCommentCount(String postId) {
    return _commentsByPostId[postId]?.length ?? 0;
  }

  void addComment(String postId, Comment comment) {
    final list = _commentsByPostId.putIfAbsent(postId, () => []);
    list.add(comment);

    // update jumlah komentar di Post model (int)
    final post = _posts[postId];
    if (post != null) {
      _posts[postId] = post.copyWith(comments: list.length);
    }
  }

  void toggleLike(String postId) {
    final post = _posts[postId];
    if (post == null) return;

    final newIsLiked = !post.isLiked;
    final newLikes = (post.likes + (newIsLiked ? 1 : -1));
    final safeLikes = newLikes < 0 ? 0 : newLikes;

    _posts[postId] = post.copyWith(
      likes: safeLikes,
      isLiked: newIsLiked,
    );
  }

  void incrementShare(String postId) {
    final post = _posts[postId];
    if (post == null) return;

    _posts[postId] = post.copyWith(
      shares: post.shares + 1,
    );
  }

  String generateCommentId() {
    return 'comment_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }
}
