import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ja/app/widgets/otp_field.dart';

import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            "Code is sent to ${controller.phoneNumber}",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),
          const Spacer(),
          Expanded(
            child: OtpField(
              otpFieldController: Get.find<OtpFieldController>(),
            ),
          ),
          const Spacer(),
          RichText(
            text: TextSpan(
              text: "Didn't recieve the code? ",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: "Request again",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: CupertinoButton.filled(
              onPressed: controller.verifyOtp,
              child: Container(
                width: Get.width,
                height: 25,
                alignment: Alignment.center,
                child: Obx(
                  () {
                    return controller.isLoading.value
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            "Verify and Login",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                            ),
                          );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
