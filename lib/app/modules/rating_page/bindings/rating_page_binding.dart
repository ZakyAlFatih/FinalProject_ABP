import 'package:get/get.dart';

import '../controllers/rating_page_controller.dart';

class RatingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingPageController>(
      () => RatingPageController(),
    );
  }
}
