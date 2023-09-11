import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ja/app/data/repositories/device_repository.dart';
import 'package:ja/app/data/services/auth_service.dart';
import 'package:ja/app/data/services/device_info_service.dart';
import 'package:ja/app/data/services/fcm_service.dart';
import 'package:ja/app/data/services/pref_service.dart';
import 'package:ja/app/data/services/sms_service.dart';
import 'package:ja/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => PrefService().init());
  await Get.putAsync(() => FCMService().init());
  await Get.putAsync(() => SMSService().init());
  await Get.putAsync(() => DeviceInfoService().init());
  Get.put(DeviceRepository());
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemStatusBarContrastEnforced: true,
            systemNavigationBarContrastEnforced: true,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          labelStyle: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.grey.shade700,
          ),
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff7be34f),
          onPrimary: Colors.black,
          secondary: Color(0xfff6f5fa),
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
            ),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      defaultTransition: Transition.cupertino,
    ),
  );
}
