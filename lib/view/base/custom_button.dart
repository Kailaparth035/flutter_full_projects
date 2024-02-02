import 'package:aspirevue/controller/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../util/colors.dart';
import '../../util/string.dart';
import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final Color textColor;
  final Color? bgColor;
  final double height;
  final double? width;
  final double radius;
  final bool isBackArrow;
  final bool isBoarder;
  final double? fontSize;
  final FontWeight fontWeight;
  final bool isLoading;
  final GestureTapCallback onPressed;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      this.width,
      required this.height,
      this.bgColor,
      required this.radius,
      this.fontSize,
      this.fontWeight = FontWeight.w700,
      this.isBackArrow = true,
      this.isLoading = false,
      this.isBoarder = false,
      this.textColor = AppColors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          bgColor ?? AppColors.secondaryColor,
          bgColor ?? AppColors.primaryColor
        ]),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: CommonController.getIsIOS() ? null : Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
        ),
        onPressed: onPressed,
        child: isLoading
            ? Center(
                child: SizedBox(
                  height: height - 15.sp,
                  width: height - 15.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textColor,
                  ),
                ),
              )
            : CustomText(
                text: buttonText,
                textAlign: TextAlign.start,
                fontSize: fontSize ?? 11.sp,
                color: textColor,
                fontWeight: fontWeight,
                fontFamily: AppString.manropeFontFamily,
                // textSpacing: 1.sp,
              ),
      ),
    );
  }
}
