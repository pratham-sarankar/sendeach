import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ja/app/data/providers/sms_provider.dart';
import 'package:ja/app/data/repositories/sms_repository.dart';
import 'package:ja/app/data/services/pref_service.dart';
import 'package:sms_sender/sms_sender.dart';

class SMSService extends GetxService {
  late final GetStorage _box;
  late bool isDefaultSmsApp;

  Future<SMSService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    isDefaultSmsApp = await SmsSender.isDefaultSmsApp;
    Get.put(SmsRepository());
    return this;
  }

  Future setAsDefaultSmsApp() async {
    await SmsSender.setAsDefaultSmsApp();
  }

  Future saveSmsId(int? smsId) async {
    return await _box.write("smsId", smsId);
  }

  int? readSmsId() {
    return _box.read<int>("smsId");
  }

  void sendSMS({
    required TextEditingController recipientsController,
    required TextEditingController messageController,
  }) async {
    await Permission.sms.request();
    List<String> recipients = recipientsController.text.split(",");
    await SmsSender().sendSms(
      recipients,
      messageController.text,
      _onSent,
      _onDelivered,
      deleteAfterSent: Get
          .find<PrefService>()
          .deleteAfterSent
          .value,
      onLastSmsDeleted: _onLastSmsDeleted,
    );
  }

  Future sendSms(RemoteMessage remoteMessage) async {
    await init();
    var data = remoteMessage.data;
    var recipients = List<String>.from(jsonDecode(data['recipients']) ?? []);
    var message = remoteMessage.data['message'] ?? "";
    var smsId = int.parse(data['id'].toString());
    await saveSmsId(smsId);
    await Get.putAsync(() => PrefService().init());
    SmsSender().sendSms(
      recipients,
      message,
      _onSent,
      _onDelivered,
      deleteAfterSent: Get
          .find<PrefService>()
          .deleteAfterSent
          .value,
      onLastSmsDeleted: _onLastSmsDeleted,
    );
  }

  Future _onSent(bool success) async {
    var smsId = readSmsId();
    if (smsId != null) {
      await Get.find<SmsRepository>().updateStatus(smsId, SmsStatus.sent);
    }
    Fluttertoast.showToast(msg: "Sms sent");
  }

  Future _onDelivered(bool success) async {
    var smsId = readSmsId();
    if (smsId != null) {
      await Get.find<SmsRepository>().updateStatus(smsId, SmsStatus.delivered);
    }
    Fluttertoast.showToast(msg: "Sms Delivered");
  }

  Future _onLastSmsDeleted(bool success) async {
    Fluttertoast.showToast(msg: "Last Sms Deleted");
  }
}
