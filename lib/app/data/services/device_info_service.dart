import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

class DeviceInfoService extends GetxService {
  late String deviceId;

  Future<DeviceInfoService> init() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceId = (await deviceInfo.androidInfo).id;
    } else if (Platform.isIOS) {
      deviceId = (await deviceInfo.iosInfo).identifierForVendor!;
    }
    return this;
  }
}
