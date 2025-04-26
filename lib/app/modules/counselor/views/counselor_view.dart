import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counselor_controller.dart';

class CounselorView extends StatelessWidget {
  const CounselorView({super.key});

  @override
  Widget build(BuildContext context) {
    final counselorUid = Get.arguments['id'] ?? 'Unknown';
    final controller = Get.put(CounselorController());

    // Ambil data counselor dan jadwalnya berdasarkan UID
    controller.fetchCounselorData(counselorUid);
    controller.fetchSchedules(counselorUid);

    return Obx(() {
      return controller.showRatingPage.value
          ? RatingWidget(
              counselorName: controller.counselorData['name'] ?? 'Counselor',
            )
          : CounselorProfileWidget(controller: controller, counselorUid: counselorUid);
    });
  }
}

class CounselorProfileWidget extends StatelessWidget {
  final CounselorController controller;
  final String counselorUid;

  const CounselorProfileWidget({super.key, required this.controller, required this.counselorUid});

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

            // Ambil `scheduleIdX` dari counselor untuk menampilkan jadwal yang sesuai
            List<Widget> scheduleButtons = controller.schedules.map((schedule) {
              String adjustedDay = '';
              String adjustedTime = '';

              if (schedule['id'] == controller.counselorData['scheduleId1']) {
                adjustedDay = controller.counselorData['availability_day1'] ?? '';
                adjustedTime = controller.counselorData['availability_time1'] ?? '';
              } else if (schedule['id'] == controller.counselorData['scheduleId2']) {
                adjustedDay = controller.counselorData['availability_day2'] ?? '';
                adjustedTime = controller.counselorData['availability_time2'] ?? '';
              } else if (schedule['id'] == controller.counselorData['scheduleId3']) {
                adjustedDay = controller.counselorData['availability_day3'] ?? '';
                adjustedTime = controller.counselorData['availability_time3'] ?? '';
              }

              return _buildScheduleBox(
                adjustedDay,
                adjustedTime,
                isActive: !(schedule['isBooked'] as bool? ?? false),
                onTap: () {
                  controller.selectedScheduleId.value = schedule['id'];
                },
              );
            }).toList();

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
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: NetworkImage(
                          controller.counselorData['avatar'] ?? 'https://via.placeholder.com/150',
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

                // Detail Profil
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rating', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2897FF))),
                      Row(
                        children: List.generate(
                          controller.counselorData['rating'] ?? 0,
                          (index) => const Icon(Icons.star, color: Colors.blue, size: 30),
                        ),
                      ),
                      const Divider(color: Colors.blue),
                      const SizedBox(height: 10),

                      const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2897FF))),
                      Text(controller.counselorData['about'] ?? 'No description available.', style: const TextStyle(fontSize: 18.5, color: Colors.black54)),
                      const Divider(color: Colors.blue),
                      const SizedBox(height: 15),

                      const Text('Jadwal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2897FF))),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        alignment: WrapAlignment.center, // 🔥 Selalu berada di tengah
                        children: scheduleButtons.isNotEmpty
                            ? scheduleButtons
                            : [const Text("Tidak ada jadwal tersedia", style: TextStyle(fontSize: 16, color: Colors.grey))],
                      ),
                      const Divider(color: Colors.blue),
                      const SizedBox(height: 20),

                      // Tombol Booking
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
                              if (controller.selectedScheduleId.value.isNotEmpty) {
                                controller.bookSchedule(controller.selectedScheduleId.value, counselorUid);
                              }
                            },
                            child: const Text('Booking', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: controller.toggleView,
                        child: const Text('Testing', style: TextStyle(color: Colors.blue)),
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

  static Widget _buildScheduleBox(String day, String time, {bool isActive = true, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : const Color(0xFFE8F1FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isActive ? Colors.white : Colors.blue)),
            const SizedBox(height: 5),
            Text(time, style: TextStyle(fontSize: 12, color: isActive ? Colors.white : Colors.blue)),
          ],
        ),
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