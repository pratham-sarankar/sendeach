import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Image.asset("assets/login.png"),
          ),
          const SizedBox(height: 10),
          const Text(
            "You'll recieve a 4 digit code\n to verify next.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          Card(
            margin: EdgeInsets.zero,
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                right: 15,
                left: 15,
                top: 18,
                bottom: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Enter your phone",
                        hintText: "+1 (878) 198-1237",
                      ),
                      autofocus: true,
                    ),
                  ),
                  CupertinoButton.filled(
                    onPressed: controller.newLogin,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: controller.obx(
                      (state) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: state! ? 0 : 1,
                              child: Text(
                                "Continue",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: state! ? 1 : 0,
                              child: const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
