import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_page_controller.dart';

class UserPageView extends GetView<UserPageController> {
  const UserPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Profil Pengguna', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 45),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/profile_picture.png'),
                    ),
                    SizedBox(height: 10),
                    Text('Name',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'email',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Phone', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: '+62 XXXXXXXXXX',
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Edit Profil', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: 130,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Log Out', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Color(0xFF8DC8FF),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/images/home.png')), label: 'Beranda'),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/images/activity_history.png')), label: 'Riwayat'),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/images/chat_room.png')), label: 'Chat'),
            BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/images/user.png')), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
