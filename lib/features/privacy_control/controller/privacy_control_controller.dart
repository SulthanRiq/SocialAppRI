import 'package:get/get.dart';

class PrivacyControlController extends GetxController {
  final profileName = 'Balanced'.obs;
  final privacyScore = 78.obs;

  // Personal Information
  final locationStatus = 'Limited'.obs;
  final photosStatus = 'ON'.obs;
  final contactsStatus = 'OFF'.obs;

  // Behavioral Data
  final browsingStatus = 'OFF'.obs;
  final interactionsStatus = 'ON'.obs;

  // Communication
  final messagesStatus = 'Metadata'.obs;
  final phoneStatus = 'ON'.obs;

  void onManagePersonalInfo() {
    Get.snackbar('Manage', 'Managing Personal Information');
  }

  void onManageBehavioralData() {
    Get.snackbar('Manage', 'Managing Behavioral Data');
  }

  void onManageCommunication() {
    Get.snackbar('Manage', 'Managing Communication Permissions');
  }
}
