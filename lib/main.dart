import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/routes/app_pages.dart'; // Sesuaikan dengan path app_routes Anda

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    debugPrint("Firebase initialized");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("Building MyApp...");

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes
          .LOGIN, // Anda bisa sesuaikan dengan halaman awal yang diinginkan
      getPages: AppPages.routes,
    );
  }
}
