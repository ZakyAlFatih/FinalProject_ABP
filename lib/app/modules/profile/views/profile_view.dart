import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isEditing.value
          ? _buildEditProfile(context, controller)
          : _buildProfile(context),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Profil Pengguna',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(
            () {
              if (controller.userData.isEmpty) {
                // Tampilkan loading saat data belum siap
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  // Header Profil
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45),
                        bottomRight: Radius.circular(45),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 45),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              controller.userData['avatar'] ?? 'https://via.placeholder.com/50'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.userData['name'] ?? 'Nama Tidak Tersedia',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Detail Profil
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: controller.userData['email'] ??
                                'Email Tidak Tersedia',
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          'Phone',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: controller.userData['phone'] ??
                                '+62 XXXXXXXXXX',
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Tombol Edit Profil
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
                              onPressed: () {
                                controller.isEditing.value = true;
                              },
                              child: const Text(
                                'Edit Profil',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Tombol Log Out
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
                              onPressed: () {
                                controller.logout(); // Fungsi logout di Controller
                              },
                              child: const Text(
                                'Log Out',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfile(BuildContext context, ProfileController controller) {
    // Controllers for input fields tied to observable data
    final nameController = TextEditingController(text: controller.userData['name'] ?? '');
    final phoneController = TextEditingController(text: controller.userData['phone'] ?? '');
    final passwordController = TextEditingController(); // For password changes
    final confirmPasswordController = TextEditingController(); // To confirm password

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => controller.exitEditMode(), // Explicitly exit edit mode
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Picture Edit Section
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
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                            controller.userData['avatar'] ?? 'https://via.placeholder.com/150'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            print("Edit photo profile clicked");
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF006FFD),
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

            // Input Fields Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(label: 'Nama', hint: 'nama', controller: nameController),
                  const SizedBox(height: 20),
                  _buildInputField(label: 'Password', hint: 'password', obscure: true, controller: passwordController),
                  _buildInputField(
                      label: '', hint: 'confirm password', obscure: true, reduceGap: true, controller: confirmPasswordController),
                  const SizedBox(height: 30),
                  _buildInputField(label: 'Phone', hint: '+62XXXXXXXXXX', controller: phoneController),
                  const SizedBox(height: 35),

                  // Save Button
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
                        onPressed: () {
                          if (passwordController.text == confirmPasswordController.text) {
                            controller.updateFullProfile(
                              photoUrl: controller.userData['avatar'] ?? '',
                              name: nameController.text,
                              phone: phoneController.text,
                              email: controller.userData['email'],
                              password: passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                            );
                          } else {
                            Get.snackbar('Error', 'Passwords do not match!');
                          }
                        },
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

  Widget _buildInputField({
    required String label,
    required String hint,
    TextEditingController? controller, // Add this parameter for input control
    bool obscure = false,
    bool reduceGap = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: reduceGap ? 5 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 25,
            child: TextField(
              controller: controller, // Use the controller here
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
                isDense: true,
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
