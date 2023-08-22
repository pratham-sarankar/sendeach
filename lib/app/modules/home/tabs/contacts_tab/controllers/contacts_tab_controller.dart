import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsTabController extends GetxController
    with StateMixin<List<Contact>> {
  late TextEditingController searchController;
  late Rx<PermissionStatus> permissionStatus;

  @override
  void onInit() {
    searchController = TextEditingController();
    initialize();
    super.onInit();
  }

  void initialize() async {
    permissionStatus = Rx(await Permission.contacts.request());
    var contacts = RxList(await ContactsService.getContacts(
      withThumbnails: true,
      orderByGivenName: true,
    ));
    change(contacts,
        status: contacts.isEmpty ? RxStatus.empty() : RxStatus.success());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void search(String value) async {
    change(state, status: RxStatus.loading());
    var contacts = RxList(await ContactsService.getContacts(
      withThumbnails: true,
      orderByGivenName: true,
      query: value,
    ));
    change(contacts,
        status: contacts.isEmpty ? RxStatus.empty() : RxStatus.success());
  }
}
