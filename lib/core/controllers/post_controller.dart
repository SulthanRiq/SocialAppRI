import 'package:get/get.dart';

class PostController extends GetxController {
  // Map untuk menyimpan jumlah like setiap post berdasarkan ID
  final RxMap<String, int> postLikes = <String, int>{}.obs;

  // Map untuk menyimpan status apakah user sudah like post ini
  final RxMap<String, bool> userLikedPosts = <String, bool>{}.obs;

  // Fungsi untuk set initial likes dari string (misal: "20.5k" -> 20500)
  void setInitialLikes(String postId, String likesString) {
    if (!postLikes.containsKey(postId)) {
      postLikes[postId] = _parseLikesString(likesString);
      userLikedPosts[postId] = false;
    }
  }

  // Fungsi untuk toggle like
  void toggleLike(String postId) {
    if (!postLikes.containsKey(postId)) {
      postLikes[postId] = 0;
      userLikedPosts[postId] = false;
    }

    if (userLikedPosts[postId] == true) {
      // Unlike
      postLikes[postId] = postLikes[postId]! - 1;
      userLikedPosts[postId] = false;
    } else {
      // Like
      postLikes[postId] = postLikes[postId]! + 1;
      userLikedPosts[postId] = true;
    }
  }

  // Fungsi untuk get formatted likes (misal: 20500 -> "20.5k")
  String getFormattedLikes(String postId) {
    if (!postLikes.containsKey(postId)) return '0';

    int likes = postLikes[postId]!;
    if (likes >= 1000000) {
      return '${(likes / 1000000).toStringAsFixed(1)}M';
    } else if (likes >= 1000) {
      return '${(likes / 1000).toStringAsFixed(1)}k';
    } else {
      return likes.toString();
    }
  }

  // Fungsi untuk check apakah user sudah like post ini
  bool isLiked(String postId) {
    return userLikedPosts[postId] ?? false;
  }

  // Helper: Parse string like "20.5k" atau "150.2k" ke integer
  int _parseLikesString(String likesStr) {
    String cleaned = likesStr.toLowerCase().replaceAll(',', '.');

    if (cleaned.contains('m')) {
      double value = double.tryParse(cleaned.replaceAll('m', '')) ?? 0;
      return (value * 1000000).toInt();
    } else if (cleaned.contains('k')) {
      double value = double.tryParse(cleaned.replaceAll('k', '')) ?? 0;
      return (value * 1000).toInt();
    } else {
      return int.tryParse(cleaned) ?? 0;
    }
  }
}