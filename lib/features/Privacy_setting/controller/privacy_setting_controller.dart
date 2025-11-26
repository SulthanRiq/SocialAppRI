import 'package:get/get.dart';

class PrivacyController extends GetxController {
  // DATA DUMMY – nanti bisa kamu ganti dari API / local storage
  final interests = <String>['Technology', 'Fitness', 'Food'].obs;

  final isNudgeActive = true.obs;
  final currentReminders = 1.obs;

  final lastUpdatedDaysAgo = 2.obs;
  final privacyScore = 78.obs;

  // ====== ACTIONS (sementara hanya print / snackbar) ======
  void onManageTopics() {
    Get.snackbar('Manage Topics', 'Buka pengaturan topik & interest.');
  }

  void onViewDashboard() {
    Get.snackbar('Dashboard', 'Buka dashboard aktivitas harian.');
  }

  void onSetReminder() {
    Get.snackbar('Reminder', 'Buka pengaturan daily reminder.');
  }

  void onManagePrivacy() {
    Get.snackbar('Privacy Control', 'Buka pengaturan data & permission.');
  }

  void onOpenPrivacyPolicy() {
    Get.snackbar('Privacy Policy', 'Buka Privacy Policy (Plain Explained).');
  }

  void onOpenDataUsage() {
    Get.snackbar('Data Usage', 'Buka Data Usage Explained.');
  }

  void onOpenYourRights() {
    Get.snackbar('Your Rights', 'Buka halaman Your Rights.');
  }
}
