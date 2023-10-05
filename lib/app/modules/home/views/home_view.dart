import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ja/app/modules/home/tabs/home_tab/views/home_tab_view.dart';
import 'package:ja/app/modules/home/tabs/profile_tab/views/profile_tab_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_alt_circle_fill),
                label: "Profile",
              ),
            ],
            onTap: controller.changeIndex,
            currentIndex: controller.index.value,
            elevation: 20,
            selectedLabelStyle: GoogleFonts.poppins(),
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedItemColor: Colors.black.withGreen(70),
            unselectedItemColor: Colors.grey.shade700,
            unselectedLabelStyle: GoogleFonts.poppins(),
          ),
          body: IndexedStack(
            index: controller.index.value,
            children: const [
              HomeTabView(),
              ProfileTabView(),
            ],
          ),
        );
      },
    );
  }
}
