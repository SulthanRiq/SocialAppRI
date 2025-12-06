// lib/core/models/verification.dart
class Verification {
  final String articleId;
  final String username;
  final bool hasReadFully;
  final int understandingLevel;
  final String? additionalCaption;
  final List<String> selectedSuggestions;
  final DateTime timestamp;
  final String readingTime;
  final String status;

  Verification({
    required this.articleId,
    required this.username,
    required this.hasReadFully,
    required this.understandingLevel,
    this.additionalCaption,
    required this.selectedSuggestions,
    required this.timestamp,
    required this.readingTime,
    required this.status,
  });

  String get quizScore {
    int score = 0;
    if (hasReadFully) score++;
    if (understandingLevel == 1) score++;
    return '$score/2';
  }

  static String determineStatus(bool hasReadFully, int understandingLevel) {
    if (hasReadFully && understandingLevel == 1) {
      return 'Informed Reader';
    } else if (hasReadFully || understandingLevel == 1) {
      return 'Partial Reader';
    } else {
      return 'Quick Reader';
    }
  }
}