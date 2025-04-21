import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterCounselorController extends GetxController {
  var name = ''.obs;
  var bidang = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isPasswordHidden = true.obs;
  var isAgreed = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void signUp() async {
    if (!isAgreed.value) {
      Get.snackbar("Error", "You must agree to the terms and conditions");
      return;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      // Buat akun dengan Firebase Auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      final uid = userCredential.user!.uid;

      // Simpan data tambahan ke Firestore
      await FirebaseFirestore.instance.collection('counselors').doc(uid).set({
        'name': name.value.trim(),
        'email': email.value.trim(),
        'bidang': bidang.value.trim(),
        'role': 'counselor', // ✅ Ditambahkan field role
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Counselor account created successfully");
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Error", "An error occurred");
    }
  }
}
