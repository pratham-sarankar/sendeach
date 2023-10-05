import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

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

import '../controllers/home_tab_controller.dart';

class HomeTabView extends GetView<HomeTabController> {
  const HomeTabView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        centerTitle: true,
        title: Image.asset("assets/logo.png", height: 135),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(),
          Obx(
            () => StatusButton(
              isConnected: Get.find<DeviceRepository>().isConnected.value,
              onPressed: () {
                Get.find<DeviceRepository>().toggleConnection();
              },
              subtitle: controller.getConnectionStatus(),
              hasError: Get.find<DeviceRepository>().hasError.value,
            ),
          ),
          Expanded(
            child: Image.asset(
              "assets/home_bg_2.png",
              // color: Colors.blue,
              alignment: Alignment.center,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
