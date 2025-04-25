import 'package:finpro_abpx/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void logout() async {
    try {
      await _auth.signOut(); // Keluar dari Firebase Authentication
      Get.offAllNamed(Routes.LOGIN); // Arahkan ke halaman login
      Get.snackbar('Logout', 'Berhasil keluar.');
    } catch (e) {
      Get.snackbar('Logout Error', 'Gagal logout: $e');
    }
  }
}
