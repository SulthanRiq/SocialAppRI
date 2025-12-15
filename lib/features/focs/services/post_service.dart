// ============================================
// FILE: services/post_service.dart
// ============================================
import 'dart:math';

class PostService {
  // Singleton pattern
  static final PostService _instance = PostService._internal();
  factory PostService() => _instance;
  PostService._internal();

  // Temporary storage (akan diganti dengan database/API)
  final Map<String, Post> _posts = {};

  // Initialize dengan data dummy
  void initializeDummyData() {
    _posts['post1'] = Post(
      id: 'post1',
      userName: 'Martina',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'Morning Yall, Have a Nice DAYYY !!!',
      time: '1 jam',
      likeCount: 1200,
      commentCount: 2,
      shareCount: 1,
      comments: [
        Comment(
          id: 'c1',
          userName: 'John Doe',
          userAvatar: 'https://i.pravatar.cc/150?img=1',
          content: 'Have a great day too!',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ],
    );

    _posts['post2'] = Post(
      id: 'post2',
      userName: 'Martina',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'Damnit i wanna explode rn...',
      time: '1 jam',
      imageUrl: 'https://picsum.photos/400/300',
      likeCount: 856,
      commentCount: 5,
      shareCount: 3,
    );
  }

  Post? getPost(String postId) {
    return _posts[postId];
  }

  void toggleLike(String postId) {
    _posts[postId]?.toggleLike();
  }

  void addComment(String postId, Comment comment) {
    _posts[postId]?.addComment(comment);
  }

  void incrementShare(String postId) {
    _posts[postId]?.incrementShare();
  }

  // Generate comment ID
  String generateCommentId() {
    return 'comment_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }
}