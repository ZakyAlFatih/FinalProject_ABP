import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finpro_abpx/app/routes/app_pages.dart';

class ProfileCounselorController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userData = {}.obs; 
  final isEditing = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Ambil data counselor dari Firestore
  Future<void> fetchUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('counselors').doc(uid).get();
      if (userDoc.exists) {
        userData.value = userDoc.data() as Map<String, dynamic>;
      } else {
        userData.value = {};
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data: $e');
    }
  }

  // Tambah `scheduleIdX` saat pertama kali mengisi `availability_dayX` dan `availability_timeX` dengan `isBooked: false`
  Future<void> createScheduleIfNotExists(String scheduleKey) async {
    try {
      String uid = _auth.currentUser!.uid;
      String scheduleId = userData[scheduleKey] ?? '';

      if (scheduleId.isEmpty) {
        // Jika belum ada `scheduleId`, buat dokumen baru di `schedules`
        DocumentReference newScheduleRef = await _firestore.collection('schedules').add({
          'scheduleId': '',
          'counselorId': uid,
          'isBooked': false, // Tambahkan isBooked dengan nilai false
        });

        String newScheduleId = newScheduleRef.id;
        await newScheduleRef.update({'scheduleId': newScheduleId});

        // Simpan `scheduleIdX` di koleksi `counselors`
        await _firestore.collection('counselors').doc(uid).update({scheduleKey: newScheduleId});
        userData[scheduleKey] = newScheduleId;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat jadwal: $e');
    }
  }

  // Update profil tanpa mengubah fitur lain, tetap menyimpan `scheduleIdX`
  Future<void> updateFirestoreProfile({
    required String photoUrl,
    required String name,
    required String phone,
    required String email,
    required Map<String, dynamic> availability,
    required String about,
  }) async {
    try {
      String uid = _auth.currentUser!.uid;
      Map<String, dynamic> updatedData = {
        'avatar': photoUrl,
        'name': name,
        'phone': phone,
        'email': email,
        'availability_day1': availability['day1'],
        'availability_time1': availability['time1'],
        'availability_day2': availability['day2'],
        'availability_time2': availability['time2'],
        'availability_day3': availability['day3'],
        'availability_time3': availability['time3'],
        'scheduleId1': userData['scheduleId1'] ?? '',
        'scheduleId2': userData['scheduleId2'] ?? '',
        'scheduleId3': userData['scheduleId3'] ?? '',
        'about': about,
      };

      await _firestore.collection('counselors').doc(uid).update(updatedData);
      userData.value = updatedData;

      // Pastikan `scheduleIdX` dibuat jika belum ada
      createScheduleIfNotExists('scheduleId1');
      createScheduleIfNotExists('scheduleId2');
      createScheduleIfNotExists('scheduleId3');

      Get.snackbar('Success', 'Profil berhasil diperbarui!');
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e');
    }
  }

  // `updateFullProfile`
  Future<void> updateFullProfile({
    required String photoUrl,
    required String name,
    required String phone,
    required String email,
    String? password,
    String? confirmPassword,
    required Map<String, dynamic> availability,
    required String about,
  }) async {
    try {
      await updateFirestoreProfile(
        photoUrl: photoUrl,
        name: name,
        phone: phone,
        email: email,
        availability: availability,
        about: about,
      );

      if (password != null && confirmPassword != null && password == confirmPassword) {
        await updatePassword(password);
      } else if (password != confirmPassword) {
        Get.snackbar('Error', 'Passwords do not match!');
      }

      isEditing.value = false; 
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e');
    }
  }

  // Mode edit
  void enterEditMode() {
    isEditing.value = true;
  }

  void exitEditMode() {
    isEditing.value = false;
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      await user?.updatePassword(newPassword);
    } catch (e) {
      if (e.toString().contains('requires-recent-login')) {
        Get.snackbar('Error', 'Harap login ulang sebelum mengganti password.');
      } else {
        Get.snackbar('Error', 'Gagal memperbarui password.');
      }
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar('Logout', 'Anda telah logout.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal logout: $e');
    }
  }
}