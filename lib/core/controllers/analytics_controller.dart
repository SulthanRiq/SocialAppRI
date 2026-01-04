import 'package:firebase_analytics/observer.dart';
import 'package:get/get.dart';
import '../services/analytics_service.dart';
import '../models/user_model.dart';

/// Controller untuk mengelola Analytics di seluruh aplikasi
class AnalyticsController extends GetxController {
  final AnalyticsService _analyticsService = AnalyticsService();

  // Status analytics
  final RxBool isAnalyticsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initAnalytics();
  }

  /// Initialize analytics saat app start
  Future<void> _initAnalytics() async {
    try {
      await _analyticsService.logAppOpen();
      print('✅ Analytics initialized');
    } catch (e) {
      print('❌ Failed to initialize analytics: $e');
    }
  }

  // ==================== USER ANALYTICS ====================

  /// Track user signup
  Future<void> trackSignUp({required String method}) async {
    await _analyticsService.logSignUp(method: method);
  }

  /// Track user login
  Future<void> trackLogin({required String method}) async {
    await _analyticsService.logLogin(method: method);
  }

  /// Track user logout
  Future<void> trackLogout() async {
    await _analyticsService.logLogout();
  }

  /// Set current user untuk analytics
  Future<void> setCurrentUser(UserModel user) async {
    await _analyticsService.setUserId(user.uid);
    await _analyticsService.setUserProperties(
      username: user.username,
      email: user.email,
    );
  }

  // ==================== SCREEN ANALYTICS ====================

  /// Track screen view
  Future<void> trackScreen(String screenName) async {
    await _analyticsService.logScreenView(screenName: screenName);
  }

  // ==================== POST ANALYTICS ====================

  /// Track post creation
  Future<void> trackCreatePost({
    required String postId,
    required String contentType,
  }) async {
    await _analyticsService.logCreatePost(
      postId: postId,
      contentType: contentType,
    );
  }

  /// Track post like
  Future<void> trackLikePost({
    required String postId,
    required String postOwnerId,
  }) async {
    await _analyticsService.logLikePost(
      postId: postId,
      postOwnerId: postOwnerId,
    );
  }

  /// Track post unlike
  Future<void> trackUnlikePost({required String postId}) async {
    await _analyticsService.logUnlikePost(postId: postId);
  }

  /// Track post comment
  Future<void> trackCommentPost({
    required String postId,
    required int commentLength,
  }) async {
    await _analyticsService.logCommentPost(
      postId: postId,
      commentLength: commentLength.toString(),
    );
  }

  /// Track post share
  Future<void> trackSharePost({
    required String postId,
    required String method,
  }) async {
    await _analyticsService.logSharePost(
      postId: postId,
      method: method,
    );
  }

  /// Track post view
  Future<void> trackViewPost({required String postId}) async {
    await _analyticsService.logViewPost(postId: postId);
  }

  // ==================== CHAT ANALYTICS ====================

  /// Track message send
  Future<void> trackSendMessage({
    required String chatRoomId,
    required String messageType,
    required String receiverId,
  }) async {
    await _analyticsService.logSendMessage(
      chatRoomId: chatRoomId,
      messageType: messageType,
      receiverId: receiverId,
    );
  }

  /// Track start chat
  Future<void> trackStartChat({required String receiverId}) async {
    await _analyticsService.logStartChat(receiverId: receiverId);
  }

  // ==================== SEARCH ANALYTICS ====================

  /// Track search
  Future<void> trackSearch({
    required String searchTerm,
    required String searchType,
  }) async {
    await _analyticsService.logSearch(
      searchTerm: searchTerm,
      searchType: searchType,
    );
  }

  // ==================== PROFILE ANALYTICS ====================

  /// Track profile view
  Future<void> trackViewProfile({
    required String profileUserId,
    required bool isOwnProfile,
  }) async {
    await _analyticsService.logViewProfile(
      profileUserId: profileUserId,
      isOwnProfile: isOwnProfile,
    );
  }

  /// Track profile edit
  Future<void> trackEditProfile() async {
    await _analyticsService.logEditProfile();
  }

  /// Track profile picture update
  Future<void> trackUpdateProfilePicture() async {
    await _analyticsService.logUpdateProfilePicture();
  }

  // ==================== NOTIFICATION ANALYTICS ====================

  /// Track notification received
  Future<void> trackReceiveNotification({
    required String notificationType,
  }) async {
    await _analyticsService.logReceiveNotification(
      notificationType: notificationType,
    );
  }

  /// Track notification tapped
  Future<void> trackTapNotification({
    required String notificationType,
  }) async {
    await _analyticsService.logTapNotification(
      notificationType: notificationType,
    );
  }

  // ==================== ERROR ANALYTICS ====================

  /// Track error
  Future<void> trackError({
    required String errorMessage,
    required String errorLocation,
    String? stackTrace,
  }) async {
    await _analyticsService.logError(
      errorMessage: errorMessage,
      errorLocation: errorLocation,
      stackTrace: stackTrace,
    );
  }

  // ==================== SETTINGS ====================

  /// Toggle analytics
  Future<void> toggleAnalytics(bool enabled) async {
    isAnalyticsEnabled.value = enabled;
    await _analyticsService.setAnalyticsCollectionEnabled(enabled);
  }

  /// Get analytics observer for navigation tracking
  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return _analyticsService.observer;
  }
}