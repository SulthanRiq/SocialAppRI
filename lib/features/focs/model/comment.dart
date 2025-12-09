// File: lib/features/focs/model/comment.dart

class Comment {
  final String id;
  final String postId;
  final String userName;
  final String userAvatar;
  final String content;
  final String time;
  final DateTime timestamp;
  final int likes;
  final bool isLiked;

  Comment({
    required this.id,
    required this.postId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.time,
    DateTime? timestamp,
    this.likes = 0,
    this.isLiked = false,
  }) : timestamp = timestamp ?? DateTime.now();

  // Copy with method
  Comment copyWith({
    String? id,
    String? postId,
    String? userName,
    String? userAvatar,
    String? content,
    String? time,
    DateTime? timestamp,
    int? likes,
    bool? isLiked,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      time: time ?? this.time,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'time': time,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'isLiked': isLiked,
    };
  }

  // From JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      content: json['content'] as String,
      time: json['time'] as String,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      likes: json['likes'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  // ToString
  @override
  String toString() {
    return 'Comment(id: $id, userName: $userName, content: $content)';
  }

  // Dummy comments for a post
  static List<Comment> dummyComments(String postId) {
    return [
      Comment(
        id: 'c1',
        postId: postId,
        userName: 'John Doe',
        userAvatar: 'https://i.pravatar.cc/150?img=15',
        content: 'Great post! Thanks for sharing 👍',
        time: '5 menit lalu',
        likes: 12,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Comment(
        id: 'c2',
        postId: postId,
        userName: 'Jane Smith',
        userAvatar: 'https://i.pravatar.cc/150?img=20',
        content: 'I totally agree with this. Very insightful!',
        time: '15 menit lalu',
        likes: 8,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      Comment(
        id: 'c3',
        postId: postId,
        userName: 'Mike Johnson',
        userAvatar: 'https://i.pravatar.cc/150?img=33',
        content: 'Can you share more details about this?',
        time: '1 jam lalu',
        likes: 3,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Comment(
        id: 'c4',
        postId: postId,
        userName: 'Sarah Wilson',
        userAvatar: 'https://i.pravatar.cc/150?img=44',
        content: 'This is exactly what I needed to read today!',
        time: '2 jam lalu',
        likes: 15,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
