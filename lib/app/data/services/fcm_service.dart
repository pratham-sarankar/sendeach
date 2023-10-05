import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ja/app/data/services/sms_service.dart';

class FCMService extends GetxService {
  late final FirebaseMessaging messaging;
  late final GetStorage _box;

  Future<FCMService> init() async {
    messaging = FirebaseMessaging.instance;
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  Future<void> saveToken(String token) async {
    print("Saving token: $token");
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

  Future<String?> generateNewToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return token;
  }
}
