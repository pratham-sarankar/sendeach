import 'package:get/get.dart';
import 'package:ja/app/data/repositories/device_repository.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  String getConnectionStatus() {
    var repository = Get.find<DeviceRepository>();
    if (repository.isLoading.value) {
      return "Loading...";
    } else if (repository.isConnecting.value) {
      return "Connecting...";
    } else if (repository.isDisconnecting.value) {
      return "Disconnecting...";
    } else if (repository.isConnected.value) {
      return "Tap to disconnect";
    } else {
      return "Tap to connect";
    }
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
