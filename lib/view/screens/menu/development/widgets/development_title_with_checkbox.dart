import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentTitleWithCheckBox extends StatefulWidget {
  const DevelopmentTitleWithCheckBox({
    super.key,
    required this.title,
    this.secondTitle,
    required this.isChecked,
    required this.isReset,
    required this.onChange,
  });

  final String title;
  final String? secondTitle;
  final bool isChecked;
  final Function(bool) onChange;
  final bool isReset;

  @override
  State<DevelopmentTitleWithCheckBox> createState() =>
      _DevelopmentTitleWithCheckBoxState();
}

class _DevelopmentTitleWithCheckBoxState
    extends State<DevelopmentTitleWithCheckBox> {
  bool isChecked = false;
  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DevelopmentTitleWithCheckBox oldWidget) {
    if (widget.isReset == true) {
      setState(() {
        isChecked = widget.isChecked;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

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
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
                  child: CustomText(
                    text: widget.title,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              CustomCheckBox(
                onTap: () {
                  widget.onChange(!isChecked);
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                borderColor: AppColors.labelColor8,
                fillColor: AppColors.labelColor8,
                isChecked: isChecked,
              ),
              5.sp.sbw
            ],
          ),
          Container(
            color: AppColors.labelColor,
            height: 1.sp,
            width: double.infinity,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
            child: CustomText(
              text: widget.secondTitle!,
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
