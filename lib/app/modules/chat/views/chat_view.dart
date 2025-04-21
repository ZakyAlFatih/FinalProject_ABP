import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();

  String senderId = FirebaseAuth.instance.currentUser!.uid;
  String senderName =
      FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown';
  String senderAvatar = FirebaseAuth.instance.currentUser!.photoURL ??
      'https://via.placeholder.com/50';

  // State untuk menyimpan counselor yang dipilih
  String? receiverId;
  String? receiverName;
  String? receiverAvatar;

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
      ),
      body: receiverId == null ? _buildCounselorList() : _buildChatUI(),
    );
  }

  Widget _buildCounselorList() {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('counselors')
          .where('role', isEqualTo: 'counselor')
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        var docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var doc = docs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://via.placeholder.com/50'),
              ),
              title: Text(doc['name']),
              subtitle: Text(doc['bidang'] ?? ''),
              onTap: () {
                setState(() {
                  receiverId = doc.id;
                  receiverName = doc['name'];
                  receiverAvatar = 'https://via.placeholder.com/50';
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
            stream: FirebaseFirestore.instance
                .collection('chats')
                .orderBy('timestamp')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              var messages = snapshot.data!.docs.where((doc) {
                var data = doc.data() as Map<String, dynamic>;
                return (data['senderId'] == senderId &&
                        data['receiverId'] == receiverId) ||
                    (data['senderId'] == receiverId &&
                        data['receiverId'] == senderId);
              }).toList();

              return ListView(
                reverse: true,
                children: messages.reversed.map((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  bool isMe = data['senderId'] == senderId;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
