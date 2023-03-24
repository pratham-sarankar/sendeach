import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:ja/app/data/repositories/user_repository.dart';
import 'package:ja/app/routes/app_pages.dart';

class LoginController extends GetxController with StateMixin<bool>{
  late TextEditingController phoneNumberController;

  @override
  void onInit() {
    phoneNumberController = TextEditingController();
    change(false,status: RxStatus.success());
    super.onInit();
  }

  void login() async {
    try {
      Get.find<UserRepository>().loginWithWhatsappNumber(
        phoneNumber: phoneNumberController.text,
        onRequestingOTP: _onRequestingOtp,
      );
    } catch (e) {
      if (e is String) {
        Fluttertoast.showToast(msg: e);
      }
    }
  }

  void newLogin() async {
    try {
      change(true);
      var token = await Get.find<UserRepository>()
          .sendOtpToWhatsappNumber(phoneNumber: phoneNumberController.text);
      change(false);
      if (token != null) {
        Get.toNamed(Routes.OTP, arguments: {
          "token": token,
          "phoneNumber": phoneNumberController.text,
        });
      }
    } catch (e) {
      change(false);
      if (e is String) {
        Fluttertoast.showToast(msg: e);
      }

    }
  }

  Future<String> _onRequestingOtp() async {
    Get.focusScope!.unfocus();
    await Future.delayed(const Duration(milliseconds: 200));
    var result = await Get.toNamed(Routes.OTP, arguments: {
      "phoneNumber": phoneNumberController.text,
    });
    if (result == null) {
      throw "Login Cancelled";
    }
    return result;
  }
}
