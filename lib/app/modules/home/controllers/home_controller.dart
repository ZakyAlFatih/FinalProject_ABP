import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var categories = <Map<String, dynamic>>[].obs; // Observable for dynamic categories

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchCategories();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Observable variables
  var cerita = "".obs; // Stores the input from the "Cerita" field
  var selectedCategory = "".obs; // Stores the selected category
  var filteredCounselors = [].obs;
  
  // Fetch categories and counselors from Firestore
  Future<void> fetchCategories() async {
  try {
    QuerySnapshot querySnapshot = await _firestore.collection('counselors').get(); // Fetch all documents
    Map<String, dynamic> groupedByBidang = {}; // Temporary map for grouping counselors by bidang

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final bidang = data['bidang'] ?? 'Unknown Bidang'; // Fallback for missing bidang

      if (!groupedByBidang.containsKey(bidang)) {
        groupedByBidang[bidang] = []; // Initialize the list for this bidang
      }

      // Extract availability days and times explicitly
      String availabilityDay1 = (data['availability_day1']?.trim().isEmpty ?? true) 
          ? 'Unknown' 
          : data['availability_day1'];

      String availabilityTime1 = (data['availability_time1']?.trim().isEmpty ?? true) 
          ? 'Unknown Time' 
          : data['availability_time1'];

      String availabilityDay2 = (data['availability_day2']?.trim().isEmpty ?? true) 
          ? 'Unknown' 
          : data['availability_day2'];

      String availabilityTime2 = (data['availability_time2']?.trim().isEmpty ?? true) 
          ? 'Unknown Time' 
          : data['availability_time2'];

      String availabilityDay3 = (data['availability_day3']?.trim().isEmpty ?? true) 
          ? 'Unknown' 
          : data['availability_day3'];

      String availabilityTime3 = (data['availability_time3']?.trim().isEmpty ?? true) 
          ? 'Unknown Time' 
          : data['availability_time3'];

      // Add counselor with explicit separation of days and times
      groupedByBidang[bidang].add({
        "name": data['name'] ?? 'Unknown',
        "availability": {
          "day1": availabilityDay1,
          "time1": availabilityTime1,
          "day2": availabilityDay2,
          "time2": availabilityTime2,
          "day3": availabilityDay3,
          "time3": availabilityTime3,
        },
        "image": data['image'] ?? 'assets/images/gasKonsul_logo.png', // Default placeholder
        "email": data['email'] ?? 'No Email',
      });
    }

    // Transform grouped map into the expected list structure
    categories.value = groupedByBidang.entries.map((entry) {
      return {
        "category": entry.key, // Bidang name
        "counselors": entry.value, // List of counselors under this bidang
      };
    }).toList();

  } catch (e) {
    Get.snackbar('Error', 'Failed to fetch counselors: $e');
  }
}

  // Method to update "Cerita"
  void updateCerita(String value) {
    cerita.value = value;
  }

  // Method to select a category
  void selectCategory(String category) {
    if (selectedCategory.value == category) {
      // If the selected category is tapped again, reset the filter
      selectedCategory.value = ''; // Clear the selected category
      filteredCounselors.value = categories
          .expand((cat) => (cat["counselors"] as List<dynamic>? ?? [])) // Safely cast and handle null
          .toList();
    } else {
      // Otherwise, apply the filter for the tapped category
      selectedCategory.value = category; // Set the selected category
      filteredCounselors.value = (categories
          .firstWhere(
            (cat) => cat["category"] == category,
            orElse: () => {"counselors": []}, // Fallback: empty map
          )["counselors"] as List<dynamic>? ?? []); // Safely cast and handle null
    }
  }
}
