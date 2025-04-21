import 'package:get/get.dart';

import '../controllers/navbar_counselor_controller.dart';

class NavbarCounselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarCounselorController>(
      () => NavbarCounselorController(),
    );
  }
}
