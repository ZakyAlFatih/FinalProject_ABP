import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_counselor_controller.dart';


class ProfileCounselorView extends GetView<ProfileCounselorController> {
  const ProfileCounselorView({super.key});

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
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // Fetch availability data
              String day1 = controller.userData['availability_day1'] ?? 'Unknown';
              String time1 = controller.userData['availability_time1'] ?? 'Unknown Time';
              String day2 = controller.userData['availability_day2'] ?? 'Unknown';
              String time2 = controller.userData['availability_time2'] ?? 'Unknown Time';
              String day3 = controller.userData['availability_day3'] ?? 'Unknown';
              String time3 = controller.userData['availability_time3'] ?? 'Unknown Time';

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
                            controller.userData['avatar'] ?? 'https://via.placeholder.com/50',
                          ),
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
                            hintText: controller.userData['email'] ?? 'Email Tidak Tersedia',
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
                            hintText: controller.userData['phone'] ?? '+62 XXXXXXXXXX',
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Schedule Section with Conditions
                        const Text(
                          'Jadwal',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Conditional display logic
                        if (day1 == '' && time1 == '' || day1 == 'Unknown')
                          const Text(
                            'Tidak ada jadwal, silahkan "Edit Profile" untuk menambahkan jadwal', // Placeholder for your message
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          )
                        else if (day2 == '' || time2 == '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _availabilityBox(day1, time1), // Single box with day1 and time1
                            ],
                          )
                        else if (day3 == '' || time3 == '')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _availabilityBox(day1, time1),
                              const SizedBox(width: 10),
                              _availabilityBox(day2, time2), // Two boxes: day1+time1, day2+time2
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _availabilityBox(day1, time1),
                              const SizedBox(width: 10),
                              _availabilityBox(day2, time2),
                              const SizedBox(width: 10),
                              _availabilityBox(day3, time3), // Three boxes for all days and times
                            ],
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
                                controller.logout(); // Logout logic
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

  // Helper widget to create availability box
  Widget _availabilityBox(String day, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            time,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfile(BuildContext context, ProfileCounselorController controller) {
    final nameController = TextEditingController(text: controller.userData['name'] ?? '');
    final phoneController = TextEditingController(text: controller.userData['phone'] ?? '');
    final passwordController = TextEditingController(); 
    final confirmPasswordController = TextEditingController(); 

    // Availability Controllers with validation logic
    final day1Controller = TextEditingController(text: controller.userData['availability_day1'] ?? '');
    final time1Controller = TextEditingController(text: controller.userData['availability_time1'] ?? '');
    final day2Controller = TextEditingController(
        text: controller.userData['availability_day2'] ?? '',
    );
    final time2Controller = TextEditingController(
        text: controller.userData['availability_time2'] ?? '',
    );
    final day3Controller = TextEditingController(
        text: controller.userData['availability_day3'] ?? '',
    );
    final time3Controller = TextEditingController(
        text: controller.userData['availability_time3'] ?? '',
    );

    final aboutController = TextEditingController(text: controller.userData['about'] ?? 'No Description');

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
          onPressed: () => controller.exitEditMode(), 
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(label: 'Nama', hint: 'Nama', controller: nameController),
              const SizedBox(height: 20),

              _buildInputField(
                label: 'About',
                hint: 'Write something about yourself...',
                controller: aboutController,
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              _buildInputField(label: 'Phone', hint: '+62XXXXXXXXXX', controller: phoneController),
              const SizedBox(height: 30),

              _buildInputField(label: 'Password', hint: 'Password', obscure: true, controller: passwordController),
              _buildInputField(
                  label: '', hint: 'Confirm Password', obscure: true, reduceGap: true, controller: confirmPasswordController),
              const SizedBox(height: 30),

              // Availability with validation
              _buildInputField(label: 'Availability - Day 1', hint: 'Day 1 (e.g., Mon)', controller: day1Controller),
              _buildInputField(label: '', hint: 'Time 1 (e.g., 10:00-12:00)', reduceGap: true, controller: time1Controller),
              const SizedBox(height: 20),

              // Disable Day 2 if Day 1 is empty
              _buildInputField(
                label: 'Availability - Day 2',
                hint: 'Day 2 (e.g., Tue)',
                controller: day2Controller,
                readOnly: day1Controller.text.isEmpty,
              ),
              _buildInputField(
                label: '',
                hint: 'Time 2 (e.g., 14:00-16:00)',
                reduceGap: true,
                controller: time2Controller,
                readOnly: day1Controller.text.isEmpty,
              ),
              const SizedBox(height: 20),

              // Disable Day 3 if Day 2 is empty
              _buildInputField(
                label: 'Availability - Day 3',
                hint: 'Day 3 (e.g., Fri)',
                controller: day3Controller,
                readOnly: day2Controller.text.isEmpty,
              ),
              _buildInputField(
                label: '',
                hint: 'Time 3 (e.g., 16:00-18:00)',
                reduceGap: true,
                controller: time3Controller,
                readOnly: day2Controller.text.isEmpty,
              ),
              const SizedBox(height: 30),

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
                          availability: {
                            "day1": day1Controller.text,
                            "time1": time1Controller.text,
                            "day2": day1Controller.text.isNotEmpty ? day2Controller.text : '',
                            "time2": day1Controller.text.isNotEmpty ? time2Controller.text : '',
                            "day3": day2Controller.text.isNotEmpty ? day3Controller.text : '',
                            "time3": day2Controller.text.isNotEmpty ? time3Controller.text : '',
                          },
                          about: aboutController.text,
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
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    bool reduceGap = false,
    bool readOnly = false,
    int maxLines = 1,
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
          TextField(
            controller: controller,
            obscureText: obscure,
            readOnly: readOnly,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: readOnly ? Colors.grey[200] : const Color(0xFFE8F1FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}