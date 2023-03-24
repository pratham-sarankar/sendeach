import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpField extends StatelessWidget {
  const OtpField({Key? key, required this.otpFieldController})
      : super(key: key);
  final OtpFieldController otpFieldController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: OtpFieldController(),
      builder: (controller) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OtpBox(
              index: 0,
              controller: controller,
            ),
            const SizedBox(width: 15),
            OtpBox(
              index: 1,
              controller: controller,
            ),
            const SizedBox(width: 15),
            OtpBox(
              index: 2,
              controller: controller,
            ),
            const SizedBox(width: 15),
            OtpBox(
              index: 3,
              controller: controller,
            ),
          ],
        );
      },
    );
  }
}

class OtpBox extends StatelessWidget {
  const OtpBox({Key? key, required this.index, required this.controller})
      : super(key: key);
  final int index;
  final OtpFieldController controller;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      onKey: (event) {
        if (event.runtimeType == RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.backspace) {
            if (controller.controllers[index].text.isEmpty && index != 0) {
              controller.focusNodes[index - 1].requestFocus();
            }
          }
        }
      },
      focusNode: FocusNode(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Get.theme.colorScheme.secondary,
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: TextField(
              autofocus: index == 0,
              controller: controller.controllers[index],
              focusNode: controller.focusNodes[index],
              style: const TextStyle(
                fontSize: 22,
              ),
              onChanged: (value) {
                if (value.isEmpty && index != 0) {
                  controller.focusNodes[index - 1].requestFocus();
                } else if (value.isNotEmpty && index != 3) {
                  controller.focusNodes[index + 1].requestFocus();
                }
              },
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpFieldController extends GetxController with StateMixin<String> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  OtpFieldController();

  String get otp {
    return controllers.fold(
        "", (previousValue, element) => previousValue + element.text);
  }

  @override
  void onInit() {
    controllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    super.onInit();
  }
}
