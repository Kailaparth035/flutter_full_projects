import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void showCustomSnackBar(
  String? message, {
  bool isError = true,
  int duration = 2,
  String? statusMessage,
  Color? color,
}) {
  if (message != null) {
    if (message.isNotEmpty && message != "") {
      if (statusMessage == null && isError == false) {
        Get.snackbar(
          "",
          "",
          titleText: Transform.translate(
            offset: Offset(0, 2.sp),
            child: Row(
              children: [
                Image.asset(
                  AppImages.doneRoundedIc,
                  height: 15.sp,
                  width: 15.sp,
                ),
                5.sp.sbw,
                CustomText(
                  text: "Success",
                  textAlign: TextAlign.start,
                  color: AppColors.white,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          messageText: 0.sbh,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.labelColor40.withOpacity(0.7),
          borderRadius: Get.context!.isTablet ? 5.sp : 10.sp,
          margin: EdgeInsets.all(1.5.h),
          padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 10.sp),
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
          isDismissible: true,
        );
      } else {
        Get.snackbar(
          statusMessage ?? (isError ? "Failed" : "Success"),
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: color ??
              (isError
                  ? AppColors.redColor.withOpacity(0.7)
                  : AppColors.labelColor40.withOpacity(0.7)),
          borderRadius: Get.context!.isTablet ? 5.sp : 10.sp,
          margin: EdgeInsets.all(1.5.h),
          colorText: Colors.white,
          duration: Duration(seconds: duration),
          isDismissible: true,
        );
      }
    }
  }
}

void showCustomSnackBarWithMessage(
  String message,
) {
  Get.snackbar(
    "",
    "",
    titleText: Transform.translate(
      offset: Offset(0, 2.sp),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_outlined,
            size: 14.sp,
            color: AppColors.white,
          ),
          5.sp.sbw,
          CustomText(
            text: message,
            textAlign: TextAlign.start,
            color: AppColors.white,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ),
    messageText: 0.sbh,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.labelColor40.withOpacity(0.7),
    borderRadius: Get.context!.isTablet ? 5.sp : 10.sp,
    margin: EdgeInsets.all(1.5.h),
    padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 10.sp),
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    isDismissible: true,
  );
}
