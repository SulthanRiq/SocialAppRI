// lib/core/repositories/verification_repository.dart
import '../models/verification.dart';

class VerificationRepository {
  final List<Verification> _verifications = [];

  Future<bool> saveVerification(Verification verification) async {
    await Future.delayed(Duration(milliseconds: 400));
    _verifications.add(verification);
    return true;
  }

  Future<List<Verification>> getUserVerifications(String username) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _verifications.where((v) => v.username == username).toList();
  }

  Future<bool> hasVerified(String articleId, String username) async {
    await Future.delayed(Duration(milliseconds: 200));
    return _verifications.any(
          (v) => v.articleId == articleId && v.username == username,
    );
  }
}