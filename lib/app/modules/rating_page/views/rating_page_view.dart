import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/rating_page_controller.dart';

class RatingPageView extends GetView<RatingPageController> {
  const RatingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8F1FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Adi S.Psi',
          style: TextStyle(
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
            Column(
              children: const [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('assets/profile_picture.png'),
                ),
                SizedBox(height: 65),
                Text(
                  'Silahkan beri rating kepada counselor',
                  style: TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Expanded(
                    child: IconButton(
                      icon: const Icon(
                        Icons.star_border,
                        color: Colors.grey,
                        size: 75,
                      ),
                      onPressed: () {},
                    ),
                  ),
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