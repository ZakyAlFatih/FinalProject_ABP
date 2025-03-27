import 'package:get/get.dart';

import '../controllers/conselor_profile_controller.dart';

class ConselorProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConselorProfileController>(
      () => ConselorProfileController(),
    );
  }
}
