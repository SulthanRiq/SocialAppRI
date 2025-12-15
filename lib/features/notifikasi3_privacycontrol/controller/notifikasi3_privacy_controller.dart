import 'package:get/get.dart';

class Notifikasi3PrivacyController extends GetxController {
  // ================= ACTION: ALLOW =================
  void onAllow() {
    // TODO:
    // - Simpan izin Messages & Phone Access
    // - Lanjut ke step berikutnya (jika ada)
    // - Atau close permission page

    Get.snackbar(
      'Permission Granted',
      'Messages & Phone Access diizinkan',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  }

  // ================= ACTION: DENY =================
  void onDeny() {
    // TODO:
    // - Simpan status penolakan
    // - Nonaktifkan fitur terkait

    Get.snackbar(
      'Permission Denied',
      'Messages & Phone Access ditolak',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  }

  // ================= ACTION: REMIND ME LATER =================
  void onRemindMeLater() {
    // TODO:
    // - Simpan reminder
    // - Jadwalkan notifikasi ulang

    Get.snackbar(
      'Reminder',
      'Kami akan mengingatkan Anda nanti',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  }
}
