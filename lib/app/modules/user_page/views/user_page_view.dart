import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_page_controller.dart';

class UserPageView extends GetView<UserPageController> {
  const UserPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
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
    );
  }
}
