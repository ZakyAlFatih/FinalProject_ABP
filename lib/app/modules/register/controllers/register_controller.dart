import 'package:get/get.dart';

class RegisterController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;
  var isPasswordHidden = true.obs;
  var isAgreed = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void signUp() {
    if (!isAgreed.value) {
      Get.snackbar("Error", "You must agree to the terms and conditions");
      return;
    }
    if (password.value != confirmPassword.value) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }
    // Simulate sign-up process
    Get.snackbar("Success", "Account created successfully");
  }
}
