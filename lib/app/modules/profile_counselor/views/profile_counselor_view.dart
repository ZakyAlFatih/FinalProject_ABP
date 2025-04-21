import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_counselor_controller.dart';

class ProfileCounselorView extends GetView<ProfileCounselorController> {
  const ProfileCounselorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileCounselorView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfileCounselorView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
