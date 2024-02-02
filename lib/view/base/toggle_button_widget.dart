import 'package:aspirevue/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class ToggleButtonWidget extends StatelessWidget {
  const ToggleButtonWidget(
      {super.key,
      required this.value,
      required this.onChange,
      required this.isShowText,
      this.height,
      this.width,
      this.activeText,
      this.inactiveText,
      this.isDisable,
      this.padding});
  final bool? isDisable;
  final bool value;
  final bool isShowText;
  final Function(bool) onChange;
  final double? height;
  final double? width;
  final double? padding;

  final String? activeText;
  final String? inactiveText;

  @override
  Widget build(BuildContext context) {
    // return FlutterSwitch(
    //   width: width ?? 45.sp,
    //   height: height ?? 20.sp,
    //   padding: padding ?? 2.sp,
    //   activeText: activeText ?? AppString.yes,
    //   inactiveText: inactiveText ?? AppString.no,
    //   showOnOff: isShowText,
    //   activeTextColor: AppColors.primaryColor,
    //   inactiveTextColor: AppColors.redColor,
    //   activeTextFontWeight: FontWeight.w500,
    //   inactiveTextFontWeight: FontWeight.w500,
    //   inactiveToggleColor:
    //       isDisable == true ? AppColors.labelColor23 : AppColors.labelColor8,
    //   activeToggleColor:
    //       isDisable == true ? AppColors.labelColor23 : AppColors.primaryColor,
    //   activeColor: AppColors.labelColor46,
    //   inactiveColor: AppColors.labelColor46,
    //   valueFontSize: height == null ? 10.sp : height! - 8.sp,
    //   toggleSize: height == null ? 15.sp : height! - 5.sp,
    //   value: value,
    //   onToggle: (val) {
    //     if (isDisable != true) {
    //       onChange(val);
    //     }
    //   },
    // );

    return SizedBox(
      // color: Colors.amber,
      // height: 10.0,
      height: 20.sp,
      width: 38.sp,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: CupertinoSwitch(
          activeColor: isDisable == true
              ? AppColors.labelColor23
              : AppColors.primaryColor,
          trackColor: isDisable == true ? AppColors.labelColor23 : null,
          value: value,
          onChanged: (val) {
            if (isDisable != true) {
              onChange(val);
            }
          },
        ),
      ),
    );
  }

  // }
}
