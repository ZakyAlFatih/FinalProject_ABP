import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final HistoryController controller = Get.find<HistoryController>();

  @override
  void initState() {
    super.initState();
    controller.fetchBookingHistory(); // Data di-refresh setiap kali widget diakses
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.blue.shade500),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Riwayat",
            style: TextStyle(
              fontFamily: 'Arial Rounded MT Bold',
              fontSize: 24,
              color: Colors.blue.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue.shade50,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Obx(() {
          // Tampilkan indikator loading saat data di-fetch
          if (controller.isFetching.value) {
            return Center(child: CircularProgressIndicator(color: Colors.blue.shade500));
          }

          // Periksa apakah pengguna memiliki riwayat booking
          if (controller.bookingHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/gasKonsul_logo.png',
                    width: 150.0,
                    height: 150.0,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "MAAF",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade500,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Riwayat anda masih kosong",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Harap pesan konselor terlebih dahulu",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // daftar riwayat booking dalam bentuk card
          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: controller.bookingHistory.length,
            itemBuilder: (context, index) {
              final history = controller.bookingHistory[index];
              return Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade500,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(history.counselorName),
                  subtitle: Text("${history.counselorBidang} • ${history.day}, ${history.time}"),
                ),
              );
            },
          );
        }),
        backgroundColor: Colors.white,
      ),
    );
  }
}