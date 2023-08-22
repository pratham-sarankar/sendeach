import 'package:get/get.dart';

import '../data/services/auth_service.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/tabs/contacts_tab/bindings/contacts_tab_binding.dart';
import '../modules/home/tabs/contacts_tab/views/contacts_tab_view.dart';
import '../modules/home/tabs/home_tab/bindings/home_tab_binding.dart';
import '../modules/home/tabs/home_tab/views/home_tab_view.dart';
import '../modules/home/tabs/profile_tab/bindings/profile_tab_binding.dart';
import '../modules/home/tabs/profile_tab/views/profile_tab_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/sms/bindings/sms_binding.dart';
import '../modules/sms/views/sms_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final INITIAL =
      Get.find<AuthService>().isLoggedIn ? Routes.HOME : Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.SMS,
      page: () => const SmsView(),
      binding: SmsBinding(),
    ),
    GetPage(
      name: _Paths.HOME_TAB,
      page: () => const HomeTabView(),
      binding: HomeTabBinding(),
    ),
    GetPage(
      name: _Paths.CONTACTS_TAB,
      page: () => const ContactsTabView(),
      binding: ContactsTabBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_TAB,
      page: () => const ProfileTabView(),
      binding: ProfileTabBinding(),
    ),
  ];
}
