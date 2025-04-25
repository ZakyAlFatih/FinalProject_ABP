import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Content with padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Logo
                    Image.asset('assets/images/gasKonsul_logo.png',
                        width: 80, height: 80),
                    const SizedBox(height: 10),
                    // App Name
                    const Text(
                      "GasKonsul",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 5),
                    // Welcome Text
                    const Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // Email Input
                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 15),
                    // Password Input
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.isPasswordHidden.value,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              controller.togglePasswordVisibility();
                            },
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(
                              '/register'); // atau Routes.REGISTER kalau pakai routes auto-generated
                        },
                        child: const Text("Sign Up",
                            style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.login();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text("Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register-counselor');
                          },
                          child: const Text(
                            "Sign Up as Counselor",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Social Media Login with Background (outside Padding)
              SizedBox(
                width: double.infinity, // Ensure full width
                height: 300, // Adjust height as needed
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/rec1.png',
                        width: double.infinity,
                        fit: BoxFit.cover, // Ensure image covers the area
                      ),
                    ),
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/rec2.png',
                        fit: BoxFit.cover, // Ensure image covers the area
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _socialButton(
  //     String imagePath, Color backgroundColor, VoidCallback onTap) {
  //   return InkWell(
  //     onTap: onTap,
  //     child: CircleAvatar(
  //       radius: 22,
  //       backgroundColor: backgroundColor,
  //       child: Image.asset(imagePath, width: 24, height: 24),
  //     ),
  //   );
  // }
}
