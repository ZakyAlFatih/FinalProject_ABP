import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finpro_abpx/app/routes/app_pages.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      // Cek apakah user ini counselor
      DocumentSnapshot counselorDoc =
          await _firestore.collection('counselors').doc(uid).get();

      if (counselorDoc.exists) {
        // Jika counselor, arahkan ke chat_counselor_view
        Get.offAllNamed(
            Routes.NAVBAR_COUNSELOR); // Pastikan ini sudah ada di routes
      } else {
        // Jika user biasa, arahkan ke NAVBAR
        Get.offAllNamed(Routes.NAVBAR);
      }

      Get.snackbar("Login", "Welcome back!");
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Login failed");
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred");
    }
  }

  void googleLogin() {
    Get.snackbar("Google Login", "Google login not implemented yet.");
  }

  void appleLogin() {
    Get.snackbar("Apple Login", "Apple login not implemented yet.");
  }

  void facebookLogin() {
    Get.snackbar("Facebook Login", "Facebook login not implemented yet.");
  }
}
