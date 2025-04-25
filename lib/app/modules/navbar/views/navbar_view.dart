import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavbarController>(builder: (controller) {
      // Check for arguments passed via Get.offAllNamed
      final args = Get.arguments;
      if (args != null && args['navigateTo'] == 'profile') {
        controller.selectedIndex.value = 3; // Set index to Profil
      }
        return Scaffold(
          body: Obx(() => controller.screens[controller.selectedIndex.value]),
          bottomNavigationBar: Obx(
            () => Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: controller.selectedIndex.value,
                onTap: (index) => controller.selectedIndex.value = index,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.blue.shade900,
                unselectedItemColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: "Beranda",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_outlined),
                    activeIcon: Icon(Icons.receipt_long),
                    label: "Riwayat",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_outlined),
                    activeIcon: Icon(Icons.chat),
                    label: "Chat",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: "Profil",
                  ),
                ],
              ),
            ),
          ),
        );
    });
  }
}

// Dummy pages untuk testing
class BerandaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Beranda'));
  }
}

class RiwayatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Riwayat'));
  }
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Chat'));
  }
}

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Profil'));
  }
}
