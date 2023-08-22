import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ja/app/data/repositories/device_repository.dart';
import 'package:ja/app/data/services/auth_service.dart';
import 'package:ja/app/data/services/device_info_service.dart';
import 'package:ja/app/data/services/pref_service.dart';
import 'package:ja/app/data/services/sms_service.dart';
import 'package:ja/app/routes/app_pages.dart';
import 'package:ja/app/widgets/confirmation_dialog.dart';
import 'package:ja/app/widgets/set_default_toast.dart';
import 'package:ja/app/widgets/status_button.dart';

import '../controllers/profile_tab_controller.dart';

class ProfileTabView extends GetView<ProfileTabController> {
  const ProfileTabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case "logout":
                  var result = await Get.dialog(const ConfirmationDialog());
                  if (result) {
                    await Get.find<AuthService>().logout();
                    Get.offAllNamed(Routes.LOGIN);
                  }
                  break;
                case "test":
                  Get.toNamed(Routes.SMS);
              }
            },
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  value: "test",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Icon(CupertinoIcons.envelope, size: 20),
                      SizedBox(width: 10),
                      Text("Test")
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: "logout",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Icon(Icons.exit_to_app, size: 20),
                      SizedBox(width: 10),
                      Text("Logout")
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),

      body: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Your Device ID",
              ),
              initialValue: Get.find<DeviceInfoService>().deviceId,
            ),
            const Divider(
              height: 30,
            ),
            if (Get.find<SMSService>().isDefaultSmsApp)
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      initialValue: "Auto Delete",
                      decoration: const InputDecoration(
                        labelText: "Settings",
                      ),
                    ),
                  ),
                  Obx(
                        () {
                      return CupertinoSwitch(
                        value: Get.find<PrefService>().deleteAfterSent.value,
                        onChanged: (value) {
                          Get.find<PrefService>()
                              .saveBool(Preference.deleteAfterSent, value);
                        },
                      );
                    },
                  )
                ],
              ),
            const Spacer(),
            if (!Get.find<SMSService>().isDefaultSmsApp)
              const SetDefaultToast(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
