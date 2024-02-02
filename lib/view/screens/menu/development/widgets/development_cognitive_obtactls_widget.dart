import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentCognitiveObtaclsWidget extends StatelessWidget {
  const DevelopmentCognitiveObtaclsWidget({super.key, required this.data});
  final CognitiveObstacle data;
  @override
  Widget build(BuildContext context) {
    return _buildBoxListTile();
  }

  Container _buildBoxListTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
          boxShadow: CommonController.getBoxShadow,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: AppColors.labelColor),
          color: AppColors.white),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(),
          _buildChild(),
        ],
      ),
    );
  }

  Container _buildCardTitle() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.sp),
          topRight: Radius.circular(5.sp),
        ),
        color: AppColors.labelColor15.withOpacity(0.85),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
      child: CustomText(
        text: "Obstacle : ${data.areaName}",
        textAlign: TextAlign.start,
        color: AppColors.white,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 12.sp,
        maxLine: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildChild() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(5.sp),
          bottomLeft: Radius.circular(5.sp),
        ),
        color: AppColors.backgroundColor1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Action",
            textAlign: TextAlign.center,
            color: AppColors.labelColor2,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 9.sp,
            maxLine: 10,
            fontWeight: FontWeight.w700,
          ),
          5.sp.sbh,
          CustomText(
            text: data.selectedAction.toString(),
            textAlign: TextAlign.center,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            maxLine: 10,
            fontWeight: FontWeight.w600,
          ),
          5.sp.sbh,
          _buildDivider(),
          5.sp.sbh,
          _buildTitleDescription(
              "In terms of your own awareness, select the thinking tendencies that might occasionally surface within yourself."
                  .toUpperCase(),
              data.leftMeaning.toString(),
              true)
        ],
      ),
    );
  }

  _buildTitleDescription(String title, String value, bool isLast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          textAlign: TextAlign.start,
          color: AppColors.labelColor2,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 9.sp,
          maxLine: 10,
          fontWeight: FontWeight.w700,
        ),
        5.sp.sbh,
        value.toString() != ""
            ? Column(
                children: [
                  CustomText(
                    text: value,
                    textAlign: TextAlign.start,
                    color: AppColors.black,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    maxLine: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  5.sp.sbh
                ],
              )
            : 0.sbh,
        isLast
            ? 0.sbh
            : Column(
                children: [
                  _buildDivider(),
                  5.sp.sbh,
                ],
              ),
      ],
    );
  }

  Divider _buildDivider() {
    return const Divider(
      height: 1,
      color: AppColors.labelColor,
      thickness: 1,
    );
  }
}
