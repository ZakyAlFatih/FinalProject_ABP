import 'package:get/get.dart';

class BerandaController extends GetxController {
  //TODO: Implement BerandaController

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
  var categories = [
    {
      "category": "Psikologi", // Changed from "name" to "category"
      "counselors": [
        {"name": "Adi S.Psi", "availability": "Mon-Wed"},
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
      selectedCategory.value = ""; // Uncheck the selection if the same category is pressed
    } else {
      selectedCategory.value = category; // Select the new category
    }
  }
}
