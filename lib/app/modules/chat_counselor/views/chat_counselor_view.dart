import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_counselor_controller.dart';

class ChatCounselorView extends StatefulWidget {
  const ChatCounselorView({super.key});

  @override
  State<ChatCounselorView> createState() => _ChatCounselorViewState();
}

class _ChatCounselorViewState extends State<ChatCounselorView> {
  final controller = Get.put(ChatCounselorController());
  final TextEditingController _messageController = TextEditingController();

  String senderId = FirebaseAuth.instance.currentUser!.uid;
  String senderName = FirebaseAuth.instance.currentUser!.displayName ?? 'User';
  String senderAvatar = FirebaseAuth.instance.currentUser!.photoURL ?? 'https://via.placeholder.com/50';

  String? receiverId;
  String? receiverName;
  String? receiverAvatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          receiverName ?? 'Chat Counselor',
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: receiverId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  setState(() {
                    receiverId = null;
                  });
                },
              )
            : null,
      ),
      body: receiverId == null ? _buildBookedUserList() : _buildChatUI(),
    );
  }

  // Tampilkan daftar user yang sudah membooking konselor
  Widget _buildBookedUserList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('bookings')
          .where('counselorId', isEqualTo: senderId) // Hanya ambil user yang membooking konselor ini
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        var bookingDocs = snapshot.data!.docs;

        if (bookingDocs.isEmpty) {
          return const Center(
            child: Text(
              "Belum ada user yang membooking Anda",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          );
        }

        // Gunakan Set untuk memastikan hanya satu user per counselor
        Set<String> uniqueUserIds = {};
        List<Map<String, dynamic>> uniqueUsers = [];

        for (var doc in bookingDocs) {
          var data = doc.data() as Map<String, dynamic>;
          if (!uniqueUserIds.contains(data['userId'])) {
            uniqueUserIds.add(data['userId']);
            uniqueUsers.add({
              'userId': data['userId'],
              'userName': data['userName'],
            });
          }
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: uniqueUsers.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 70, endIndent: 20),
          itemBuilder: (context, index) {
            var userData = uniqueUsers[index];
            String userId = userData['userId'];
            String userName = userData['userName'];

            return ListTile(
              onTap: () {
                setState(() {
                  receiverId = userId;
                  receiverName = userName;
                  receiverAvatar = 'https://via.placeholder.com/50';
                });
              },
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://via.placeholder.com/50'),
              ),
              title: Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Klik untuk mulai chat'),
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
            stream: FirebaseFirestore.instance
                .collection('chats')
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
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
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        data['content'],
                        style: TextStyle(color: isMe ? Colors.white : Colors.black),
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
                  decoration: const InputDecoration(
                    hintText: 'Ketik pesan...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection('chats').add({
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
              )
            ],
          ),
        ),
      ],
    );
  }
}