import 'package:firebase_analytics/firebase_analytics.dart';

/// Service untuk mengelola Firebase Analytics
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);

  // ==================== USER EVENTS ====================

  /// Log ketika user sign up
  Future<void> logSignUp({required String method}) async {
    await _analytics.logSignUp(signUpMethod: method);
    print('📊 Analytics: Sign up with $method');
  }

  /// Log ketika user login
  Future<void> logLogin({required String method}) async {
    await _analytics.logLogin(loginMethod: method);
    print('📊 Analytics: Login with $method');
  }

  /// Log ketika user logout
  Future<void> logLogout() async {
    await _analytics.logEvent(name: 'logout');
    print('📊 Analytics: Logout');
  }

  /// Set user ID untuk tracking
  Future<void> setUserId(String userId) async {
    await _analytics.setUserId(id: userId);
    print('📊 Analytics: User ID set to $userId');
  }

  /// Set user properties
  Future<void> setUserProperties({
    required String username,
    String? email,
  }) async {
    await _analytics.setUserProperty(name: 'username', value: username);
    if (email != null) {
      await _analytics.setUserProperty(name: 'email', value: email);
    }
    print('📊 Analytics: User properties set');
  }

  // ==================== SCREEN VIEW EVENTS ====================

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass ?? screenName,
    );
    print('📊 Analytics: Screen view - $screenName');
  }

  // ==================== POST EVENTS ====================

  /// Log ketika user create post
  Future<void> logCreatePost({
    required String postId,
    required String contentType, // 'text', 'image', 'video'
  }) async {
    await _analytics.logEvent(
      name: 'create_post',
      parameters: {
        'post_id': postId,
        'content_type': contentType,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    print('📊 Analytics: Post created - $postId');
  }

  /// Log ketika user like post
  Future<void> logLikePost({
    required String postId,
    required String postOwnerId,
  }) async {
    await _analytics.logEvent(
      name: 'like_post',
      parameters: {
        'post_id': postId,
        'post_owner_id': postOwnerId,
      },
    );
    print('📊 Analytics: Post liked - $postId');
  }

  /// Log ketika user unlike post
  Future<void> logUnlikePost({
    required String postId,
  }) async {
    await _analytics.logEvent(
      name: 'unlike_post',
      parameters: {
        'post_id': postId,
      },
    );
    print('📊 Analytics: Post unliked - $postId');
  }

  /// Log ketika user comment on post
  Future<void> logCommentPost({
    required String postId,
    required String commentLength,
  }) async {
    await _analytics.logEvent(
      name: 'comment_post',
      parameters: {
        'post_id': postId,
        'comment_length': commentLength,
      },
    );
    print('📊 Analytics: Comment added - $postId');
  }

  /// Log ketika user share post
  Future<void> logSharePost({
    required String postId,
    required String method, // 'copy_link', 'social_media', etc
  }) async {
    await _analytics.logShare(
      contentType: 'post',
      itemId: postId,
      method: method,
    );
    print('📊 Analytics: Post shared - $postId via $method');
  }

  /// Log ketika user view post detail
  Future<void> logViewPost({
    required String postId,
  }) async {
    await _analytics.logEvent(
      name: 'view_post',
      parameters: {
        'post_id': postId,
      },
    );
    print('📊 Analytics: Post viewed - $postId');
  }

  // ==================== CHAT EVENTS ====================

  /// Log ketika user send message
  Future<void> logSendMessage({
    required String chatRoomId,
    required String messageType, // 'text', 'image'
    required String receiverId,
  }) async {
    await _analytics.logEvent(
      name: 'send_message',
      parameters: {
        'chat_room_id': chatRoomId,
        'message_type': messageType,
        'receiver_id': receiverId,
      },
    );
    print('📊 Analytics: Message sent - $messageType');
  }

  /// Log ketika user start new chat
  Future<void> logStartChat({
    required String receiverId,
  }) async {
    await _analytics.logEvent(
      name: 'start_chat',
      parameters: {
        'receiver_id': receiverId,
      },
    );
    print('📊 Analytics: Chat started with $receiverId');
  }

  // ==================== SEARCH EVENTS ====================

  /// Log ketika user search
  Future<void> logSearch({
    required String searchTerm,
    required String searchType, // 'user', 'post', 'tag'
  }) async {
    await _analytics.logSearch(
      searchTerm: searchTerm,
      parameters: {
        'search_type': searchType,
      },
    );
    print('📊 Analytics: Search - $searchTerm ($searchType)');
  }

  // ==================== PROFILE EVENTS ====================

  /// Log ketika user view profile
  Future<void> logViewProfile({
    required String profileUserId,
    required bool isOwnProfile,
  }) async {
    await _analytics.logEvent(
      name: 'view_profile',
      parameters: {
        'profile_user_id': profileUserId,
        'is_own_profile': isOwnProfile,
      },
    );
    print('📊 Analytics: Profile viewed - $profileUserId');
  }

  /// Log ketika user edit profile
  Future<void> logEditProfile() async {
    await _analytics.logEvent(name: 'edit_profile');
    print('📊 Analytics: Profile edited');
  }

  /// Log ketika user update profile picture
  Future<void> logUpdateProfilePicture() async {
    await _analytics.logEvent(name: 'update_profile_picture');
    print('📊 Analytics: Profile picture updated');
  }

  // ==================== NOTIFICATION EVENTS ====================

  /// Log ketika user receive notification
  Future<void> logReceiveNotification({
    required String notificationType,
  }) async {
    await _analytics.logEvent(
      name: 'receive_notification',
      parameters: {
        'notification_type': notificationType,
      },
    );
    print('📊 Analytics: Notification received - $notificationType');
  }

  /// Log ketika user tap notification
  Future<void> logTapNotification({
    required String notificationType,
  }) async {
    await _analytics.logEvent(
      name: 'tap_notification',
      parameters: {
        'notification_type': notificationType,
      },
    );
    print('📊 Analytics: Notification tapped - $notificationType');
  }

  // ==================== APP EVENTS ====================

  /// Log ketika app opened
  Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
    print('📊 Analytics: App opened');
  }

  /// Log tutorial begin
  Future<void> logTutorialBegin() async {
    await _analytics.logTutorialBegin();
    print('📊 Analytics: Tutorial begin');
  }

  /// Log tutorial complete
  Future<void> logTutorialComplete() async {
    await _analytics.logTutorialComplete();
    print('📊 Analytics: Tutorial complete');
  }

  // ==================== ERROR EVENTS ====================

  /// Log error
  Future<void> logError({
    required String errorMessage,
    required String errorLocation,
    String? stackTrace,
  }) async {
    await _analytics.logEvent(
      name: 'error',
      parameters: {
        'error_message': errorMessage,
        'error_location': errorLocation,
        if (stackTrace != null) 'stack_trace': stackTrace,
      },
    );
    print('📊 Analytics: Error - $errorMessage at $errorLocation');
  }

  // ==================== CUSTOM EVENTS ====================

  /// Log custom event dengan parameters
  Future<void> logCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
    print('📊 Analytics: Custom event - $eventName');
  }

  // ==================== SETTINGS ====================

  /// Enable/disable analytics collection
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    await _analytics.setAnalyticsCollectionEnabled(enabled);
    print('📊 Analytics: Collection ${enabled ? "enabled" : "disabled"}');
  }

  /// Reset analytics data
  Future<void> resetAnalyticsData() async {
    await _analytics.resetAnalyticsData();
    print('📊 Analytics: Data reset');
  }
}