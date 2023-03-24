import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ja/app/data/services/sms_service.dart';
import 'package:ja/app/widgets/toast.dart';

class SetDefaultToast extends StatelessWidget {
  const SetDefaultToast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Toast(
      titleText: "Did you know?",
      isClosable: true,
      subTitle: RichText(
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: "You can",
          children: [
            TextSpan(
              text: " set as default",
              style: GoogleFonts.poppins(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await Get.find<SMSService>().setAsDefaultSmsApp();
                },
            ),
            const TextSpan(
                text:
                    " to unlock more features. The app must be restarted to apply the changes."),
          ],
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
