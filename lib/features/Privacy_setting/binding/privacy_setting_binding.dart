import 'package:get/get.dart';
import '../controller/privacy_setting_controller.dart';

class PrivacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyController>(() => PrivacyController());
  }
}
