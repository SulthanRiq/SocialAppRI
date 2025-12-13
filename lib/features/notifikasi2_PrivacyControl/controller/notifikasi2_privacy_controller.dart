import 'package:get/get.dart';

class PermissionPhotosLocationController extends GetxController {

  /// Ketika user menekan ALLOW
  void onAllow() {
    // contoh aksi:
    // - simpan preferensi izin
    // - lanjut ke step permission berikutnya
    // - atau close dialog
    Get.snackbar(
      'Permission Granted',
      'Photos & Location diizinkan',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back(); // tutup halaman permission
  }

  /// Ketika user menekan DENY
  void onDeny() {
    Get.snackbar(
      'Permission Denied',
      'Akses Photos & Location ditolak',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  }

  /// Ketika user menekan Remind me later
  void onRemindMeLater() {
    Get.snackbar(
      'Reminder',
      'Kami akan mengingatkan lagi nanti',
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.back();
  }
}
