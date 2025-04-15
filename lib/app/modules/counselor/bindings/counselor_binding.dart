import 'package:get/get.dart';

import '../controllers/counselor_controller.dart';

class CounselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounselorController>(
      () => CounselorController(),
    );
  }
}
