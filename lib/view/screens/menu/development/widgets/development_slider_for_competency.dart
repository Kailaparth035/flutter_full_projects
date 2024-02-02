import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/development/comp_reflect_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentSliderForCompetency extends StatefulWidget {
  const DevelopmentSliderForCompetency({
    super.key,
    required this.title,
    required this.sliderValue,
    required this.onChange,
    required this.data,
    required this.isReset,
  });
  final bool isReset;
  final String title;
  final double sliderValue;
  final Function(double) onChange;
  final SliderListForCompetancy data;

  @override
  State<DevelopmentSliderForCompetency> createState() =>
      _DevelopmentSliderForCompetencyState();
}

class _DevelopmentSliderForCompetencyState
    extends State<DevelopmentSliderForCompetency> {
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
          _buildTitle(),
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
              max: 100.0,
              isEnable: true,
              value: widget.sliderValue,
              returnValue: widget.onChange,
              isReset: widget.isReset,
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.all(8.sp),
          //   child: Center(
          //     child: SelfReflactViewPopUp(
          //       title: "Scoring Rubric",
          //       desc: widget.data.rubricDescription.toString(),
          //       child: CustomButton2(
          //           padding:
          //               EdgeInsets.symmetric(horizontal: 10.sp, vertical: 3.sp),
          //           buttonText: widget.data.rubricTitle.toString(),
          //           radius: 15.sp,
          //           fontSize: 10.sp,
          //           onPressed: () {}),
          //     ),
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.all(8.sp),
            child: Center(
              child: SelfReflactViewPopUp(
                isHtml: true,
                title: "Scoring Rubric",
                desc: widget.data.rubricDescription.toString(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.sp),
                    gradient:
                        CommonController.getLinearGradientSecondryAndPrimary(),
                    boxShadow: CommonController.getBoxShadow,
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
                    child: CustomText(
                      text: widget.data.rubricTitle.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.white,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
          // Row(
          //   children: [
          //     Container(
          //       padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
          //       child: CustomText(
          //         text: "Scoring Rubric : ",
          //         textAlign: TextAlign.start,
          //         color: AppColors.labelColor69,
          //         fontFamily: AppString.manropeFontFamily,
          //         fontSize: 10.sp,
          //         maxLine: 2,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     10.sp.sbw,
          //     Expanded(
          //       child: Align(
          //         alignment: Alignment.centerRight,
          //         child: SelfReflactViewPopUp(
          //           title: "Scoring Rubric",
          //           desc: widget.data.rubricDescription.toString(),
          //           child: Container(
          //             padding: EdgeInsets.symmetric(
          //                 vertical: 4.sp, horizontal: 7.sp),
          //             child: CustomText(
          //               text: widget.data.rubricTitle.toString(),
          //               textAlign: TextAlign.start,
          //               color: AppColors.labelColor8,
          //               fontFamily: AppString.manropeFontFamily,
          //               fontSize: 10.sp,
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
              desc: widget.data.description.toString(),
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
