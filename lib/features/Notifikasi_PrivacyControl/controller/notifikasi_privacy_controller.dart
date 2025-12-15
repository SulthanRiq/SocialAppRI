import 'package:get/get.dart';

class PrivacyControlController extends GetxController {

  void onAllow() {
    Get.offNamed('/privacy-control');
  }

  void onDeny() {
    Get.back();
  }

  void onRemindMeLater() {
    Get.snackbar(
      "Reminder",
      "Kami akan mengingatkan kamu lagi nanti.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
