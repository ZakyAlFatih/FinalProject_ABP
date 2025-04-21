import 'package:get/get.dart';

import '../controllers/register_counselor_controller.dart';

class RegisterCounselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterCounselorController>(
      () => RegisterCounselorController(),
    );
  }
}
