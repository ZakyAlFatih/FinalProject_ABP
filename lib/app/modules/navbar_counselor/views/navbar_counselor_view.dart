import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navbar_counselor_controller.dart';

class NavbarCounselorView extends GetView<NavbarCounselorController> {
  const NavbarCounselorView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavbarCounselorController>(builder: (controller) {
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
                  icon: Icon(Icons.chat_outlined),
                  activeIcon: Icon(Icons.chat),
                  label: "Chat",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
