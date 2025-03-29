import 'package:finpro_abpx/app/modules/chat/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finpro_abpx/app/modules/chat/controllers/chat_controller.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    Get.put(ChatController()); // Inisialisasi ChatController
    super.onInit();
  }

  final List<Widget> screens = [
    Center(child: Text("Beranda Page")),
    Center(child: Text("Riwayat Page")),
    ChatView(),
    Center(child: Text("Profil Page")),
  ];
}
