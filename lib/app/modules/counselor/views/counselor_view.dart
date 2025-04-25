import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counselor_controller.dart';

class CounselorView extends StatelessWidget {
  const CounselorView({super.key});

  @override
  Widget build(BuildContext context) {
    final counselorId = Get.arguments['id'] ?? 'Unknown'; // Retrieve the counselor ID
    final controller = Get.put(CounselorController());

    // Fetch counselor data using the ID
    controller.fetchCounselorData(counselorId);

    return Obx(() {
      return controller.showRatingPage.value
          ? RatingWidget(
              counselorName: controller.counselorData['name'] ?? 'Counselor',
            )
          : CounselorProfileWidget(controller: controller);
    });
  }
}

class CounselorProfileWidget extends StatelessWidget {
  final CounselorController controller;

  const CounselorProfileWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2897FF),
        centerTitle: true,
        title: Obx(() {
          return Text(
            controller.counselorData['name'] ?? 'Loading...',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          );
        }),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.counselorData.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Extract availability data
            String availDay1 = controller.counselorData['availability_day1'] ?? 'Unknown';
            String availTime1 = controller.counselorData['availability_time1'] ?? 'Unknown Time';
            String availDay2 = controller.counselorData['availability_day2'] ?? 'Unknown';
            String availTime2 = controller.counselorData['availability_time2'] ?? 'Unknown Time';
            String availDay3 = controller.counselorData['availability_day3'] ?? 'Unknown';
            String availTime3 = controller.counselorData['availability_time3'] ?? 'Unknown Time';

            // Determine schedule section content
            Widget scheduleSection;
            if (availDay1 == '' || availDay1 == 'Unknown') {
              scheduleSection = const Center(
                child: Text(
                  'Tidak ada jadwal yang disediakan, silahkan cari konselor lain.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              );
            } else if (availDay2 == '' || availDay2 == 'Unknown') {
              scheduleSection = Center(
                child: _buildScheduleBox(
                  availDay1,
                  availTime1,
                  isActive: true,
                ),
              );
            } else if (availDay3 == '' || availDay3 == 'Unknown') {
              scheduleSection = Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScheduleBox(
                      availDay1,
                      availTime1,
                      isActive: true,
                    ),
                    const SizedBox(width: 10),
                    _buildScheduleBox(
                      availDay2,
                      availTime2,
                      isActive: false,
                    ),
                  ],
                ),
              );
            } else {
              scheduleSection = Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScheduleBox(
                      availDay1,
                      availTime1,
                      isActive: true,
                    ),
                    const SizedBox(width: 10),
                    _buildScheduleBox(
                      availDay2,
                      availTime2,
                      isActive: false,
                    ),
                    const SizedBox(width: 10),
                    _buildScheduleBox(
                      availDay3,
                      availTime3,
                      isActive: false,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Profile Header
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                          controller.counselorData['avatar'] ??
                              'https://via.placeholder.com/150',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Counselor ${controller.counselorData['bidang'] ?? 'Counselor'}',
                        style: const TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // Profile Details
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rating Section
                      const Text(
                        'Rating',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2897FF),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          controller.counselorData['rating'] ?? 0,
                          (index) =>
                              const Icon(Icons.star, color: Colors.blue, size: 30),
                        ),
                      ),
                      const Divider(color: Colors.blue),
                      const SizedBox(height: 10),

                      // About Section
                      const Text(
                        'About',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2897FF),
                        ),
                      ),
                      Text(
                        controller.counselorData['about'] ??
                            'No description available.',
                        style: const TextStyle(fontSize: 18.5, color: Colors.black54),
                      ),
                      const Divider(color: Colors.blue),
                      const SizedBox(height: 15),

                      // Schedule Section
                      const Text(
                        'Jadwal',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2897FF),
                        ),
                      ),
                      scheduleSection,
                      const Divider(color: Colors.blue),
                      const SizedBox(height: 20),

                      // Booking Button
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              print('Booking button clicked');
                            },
                            child: const Text('Booking',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: controller.toggleView,
                        child: const Text(
                          'Testing', // Button to switch to rating view
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  static Widget _buildScheduleBox(String day, String time,
      {bool isActive = true}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : const Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive ? Colors.blue : Colors.blue,
          width: isActive ? 0 : 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : Colors.blue,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.white : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final String counselorName;

  const RatingWidget({super.key, required this.counselorName});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F1FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: controller.toggleView, // Navigate back to profile
        ),
        centerTitle: true,
        title: Text(
          counselorName,
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display Counselor Profile Image
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(
                controller.counselorData['avatar'] ?? 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(height: 65),

            // Rating Prompt
            const Text(
              'Silahkan beri rating kepada counselor',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),

            // Star Rating Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: const Icon(
                    Icons.star_border,
                    color: Colors.grey,
                    size: 75,
                  ),
                  onPressed: () {
                    // Handle Star Selection
                    print('Star $index clicked');
                  },
                ),
              ),
            ),

            const SizedBox(height: 70),

            // Save Button
            Center(
              child: SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    print('Rating saved!');
                  },
                  child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}