import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentTitleWithRadioWidget extends StatefulWidget {
  const DevelopmentTitleWithRadioWidget({
    super.key,
    required this.mainTitle,
    required this.title,
    required this.cbTitle1,
    required this.cbTitle2,
    required this.cbTitle3,
    required this.cbTitle1Flex,
    required this.cbTitle2Flex,
    required this.cbTitle3Flex,
    this.selectedIndex,
    required this.callBack,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.isReset,
  });

  final String mainTitle;
  final String title;

  final String cbTitle1;
  final String cbTitle2;
  final String cbTitle3;

  final String value1;
  final String value2;
  final String value3;

  final int cbTitle1Flex;
  final int cbTitle2Flex;
  final int cbTitle3Flex;
  final bool isReset;

  final String? selectedIndex;
  final Function(String) callBack;
  @override
  State<DevelopmentTitleWithRadioWidget> createState() =>
      _DevelopmentTitleWithRadioWidgetState();
}

class _DevelopmentTitleWithRadioWidgetState
    extends State<DevelopmentTitleWithRadioWidget> {
  String? radioGPValue = "0";
  @override
  void initState() {
    radioGPValue = widget.selectedIndex ?? "0";
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DevelopmentTitleWithRadioWidget oldWidget) {
    if (widget.isReset == true) {
      setState(() {
        radioGPValue = widget.selectedIndex;
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.sp),
                topRight: Radius.circular(4.sp),
              ),
              color: AppColors.labelColor15.withOpacity(0.85),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
            child: CustomText(
              text: widget.mainTitle,
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          widget.title != ""
              ? Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                  child: CustomText(
                    text: widget.title,
                    textAlign: TextAlign.start,
                    color: AppColors.black,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    maxLine: 10,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : 0.sbh,
          const Divider(
            height: 1,
          ),
          5.sp.sbh,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: widget.cbTitle1Flex,
                child: _buildRadioWithTitle(
                    title: widget.cbTitle1, value: widget.value1),
              ),
              Expanded(
                flex: widget.cbTitle2Flex,
                child: _buildRadioWithTitle(
                    title: widget.cbTitle2, value: widget.value2),
              ),
              Expanded(
                flex: widget.cbTitle3Flex,
                child: _buildRadioWithTitle(
                    title: widget.cbTitle3, value: widget.value3),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRadioWithTitle({required String title, required String value}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.sp),
          child: CustomText(
            text: title,
            textAlign: TextAlign.center,
            color: AppColors.labelColor69,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 9.sp,
            maxLine: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        10.sp.sbh,
        SizedBox(
          height: 15,
          width: 15,
          child: Radio(
            value: value,
            groupValue: radioGPValue,
            activeColor: AppColors.labelColor8,
            fillColor: MaterialStateColor.resolveWith(
                (states) => AppColors.labelColor8),
            onChanged: (value) {
              setState(() {
                radioGPValue = value;
              });
              if (value != null) {
                widget.callBack(value.toString());
              }
            },
          ),
        ),
        10.sp.sbh,
      ],
    );
  }
}
