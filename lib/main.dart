import 'dart:io';
import 'dart:ui';

import 'package:aspirevue/controller/notification/notification_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/theme/light_theme.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/screens/auth/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';

import 'helper/get_di.dart' as di;
import 'helper/route_helper.dart';

// commit from new system
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  // await Firebase.initializeApp();
  // showCustomSnackBar(message.notification.toString(),
  //     color: Colors.yellow, duration: 5);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Permission.notification.request();

  await Upgrader.clearSavedSettings(); // REMOVE this for release builds

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  NotificationController().initNotification();
  await di.init();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.white,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: AppColors.primaryColor,
    ),
  );

  Stripe.publishableKey = AppConstants.stripeKey;
  FlutterBranchSdk.init(
      useTestKey: true, enableLogging: true, disableTracking: false);
  _initBranchDeepLink();
  runApp(const MyApp());
}

_initBranchDeepLink() {
  Future.delayed(const Duration(milliseconds: 100), () {
    FlutterBranchSdk.listSession().listen((data) async {
      var sharedController = Get.find<ProfileSharedPrefService>();

      // Code for referral code
      if (sharedController.isLoggedIn() == false) {
        try {
          var referralCode = data['referralCode'];
          var profileController = Get.find<ProfileSharedPrefService>();
          if (referralCode != null && referralCode != "") {
            profileController.referralCodeFromLink(referralCode);
            // Get.toNamed(RouteHelper.signUp);
            print("==========> referral Code ====> ${referralCode}");
            // Get.to(SignUpScreen());
            Navigator.of(Get.context!).push(
              MaterialPageRoute(
                builder: (context) =>
                    SignUpScreen(key: UniqueKey(), referralCode: referralCode),
              ),
            );
          } else {
            profileController.referralCodeFromLink("");
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return OverlaySupport(
          child: GetMaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            theme: basicTheme(),
            initialRoute: RouteHelper.getSplashRoute(),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50.0,
              ),
              SizedBox(height: 10.0),
              Text(
                'Error Occurred!',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
