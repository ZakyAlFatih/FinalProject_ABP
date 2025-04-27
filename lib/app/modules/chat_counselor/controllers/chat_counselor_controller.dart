import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatCounselorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable list untuk daftar chat
  var chats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChatList(); // Ambil daftar chat otomatis saat controller diinisialisasi
  }

  // Ambil daftar chat berdasarkan booking
  void fetchChatList() async {
    String currentUserId = _auth.currentUser!.uid;

    try {
      final bookingSnapshot = await _firestore.collection('bookings').get();

      List<Map<String, dynamic>> chatEntries = [];

      for (var bookingDoc in bookingSnapshot.docs) {
        final bookingData = bookingDoc.data();

        // Cek apakah user login sebagai pengguna atau konselor
        if (bookingData['userId'] == currentUserId || bookingData['counselorId'] == currentUserId) {
          chatEntries.add({
            'avatar': 'https://via.placeholder.com/50',
            'name': bookingData['counselorId'] == currentUserId ? bookingData['userName'] : bookingData['counselorName'],
            'message': 'Mulai percakapan dengan ${bookingData['counselorId'] == currentUserId ? bookingData['userName'] : bookingData['counselorName']}',
            'time': 'Baru saja',
            'isRead': false,
            'chatPartnerId': bookingData['counselorId'] == currentUserId ? bookingData['userId'] : bookingData['counselorId'],
          });
        }
      }

      chats.assignAll(chatEntries);
      print("Total daftar chat ditemukan: ${chats.length}");
    } catch (e) {
      print("Error mengambil daftar chat: $e");
    }
  }
}