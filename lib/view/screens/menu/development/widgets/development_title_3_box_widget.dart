import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentTitle3BoxWidget extends StatelessWidget {
  const DevelopmentTitle3BoxWidget(
      {super.key,
      required this.title,
      required this.fontColor,
      required this.selfReflactionValue,
      required this.reputationValue,
      required this.assessValue,
      required this.myTargetValue,
      required this.type,
      this.bgColor});
  final Color fontColor;
  final Color? bgColor;
  final String title;
  final String selfReflactionValue;
  final String reputationValue;
  final String assessValue;
  final String myTargetValue;
  final int type;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: bgColor,
        gradient: bgColor != null
            ? null
            : CommonController.getLinearGradientSecondryAndPrimary(),
      ),
      child: Column(
        children: [
          CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: fontColor,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            maxLine: 500,
            fontWeight: FontWeight.w700,
          ),
          10.sp.sbh,
          type == 3
              ? Row(
                  children: [
                    _listTileItem("Reflect", selfReflactionValue, 5,
                        MainAxisAlignment.center),
                    _listTileItem("Reputation", reputationValue, 6,
                        MainAxisAlignment.center),
                    _listTileItem(
                        "Assess", assessValue, 5, MainAxisAlignment.center)
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        _listTileItem("Self-Reflection", selfReflactionValue, 6,
                            MainAxisAlignment.start),
                        _listTileItem("Reputation", reputationValue, 6,
                            MainAxisAlignment.end),
                      ],
                    ),
                    10.sp.sbh,
                    Row(
                      children: [
                        _listTileItem(
                            "Assess", assessValue, 6, MainAxisAlignment.start),
                        _listTileItem("My Target", myTargetValue, 6,
                            MainAxisAlignment.end),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Expanded _listTileItem(
      String title, String value, int flex, MainAxisAlignment align) {
    return Expanded(
        flex: flex,
        child: Row(
          mainAxisAlignment: align,
          children: [
            CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              maxLine: 500,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: " : ",
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              maxLine: 500,
              fontWeight: FontWeight.w700,
            ),
            Container(
              color: Colors.white,
              height: 15.sp,
              width: 25.sp,
              child: Center(
                child: CustomText(
                  text: value,
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor8,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  maxLine: 500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ));
  }
}
