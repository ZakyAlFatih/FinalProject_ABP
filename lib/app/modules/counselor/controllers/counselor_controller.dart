import 'package:get/get.dart';

class CounselorController extends GetxController {
  var showRatingPage = false.obs;

  void toggleView() {
    showRatingPage.value = !showRatingPage.value;
  }
}
