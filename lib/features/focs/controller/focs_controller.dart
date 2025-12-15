// ============================================
// FILE: lib/features/focs/controller/focs_controller.dart
// GANTI YANG LAMA DENGAN INI (GetX Version)
// ============================================

import 'package:get/get.dart';
import 'package:projek_mobile/features/focs/model/post_model.dart';

class FocsController extends GetxController {
  // State variables - Reactive
  final _isFocsMode = true.obs;
  final _selectedTab = 'Focs Mode'.obs;
  final _selectedTopics = <String>{}.obs;
  final _posts = <Post>[].obs;
  final _filteredPosts = <Post>[].obs;
  final _isLoading = false.obs;
  final _errorMessage = Rxn<String>();
  final _searchQuery = ''.obs;

  // Getters
  bool get isFocsMode => _isFocsMode.value;
  String get selectedTab => _selectedTab.value;
  Set<String> get selectedTopics => _selectedTopics.value;
  List<Post> get posts => _posts;
  List<Post> get filteredPosts => _filteredPosts;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;
  bool get hasSelectedTopics => _selectedTopics.isNotEmpty;
  int get selectedTopicsCount => _selectedTopics.length;

  // Constructor - load initial data
  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  // ==================== FOCUS MODE ====================

  /// Toggle focus mode on/off
  void setFocsMode(bool value) {
    _isFocsMode.value = value;
  }

  /// Dismiss focus mode dialog
  void dismissFocsMode() {
    _isFocsMode.value = false;
  }

  // ==================== TAB MANAGEMENT ====================

  /// Switch between 'Focs Mode' and 'Reference' tabs
  void selectTab(String tab) {
    if (tab != _selectedTab.value) {
      _selectedTab.value = tab;
      _applyFilters();
    }
  }

  bool isTabSelected(String tab) => _selectedTab.value == tab;

  // ==================== TOPIC FILTER ====================

  /// Toggle topic selection
  void toggleTopic(String topic) {
    if (_selectedTopics.contains(topic)) {
      _selectedTopics.remove(topic);
    } else {
      _selectedTopics.add(topic);
    }
    _applyFilters();
  }

  /// Set multiple topics at once (from bottom sheet)
  void setSelectedTopics(Set<String> topics) {
    _selectedTopics.value = topics;
    _applyFilters();
  }

  /// Clear all topic filters
  void clearTopicFilters() {
    _selectedTopics.clear();
    _applyFilters();
  }

  /// Check if topic is selected
  bool isTopicSelected(String topic) => _selectedTopics.contains(topic);

  // ==================== POST MANAGEMENT ====================

  /// Load posts (simulate API call)
  Future<void> loadPosts() async {
    _isLoading.value = true;
    _errorMessage.value = null;

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Load dummy data
      _posts.value = Post.dummyPosts();
      _applyFilters();

      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = 'Failed to load posts: ${e.toString()}';
    }
  }

  /// Refresh posts (pull to refresh)
  Future<void> refreshPosts() async {
    await loadPosts();
  }

  /// Apply filters based on selected tab and topics
  void _applyFilters() {
    List<Post> tempPosts = List.from(_posts);

    // Filter by tab
    if (_selectedTab.value == 'Reference') {
      // Only show posts with categories in Reference tab
      tempPosts = tempPosts.where((post) => post.category != null).toList();
    }

    // Filter by selected topics
    if (_selectedTopics.isNotEmpty) {
      tempPosts = tempPosts.where((post) {
        if (post.category == null) return false;
        return _selectedTopics.contains(post.category);
      }).toList();
    }

    _filteredPosts.value = tempPosts;
  }

  /// Get posts for current view
  List<Post> getCurrentPosts() {
    return _filteredPosts;
  }

  // ==================== POST INTERACTIONS ====================

  /// Like a post
  void likePost(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isLiked: !post.isLiked,
        likes: post.isLiked ? post.likes - 1 : post.likes + 1,
      );
      _applyFilters();
    }
  }

  /// Bookmark a post
  void bookmarkPost(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        isBookmarked: !post.isBookmarked,
      );
      _applyFilters();
    }
  }

  /// Comment on a post (increment comment count)
  void commentOnPost(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        comments: post.comments + 1,
      );
      _applyFilters();
    }
  }

  /// Share a post (increment share count)
  void sharePost(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = post.copyWith(
        shares: post.shares + 1,
      );
      _applyFilters();
    }
  }

  // ==================== SEARCH ====================

  /// Search posts by content or username
  void searchPosts(String query) {
    _searchQuery.value = query;

    if (query.isEmpty) {
      _applyFilters();
    } else {
      final filtered = _posts.where((post) {
        return post.content.toLowerCase().contains(query.toLowerCase()) ||
            post.userName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _filteredPosts.value = filtered;
    }
  }

  /// Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _applyFilters();
  }

  // ==================== UTILITY ====================

  /// Reset all filters and state
  void resetAll() {
    _selectedTopics.clear();
    _searchQuery.value = '';
    _selectedTab.value = 'Focs Mode';
    _isFocsMode.value = false;
    _applyFilters();
  }
}