import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentTitleWithExpandedWidget extends StatefulWidget {
  const DevelopmentTitleWithExpandedWidget({
    super.key,
    required this.mainTitle,
    required this.title,
    required this.list,
  });

  final String mainTitle;
  final String title;

  final List list;

  @override
  State<DevelopmentTitleWithExpandedWidget> createState() =>
      _DevelopmentTitleWithRadioWidgetState();
}

class _DevelopmentTitleWithRadioWidgetState
    extends State<DevelopmentTitleWithExpandedWidget> {
  @override
  void initState() {
    super.initState();
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
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    maxLine: 10,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : 0.sbh,
          const Divider(
            height: 1,
          ),
          5.sp.sbh,
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...widget.list.map(
                (e) => Expanded(
                  child: _buildRadioWithTitle(
                      title: e["title"],
                      value: e["value"],
                      color: e["color"] != null ? e["color"] as Color : null,
                      count: e["count_value"] != null
                          ? e["count_value"] as String
                          : null),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRadioWithTitle(
      {required String title,
      required String value,
      Color? color,
      String? count}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.sp),
          child: CustomText(
            text: title,
            textAlign: TextAlign.center,
            color: AppColors.labelColor69,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            maxLine: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        5.sp.sbh,
        // CustomText(
        //   text: value,
        //   textAlign: TextAlign.center,
        //   color: color ?? AppColors.black,
        //   fontFamily: AppString.manropeFontFamily,
        //   fontSize: 10.sp,
        //   maxLine: 10,
        //   fontWeight: FontWeight.w500,
        // ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: AppString.manropeFontFamily,
                  fontWeight: FontWeight.w500,
                  color: color ?? AppColors.black,
                ),
              ),
              TextSpan(
                text: count == null || count == "" ? "" : " ($count)",
                style: TextStyle(
                  fontSize: 10.sp,
                  fontFamily: AppString.manropeFontFamily,
                  fontWeight: FontWeight.w500,
                  color: AppColors.labelColor8,
                ),
              )
            ],
          ),
        ),

        // SizedBox(
        //   height: 15,
        //   width: 15,
        //   child: Radio(
        //     value: value,
        //     groupValue: radioGPValue,
        //     activeColor: AppColors.labelColor8,
        //     fillColor: MaterialStateColor.resolveWith(
        //         (states) => AppColors.labelColor8),
        //     onChanged: (value) {
        //       setState(() {
        //         radioGPValue = value;
        //       });
        //       // onTap();
        //     },
        //   ),
        // ),
        10.sp.sbh,
      ],
    );
  }
}
