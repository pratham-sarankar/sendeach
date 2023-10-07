import 'dart:collection';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ja/app/data/models/sms.dart';
import 'package:ja/app/data/services/auth_service.dart';
import 'package:ja/app/data/services/device_info_service.dart';

class SmsProvider extends GetConnect {
  late final GetStorage _box;

  @override
  Future<void> onInit() async {
    baseUrl = const String.fromEnvironment("host");
    super.onInit();
    await GetStorage.init();
    _box = GetStorage();
  }

  Future<void> updateStatus(int smsId, SmsStatus status) async {
    await Get.putAsync(() => AuthService().init());
    var token = Get.find<AuthService>().readToken();
    var response = await post(
      '/update-status',
      {
        'id': smsId,
        'status': status.code,
      },
      contentType: 'application/json',
      headers: {"Authorization": "Bearer $token"},
    );
    print("Sms Update Request : $smsId, ${status.code}");
    print(response.body);
    if (response.body['status'] == false) {
      throw response.body['data']['message'];
    } else {
      removeSMSFromCache(smsId, "smsFailed");
      removeSMSFromCache(smsId, "smsDelivered");
    }
  }

  Future<void> removeSMSFromCache(smsId, type) async {
    var smsIds = (await _box.read(type) ?? []) as List<dynamic>;
    smsIds.remove(smsId);
    await _box.write(type, smsIds);
  }


  Future<List<Sms>> getPendingSms() async {
    final deviceId = Get.find<DeviceInfoService>().deviceId;
    final authToken = Get.find<AuthService>().readToken();
    print("device_id=$deviceId&limit=100");
    print("authToken=$authToken");
    String url = "/sms/pull-pending/app?device_id=$deviceId&limit=100";
    Response response = await get(
      url,
      contentType: 'application/json',
      headers: {"Authorization": "Bearer $authToken"},
    );
    print(response.body);
    print(response.statusCode);
    final messages = List.from(response.body['messages']);
    List<Sms> sms = messages.map((e) => Sms.fromJson(e)).toList();
    return sms;
  }
}

enum SmsStatus {
  sent,
  delivered,
  failed,
}

extension SmsStatusExtension on SmsStatus {
  int get code {
    switch (this) {
      case SmsStatus.sent:
        return 5;
      case SmsStatus.delivered:
        return 4;
      case SmsStatus.failed:
        return 3;
    }
  }

  String get value {
    switch (this) {
      case SmsStatus.sent:
        return "sent";
      case SmsStatus.delivered:
        return "delivered";
      case SmsStatus.failed:
        return "failed";
    }
  }
}
