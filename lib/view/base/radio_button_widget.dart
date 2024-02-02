import 'package:aspirevue/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RadioButtonWidget extends StatelessWidget {
  const RadioButtonWidget(
      {super.key,
      required this.value,
      required this.gpValue,
      required this.onTap});
  final String value;
  final String gpValue;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10.sp,
      width: 10.sp,
      child: Transform.scale(
        scale: 0.7.sp,
        child: Radio(
          value: value,
          groupValue: gpValue,
          activeColor: AppColors.labelColor8,
          fillColor:
              MaterialStateColor.resolveWith((states) => AppColors.labelColor8),
          onChanged: (value) {
            onTap();
          },
        ),
      ),
    );
  }
}
