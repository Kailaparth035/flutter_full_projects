import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentSelfReflectTitleWidget extends StatelessWidget {
  const DevelopmentSelfReflectTitleWidget({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: title,
      textAlign: TextAlign.center,
      color: AppColors.labelColor15,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 10.sp,
      maxLine: 500,
      fontWeight: FontWeight.w600,
    );
  }
}
