import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/chat_controller.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatController chatController = Get.put(ChatController());

  String senderId = FirebaseAuth.instance.currentUser!.uid;
  String senderName = FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown';
  String senderAvatar = FirebaseAuth.instance.currentUser!.photoURL ?? 'https://via.placeholder.com/50';

  // State untuk menyimpan counselor yang dipilih
  String? receiverId;
  String? receiverName;
  String? receiverAvatar;
  String? bookingId; // ID booking untuk memperbarui status
  String? scheduleId; // ID schedule untuk melepaskan jadwal

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        leading: receiverId != null
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    receiverId = null;
                  });
                },
              )
            : null,
        actions: receiverId != null
            ? [
                IconButton(
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    _completeSession(); // Tombol menyelesaikan sesi
                  },
                ),
              ]
            : null,
      ),
      body: receiverId == null ? _buildBookedCounselorList() : _buildChatUI(),
    );
  }

  // Tampilkan daftar konselor yang sudah dibooking oleh user
  Widget _buildBookedCounselorList() {
    return FutureBuilder<QuerySnapshot>(
      future: _firestore.collection('bookings')
          .where('userId', isEqualTo: senderId) // Ambil hanya booking dari user yang login
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        var bookingDocs = snapshot.data!.docs;

        if (bookingDocs.isEmpty) {
          return Center(
            child: Text(
              "Belum ada konselor yang dibooking",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          );
        }

        Set<String> uniqueCounselorIds = {};
        List<Map<String, dynamic>> uniqueCounselors = [];

        for (var doc in bookingDocs) {
          var data = doc.data() as Map<String, dynamic>;
          if (!uniqueCounselorIds.contains(data['counselorId'])) {
            uniqueCounselorIds.add(data['counselorId']);
            uniqueCounselors.add({
              'counselorId': data['counselorId'],
              'counselorName': data['counselorName'],
              'bookingId': doc.id, // Simpan bookingId
              'scheduleId': data['scheduleId'], // Simpan scheduleId
            });
          }
        }

        return ListView.builder(
          itemCount: uniqueCounselors.length,
          itemBuilder: (context, index) {
            var counselorData = uniqueCounselors[index];
            String counselorId = counselorData['counselorId'];
            String counselorName = counselorData['counselorName'];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://via.placeholder.com/50'),
              ),
              title: Text(counselorName),
              subtitle: Text("Chat dengan konselor ini"),
              onTap: () {
                setState(() {
                  receiverId = counselorId;
                  receiverName = counselorName;
                  receiverAvatar = 'https://via.placeholder.com/50';
                  bookingId = counselorData['bookingId']; // Simpan bookingId
                  scheduleId = counselorData['scheduleId']; // Simpan scheduleId
                });
              },
            );
          },
        );
      },
    );
  }

  Widget _buildChatUI() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('chats')
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              var messages = snapshot.data!.docs.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return (data['senderId'] == senderId && data['receiverId'] == receiverId) ||
                    (data['senderId'] == receiverId && data['receiverId'] == senderId);
              }).toList();

              return ListView(
                reverse: true,
                children: messages.reversed.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  bool isMe = data['senderId'] == senderId;
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        data['content'],
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    _firestore.collection('chats').add({
                      'senderId': senderId,
                      'receiverId': receiverId,
                      'content': _messageController.text,
                      'timestamp': Timestamp.now(),
                      'senderName': senderName,
                      'senderAvatar': senderAvatar,
                      'isRead': false,
                    });
                    _messageController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Fungsi untuk menyelesaikan sesi dan menghapus chat terkait
Future<void> _completeSession() async {
  if (bookingId == null || scheduleId == null || receiverId == null) {
    print("Error: Data sesi tidak lengkap!");
    return;
  }

  try {
    // Hapus dokumen booking
    await _firestore.collection('bookings').doc(bookingId).delete();

    // Set `isBooked = false` agar jadwal bisa dipakai kembali
    final scheduleSnapshot = await _firestore.collection('schedules')
        .where('scheduleId', isEqualTo: scheduleId)
        .get();

    if (scheduleSnapshot.docs.isNotEmpty) {
      for (var doc in scheduleSnapshot.docs) {
        await doc.reference.update({'isBooked': false});
      }
    }

    // Hapus semua chat yang berhubungan dengan sesi ini
    await _deleteChatHistory(senderId, receiverId!);

    // Perbarui daftar chat agar sesi yang sudah selesai tidak muncul lagi
    chatController.fetchChatList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sesi berhasil diselesaikan dan booking telah dihapus!"))
    );

  } catch (e) {
    print("Error saat menyelesaikan sesi: $e");
  }
}

  // Fungsi untuk menghapus semua chat terkait dengan sesi
  Future<void> _deleteChatHistory(String senderId, String receiverId) async {
    try {
      final chatSnapshot = await _firestore.collection('chats')
          .where('senderId', whereIn: [senderId, receiverId])
          .where('receiverId', whereIn: [senderId, receiverId])
          .get();

      if (chatSnapshot.docs.isEmpty) return;

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
}