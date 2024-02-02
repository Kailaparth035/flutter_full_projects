import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentSliderWithLeftRightTitle extends StatefulWidget {
  const DevelopmentSliderWithLeftRightTitle({
    super.key,
    required this.topTitle,
    required this.topSecondTitle,
    this.bottomTitle,
    this.bottomSecondTitle,
    required this.sliderValue,
    required this.onChange,
    this.headerTitle,
    required this.isReset,
    required this.isEnable,
  });

  final String topTitle;
  final String topSecondTitle;
  final String? bottomTitle;
  final String? bottomSecondTitle;
  final String? headerTitle;
  final double sliderValue;
  final Function(double) onChange;
  final bool isReset;
  final bool isEnable;

  @override
  State<DevelopmentSliderWithLeftRightTitle> createState() =>
      _DevelopmentSliderWithLeftRightTitleState();
}

class _DevelopmentSliderWithLeftRightTitleState
    extends State<DevelopmentSliderWithLeftRightTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
        color: AppColors.white,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.headerTitle != null
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.sp),
                      topRight: Radius.circular(6.sp),
                    ),
                    color: AppColors.labelColor15.withOpacity(0.85),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                  child: CustomText(
                    text: widget.headerTitle!,
                    textAlign: TextAlign.start,
                    color: AppColors.white,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : 0.sbh,
          widget.topTitle == "" && widget.topSecondTitle == ""
              ? 0.sbh
              : _buildLeftRight(widget.topTitle, widget.topSecondTitle),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.sp),
                bottomLeft: Radius.circular(5.sp),
              ),
              color: AppColors.backgroundColor1,
            ),
            width: double.infinity,
            child: SliderWidget(
              isEnable: widget.isEnable,
              value: widget.sliderValue,
              isReset: widget.isReset,
              returnValue: (val) {
                widget.onChange(val);
              },
            ),
          ),
          widget.bottomTitle == null || widget.bottomSecondTitle == null
              ? 0.sbh
              : _buildLeftRight(widget.bottomTitle!, widget.bottomSecondTitle!),
        ],
      ),
    );
  }

  Widget _buildLeftRight(String left, String right) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
              child: CustomText(
                text: left,
                textAlign: TextAlign.start,
                color: AppColors.labelColor8,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 5.sp),
          //   height: double.infinity,
          //   width: 1.sp,
          //   color: AppColors.labelColor68.withOpacity(0.40),
          // ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
              child: CustomText(
                text: right,
                textAlign: TextAlign.end,
                color: AppColors.labelColor8,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
