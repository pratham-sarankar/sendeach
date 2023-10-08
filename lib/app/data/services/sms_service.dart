import 'dart:convert';
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
    await Get.putAsync(() => PrefService().init());
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

  Future sendPendingSmsOnBackground() async {
    await init();
    var data = await Get.find<SmsRepository>().getPendingSms();

    while (data.isNotEmpty) {
      for (Sms sms in data) {
        await Future.delayed(const Duration(seconds: 2));

        if (await hasSMSCache(sms.id, "smsDelivered")) {
          Get.find<SmsRepository>().updateStatus(sms.id, SmsStatus.delivered);
          continue;
        }

        if (await hasSMSCache(sms.id, "smsFailed")) {
          Get.find<SmsRepository>().updateStatus(sms.id, SmsStatus.failed);
          continue;
        }

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
      await Future.delayed(const Duration(seconds: 5));
      data = await Get.find<SmsRepository>().getPendingSms();
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
    // print("The arguments on Delivered are $arguments");
    // var smsId = jsonDecode(arguments)['smsId'];
    // if (smsId != null) {
    //   await updateSmsCache(smsId, 'smsDelivered');
    //   await Get.find<SmsRepository>().updateStatus(smsId, SmsStatus.delivered);
    // }
    // Fluttertoast.showToast(msg: "Sms Delivered");
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
