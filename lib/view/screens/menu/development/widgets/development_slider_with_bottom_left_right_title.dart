import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentSliderForBottomLeftRightTitle extends StatelessWidget {
  const DevelopmentSliderForBottomLeftRightTitle({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.sliderValue,
    required this.onChange,
    required this.isReset,
  });

  final String leftTitle;
  final String rightTitle;
  final double sliderValue;
  final bool isReset;
  final Function(double) onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
        color: AppColors.white,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.sp),
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
              isEnable: true,
              value: sliderValue,
              returnValue: onChange,
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                    child: CustomText(
                      text: leftTitle,
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor8,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      maxLine: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5.sp),
                  height: double.infinity,
                  width: 1.sp,
                  color: AppColors.labelColor68.withOpacity(0.40),
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                    child: CustomText(
                      text: rightTitle,
                      textAlign: TextAlign.end,
                      color: AppColors.labelColor8,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      maxLine: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
