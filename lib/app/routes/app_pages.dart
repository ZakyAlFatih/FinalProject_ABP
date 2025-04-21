import 'package:get/get.dart';

import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/chat_counselor/bindings/chat_counselor_binding.dart';
import '../modules/chat_counselor/views/chat_counselor_view.dart';
import '../modules/counselor/bindings/counselor_binding.dart';
import '../modules/counselor/views/counselor_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/navbar/bindings/navbar_binding.dart';
import '../modules/navbar/views/navbar_view.dart';
import '../modules/navbar_counselor/bindings/navbar_counselor_binding.dart';
import '../modules/navbar_counselor/views/navbar_counselor_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_counselor/bindings/profile_counselor_binding.dart';
import '../modules/profile_counselor/views/profile_counselor_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/register_counselor/bindings/register_counselor_binding.dart';
import '../modules/register_counselor/views/register_counselor_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR,
      page: () => const NavbarView(),
      binding: NavbarBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.COUNSELOR,
      page: () => const CounselorView(),
      binding: CounselorBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_COUNSELOR,
      page: () => const ChatCounselorView(),
      binding: ChatCounselorBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER_COUNSELOR,
      page: () => const RegisterCounselorView(),
      binding: RegisterCounselorBinding(),
    ),
    GetPage(
      name: _Paths.NAVBAR_COUNSELOR,
      page: () => const NavbarCounselorView(),
      binding: NavbarCounselorBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_COUNSELOR,
      page: () => const ProfileCounselorView(),
      binding: ProfileCounselorBinding(),
    ),
  ];
}
