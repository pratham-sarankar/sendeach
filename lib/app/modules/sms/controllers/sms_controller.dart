import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ja/app/data/services/sms_service.dart';

class SmsController extends GetxController {
  late TextEditingController recipientsController;
  late TextEditingController messageController;

  @override
  void onInit() {
    recipientsController = TextEditingController();
    messageController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // void sendSms() {
  //   Get.find<SMSService>().sendSMS(
  //     recipientsController: recipientsController,
  //     messageController: messageController,
  //   );
  // }
}
