import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ja/app/data/models/sms.dart';
import 'package:ja/app/data/services/auth_service.dart';
import 'package:ja/app/data/services/device_info_service.dart';
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
    await Get.putAsync(() => DeviceInfoService().init());
    await Get.putAsync(() => AuthService().init());
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

  //
  // void sendSMS({
  //   required TextEditingController recipientsController,
  //   required TextEditingController messageController,
  // }) async {
  //   List<String> recipients = recipientsController.text.split(",");
  //   await SmsSender().sendSms(
  //     recipients,
  //     messageController.text,
  //     _onSent,
  //     _onDelivered,
  //     sms.id,
  //     deleteAfterSent: Get.find<PrefService>().deleteAfterSent.value,
  //     onLastSmsDeleted: _onLastSmsDeleted,
  //   );
  // }

  //This is the old version os sendSms function, which use to extract sms details from the notification payload and then send it.
  //In the new version the notification payload will not have any details, but mobile app should call the API to fetch the pending SMS.
  //And then send it.
  // Future sendSms(RemoteMessage remoteMessage) async {
  //   await init();
  //   var data = remoteMessage.data;
  //   var recipients = List<String>.from(jsonDecode(data['recipients']) ?? []);
  //   var message = data['message'] ?? "";
  //   var smsId = int.parse(data['id'].toString());
  //   await saveSmsId(smsId);
  //   await Get.putAsync(() => PrefService().init());
  //   SmsSender().sendSms(
  //     recipients,
  //     message,
  //     _onSent,
  //     _onDelivered,
  //     deleteAfterSent: Get
  //         .find<PrefService>()
  //         .deleteAfterSent
  //         .value,
  //     onLastSmsDeleted: _onLastSmsDeleted,
  //   );
  // }
  Future sendSms(RemoteMessage remoteMessage) async {
    await init();
    // var data = await Get.find<SmsRepository>().getPendingSms();
    for (var i = 0; i < 5; i++) {
      await Future.delayed(const Duration(seconds: 1));
      print("Sending sms $i");
    }
    var data = <Sms>[
      Sms(
        id: -1,
        message: "Hey",
        androidDeviceId: 1,
        to: ['+919425661140'],
        batchId: "",
        initiatedTime: DateTime.now(),
        smsType: 1,
        createdAt: DateTime.now(),
      ),
    ];
    for (final sms in data) {
      await saveSmsId(sms.id);
      await Get.putAsync(() => PrefService().init());
      await SmsSender().sendSms(
        sms.to,
        sms.message,
        _onSent,
        _onDelivered,
        sms.id,
        deleteAfterSent: Get.find<PrefService>().deleteAfterSent.value,
        onLastSmsDeleted: _onLastSmsDeleted,
      );
    }
  }

  Future sendPendingSmsOnBackground() async {
    print("sendPendingSmsOnBackground called");
    await init();
    var data = await Get.find<SmsRepository>().getPendingSms();
    print("data: ${data.length} - ${data.map((e) => e.toJson()).toList()}");
    for (Sms sms in data) {
      await Future.delayed(const Duration(seconds: 1));

      if (await hasSMSCache(sms.id, "smsDelivered")) {
        Get.find<SmsRepository>().updateStatus(sms.id, SmsStatus.delivered);
        continue;
      }

      if (await hasSMSCache(sms.id, "smsFailed")) {
        Get.find<SmsRepository>().updateStatus(sms.id, SmsStatus.failed);
        continue;
      }

      await Get.putAsync(() => PrefService().init());
      await SmsSender().sendSms(
        sms.to,
        sms.message,
        _onSent,
        _onDelivered,
        sms.id,
        deleteAfterSent: Get.find<PrefService>().deleteAfterSent.value,
        onLastSmsDeleted: _onLastSmsDeleted,
      );
    }
  }


  Future _onSent(String arguments) async {
    // var smsId = readSmsId();
    try {
      var arg = jsonDecode(arguments);

      var success = arg['success'];
      var smsId = arg['smsId'];

      if (smsId != null) {
        if (!success) {
          updateSmsCache(smsId, "smsFailed");
        } else {
          updateSmsCache(smsId, "smsDelivered");
        }
        await Get.find<SmsRepository>().updateStatus(
            smsId, success ? SmsStatus.delivered : SmsStatus.failed);
      }
    } catch (exception) {
      print(exception);
    }
  }

  Future _onDelivered(String arguments) async {
    print("The arguments on Delivered are $arguments");
    var smsId = jsonDecode(arguments)['smsId'];
    if (smsId != null) {
      await updateSmsCache(smsId, 'smsDelivered');
      await Get.find<SmsRepository>().updateStatus(smsId, SmsStatus.delivered);
    }
    Fluttertoast.showToast(msg: "Sms Delivered");
  }

  Future<void> updateSmsCache(smsId, type) async {
    var smsIds = (await _box.read(type) ?? []) as List<dynamic>;
    smsIds.add(smsId);
    await _box.write(type, smsIds);
  }


  Future<bool> hasSMSCache(int id, type) async {
    var smsIds = (await _box.read(type) ?? []) as List<dynamic>;
    return smsIds.contains(id);
  }

  Future _onLastSmsDeleted(bool success) async {
    Fluttertoast.showToast(msg: "Last Sms Deleted");
  }
}
