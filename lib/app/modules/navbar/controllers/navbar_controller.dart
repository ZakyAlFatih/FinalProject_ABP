import 'package:finpro_abpx/app/modules/chat/views/chat_view.dart';
import 'package:finpro_abpx/app/modules/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finpro_abpx/app/modules/chat/controllers/chat_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../../history/controllers/history_controller.dart';
import '../../history/views/history_view.dart';
import '../../profile/controllers/profile_controller.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    Get.put(ChatController()); // Inisialisasi ChatController
    Get.put(HomeController()); // Inisialisasi HomeController
    Get.put(HistoryController()); // Inisialisasi HomeController
    Get.put(ProfileController()); // Inisialisasi ProfileController
    super.onInit();
  }

  final List<Widget> screens = [
    HomeView(),
    HistoryView(),
    ChatView(),
    ProfileView(),
  ];
}
