import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WelcomeStepScreen extends StatefulWidget {
  const WelcomeStepScreen({super.key});

  @override
  State<WelcomeStepScreen> createState() => _WelcomeStepScreenState();
}

class _WelcomeStepScreenState extends State<WelcomeStepScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBGandImage(),
          5.h.sbh,
          Padding(
            padding: EdgeInsets.all(35.sp),
            child: Center(
              child: welcomeScreenTitle("Your 14-day trial has started."),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.sp),
            child: Center(
              child: welcomeScreenSubTitle(
                  "You will get notifications about when your trial is about to end and more."),
            ),
          ),
        ],
      ),
    );
  }

  _buildBGandImage() {
    return Stack(
      children: [
        Image.asset(
          AppImages.rectangle,
          width: Get.context!.getWidth,
          height: Get.context!.getHeight * 0.40,
          fit: BoxFit.fill,
        ),
        Positioned(
          bottom: 15.sp,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Image.asset(
                AppImages.welcomeImg,
                width: Get.context!.getWidth - 20.sp,
                height: Get.context!.getHeight * 0.30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
