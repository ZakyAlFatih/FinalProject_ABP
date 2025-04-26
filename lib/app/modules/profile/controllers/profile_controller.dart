import 'package:finpro_abpx/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var userData = {}.obs; // Observable map for user data

  // State for edit mode
  final isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data when the controller is initialized
  }

  // Fetch user data from Firestore
  void fetchUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      userData.value = userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Update profile data in Firestore
  Future<void> updateFirestoreProfile(String photoUrl, String name, String phone, String email) async {
    try {
      String uid = _auth.currentUser!.uid;
      Map<String, dynamic> updatedData = {
        'avatar': photoUrl,
        'name': name,
        'phone': phone,
        'email': email, // Pastikan email disertakan
      };
      await _firestore.collection('users').doc(uid).update(updatedData);
      userData.value = updatedData;
      Get.snackbar('Success', 'Profile updated successfully!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

  // Update password in Firebase Authentication
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      await user?.updatePassword(newPassword); // Update the password securely
    } catch (e) {
      if (e.toString().contains('requires-recent-login')) {
        Get.snackbar('Error', 'Please log in again to update your password.');
      } else {
        print('Failed to update password: $e');
      }
    }
  }

  // Full profile update handling (Firestore + Firebase Auth)
  Future<void> updateFullProfile({
    required String photoUrl,
    required String name,
    required String phone,
    required String email,
    String? password,
    String? confirmPassword,
  }) async {
    try {
      // Update Firestore profile details
      await updateFirestoreProfile(photoUrl, name, phone, email);

      // Validate and securely update password
      if (password != null && confirmPassword != null && password == confirmPassword) {
        await updatePassword(password);
      } else if (password != confirmPassword) {
        Get.snackbar('Error', 'Passwords do not match!');
      }

      isEditing.value = false; // Exit edit mode after successful updates
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }
  
  // Enable edit mode
  void enterEditMode() {
    isEditing.value = true;
  }

  // Exit edit mode
  void exitEditMode() {
    isEditing.value = false;
  }

  // Logout function
  void logout() async {
    try {
      await _auth.signOut(); // Sign out from Firebase Authentication
      Get.offAllNamed(Routes.LOGIN); // Navigate to the login page
      Get.snackbar('Logout', 'Berhasil keluar.');
    } catch (e) {
      Get.snackbar('Logout Error', 'Gagal logout: $e');
    }
  }
}