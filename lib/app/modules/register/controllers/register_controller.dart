import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isPasswordHidden = true.obs;
  var isAgreed = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name.value,
        'email': email.value.trim(),
        'role': 'user', // default role user
        'avatar': null, // bisa diisi nanti jika ada upload
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Success", "Account created successfully");
      Get.back(); // Balik ke halaman login
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Error", "An error occurred");
    }
  }
}
