import 'package:get/get.dart';
import 'package:ja/app/data/services/auth_service.dart';
import 'package:ja/app/data/services/device_info_service.dart';
import 'package:ja/app/data/services/fcm_service.dart';

class DeviceProvider extends GetConnect {
  late RxBool isConnected;
  late RxBool isLoading;
  late RxBool isConnecting;
  late RxBool isDisconnecting;
  late RxBool hasError;

  @override
  void onInit() {
    baseUrl = const String.fromEnvironment("host");
    isLoading = true.obs;
    hasError = false.obs;
    isConnected = false.obs;
    isConnecting = false.obs;
    isDisconnecting = false.obs;
    if (Get.find<AuthService>().isLoggedIn) {
      updateConnection().then((value) {
        isLoading.value = false;
      });
    } else {
      isLoading.value = false;
    }
    super.onInit();
  }

  Future updateConnection() async {
    String fcmToken = await Get.find<FCMService>().readToken();
    String deviceId = Get.find<DeviceInfoService>().deviceId;
    var token = Get.find<AuthService>().readToken();
    print("fcmToken: $fcmToken, deviceId: $deviceId, token: $token ");
    var response = await post(
      "/exist_fcm_token",
      {
        "fcm_token": fcmToken,
        "device_id": deviceId,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
      contentType: "application/json",
    );

    var body = response.body;
    isConnecting.value = false;
    isDisconnecting.value = false;
    print(body);
    if (body['status'] == true) {
      isConnected.value = body['data']['exist_fcm_token'] ?? false;
    } else {
      hasError.value = true;
    }
  }

  void connect() async {
    hasError.value = false;
    if (isConnected.value) return;
    isConnecting.value = true;
    String fcmToken = await Get.find<FCMService>().readToken();
    String deviceId = Get.find<DeviceInfoService>().deviceId;
    String? token = Get.find<AuthService>().readToken();
    Response response = await post(
      "/store_fcm_token",
      {
        "fcm_token": fcmToken,
        "device_id": deviceId,
      },
      contentType: "application/json",
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    var body = response.body;
    if (body['status'] == true) {
      updateConnection();
    } else {
      isConnecting.value = false;
      throw body['data']['message'];
    }
  }

  Future disconnect() async {
    hasError.value = false;
    if (!isConnected.value) return;
    isDisconnecting.value = true;
    var deviceId = Get.find<DeviceInfoService>().deviceId;
    var token = Get.find<AuthService>().readToken();

    var response = await post(
      "/delete_fcm_token",
      {
        "device_id": deviceId,
      },
      headers: {
        "Authorization": "Bearer $token",
      },
      contentType: "application/json",
    );

    var body = response.body;
    print(body);
    if (body['status'] == true) {
      await updateConnection();
    } else {
      isDisconnecting.value = false;
      throw body['data']['message'];
    }
  }
}
