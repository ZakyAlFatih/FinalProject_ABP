import 'package:finpro_abpx/app/modules/chat_counselor/views/chat_counselor_view.dart';
import 'package:finpro_abpx/app/modules/profile_counselor/views/profile_counselor_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finpro_abpx/app/modules/chat_counselor/controllers/chat_counselor_controller.dart';
import 'package:finpro_abpx/app/modules/profile_counselor/controllers/profile_counselor_controller.dart';

class NavbarCounselorController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    // Inisialisasi controller untuk Chat dan Profile
    Get.put(ChatCounselorController());
    Get.put(ProfileCounselorController());
    super.onInit();
  }

  // Daftar screens untuk Counselor Navbar (Chat dan Profile)
  final List<Widget> screens = [
    ChatCounselorView(),
    ProfileCounselorView(),
  ];
}
