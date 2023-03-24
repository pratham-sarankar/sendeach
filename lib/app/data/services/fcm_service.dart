import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ja/app/data/services/sms_service.dart';

class FCMService extends GetxService {
  late final FirebaseMessaging messaging;
  late final GetStorage _box;

  Future<FCMService> init() async {
    messaging = FirebaseMessaging.instance;
    setupFirebaseMessaging();
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  Future<void> saveToken(String token) async {
    return await _box.write("fcm_token", token);
  }

  Future<String> readToken() async {
    var token = _box.read<String?>("fcm_token");
    if (token == null) {
      token = await generateNewToken();
      await saveToken(token!);
    }
    return token;
  }

  void setupFirebaseMessaging() {
    messaging.setForegroundNotificationPresentationOptions(alert: false);

    // Request permission for notifications on iOS devices
    messaging.requestPermission();

    // Define the callbacks for incoming notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await Get.find<SMSService>().sendSms(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await Get.find<SMSService>().sendSms(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        await Get.find<SMSService>().sendSms(message);
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> generateNewToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  SMSService().sendSms(message);
  return Future.value();
}
