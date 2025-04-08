import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.blue.shade500), // Back arrow
            onPressed: () {
              Get.back(); // Navigate back
            },
          ),
          title: Text(
            "Riwayat",
            style: TextStyle(
              fontFamily: 'Arial Rounded MT Bold',
              fontSize: 24,
              color: Colors.blue.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue.shade50,
          centerTitle: true,
          elevation: 0.0,
          // For testing the data when there's order history or not using toogle (line 34 - 63)
          actions: [
            Obx(() {
              return GestureDetector(
                onTap: () {
                  // Toggle the value of toogleTestHistory
                  controller.toogleTestHistory.value = !controller.toogleTestHistory.value;
                },
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: controller.toogleTestHistory.value
                        ? Colors.green.shade500 // Color when active
                        : Colors.blue.shade500, // Color when inactive
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      controller.toogleTestHistory.value ? "ON" : "OFF",
                      style: TextStyle(
                        fontFamily: 'Arial Rounded MT Bold',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        body: Obx(() {
          // Check if there's no data in orderedHistory
          if (controller.orderedHistory.isEmpty || controller.toogleTestHistory.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show placeholder image
                  Image.asset(
                    'assets/images/gasKonsul_logo.png', // Replace with your image path
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16.0),

                  // Show placeholder text
                  Text(
                    "MAAF",
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade500,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Riwayat anda masih kosong",
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Harap pesan konselor terlebih dahulu",
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Show the list if there is data
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: controller.orderedHistory.length,
              itemBuilder: (context, index) {
                final history = controller.orderedHistory[index];
                return Card(
                  elevation: 3.0,
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.blue.shade500),
                    title: Text(
                      history['name'] ?? '',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Available days: ${history['days']}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            );
          }
        }),

        backgroundColor: Colors.white,
      ),
    );
  }
}