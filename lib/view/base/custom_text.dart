import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../util/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double radious;
  final int? maxLine;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFamily;
  final double textSpacing;
  final TextOverflow? overFlow;
  final FontStyle? fontStyle;
  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.radious = 18,
    this.overFlow,
    this.maxLine,
    this.textSpacing = 0,
    this.color = AppColors.black,
    required this.textAlign,
    required this.fontFamily,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLine,
        textAlign: textAlign,
        overflow: overFlow,
        style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: fontSize ?? 15.sp,
          letterSpacing: textSpacing,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          color: color,
        ));
  }
}

class CustomUnderlineText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final double radious;
  final int maxLine;
  final Color color;
  final FontWeight fontWeight;
  final double textSpacing;
  final TextAlign textAlign;
  final String fontFamily;

  const CustomUnderlineText(
      {super.key,
      required this.text,
      this.fontSize,
      this.radious = 18,
      this.textSpacing = 0.5,
      this.maxLine = 1,
      this.color = AppColors.black,
      required this.textAlign,
      required this.fontFamily,
      this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      textAlign: textAlign,
      style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: fontSize ?? 15.sp,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          color: color),
    );
  }
}
