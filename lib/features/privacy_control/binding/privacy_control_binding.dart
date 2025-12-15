import 'package:get/get.dart';
import '../controller/privacy_control_controller.dart';

class PrivacyControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyControlController>(() => PrivacyControlController());
  }
}
