// lib/core/controllers/verification_controller.dart
import 'package:get/get.dart';
import '../models/verification.dart';
import '../repositories/verification_repository.dart';

class VerificationController extends GetxController {
  final VerificationRepository _repository = VerificationRepository();

  var isVerifying = false.obs;
  var readStatus = Rxn<int>();
  var understandingLevel = Rxn<int>();
  var selectedSuggestions = <bool>[false, false, false].obs;
  var additionalCaption = ''.obs;

  Future<Verification?> submitVerification(String articleId) async {
    if (readStatus.value == null || understandingLevel.value == null) {
      Get.snackbar(
        'Peringatan',
        'Mohon jawab semua pertanyaan verifikasi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    try {
      isVerifying.value = true;

      final hasReadFully = readStatus.value == 1;
      final status = Verification.determineStatus(hasReadFully, understandingLevel.value!);

      final suggestions = <String>[];
      final allSuggestions = [
        '"Saya sudah baca artikel lengkapnya sebelum share"',
        '"Masih dalam proses investigasi, belum ada putusan hukum"',
        '"Link fact-check: [URL]"',
      ];

      for (int i = 0; i < selectedSuggestions.length; i++) {
        if (selectedSuggestions[i]) {
          suggestions.add(allSuggestions[i]);
        }
      }

      final verification = Verification(
        articleId: articleId,
        username: '@current_user',
        hasReadFully: hasReadFully,
        understandingLevel: understandingLevel.value!,
        additionalCaption: additionalCaption.value.isNotEmpty ? additionalCaption.value : null,
        selectedSuggestions: suggestions,
        timestamp: DateTime.now(),
        readingTime: '3m 15s',
        status: status,
      );

      final success = await _repository.saveVerification(verification);

      if (success) {
        return verification;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan verifikasi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isVerifying.value = false;
    }

    return null;
  }

  void resetForm() {
    readStatus.value = null;
    understandingLevel.value = null;
    selectedSuggestions.value = [false, false, false];
    additionalCaption.value = '';
  }

  void toggleSuggestion(int index) {
    selectedSuggestions[index] = !selectedSuggestions[index];
    selectedSuggestions.refresh();
  }
}