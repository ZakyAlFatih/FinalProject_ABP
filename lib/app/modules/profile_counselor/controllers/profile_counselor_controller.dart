import 'package:finpro_abpx/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileCounselorController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userData = {}.obs; // Observable map for user data
  final isEditing = false.obs; // State for edit mode

  @override
  void onInit() {
    super.onInit();
    fetchUserData(); // Fetch user data when the controller is initialized
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('counselors').doc(uid).get();
      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
        print('User data fetched successfully.');
      } else {
        print('No user found for the given UID.');
        userData.value = {};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      Get.snackbar('Error', 'Failed to fetch user data: $e');
    }
  }

  // Update profile data in Firestore
  Future<void> updateFirestoreProfile({
    required String photoUrl,
    required String name,
    required String phone,
    required String email,
    required Map<String, dynamic> availability, // Include availability
  }) async {
    try {
      String uid = _auth.currentUser!.uid;
      Map<String, dynamic> updatedData = {
        'avatar': photoUrl,
        'name': name,
        'phone': phone,
        'email': email,
        'availability_day1': availability['day1'] ?? 'Unknown',
        'availability_time1': availability['time1'] ?? 'Unknown Time',
        'availability_day2': availability['day2'] ?? 'Unknown',
        'availability_time2': availability['time2'] ?? 'Unknown Time',
        'availability_day3': availability['day3'] ?? 'Unknown',
        'availability_time3': availability['time3'] ?? 'Unknown Time',
      };

      await _firestore.collection('counselors').doc(uid).update(updatedData);
      userData.value = updatedData; // Merge updated data with current user data
      ;
      Get.snackbar('Success', 'Profile updated successfully!');
    } catch (e) {
      print('Error updating profile in Firestore: $e');
      Get.snackbar('Error', 'Failed to update profile: $e');
    }
  }

  // Update password in Firebase Authentication
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      await user?.updatePassword(newPassword);
    } catch (e) {
      if (e.toString().contains('requires-recent-login')) {
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
    required Map<String, dynamic> availability, // Add availability parameter
  }) async {
    try {
      // Update Firestore profile details
      await updateFirestoreProfile(
        photoUrl: photoUrl,
        name: name,
        phone: phone,
        email: email,
        availability: availability,
      );

      // Validate and securely update password
      if (password != null && confirmPassword != null && password == confirmPassword) {
        await updatePassword(password);
      } else if (password != confirmPassword) {
        Get.snackbar('Error', 'Passwords do not match!');
      }

      isEditing.value = false; // Exit edit mode after successful updates
    } catch (e) {
      print('Error during full profile update: $e');
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
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar('Logout', 'You have logged out successfully.');
    } catch (e) {
      print('Failed to logout: $e');
      Get.snackbar('Logout Error', 'Failed to logout: $e');
    }
  }
}