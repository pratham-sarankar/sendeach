import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ja/app/data/repositories/user_repository.dart';
import 'package:ja/app/routes/app_pages.dart';
import 'package:ja/app/widgets/otp_field.dart';

class OtpController extends GetxController {
  late RxBool isLoading;
  late String phoneNumber;
  late String token;

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    token = Get.arguments['token'];
    isLoading = RxBool(false);
    super.onInit();
  }

  void verifyOtp()async {
    try{
      isLoading.value = true;
      String otp = Get.find<OtpFieldController>().otp;
      bool loggedIn = await Get.find<UserRepository>().verifyOtp(token: token, otp: otp);
      isLoading.value = false;
      if(loggedIn){
        Get.offAllNamed(Routes.HOME);
      }
    }catch(e){
      isLoading.value = false;
      if(e is String){
        Fluttertoast.showToast(msg: e);
      }
    }
  }
}
