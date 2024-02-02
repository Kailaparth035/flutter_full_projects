import 'package:aspirevue/util/animation.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

class CustomErrorWidget extends StatelessWidget {
  final Function onRetry;
  final String text;
  final double? width;
  final bool isNoData;
  final bool? isShowCustomMessage;
  final bool? isShowRetriyButton;

  const CustomErrorWidget(
      {super.key,
      required this.onRetry,
      required this.text,
      this.width,
      this.isShowCustomMessage,
      this.isNoData = false,
      this.isShowRetriyButton = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isNoData
            ? CustomText(
                text: isShowCustomMessage == true ? text : "No Data Found!",
                textAlign: TextAlign.left,
                color: AppColors.black,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                textSpacing: 0.3.sp,
                fontWeight: FontWeight.w700,
              )
            : text == AppString.noInternetConnection
                ? Transform.translate(
                    offset: Offset(0, 55.sp),
                    child: SizedBox(
                      height: width ?? 60.w,
                      child: Lottie.asset(AppAnimation.noInternetAnimation),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: width ?? 50.w,
                        child: Lottie.asset(AppAnimation.errorAnimation),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: CustomText(
                          text: text,
                          textAlign: TextAlign.center,
                          color: AppColors.black,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 12.sp,
                          maxLine: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
        10.sp.sbh,
        isShowRetriyButton == true
            ? CustomButton2(
                buttonText: AppString.retry,
                buttonColor: AppColors.labelColor4,
                radius: 5.sp,
                padding:
                    EdgeInsets.symmetric(vertical: 7.sp, horizontal: 40.sp),
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                onPressed: () {
                  onRetry();
                })
            : 0.sbh,
        isShowRetriyButton == true ? 20.sp.sbh : 0.sbh
      ],
    );
  }
}

class CustomNoDataFoundWidget extends StatelessWidget {
  const CustomNoDataFoundWidget({super.key, this.height, this.topPadding});
  final double? height;
  final double? topPadding;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 60.w,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: topPadding ?? 15.h),
          child: CustomText(
            text: "No Data Found!",
            textAlign: TextAlign.left,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            textSpacing: 0.3.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
    // return Center(
    //   child: SizedBox(
    //     height: width ?? 60.w,
    //     child: Lottie.asset(AppAnimation.noDataFoundAnimation, reverse: true),
    //   ),
    // );
  }
}

class CustomMessagesDataFoundWidget extends StatelessWidget {
  const CustomMessagesDataFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60.w,
        child:
            Lottie.asset(AppAnimation.noMessagesFoundAnimation, reverse: true),
      ),
    );
  }
}
