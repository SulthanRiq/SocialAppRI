import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../core/models/post_model.dart';

class FocsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State
  RxList<PostModel> allPosts = <PostModel>[].obs;
  RxList<PostModel> filteredPosts = <PostModel>[].obs;
  RxSet<String> selectedTopics = <String>{}.obs;
  RxString searchQuery = ''.obs;
  RxString selectedTab = 'Focs Mode'.obs;
  RxBool isLoading = false.obs;
  Rx<String?> errorMessage = Rx<String?>(null);

  // Focus Mode State
  RxBool isFocusSessionActive = false.obs;
  RxInt focusTimeRemaining = 0.obs; // in seconds
  Timer? _focusTimer;

  StreamSubscription? _postsSub;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  // ================= FETCH POSTS
  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      _postsSub = _firestore
          .collection('posts')
          .orderBy('createdAtClient', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
          List<PostModel> posts = [];
          for (var doc in snapshot.docs) {
            posts.add(PostModel.fromFirestore(doc));
          }
          allPosts.value = posts;
          _applyFilters();
          isLoading.value = false;
        },
        onError: (error) {
          errorMessage.value = 'Error loading posts: $error';
          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to fetch posts';
      isLoading.value = false;
    }
  }

  // ================= APPLY FILTERS
  void _applyFilters() {
    List<PostModel> filtered = allPosts;

    // Filter by topics
    if (selectedTopics.isNotEmpty) {
      filtered = filtered.where((post) {
        return post.topics.any((topic) => selectedTopics.contains(topic));
      }).toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((post) {
        return post.content.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            post.username.toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    filteredPosts.value = filtered;
  }

  // ================= SEARCH
  void searchPosts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void clearSearch() {
    searchQuery.value = '';
    _applyFilters();
  }

  // ================= TOPICS
  void setSelectedTopics(Set<String> topics) {
    selectedTopics.value = topics;
    _applyFilters();
  }

  bool get hasSelectedTopics => selectedTopics.isNotEmpty;
  int get selectedTopicsCount => selectedTopics.length;

  // ================= TAB
  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  bool isTabSelected(String tab) => selectedTab.value == tab;

  // ================= GET CURRENT POSTS
  List<PostModel> getCurrentPosts() {
    if (selectedTab.value == 'Focs Mode') {
      return filteredPosts;
    } else {
      // Reference mode: bisa tampilkan saved posts atau bookmarked posts
      return filteredPosts.where((post) => post.topics.isNotEmpty).toList();
    }
  }

  // ================= FOCUS SESSION
  void startFocusSession({int minutes = 25}) {
    isFocusSessionActive.value = true;
    focusTimeRemaining.value = minutes * 60;

    _focusTimer?.cancel();
    _focusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (focusTimeRemaining.value > 0) {
        focusTimeRemaining.value--;
      } else {
        endFocusSession();
      }
    });

    Get.snackbar(
      'Focus Mode',
      'Focus session dimulai: $minutes menit',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void endFocusSession() {
    _focusTimer?.cancel();
    isFocusSessionActive.value = false;
    focusTimeRemaining.value = 0;

    Get.snackbar(
      'Focus Mode',
      'Focus session selesai!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String get focusTimeFormatted {
    int minutes = focusTimeRemaining.value ~/ 60;
    int seconds = focusTimeRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // ================= ACTIONS
  Future<void> refreshPosts() async {
    await fetchPosts();
  }

  void likePost(String postId) {
    // Implement like logic
  }

  void sharePost(String postId) {
    // Implement share logic
  }

  @override
  void onClose() {
    _postsSub?.cancel();
    _focusTimer?.cancel();
    super.onClose();
  }
}