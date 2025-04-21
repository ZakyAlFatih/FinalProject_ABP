import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var chats = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ambil chat dari Firestore
  void fetchChats(String senderId, String receiverId) async {
    _firestore
        .collection('chats')
        .orderBy('timestamp')
        .snapshots()
        .listen((event) {
      // Filter pesan yang hanya milik dua user ini
      List<QueryDocumentSnapshot<Map<String, dynamic>>> filteredChats = event
          .docs
          .where((doc) =>
              (doc['senderId'] == senderId &&
                  doc['receiverId'] == receiverId) ||
              (doc['senderId'] == receiverId && doc['receiverId'] == senderId))
          .toList();

      // Update list dengan hasil yang sudah difilter
      chats.value = filteredChats.map((doc) {
        var data = doc.data();
        return {
          'senderId': data['senderId'],
          'receiverId': data['receiverId'],
          'senderName': data['senderName'],
          'message': data['content'],
          'time': (data['timestamp'] as Timestamp).toDate().toString(),
          'avatar': data['senderAvatar'],
          'isRead': data['isRead'],
        };
      }).toList();
    });
  }

  // Fungsi untuk mengupdate chat ke dalam list
  void _updateChats(QuerySnapshot<Map<String, dynamic>> event) {
    for (var doc in event.docs) {
      var data = doc.data();
      chats.add({
        'senderId': data['senderId'],
        'receiverId': data['receiverId'],
        'senderName': data['senderName'],
        'message': data['content'],
        'time': (data['timestamp'] as Timestamp).toDate().toString(),
        'avatar': data['senderAvatar'],
        'isRead': data['isRead'],
      });
    }
  }

  // Kirim pesan ke Firestore
  void sendMessage(String senderId, String receiverId, String content,
      String senderName, String senderAvatar) {
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
