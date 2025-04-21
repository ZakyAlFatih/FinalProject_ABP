import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_counselor_controller.dart';

class ChatCounselorView extends GetView<ChatCounselorController> {
  const ChatCounselorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ChatCounselor',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/300', // bisa diganti avatar user login
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: controller.chats.length,
            separatorBuilder: (context, index) => const Divider(
              height: 1,
              indent: 70,
              endIndent: 20,
            ),
            itemBuilder: (context, index) {
              final chat = controller.chats[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(chat['avatar'] as String),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      chat['time'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        chat['message'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (chat['isRead'] as bool)
                      const Icon(Icons.check, color: Colors.blue, size: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
