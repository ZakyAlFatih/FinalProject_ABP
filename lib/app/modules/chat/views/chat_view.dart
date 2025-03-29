import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SafeArea(
        child: Obx(() => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.chats.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                var chat = controller.chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(chat['avatar'] as String),
                  ),
                  title: Text(
                    chat['name'] as String,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chat['message'] as String),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(chat['time'] as String,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      if (chat['isRead'] as bool)
                        const Icon(Icons.check, color: Colors.blue, size: 16),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
