import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_edit_controller.dart';

class ProfileEditView extends GetView<ProfileEditController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('Edit Profil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 35),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/profile_picture.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            print("Edit foto profil diklik");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF006FFD),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: const Icon(Icons.edit, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(label: 'Nama', hint: 'nama'),
                  const SizedBox(height: 20),
                  _buildInputField(label: 'Email', hint: 'email'),
                  const SizedBox(height: 20),
                  _buildInputField(label: 'Password', hint: 'password', obscure: true),
                  _buildInputField(label: '', hint: 'confirm password', obscure: true, reduceGap: true),
                  const SizedBox(height: 30),
                  _buildInputField(label: 'Phone', hint: '+62XXXXXXXXXX'),
                  const SizedBox(height: 35),
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
                        child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required String hint, bool obscure = false, bool reduceGap = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: reduceGap ? 5 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
          SizedBox(
            width: double.infinity,
            height: 25,
            child: TextField(
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: const Color(0xFFE8F1FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                isDense: true, // Biar teksnya tetep di dalem border
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}