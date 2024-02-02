import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class QuestionListTileWidget extends StatelessWidget {
  const QuestionListTileWidget(
      {super.key,
      required this.question,
      required this.lable,
      required this.bgColor,
      required this.isAnswered,
      required this.onTap,
      required this.borderColor,
      required this.fontSize,
      this.isColored,
      this.isSelected});

  final String question;
  final String lable;
  final Color bgColor;
  final bool isAnswered;
  final Function onTap;
  final Color borderColor;
  final bool? isColored;
  final bool? isSelected;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          splashColor: !isAnswered ? AppColors.labelColor : Colors.transparent,
          highlightColor:
              !isAnswered ? AppColors.labelColor : Colors.transparent,
          onTap: () {
            onTap();
          },
          child: Container(
            padding: EdgeInsets.all(4.sp),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(3.sp),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isColored == null ? _buildFirstBox() : _buildFirstBoxColored(),
                10.sp.sbw,
                Expanded(
                  child: CustomText(
                    text: question,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor64,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        10.sp.sbh,
      ],
    );
  }

  Container _buildFirstBox() {
    return Container(
      height: 20.sp,
      width: 20.sp,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2.sp),
        border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Center(
        child: CustomText(
          text: lable,
          textAlign: TextAlign.center,
          color: AppColors.labelColor64,
          fontFamily: AppString.manropeFontFamily,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Container _buildFirstBoxColored() {
    return Container(
      height: 20.sp,
      width: 20.sp,
      padding: EdgeInsets.all(1.sp),
      decoration: BoxDecoration(
        color: bgColor,
        gradient: LinearGradient(
          colors: [
            isSelected != null && isSelected == true
                ? AppColors.labelColor
                : AppColors.secondaryColor,
            isSelected != null && isSelected == true
                ? AppColors.labelColor
                : AppColors.primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(3.sp),
        // border: Border.all(color: AppColors.black, width: 1),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected != null && isSelected == true
              ? AppColors.circlepink
              : AppColors.white,
          borderRadius: BorderRadius.circular(2.sp),
        ),
        child: Center(
          child: CustomText(
            text: lable,
            textAlign: TextAlign.center,
            color: AppColors.labelColor64,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
