import 'package:aspirevue/util/dimension.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../util/colors.dart';
import '../../util/string.dart';
import 'custom_text.dart';

class CustomContainer extends StatelessWidget {
  final Color buttonColor;
  final String leadingText;
  final String imagePath;
  final GestureTapCallback onPressed;

  const CustomContainer({
    super.key,
    required this.onPressed,
    required this.buttonColor,
    required this.leadingText,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 7.h,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 6.5.h,
              width: 7.w,
            ),
            SizedBox(width: 2.w),
            CustomText(
              text: leadingText,
              textAlign: TextAlign.start,
              color: AppColors.labelColor2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
