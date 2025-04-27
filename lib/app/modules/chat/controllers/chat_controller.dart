import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController extends GetxController {
  var chats = <Map<String, dynamic>>[].obs;
  var chatList = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    fetchChatList(); // Otomatis ambil daftar chat saat controller diinisialisasi
  }

  // Ambil daftar chat berdasarkan booking
  void fetchChatList() async {
    String currentUserId = _auth.currentUser!.uid;

    try {
      final bookingSnapshot = await _firestore.collection('bookings')
          .where('userId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'Booked') // Hanya ambil sesi yang masih aktif
          .get();

      List<Map<String, dynamic>> chatEntries = [];

      for (var bookingDoc in bookingSnapshot.docs) {
        final bookingData = bookingDoc.data();

        chatEntries.add({
          'chatPartnerId': bookingData['counselorId'],
          'chatPartnerName': bookingData['counselorName'],
          'status': bookingData['status'],
          'bookingId': bookingDoc.id,
          'scheduleId': bookingData['scheduleId'],
        });
      }

      chatList.assignAll(chatEntries); // Sekarang hanya sesi "Booked" yang ditampilkan
      print("Total chat ditemukan: ${chatList.length}");

    } catch (e) {
      print("Error mengambil daftar chat: $e");
    }
  }

  // Fungsi menyelesaikan sesi, mengubah status booking, dan menghapus chat terkait
  Future<void> completeBooking(String bookingId, String scheduleId, String senderId, String receiverId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'Completed',
      });

      await _firestore.collection('schedules')
          .where('scheduleId', isEqualTo: scheduleId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.update({'isBooked': false});
        }
      });

      await deleteChatHistory(senderId, receiverId);

      // Perbarui daftar chat agar sesi yang sudah selesai tidak muncul lagi
      fetchChatList();

      print("Sesi selesai, jadwal tersedia kembali, dan chat telah dihapus!");

    } catch (e) {
      print("Error saat menyelesaikan sesi: $e");
    }
  }

  // Fungsi untuk menghapus chat setelah sesi selesai
  Future<void> deleteChatHistory(String senderId, String receiverId) async {
    try {
      final chatSnapshot = await _firestore.collection('chats')
          .where('senderId', whereIn: [senderId, receiverId])
          .where('receiverId', whereIn: [senderId, receiverId])
          .get();

      if (chatSnapshot.docs.isEmpty) {
        print("Tidak ada pesan yang ditemukan untuk dihapus.");
        return;
      }

      WriteBatch batch = _firestore.batch();
      for (var doc in chatSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print("Semua pesan dalam sesi telah dihapus!");

    } catch (e) {
      print("Error saat menghapus chat: $e");
    }
  }

  // Kirim pesan ke Firestore
  void sendMessage(String senderId, String receiverId, String content, String senderName, String senderAvatar) {
    var message = {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': Timestamp.now(),
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'isRead': false,
    };

    _firestore.collection('chats').add(message);
  }
}