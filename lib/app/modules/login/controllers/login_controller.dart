import 'package:get/get.dart';
import 'package:flutter/material.dart'; // <--- Tambahin ini
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finpro_abpx/app/modules/navbar/views/navbar_view.dart';
import 'package:finpro_abpx/app/routes/app_pages.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print("Email: $email"); // DEBUG
    print("Password: $password"); // DEBUG

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar("Login", "Welcome back!");
      Get.offAllNamed(Routes.NAVBAR); // ✅ ini benar
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      Get.snackbar("Login Error", e.message ?? "Login failed");
    } catch (e) {
      print("Generic Error: $e");
      Get.snackbar("Error", "An error occurred");
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
