import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TitleSliderAndBottom2Title extends StatefulWidget {
  const TitleSliderAndBottom2Title({
    super.key,
    this.mainTitle,
    required this.title,
    required this.bottomLeftTitle,
    required this.bottomRightTitle,
    required this.list,
    this.mainTitleBGColor,
    this.mainTitleFontColor,
    this.mainBGColor,
    this.isShowtooltip = false,
    required this.isReset,
    this.description,
  });

  final String? mainTitle;
  final String title;
  final String bottomLeftTitle;
  final String bottomRightTitle;
  final List<SliderModel> list;
  final Color? mainTitleBGColor;
  final Color? mainTitleFontColor;
  final Color? mainBGColor;
  final bool isReset;
  final bool isShowtooltip;
  final String? description;

  @override
  State<TitleSliderAndBottom2Title> createState() =>
      _TitleSliderAndBottom2TitleState();
}

class _TitleSliderAndBottom2TitleState
    extends State<TitleSliderAndBottom2Title> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
        color: widget.mainBGColor ?? AppColors.white,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.mainTitle != null
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.sp),
                      topRight: Radius.circular(4.sp),
                    ),
                    color: widget.mainTitleBGColor ??
                        AppColors.labelColor15.withOpacity(0.85),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
                  child: CustomText(
                    text: widget.mainTitle!,
                    textAlign: TextAlign.start,
                    color: widget.mainTitleFontColor ?? AppColors.white,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    maxLine: 10,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : 0.sbh,
          widget.isShowtooltip ? _buildTitle() : 0.sbh,
          widget.title == "" || widget.isShowtooltip == true
              ? 0.sbh
              : Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                  child: CustomText(
                    text: widget.title,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.sp),
                bottomLeft: Radius.circular(5.sp),
              ),
              color: AppColors.backgroundColor1,
            ),
            width: double.infinity,
            child: Column(
              children: [
                ...widget.list.map(
                  (e) => SliderWidget(
                    sliderColor: e.color,
                    isEnable: e.isEnable,
                    value: e.value,
                    returnValue: (val) {
                      if (e.returnValue != null) {
                        e.returnValue!(val);
                      }
                    },
                    interval: e.interval,
                    isReset: widget.isReset,
                    max: e.max,
                  ),
                )
              ],
            ),
          ),
          widget.bottomLeftTitle != "" && widget.bottomRightTitle != ""
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.sp, horizontal: 7.sp),
                          child: CustomText(
                            text: widget.bottomLeftTitle,
                            textAlign: TextAlign.start,
                            color: AppColors.labelColor8,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5.sp),
                        height: double.infinity,
                        width: 1.sp,
                        color: AppColors.labelColor68.withOpacity(0.40),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.sp, horizontal: 7.sp),
                          child: CustomText(
                            text: widget.bottomRightTitle,
                            textAlign: TextAlign.end,
                            color: AppColors.labelColor8,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : widget.bottomLeftTitle != ""
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 4.sp, horizontal: 7.sp),
                      child: CustomText(
                        text: widget.bottomLeftTitle,
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor8,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : 0.sbh,
        ],
      ),
    );
  }

  Row _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
            child: CustomText(
              text: widget.title,
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
          child: SelfReflactViewPopUp(
              isHtml: true,
              title: widget.title,
              desc: widget.description.toString(),
              child: Image.asset(
                AppImages.infoIc,
                height: 15.sp,
                width: 15.sp,
              )),
        )
      ],
    );
  }
}
