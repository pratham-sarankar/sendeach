import 'package:get/get.dart';
import 'package:ja/app/modules/home/tabs/contacts_tab/controllers/contacts_tab_controller.dart';
import 'package:ja/app/modules/home/tabs/home_tab/controllers/home_tab_controller.dart';
import 'package:ja/app/modules/home/tabs/profile_tab/controllers/profile_tab_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<HomeTabController>(() => HomeTabController());
    Get.lazyPut<ContactsTabController>(() => ContactsTabController());
    Get.lazyPut<ProfileTabController>(() => ProfileTabController());
  }
}
