import 'package:get/get.dart';

class ChatCounselorController extends GetxController {
  // List chat dengan data dummy
  final chats = [
    {
      'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
      'name': 'Hasna S.Psi',
      'message': 'Saran saya anda dapat berce..',
      'time': 'Kamis, 13:34',
      'isRead': false,
    },
    {
      'avatar': 'https://randomuser.me/api/portraits/men/2.jpg',
      'name': 'John Doe',
      'message': 'Okee, Terimakasih 🙏',
      'time': 'Senin, 09:46',
      'isRead': true,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Bisa fetch dari API nanti
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
