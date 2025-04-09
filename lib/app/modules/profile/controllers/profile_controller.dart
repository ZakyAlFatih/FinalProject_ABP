import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Menentukan apakah sedang dalam mode edit profil
  final isEditing = false.obs;

  // Fungsi untuk mengaktifkan mode edit
  void enterEditMode() {
    isEditing.value = true;
  }

  // Fungsi untuk keluar dari mode edit
  void exitEditMode() {
    isEditing.value = false;
  }
}
