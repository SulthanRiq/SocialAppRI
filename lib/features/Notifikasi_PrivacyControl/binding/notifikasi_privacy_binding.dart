import 'package:get/get.dart';
import '../controller/notifikasi_privacy_controller.dart';

class NotiPrivacyControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PrivacyControlController());
  }
}
