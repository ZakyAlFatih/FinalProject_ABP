import 'package:get/get.dart';

class LoginController extends GetxController {
  // Reactive variable for password visibility
  var isPasswordHidden = true.obs;

  // Reactive variables for email and password (to store input)
  var email = ''.obs;
  var password = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Method to handle login (placeholder)
  void login() {
    // Add your login logic here (e.g., API call)
    print(
        'Logging in with email: ${email.value} and password: ${password.value}');
    // Example: Show a snackbar
    Get.snackbar('Login', 'Login button pressed!');
  }

  // Methods for social media login (placeholders)
  void googleLogin() {
    print('Logging in with Google');
    Get.snackbar('Google Login', 'Google login pressed!');
  }

  void appleLogin() {
    print('Logging in with Apple');
    Get.snackbar('Apple Login', 'Apple login pressed!');
  }

  void facebookLogin() {
    print('Logging in with Facebook');
    Get.snackbar('Facebook Login', 'Facebook login pressed!');
  }
}
