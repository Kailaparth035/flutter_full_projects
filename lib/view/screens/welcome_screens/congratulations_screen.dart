import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimension.dart';
import '../../../util/images.dart';
import '../../../util/string.dart';
import '../../base/custom_text.dart';

class CongratulationScreen extends StatefulWidget {
  const CongratulationScreen({super.key});

  @override
  State<CongratulationScreen> createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CommonController.getAnnanotaion(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor1,
          body: SafeArea(
            child: Stack(
              children: [
                // Image.asset(AppImages.background,
                //     width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.check, height: 30.h),
                      CustomText(
                        text: "Welcome",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor7,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 21.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      1.h.sbh,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.sp),
                        child: CustomText(
                          maxLine: 5,
                          text:
                              "Let's start with a quick product tour and you'll be up and running in no time!",
                          textAlign: TextAlign.center,
                          color: AppColors.labelColor6,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      8.h.sbh,
                      Padding(
                        padding: EdgeInsets.only(left: 3.h, right: 3.h),
                        child: CustomButton2(
                            buttonText: "Get started",
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            radius: Dimensions.radiusDefault,
                            fontSize: 13.sp,
                            onPressed: () {
                              Get.offAllNamed(RouteHelper.getMainRoute());
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
