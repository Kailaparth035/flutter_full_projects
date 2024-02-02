import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/comp_goal_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_goal_dialog.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CompGoalToggleCardWidget extends StatefulWidget {
  const CompGoalToggleCardWidget({
    super.key,
    required this.data,
    required this.userId,
    required this.styleId,
    required this.mainData,
    required this.onReaload,
  });
  final SubdataToggle data;
  final String userId;
  final String styleId;

  final CompGoalTitleList mainData;
  final Future Function(bool) onReaload;

  @override
  State<CompGoalToggleCardWidget> createState() =>
      _CompGoalToggleCardWidgetState();
}

class _CompGoalToggleCardWidgetState extends State<CompGoalToggleCardWidget> {
  bool prioritizeToggle = false;
  bool publishToggle = false;
  bool recognizeToggle = false;

  @override
  void initState() {
    prioritizeToggle = widget.data.isPrirotizeChecked == "1";
    publishToggle = widget.data.isPublishedChecked == "1";
    recognizeToggle = widget.data.isRecognizeChecked == "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardChildFirstRow();
  }

  Widget _buildCardChildFirstRow() {
    return Container(
      margin: EdgeInsets.only(bottom: 7.sp),
      padding: EdgeInsets.symmetric(vertical: 7.sp),
      decoration: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
        color: AppColors.backgroundColor1,
      ),
      width: double.infinity,
      child: Column(
        children: [
          _buildTitleDescription(
            "SUGGESTED OBJECTIVES",
            widget.data.suggestedObjective.toString(),
            false,
          ),
          _buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.data.isRecognizeShow == "1"
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "RECOGNIZE",
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor2,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 9.sp,
                              maxLine: 10,
                              fontWeight: FontWeight.w700,
                            ),
                            5.sp.sbh,
                            ToggleButtonWidget(
                              height: 16.sp,
                              width: 40.sp,
                              padding: 1.sp,
                              value: recognizeToggle,
                              onChange: (val) {
                                setState(() {
                                  recognizeToggle = !recognizeToggle;
                                });
                                updateRecognizeToggle(
                                    recognizeToggle, widget.data);
                              },
                              isShowText: false,
                              isDisable: false,
                            ),
                          ],
                        ),
                      )
                    : 0.sbh,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "PRIORITIZE",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor2,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 9.sp,
                        maxLine: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      5.sp.sbh,
                      ToggleButtonWidget(
                        height: 16.sp,
                        width: 40.sp,
                        padding: 1.sp,
                        value: prioritizeToggle,
                        onChange: (val) {
                          if (widget.data.isPrirotizeDisabled != "1") {
                            setState(() {
                              prioritizeToggle = !prioritizeToggle;
                            });
                            toggle(true, prioritizeToggle);
                          }
                        },
                        isShowText: false,
                        isDisable: widget.data.isPrirotizeDisabled != "0",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "PUBLISH",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor2,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 9.sp,
                        maxLine: 10,
                        fontWeight: FontWeight.w700,
                      ),
                      5.sp.sbh,
                      ToggleButtonWidget(
                        height: 16.sp,
                        width: 40.sp,
                        padding: 1.sp,
                        value: publishToggle,
                        onChange: (val) {
                          if (widget.data.isPublishedDisabled != "1" &&
                              prioritizeToggle == true) {
                            setState(() {
                              publishToggle = !publishToggle;
                            });

                            toggle(false, publishToggle);
                          }
                        },
                        isShowText: false,
                        isDisable: widget.data.isPublishedDisabled != "0",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildTitleDescription(String title, String value, bool isLast) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.sp),
      child: Column(
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
          2.sp.sbh,
          CustomText(
            text: value,
            textAlign: TextAlign.start,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 9.sp,
            maxLine: 10,
            fontWeight: FontWeight.w700,
          ),
          5.sp.sbh,
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      height: 1,
      color: AppColors.labelColor,
      thickness: 1,
    );
  }

  toggle(bool isPrior, bool isTrue) async {
    var result = await Get.find<DevelopmentController>().updateGoalButton(
      isPriore: isPrior,
      userId: widget.userId,
      goalselector: isPrior
          ? isTrue == true
              ? "1"
              : "0"
          : isTrue == true
              ? "2"
              : "1",
      corecompetencyId: widget.data.compentencyId.toString(),
      positionId: widget.mainData.positionId.toString(),
      positionDetail: widget.mainData.positionDetail.toString(),
      focusId: widget.data.id.toString(),
      recognizeButton: "0",
      type: "3",
      context: context,
    );

    if (result != null) {
      if (isPrior == false && isTrue == true) {
        // ignore: use_build_context_synchronously
        var res = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return GoalDetailDialog(
              goalId: result,
              title: widget.data.suggestedObjective.toString(),
              styleId: widget.styleId,
              userId: widget.userId,
            );
          },
        );
        if (res != null && res == true) {
          await widget.onReaload(false);
        }
      }
    } else {
      if (isPrior == true) {
        setState(() {
          prioritizeToggle = !prioritizeToggle;
        });
      } else {
        setState(() {
          publishToggle = !publishToggle;
        });
      }
    }
  }

  updateRecognizeToggle(bool isTrue, SubdataToggle data) async {
    bool? result = await Get.find<DevelopmentController>().updateGoalButton(
      isPriore: true,
      userId: widget.userId,
      goalselector: "0",
      corecompetencyId: widget.data.compentencyId.toString(),
      positionId: widget.mainData.positionId.toString(),
      positionDetail: widget.mainData.positionDetail.toString(),
      focusId: widget.data.id.toString(),
      recognizeButton: isTrue == true ? "1" : "0",
      type: "3",
      context: context,
    );

    if (result != null && result == true) {
    } else {
      setState(() {
        recognizeToggle = !recognizeToggle;
      });
    }
  }
}
