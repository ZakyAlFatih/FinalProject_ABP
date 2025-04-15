import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counselor_controller.dart';

class CounselorView extends StatelessWidget {
  const CounselorView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CounselorController());

    return Obx(() {
      return controller.showRatingPage.value
          ? const RatingWidget()
          : const CounselorProfileWidget();
    });
  }
}

class CounselorProfileWidget extends StatelessWidget {
  const CounselorProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorController>();

    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2897FF),
        centerTitle: true,
        title: const Text('Adi S.Psi',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
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
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage('assets/profile_picture.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Counselor Psikologi',
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rating',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2897FF))),
                    Row(
                      children: List.generate(
                          5,
                          (index) => const Icon(Icons.star,
                              color: Colors.blue, size: 30)),
                    ),
                    const Divider(color: Colors.blue),
                    const SizedBox(height: 10),
                    const Text('About',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2897FF))),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style:
                          TextStyle(fontSize: 18.5, color: Colors.black54),
                    ),
                    const Divider(color: Colors.blue),
                    const SizedBox(height: 15),
                    const Text('Jadwal',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2897FF))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildScheduleBox('Senin', '05:30 - 09:00',
                            isActive: true),
                        _buildScheduleBox('Rabu', '05:30 - 09:00',
                            isActive: false),
                        _buildScheduleBox('Kamis', '05:30 - 09:00',
                            isActive: false),
                      ],
                    ),
                    const Divider(color: Colors.blue),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text('Booking',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: controller.toggleView,
                            child: const Text(
                              'Testing', // Button untuk pindah ke rating
                              style: TextStyle(color: Colors.blue),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
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
            width: isActive ? 0 : 2),
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
  const RatingWidget({super.key});

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
          onPressed: controller.toggleView, // Kembali ke profile
        ),
        centerTitle: true,
        title: const Text(
          'Adi S.Psi',
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/profile_picture.png'),
            ),
            const SizedBox(height: 65),
            const Text(
              'Silahkan beri rating kepada counselor',
              style: TextStyle(
                  fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
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
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 70),
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
                  onPressed: () {},
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
