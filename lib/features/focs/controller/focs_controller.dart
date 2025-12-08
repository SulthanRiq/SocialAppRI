// File: lib/features/focs/controller/focs_controller.dart

import 'package:flutter/material.dart';
import 'package:projek_mobile/features/focs/model/post.dart';
import 'package:projek_mobile/features/focs/model/topic.dart';

class FocsController extends ChangeNotifier {
  // State variables
  bool _isFocsMode = true;
  String _selectedTab = 'Focs Mode';
  Set<String> _selectedTopics = {};
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isFocsMode => _isFocsMode;
  String get selectedTab => _selectedTab;
  Set<String> get selectedTopics => _selectedTopics;
  List<Post> get posts => _posts;
  List<Post> get filteredPosts => _filteredPosts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasSelectedTopics => _selectedTopics.isNotEmpty;
  int get selectedTopicsCount => _selectedTopics.length;

  // Constructor - load initial data
  FocsController() {
    loadPosts();
  }

  // ==================== FOCUS MODE ====================

  /// Toggle focus mode on/off
  void setFocsMode(bool value) {
    _isFocsMode = value;
    notifyListeners();
  }

  /// Dismiss focus mode dialog
  void dismissFocsMode() {
    _isFocsMode = false;
    notifyListeners();
  }

  // ==================== TAB MANAGEMENT ====================

  /// Switch between 'Focs Mode' and 'Reference' tabs
  void selectTab(String tab) {
    if (tab != _selectedTab) {
      _selectedTab = tab;
      _applyFilters();
      notifyListeners();
    }
  }

  bool isTabSelected(String tab) => _selectedTab == tab;

  // ==================== TOPIC FILTER ====================

  /// Toggle topic selection
  void toggleTopic(String topic) {
    if (_selectedTopics.contains(topic)) {
      _selectedTopics.remove(topic);
    } else {
      _selectedTopics.add(topic);
    }
    _applyFilters();
    notifyListeners();
  }

  /// Set multiple topics at once (from bottom sheet)
  void setSelectedTopics(Set<String> topics) {
    _selectedTopics = topics;
    _applyFilters();
    notifyListeners();
  }

  /// Clear all topic filters
  void clearTopicFilters() {
    _selectedTopics.clear();
    _applyFilters();
    notifyListeners();
  }

  /// Check if topic is selected
  bool isTopicSelected(String topic) => _selectedTopics.contains(topic);

  // ==================== POST MANAGEMENT ====================

  /// Load posts (simulate API call)
  Future<void> loadPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Load dummy data
      _posts = Post.dummyPosts();
      _applyFilters();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load posts: ${e.toString()}';
      notifyListeners();
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
    if (_selectedTab == 'Reference') {
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

    _filteredPosts = tempPosts;
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
      notifyListeners();
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
      notifyListeners();
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
      notifyListeners();
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
      notifyListeners();
    }
  }

  // ==================== SEARCH ====================

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  /// Search posts by content or username
  void searchPosts(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      _applyFilters();
    } else {
      final filtered = _posts.where((post) {
        return post.content.toLowerCase().contains(query.toLowerCase()) ||
            post.userName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      _filteredPosts = filtered;
    }

    notifyListeners();
  }

  /// Clear search
  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }

  // ==================== UTILITY ====================

  /// Reset all filters and state
  void resetAll() {
    _selectedTopics.clear();
    _searchQuery = '';
    _selectedTab = 'Focs Mode';
    _isFocsMode = false;
    _applyFilters();
    notifyListeners();
  }

  /// Dispose controller
  @override
  void dispose() {
    // Clean up resources if needed
    super.dispose();
  }
}
