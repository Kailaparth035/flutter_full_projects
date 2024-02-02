import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentSliderWithTitle extends StatelessWidget {
  const DevelopmentSliderWithTitle({
    super.key,
    required this.title,
    required this.sliderValue,
    this.secondTitle,
    this.middleTitle,
    required this.onChange,
    this.topBgColor,
    required this.isReset,
    required this.isEnable,
  });
  final bool isReset;
  final String title;
  final String? middleTitle;
  final String? secondTitle;

  final double sliderValue;
  final Function(double) onChange;
  final Color? topBgColor;
  final bool isEnable;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(6.sp),
        border: Border.all(color: AppColors.labelColor),
        color: AppColors.white,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.sp),
                topRight: Radius.circular(6.sp),
              ),
              color: topBgColor ?? AppColors.white,
            ),
            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color:
                  topBgColor == null ? AppColors.labelColor8 : AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          middleTitle == null
              ? 0.sbh
              : Container(
                  width: double.infinity,
                  color: AppColors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                  child: CustomText(
                    text: middleTitle!,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.sp),
                bottomLeft: Radius.circular(5.sp),
              ),
              color: AppColors.backgroundColor1,
            ),
            width: double.infinity,
            child: SliderWidget(
              isReset: isReset,
              isEnable: isEnable,
              value: sliderValue,
              returnValue: onChange,
            ),
          ),
          secondTitle == null
              ? 0.sbh
              : Container(
                  // width: double.infinity,
                  // color: AppColors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                  child: CustomText(
                    text: secondTitle!,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
        ],
      ),
    );
  }
}
