import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentReputationCardWidget extends StatelessWidget {
  const DevelopmentReputationCardWidget({
    super.key,
    required this.mainTitle,
    required this.title,
    required this.secondTitle,
  });

  final String mainTitle;
  final String title;
  final String secondTitle;

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
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.sp),
                topRight: Radius.circular(4.sp),
              ),
              color: AppColors.labelColor15.withOpacity(0.85),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
            child: CustomText(
              text: mainTitle,
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CustomText(
                    text: title,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    maxLine: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: CustomText(
                    text: secondTitle,
                    textAlign: TextAlign.end,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    maxLine: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
              isEnable: true,
              value: 50,
              returnValue: (val) {},
            ),
          )
        ],
      ),
    );
  }
}
