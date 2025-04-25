import 'package:finpro_abpx/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userData = {}.obs;

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

  Future<void> fetchUserData() async {
    try {
      String? uid = _auth.currentUser?.uid; // Ambil UID pengguna
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in.');
        return;
      }

      // Ambil data Firestore berdasarkan UID
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        userData.value = userDoc.data() ?? {}; // Simpan data ke variabel reaktif
      } else {
        Get.snackbar('Error', 'User not found in database.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }
}
