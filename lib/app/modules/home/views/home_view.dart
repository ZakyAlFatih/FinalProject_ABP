import 'package:finpro_abpx/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

Widget buildHorizontalCounselorList(List<dynamic> counselors) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: counselors.map((counselor) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          elevation: 2,
          child: Container(
            height: 190,
            width: 160, // Adjust card width
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade50, // Background color for the card
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Counselor's profile image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    counselor["image"] ??
                        'assets/images/gasKonsul_logo.png', // Placeholder image
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                  ),
                ),
                SizedBox(height: 8),
                // Counselor's name
                Text(
                  counselor["name"] ?? "Unknown",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Counselor's availability
                Text(
                  (() {
                    // Dynamically decide what to display based on availability conditions
                    if (counselor["availability"]["day1"] == "Unknown" ||
                        counselor["availability"]["day2"] == "Unknown") {
                      return counselor["availability"]
                          ["day1"]; // Only show day1 if it's Unknown
                    } else if (counselor["availability"]["day3"] == "Unknown") {
                      return '${counselor["availability"]["day1"]}, ${counselor["availability"]["day2"]}'; // Show day1 and day2 when day3 is Unknown
                    } else {
                      // If none are Unknown, show all days
                      return '${counselor["availability"]["day1"]}, ${counselor["availability"]["day2"]}, ${counselor["availability"]["day3"]}';
                    }
                  })(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Spacer(),
                // "Selengkapnya" Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to CounselorView using a named route, passing only the counselor ID
                      Get.toNamed(
                        Routes.COUNSELOR,
                        arguments: {'id': counselor["uid"]}, // Passing the ID
                      );
                    },
                    child: Text(
                      "Selengkapnya",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "GasKonsul",
              style: TextStyle(
                fontFamily: 'Arial Rounded MT Bold',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade500,
              ),
            ),
            SizedBox(width: 30),

            // Search Bar
            Expanded(
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari',
                    suffixIcon: Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),

            // Profile Icon with Horizontal Half Rectangle
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: 80,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.zero,
                      bottomRight: Radius.zero,
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage('assets/images/gasKonsul_logo.png'),
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade50,
        toolbarHeight: 100.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Problem section ("Cerita" form)
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ada masalah apa?',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        'Ceritakan dan kami carikan orang yang tepat',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        maxLines: 1,
                        onChanged: (value) => controller.updateCerita(value),
                        decoration: InputDecoration(
                          hintText: 'Cerita',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 248, 233, 233),
                                width: 2.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.cariCounselor();
                        },
                        child: Text('Cari Konselor yang Cocok'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Obx(() {
                  if (controller.rekomendasiBidang.value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Rekomendasi Bidang: ${controller.rekomendasiBidang.value}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
                SizedBox(height: 16),
                Text(
                  'Kategori Konsultasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Obx(() => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.categories.map((category) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            child: ElevatedButton(
                              onPressed: () => controller
                                  .selectCategory(category["category"]),
                              child: Text(category["category"]),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.selectedCategory.value ==
                                            category["category"]
                                        ? Colors.blue
                                        : Colors.grey,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )),
                SizedBox(height: 16),
                Obx(() {
                  if (controller.selectedCategory.value.isNotEmpty) {
                    if (controller.filteredCounselors.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Tidak ada konsultan di kategori ini.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    return buildHorizontalCounselorList(
                        controller.filteredCounselors);
                  } else {
                    return Column(
                      children: controller.categories.map((category) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                category["category"]?.toString() ?? "Unknown",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade400),
                              ),
                            ),
                            SizedBox(
                              height: 190,
                              child: buildHorizontalCounselorList(
                                  category["counselors"] ?? []),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}
