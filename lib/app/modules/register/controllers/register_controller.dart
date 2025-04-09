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
      await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value.trim(),
      );

      Get.snackbar("Success", "Account created successfully");
      Get.back(); // Balik ke halaman login
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } catch (e) {
      Get.snackbar("Error", "An error occurred");
    }
  }
}
