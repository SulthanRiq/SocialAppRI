import 'package:get/get.dart';
import '../controller/notifikasi2_privacy_controller.dart';

class PermissionPhotosLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PermissionPhotosLocationController());
  }
}
