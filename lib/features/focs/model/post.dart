// File: lib/features/focs/model/post.dart

class Post {
  final String id;
  final String userName;
  final String userAvatar;
  final String time;
  final String content;
  final String? category;
  final int likes;
  final int comments;
  final int shares;
  final String? imageUrl;
  final bool isLiked;
  final bool isBookmarked;

  Post({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.time,
    required this.content,
    this.category,
    required this.likes,
    required this.comments,
    required this.shares,
    this.imageUrl,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  // Copy with method - untuk update state
  Post copyWith({
    String? id,
    String? userName,
    String? userAvatar,
    String? time,
    String? content,
    String? category,
    int? likes,
    int? comments,
    int? shares,
    String? imageUrl,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return Post(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      time: time ?? this.time,
      content: content ?? this.content,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      imageUrl: imageUrl ?? this.imageUrl,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  // To JSON - untuk simpan ke database/API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userAvatar': userAvatar,
      'time': time,
      'content': content,
      'category': category,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'imageUrl': imageUrl,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }

  // From JSON - untuk parse dari database/API
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      time: json['time'] as String,
      content: json['content'] as String,
      category: json['category'] as String?,
      likes: json['likes'] as int,
      comments: json['comments'] as int,
      shares: json['shares'] as int,
      imageUrl: json['imageUrl'] as String?,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  // ToString - untuk debugging
  @override
  String toString() {
    return 'Post(id: $id, userName: $userName, content: $content)';
  }

  // Dummy data untuk testing
  static List<Post> dummyPosts() {
    return [
      Post(
        id: '1',
        userName: 'Martina',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        time: '1 jam',
        content: 'Morning Yall, Have a Nice DAYYY !!!',
        likes: 1200,
        comments: 2,
        shares: 1,
      ),
      Post(
        id: '2',
        userName: 'Martina',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        time: '1 jam',
        content: 'Damnit i wanna explode rn...',
        likes: 856,
        comments: 5,
        shares: 3,
        imageUrl: 'https://picsum.photos/400/300',
      ),
      Post(
        id: '3',
        userName: 'Emma Watson',
        userAvatar: 'https://i.pravatar.cc/150?img=10',
        time: '3 jam',
        content:
            'Wanna cheat tip?  Use the Pomodoro technique with 25-minute focused sessions. Your brain needs breaks to stay sharp !!',
        category: 'Health',
        likes: 2500,
        comments: 8,
        shares: 12,
      ),
      Post(
        id: '4',
        userName: 'Zack',
        userAvatar: 'https://i.pravatar.cc/150?img=12',
        time: '8 jam',
        content: 'Again again n again, undisputed.... #gym',
        category: 'Sports',
        likes: 2200,
        comments: 4,
        shares: 31,
        imageUrl:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400',
      ),
    ];
  }
}
