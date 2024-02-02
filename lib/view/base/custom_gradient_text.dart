import 'package:aspirevue/controller/common_controller.dart';
import 'package:flutter/material.dart';

import '../../util/gradient_text.dart';
import '../../util/string.dart';

class CustomGradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final TextDecoration decoration;

  const CustomGradientText(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.fontFamily,
      required this.fontWeight,
      this.decoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    return GradientText(text,
        style: TextStyle(
            fontSize: fontSize,
            decoration: decoration,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: fontWeight),
        gradient: CommonController.getLinearGradientSecondryAndPrimary());
  }
}
