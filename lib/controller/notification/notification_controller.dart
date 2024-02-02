import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/main/notification_list_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';

class NotificationController {
  initNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');

      FirebaseMessaging.onMessage.listen(onMessageHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        Get.to(const NotificationListScreen());
      });
    }
  }

  onMessageHandler(RemoteMessage message) {
    debugPrint(
        'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

    if (message.notification != null) {
      bool isTapped = false;
      final mainController = Get.find<MainController>();

      mainController.notificationCount.value =
          mainController.notificationCount.value + 1;

      showSimpleNotification(
          InkWell(
            child: CustomText(
              text: message.notification!.title.toString(),
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              color: AppColors.white,
              maxLine: 50,
              fontWeight: FontWeight.w600,
            ),
            onTap: () {
              if (!isTapped) {
                isTapped = true;
              }
            },
          ),
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: CommonController.getLinearGradientSecondryAndPrimary(),
            ),
            child: Image(
              image: const AssetImage(AppImages.logo),
              height: 25.sp,
              width: 25.sp,
            ),
          ),
          slideDismissDirection: DismissDirection.horizontal,
          subtitle: CustomText(
            text: message.notification!.body.toString(),
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            color: AppColors.white,
            maxLine: 50,
            fontWeight: FontWeight.w400,
          ),
          background: AppColors.labelColor4,
          autoDismiss: true,
          duration: const Duration(seconds: 7));
    }
  }
}
