import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../core/models/post_model.dart';

class SearchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<PostModel> searchResults = <PostModel>[].obs;
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;

  StreamSubscription? _searchSub;

  // ================= SEARCH POSTS
  void searchPosts(String query) {
    if (query.trim().isEmpty) {
      searchResults.clear();
      searchQuery.value = '';
      _searchSub?.cancel();
      return;
    }

    searchQuery.value = query.trim().toLowerCase();
    isSearching.value = true;

    // Cancel previous subscription
    _searchSub?.cancel();

    // Search posts yang mengandung query di content atau username
    _searchSub = _firestore
        .collection('posts')
        .orderBy('createdAtClient', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
        List<PostModel> results = [];

        for (var doc in snapshot.docs) {
          final post = PostModel.fromFirestore(doc);

          // Filter berdasarkan content atau username
          if (post.content.toLowerCase().contains(searchQuery.value) ||
              post.username.toLowerCase().contains(searchQuery.value)) {
            results.add(post);
          }
        }

        searchResults.value = results;
        isSearching.value = false;
      },
      onError: (error) {
        print('❌ Search error: $error');
        isSearching.value = false;
      },
    );
  }

  // ================= CLEAR SEARCH
  void clearSearch() {
    searchResults.clear();
    searchQuery.value = '';
    _searchSub?.cancel();
  }

  @override
  void onClose() {
    _searchSub?.cancel();
    super.onClose();
  }
}