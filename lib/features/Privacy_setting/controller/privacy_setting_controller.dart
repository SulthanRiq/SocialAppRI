import 'package:get/get.dart';

class PrivacyController extends GetxController {
  // ======= DATA ==========
  final RxList<String> interests = <String>[
    'Technology',
    'Fitness',
    'Foods',
  ].obs;

  final RxBool isNudgeActive = true.obs;
  final RxInt currentReminders = 1.obs;
  final RxInt lastUpdatedDaysAgo = 2.obs;
  final RxInt privacyScore = 78.obs;

  // ====== ACTIONS ======
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
    Get.toNamed('/privacy-control');  
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

  @override
  void onInit() {
    super.onInit();
    // Bisa tambahkan inisialisasi dari storage / API di sini
  }
}
