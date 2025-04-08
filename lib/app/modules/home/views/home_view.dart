import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

Widget buildHorizontalCounselorList(List<dynamic> counselors) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: counselors.length,
    itemBuilder: (context, index) {
      final counselor = counselors[index];
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        elevation: 2,
        child: Container(
          height: 190,
          width: 130, // Adjust card width
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
                  counselor["image"] ?? 'assets/images/gasKonsul_logo.png', // Placeholder image
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
                counselor["availability"] ?? "Unknown",
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
                    Get.snackbar(
                      'Selengkapnya Pressed',
                      '${counselor["name"] ?? "Unknown"}\'s Selengkapnya was pressed!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.blue.shade100,
                      colorText: Colors.black,
                      duration: Duration(seconds: 2),
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
    },
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
            // App Name
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
                height: 30, // Set the height of the search bar
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, // Soft shadow
                      blurRadius: 4.0, // Blur effect
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari', // Placeholder text
                    suffixIcon: Icon(Icons.search, color: Colors.grey), // Search icon on the right
                    filled: true,
                    fillColor: Colors.white, // White background for input field
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rounded corners
                      borderSide: BorderSide.none, // No border line
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Adjust padding
                  ),
                ),
              ),
            ),
            SizedBox(width: 10), // Spacing between search bar and profile icon

            // Profile Icon with Horizontal Half Rectangle
            Stack(
              alignment: Alignment.centerLeft, // Align both layers horizontally
              children: [
                // Background Shape (Horizontal Half Rectangle)
                Container(
                  width: 80, // Length extending to the right
                  height: 55, // Height of the background shape
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100, // Background color
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), // Rounded top left corner
                      bottomLeft: Radius.circular(30), // Rounded bottom left corner
                      topRight: Radius.zero, // Straight edge at the top right
                      bottomRight: Radius.zero, // Straight edge at the bottom right
                    ), // Creates the "half rectangle" effect extending to the right
                  ),
                ),
                Positioned(
                  left: 10,
                  // Circular Profile Image
                  child: CircleAvatar(
                  radius: 20, // Radius of the circular profile image
                  backgroundImage: AssetImage('assets/images/gasKonsul_logo.png'), // Replace with your image asset
                )),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade50, // AppBar background color
        toolbarHeight: 100.0, // Increase AppBar height for better UI
      ),
      body: SafeArea(
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
                      onChanged: (value) => controller.updateCerita(value), // Updates "cerita"
                      decoration: InputDecoration(
                        hintText: 'Cerita',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0), // Rounded corners
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.white, width: 2.0),
                        ),
                        filled: true,
                        fillColor: Colors.white, // Sets the background color to white
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Categories
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
                        onPressed: () => controller.selectCategory(category["category"] as String), // Use category name
                        child: Text(category["category"] as String), // Display category name
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.selectedCategory.value == category["category"]
                              ? Colors.blue
                              : Colors.grey, // Highlight the selected category
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
              SizedBox(height: 16),

              // Vertical Scrolling: Categories
              Expanded(
                child: Obx(() {
                  // Check if a category is selected
                  if (controller.selectedCategory.value.isNotEmpty) {
                    // Filtered Display: Show counselors for the selected category horizontally
                    if (controller.filteredCounselors.isEmpty) {
                      return Center(
                        child: Text(
                          "Tidak ada konsultan di kategori ini.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        SizedBox(      
                          height: 190, // Set height for horizontal scrolling
                          child: buildHorizontalCounselorList(controller.filteredCounselors),
                        ),
                      ]
                    );
                  } else {
                    // Unfiltered Display: Show all categories vertically, counselors horizontally
                    return ListView.builder(
                      itemCount: controller.categories.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = controller.categories[categoryIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Title
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                category["category"]?.toString() ?? "Unknown", // Category name
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade400,
                                ),
                              ),
                            ),
                            // Horizontal Scrolling Counselors
                            SizedBox(
                              height: 190, // Set height for horizontal scrolling
                              child: buildHorizontalCounselorList(category["counselors"] as List? ?? []),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}