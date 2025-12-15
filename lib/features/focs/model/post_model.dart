// ============================================
// FILE: lib/features/focs/model/post_model.dart
// ============================================

class Post {
  final String id;
  final String userName;
  final String userAvatar;
  final String content;
  final String time;
  final String? imageUrl;
  final String? category;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final bool isBookmarked;

  Post({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.time,
    this.imageUrl,
    this.category,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  // Format angka (1200 -> 1.2k)
  String get formattedLikes => _formatNumber(likes);
  String get formattedComments => _formatNumber(comments);
  String get formattedShares => _formatNumber(shares);

  String _formatNumber(int num) {
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}k';
    }
    return num.toString();
  }

  // Copy with
  Post copyWith({
    String? id,
    String? userName,
    String? userAvatar,
    String? content,
    String? time,
    String? imageUrl,
    String? category,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return Post(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      time: time ?? this.time,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'time': time,
      'imageUrl': imageUrl,
      'category': category,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }

  // From JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      userName: json['userName'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      content: json['content'] ?? '',
      time: json['time'] ?? '',
      imageUrl: json['imageUrl'],
      category: json['category'],
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      shares: json['shares'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }

  // Dummy Posts
  static List<Post> dummyPosts() {
    return [
      Post(
        id: 'post1',
        userName: 'Martina',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        content: 'Morning Yall, Have a Nice DAYYY !!!',
        time: '1 jam',
        likes: 1200,
        comments: 2,
        shares: 1,
      ),
      Post(
        id: 'post2',
        userName: 'Martina',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        content: 'Damnit i wanna explode rn...',
        time: '1 jam',
        imageUrl: 'https://picsum.photos/400/300',
        likes: 856,
        comments: 5,
        shares: 3,
      ),
      Post(
        id: 'post3',
        userName: 'Alex Johnson',
        userAvatar: 'https://i.pravatar.cc/150?img=8',
        content: 'Just finished my morning workout! Feeling great 💪',
        time: '2 jam',
        likes: 432,
        comments: 12,
        shares: 5,
      ),
      Post(
        id: 'post4',
        userName: 'Emma Watson',
        userAvatar: 'https://i.pravatar.cc/150?img=10',
        content: 'Wanna cheat tip? Use the Pomodoro technique with 25-minute focused sessions. Your brain needs breaks to stay sharp !!',
        time: '3 jam',
        category: 'Health',
        likes: 2500,
        comments: 8,
        shares: 12,
      ),
      Post(
        id: 'post5',
        userName: 'Zack',
        userAvatar: 'https://i.pravatar.cc/150?img=12',
        content: 'Again again n again, undisputed.... #gym',
        time: '8 jam',
        imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400',
        category: 'Sports',
        likes: 2200,
        comments: 4,
        shares: 31,
      ),
      Post(
        id: 'post6',
        userName: 'Sarah',
        userAvatar: 'https://i.pravatar.cc/150?img=25',
        content: 'Healty fit checkk :)), get breadfast w me',
        time: '5 jam',
        imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400',
        category: 'Food',
        likes: 17500,
        comments: 10,
        shares: 31,
      ),
      Post(
        id: 'post7',
        userName: 'David Lee',
        userAvatar: 'https://i.pravatar.cc/150?img=15',
        content: 'New tech gadgets review! Check out my latest video on YouTube 📱',
        time: '4 jam',
        category: 'Technology',
        likes: 5600,
        comments: 45,
        shares: 23,
      ),
      Post(
        id: 'post8',
        userName: 'Jessica Brown',
        userAvatar: 'https://i.pravatar.cc/150?img=20',
        content: 'Travel tips for Southeast Asia! 🌏 Best places to visit on a budget',
        time: '6 jam',
        imageUrl: 'https://images.unsplash.com/photo-1552733407-5d5c46c3bb3b?w=400',
        category: 'Travel',
        likes: 8900,
        comments: 67,
        shares: 89,
      ),
    ];
  }
}