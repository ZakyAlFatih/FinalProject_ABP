import 'package:get/get.dart';

import '../controllers/profile_counselor_controller.dart';

class ProfileCounselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileCounselorController>(
      () => ProfileCounselorController(),
    );
  }
}
