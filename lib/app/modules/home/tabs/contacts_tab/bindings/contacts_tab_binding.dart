import 'package:get/get.dart';

import '../controllers/contacts_tab_controller.dart';

class ContactsTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactsTabController>(
      () => ContactsTabController(),
    );
  }
}
