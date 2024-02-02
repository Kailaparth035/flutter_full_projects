import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class NotificationAllowScreen extends StatefulWidget {
  const NotificationAllowScreen({super.key});

  @override
  State<NotificationAllowScreen> createState() =>
      _NotificationAllowScreenState();
}

class _NotificationAllowScreenState extends State<NotificationAllowScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                15.h.sbh,
                SvgPicture.asset(SvgImage.welcomeNotificationImage,
                    height: 25.h),
                CustomText(
                  fontWeight: FontWeight.w700,
                  fontSize: 21.sp,
                  color: AppColors.labelColor8,
                  text: "Allow Notification",
                  textAlign: TextAlign.center,
                  fontFamily: AppString.manropeFontFamily,
                ),
                2.h.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: welcomeScreenSubTitle(
                      "You can manage various notifications from AspireVue through the system settings of your mobile device."),
                ),
                // Spacer(),
                2.h.sbh,
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(left: 3.h, right: 3.h),
        //   child: CustomButton2(
        //       buttonText: "Allow Notifications",
        //       width: MediaQuery.of(context).size.width,
        //       padding: EdgeInsets.symmetric(vertical: 2.h),
        //       radius: Dimensions.radiusDefault,
        //       fontSize: 13.sp,
        //       onPressed: () {
        //         Get.find<MainController>().allowNotification(true);
        //       }),
        // ),
        2.h.sbh,
      ],
    );
  }
}
