import 'package:get/get.dart';

import '../modules/conselor_profile/bindings/conselor_profile_binding.dart';
import '../modules/conselor_profile/views/conselor_profile_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile_edit/bindings/profile_edit_binding.dart';
import '../modules/profile_edit/views/profile_edit_view.dart';
import '../modules/rating_page/bindings/rating_page_binding.dart';
import '../modules/rating_page/views/rating_page_view.dart';
import '../modules/user_page/bindings/user_page_binding.dart';
import '../modules/user_page/views/user_page_view.dart';

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
      name: _Paths.USER_PAGE,
      page: () => const UserPageView(),
      binding: UserPageBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_EDIT,
      page: () => const ProfileEditView(),
      binding: ProfileEditBinding(),
    ),
    GetPage(
      name: _Paths.CONSELOR_PROFILE,
      page: () => const ConselorProfileView(),
      binding: ConselorProfileBinding(),
    ),
    GetPage(
      name: _Paths.RATING_PAGE,
      page: () => const RatingPageView(),
      binding: RatingPageBinding(),
    ),
  ];
}
