// import 'package:finpro_abpx/app/modules/navbar/views/navbar_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/beranda_controller.dart';
import '../../navbar/views/navbar_view.dart';

class BerandaView extends GetView<BerandaController> {
  const BerandaView({super.key});

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
              )
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
            // Profile Icon
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/gasKonsul_logo.png'), // Replace with actual image path
              radius: 20, // Adjust size of the avatar
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade50, // AppBar background color
        toolbarHeight: 100.0, // Increase AppBar height for better UI
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Problem section ("Cerita" form)
              Obx(() => Container(
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
                          )
                        ),
                        SizedBox(height: 3.0),

                        Text(
                          'Ceritakan dan kami carikan orang yang tepat',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 18, 
                            color: Colors.white),
                        ),
                        SizedBox(height: 8.0),

                        TextField(
                          maxLines: 1,
                          onChanged: (value) => controller.updateCerita(value),
                          decoration: InputDecoration(
                            hintText: 'Cerita',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0), // Rounded corners
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                            ),
                            // Make the input field white
                            filled: true, // Enables the background color
                            fillColor: Colors.white, // Sets the background color to white
                          ),
                        ),
                        SizedBox(height: 8.0),

                        Text(
                          'Your Story: ${controller.cerita.value}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 16),

              // Categories
              Text('Kategori Konsultasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

              // Consultant Profiles
              Text(
                'Konsultan Tersedia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Vertical Scrolling: Categories
              Expanded(
                child: Obx(() => ListView.builder(
                  itemCount: controller.categories.length, // Assuming categories are managed in your controller
                  itemBuilder: (context, categoryIndex) {
                    final category = controller.categories[categoryIndex];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Title
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            category["category"]?.toString() ?? "Unknown", // Cast to String for safety
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade400,
                            ),
                          ),
                        ),
                        // Horizontal Scrolling: Counselors
                        SizedBox(
                          height: 150, // Height for horizontal scrolling
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (category["counselors"] as List?)?.length ?? 0, // Number of counselors in this category
                            itemBuilder: (context, counselorIndex) {
                              final counselor = (category["counselors"] as List?)?[counselorIndex];
                              return Card(
                                // elevation: 2.0,
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width: 130, // Adjust card width
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50, // Background color for the card
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // CircleAvatar to display counselor's profile image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10), // Adjust for rounded corners
                                        child: Image.asset(
                                          counselor["image"] ?? 'assets/images/gasKonsul_logo.png', // Placeholder image
                                          fit: BoxFit.cover, // Ensures the image fills the shape
                                          width: 80, // Set the width
                                          height: 80, // Set the height
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
                                      // Counselor's availability details
                                      Text(
                                        counselor["availability"] ?? "Unknown",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                )),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavbarView(),
    );
  }
}