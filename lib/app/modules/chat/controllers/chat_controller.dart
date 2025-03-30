// import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var chats = [
    {
      'name': 'Hasna S.Psi',
      'message': 'Saran saya anda dapat berce..',
      'time': 'Kamis, 13:34',
      'avatar': 'https://via.placeholder.com/50',
      'isRead': false,
    },
    {
      'name': 'Adi S.Psi',
      'message': 'Anda: Okee, Terimakasih 🙏',
      'time': 'Senin, 09:46',
      'avatar': 'https://via.placeholder.com/50',
      'isRead': true,
    },
  ].obs;
}
