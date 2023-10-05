import 'package:get/get.dart';
import 'package:ja/app/data/repositories/device_repository.dart';

class HomeTabController extends GetxController {
  //TODO: Implement HomeTabController

  @override
  void onInit() {
    connectIfNotConnected();
    super.onInit();
  }

  void connectIfNotConnected() {
    var repository = Get.find<DeviceRepository>();
    if (!repository.isConnected.value) {
      repository.connect();
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
}
