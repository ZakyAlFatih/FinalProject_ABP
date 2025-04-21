import 'package:get/get.dart';

import '../controllers/chat_counselor_controller.dart';

class ChatCounselorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatCounselorController>(
      () => ChatCounselorController(),
    );
  }
}
