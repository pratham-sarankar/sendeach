import 'package:get/get.dart';
import 'package:ja/app/data/repositories/device_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  late RxInt index = 0.obs;


  void changeIndex(int index) {
    this.index.value = index;
  }

  @override
  void onInit() {
    index = 0.obs;
    getSmsPermission();
    super.onInit();
  }

  void getSmsPermission()async{
    PermissionStatus status = await Permission.sms.request();
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
