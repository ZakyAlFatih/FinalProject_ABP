import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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
  var categories = [
    {
      "category": "Psikologi", // Changed from "name" to "category"
      "counselors": [
        {"name": "Adi S.Psi", "availability": "Mon-Wed", "image": "assets/images/Adi_S.png"},
        {"name": "Hasna S.Psi", "availability": "Thu-Fri"},
        {"name": "Raka S.Psi", "availability": "Sat-Sun"},
      ],
    },
    {
      "category": "SDM", // Changed from "name" to "category"
      "counselors": [
        {"name": "Rina SDM", "availability": "Mon-Fri"},
        {"name": "Bima SDM", "availability": "Sat-Sun"},
      ],
    },
    {
      "category": "Bas",
    },
  ].obs; // Observable for reactivity

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
