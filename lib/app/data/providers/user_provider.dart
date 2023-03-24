import 'dart:convert';
import 'package:get/get.dart';
import 'package:ja/app/data/services/auth_service.dart';

class UserProvider extends GetConnect {
  @override
  void onInit() {
    baseUrl = const String.fromEnvironment("host");
    super.onInit();
  }

  Future<bool> loginWithWhatsappNumber({
    required String phoneNumber,
    required Future<String> Function() onRequestingOTP,
  }) async {
    Response response = await post(
      "/login",
      jsonEncode({"phone": phoneNumber}),
      contentType: "application/json",
    );
    if (response.body['status'] == true) {
      var token = response.body['data']['token'];
      var otp = await onRequestingOTP();
      var authToken = await _verifyOtp(token: token, otp: otp);
      if (authToken == null) {
        return false;
      }
      await Get.find<AuthService>().saveToken(authToken);
      return true;
    } else {
      throw response.body['data']['message'];
    }
  }

  Future<String?> sendOtpToWhatsappNumber({required String phoneNumber}) async {
    Response response = await post(
      "/login",
      jsonEncode({"phone": phoneNumber}),
      contentType: "application/json",
    );
    if (response.body['status'] == true) {
      var token = response.body['data']['token'];
      return token;
    } else {
      throw response.body['data']['message'];
    }
  }

  Future<bool> verifyOtp({required String token, required String otp}) async {
    Response response = await post(
      "/verify_otp_login",
      {"token": token, "code": otp},
      contentType: "application/json",
    );
    if (response.body['status'] == true) {
      var authToken = response.body['data']['token'];
      await Get.find<AuthService>().saveToken(authToken);
      return true;
    } else {
      throw response.body['data']['message'];
    }
  }

  Future<String?> _verifyOtp(
      {required String token, required String otp}) async {
    Response response = await post(
      "/verify_otp_login",
      {"token": token, "code": otp},
      contentType: "application/json",
    );
    if (response.body['status'] == true) {
      var token = response.body['data']['token'];
      return token;
    } else {
      throw response.body['data']['message'];
    }
  }
}
