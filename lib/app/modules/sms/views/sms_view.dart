import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/sms_controller.dart';

class SmsView extends GetView<SmsController> {
  const SmsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send SMS"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: controller.recipientsController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Recipients",
                hintText: "+1 (877) 129 1203, +919892346654",
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: const InputDecoration(
                  hintText: "Type message here . . .",
                ),
                expands: true,
                maxLines: null,
              ),
            ),
            CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              onPressed: controller.sendSms,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    "Send",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Icon(CupertinoIcons.arrow_right, size: 20),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
