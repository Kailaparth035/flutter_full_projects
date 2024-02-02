import 'package:aspirevue/util/string.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'colors.dart';

class WidgetStyles {
  static TextStyle normalText = TextStyle(
    color: AppColors.normalTextColor,
    fontFamily: AppString.manropeFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 9.sp,
  );

  static TextStyle highLightText = TextStyle(
    decoration: TextDecoration.underline,
    color: AppColors.secondaryColor,
    fontFamily: AppString.manropeFontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
  );
}
