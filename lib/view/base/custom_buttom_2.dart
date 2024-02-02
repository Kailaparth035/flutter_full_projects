import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../util/colors.dart';
import '../../util/string.dart';
import 'custom_text.dart';

class CustomButton2 extends StatelessWidget {
  final Color? buttonColor;
  final String buttonText;
  final String? icon;
  final String? endIcon;

  final Color textColor;
  final Color? borderColor;
  final double radius;
  final bool isBoarder;
  final double? fontSize;
  final FontWeight fontWeight;
  final bool isLoading;
  final Function onPressed;
  final EdgeInsetsGeometry? padding;
  final bool? isDisable;

  final double? height;
  final double? width;
  final double? topIconPadding;
  final double? iconHeight;

  const CustomButton2(
      {super.key,
      required this.onPressed,
      this.buttonColor,
      this.icon,
      this.endIcon,
      required this.buttonText,
      this.isDisable,
      required this.radius,
      this.fontSize,
      this.fontWeight = FontWeight.w700,
      this.borderColor,
      this.isLoading = false,
      this.isBoarder = false,
      this.padding,
      this.textColor = AppColors.white,
      this.height,
      this.topIconPadding,
      this.iconHeight,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.25),
              spreadRadius: -0.5,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ]),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor ?? AppColors.white,
          border: borderColor == null ? null : Border.all(color: borderColor!),
          gradient: buttonColor != null
              ? null
              : LinearGradient(colors: [
                  AppColors.secondaryColor
                      .withOpacity(isDisable == true ? 0.6 : 1),
                  AppColors.primaryColor
                      .withOpacity(isDisable == true ? 0.6 : 1),
                ], stops: const [
                  0.0,
                  1
                ]),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.none,
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            highlightColor: AppColors.white.withOpacity(0.3),
            onTap: () {
              if (isDisable != true) {
                onPressed();
              }
            },
            child: Container(
              color: Colors.transparent,
              padding: padding ?? EdgeInsets.all(3.sp),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        height: (fontSize ?? 12.sp) + 5.sp,
                        width: (fontSize ?? 12.sp) + 5.sp,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          color: textColor,
                        ),
                      ),
                    )
                  : _buildView(),
            ),
          ),
        ),
      ),
    );
  }

  _buildView() {
    if (icon == null && endIcon == null) {
      if (height != null && width != null) {
        return Center(
          child: CustomText(
            text: buttonText,
            textAlign: TextAlign.center,
            fontSize: fontSize ?? 12.sp,
            color: textColor,
            maxLine: 2,
            fontWeight: fontWeight,
            fontFamily: AppString.manropeFontFamily,
            textSpacing: 0.5.sp,
          ),
        );
      } else {
        return CustomText(
          text: buttonText,
          textAlign: TextAlign.center,
          fontSize: fontSize ?? 12.sp,
          color: textColor,
          maxLine: 2,
          fontWeight: fontWeight,
          fontFamily: AppString.manropeFontFamily,
          textSpacing: 0.5.sp,
        );
      }
    } else if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: Offset(0, topIconPadding ?? -1),
            child: Image.asset(
              icon!,
              height: iconHeight ?? fontSize ?? 12.sp,
            ),
          ),
          5.sp.sbw,
          Flexible(
            child: CustomText(
              text: buttonText,
              textAlign: TextAlign.center,
              fontSize: fontSize ?? 12.sp,
              color: textColor,
              maxLine: 2,
              fontWeight: fontWeight,
              fontFamily: AppString.manropeFontFamily,
              textSpacing: 0.5.sp,
            ),
          )
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: buttonText,
            textAlign: TextAlign.center,
            fontSize: fontSize ?? 12.sp,
            color: textColor,
            maxLine: 2,
            fontWeight: fontWeight,
            fontFamily: AppString.manropeFontFamily,
            textSpacing: 0.5.sp,
          ),
          5.sp.sbw,
          Image.asset(
            endIcon!,
            height: fontSize,
          ),
        ],
      );
    }
  }
}
