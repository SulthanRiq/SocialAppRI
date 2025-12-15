import 'package:get/get.dart';
import '../controller/notifikasi3_privacy_controller.dart';

class Notifikasi3PrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Notifikasi3PrivacyController>(
      Notifikasi3PrivacyController(),
    );
  }
}
