import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/conselor_profile_controller.dart';

class ConselorProfileView extends GetView<ConselorProfileController> {
  const ConselorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1FF),
      appBar: AppBar(
        backgroundColor: Color(0xFF2897FF),
        centerTitle: true,
        title: const Text('Adi S.Psi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25)),
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
                      style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
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
                    const Text('Rating', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2897FF))),
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.blue, size: 30)),
                    ),
                    const Divider(color: Colors.blue,),
                    const SizedBox(height: 10),
                    const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2897FF))),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: TextStyle(fontSize: 18.5, color: Colors.black54),
                    ),
                    const Divider(color: Colors.blue,),
                    const SizedBox(height: 15),
                    const Text('Jadwal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2897FF))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildScheduleBox('Senin', '05:30 - 09:00', isActive: true),
                        _buildScheduleBox('Rabu', '05:30 - 09:00', isActive: false),
                        _buildScheduleBox('Kamis', '05:30 - 09:00', isActive: false),
                      ],
                    ),
                    const Divider(color: Colors.blue,),
                    const SizedBox(height: 20),
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
                          child: const Text('Booking', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleBox(String day, String time, {bool isActive = true}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Color(0xFFE8F1FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isActive ? Colors.blue : Colors.blue, width: isActive ? 0 : 2),
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
