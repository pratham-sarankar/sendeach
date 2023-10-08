import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ja/app/data/repositories/device_repository.dart';
import 'package:ja/app/data/services/auth_service.dart';
import 'package:ja/app/data/services/device_info_service.dart';
import 'package:ja/app/data/services/fcm_service.dart';
import 'package:ja/app/data/services/foreground_service.dart';
import 'package:ja/app/data/services/pref_service.dart';
import 'package:ja/app/data/services/sms_service.dart';
import 'package:ja/firebase_options.dart';
import 'package:sms_sender/sms_sender.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // SMSService().sendPendingSmsOnBackground();
  FlutterBackgroundService().invoke('startSendingSMS');
}

@pragma('vm:entry-point')
Future setupFirebaseMessaging() async {
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("OnMessage function called");
    // SMSService().sendPendingSmsOnBackground();

    FlutterBackgroundService().invoke('startSendingSMS');
  });
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //   print("OnMessageOpenedApp function called");
  //   // SMSService().sendPendingSmsOnBackground();
  //   FlutterBackgroundService().invoke('startSendingSMS');
  //
  // });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFirebaseMessaging();
  await initializeService();

  //Put Repositories
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => PrefService().init());
  await Get.putAsync(() => FCMService().init());
  await Get.putAsync(() => SMSService().init());
  await Get.putAsync(() => ForegroundService().init());
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

@pragma('vm:entry-point')
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'sendeach_server_status', // id
    'SENDEACH SERVICE', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onStart,
      // auto start service
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'sendeach_server_status',
      initialNotificationTitle: 'SENDEACH SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,
      // this will be executed when app is in foreground in separated isolate
      onForeground: onStart,
      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('startSendingSMS').listen((event) async {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Connected to server",
          content: "Processing SMS",
        );
      }

      await SMSService().sendPendingSmsOnBackground();

      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Connected to server",
          content: "Listening for incoming messages",
        );
      }
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });

    // // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await service.isForegroundService()) {
        await Get.putAsync(() => AuthService().init());

        if (!Get.find<AuthService>().isLoggedIn) {
          service.setForegroundNotificationInfo(
            title: "Waiting for login",
            content: "Please login to start sending SMS",
          );
        } else {
          service.setForegroundNotificationInfo(
            title: "Connected to server",
            content: "Listening for incoming messages",
          );
        }
      }
    });
  }
}
