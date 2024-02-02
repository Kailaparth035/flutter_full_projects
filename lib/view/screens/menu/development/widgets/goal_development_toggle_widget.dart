import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_goal_dialog.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DevelopmentToggleWidget extends StatefulWidget {
  const DevelopmentToggleWidget({
    super.key,
    required this.data,
    required this.styleId,
    required this.userId,
    required this.onReaload,
  });
  final GoalDataForDevelopment data;
  final Future Function(bool) onReaload;

  final String? styleId;
  final String? userId;
  @override
  State<DevelopmentToggleWidget> createState() =>
      _DevelopmentToggleWidgetState();
}

class _DevelopmentToggleWidgetState extends State<DevelopmentToggleWidget> {
  bool prioritizeToggle = false;
  bool publishToggle = false;
  bool recognizeToggle = false;
  @override
  void initState() {
    prioritizeToggle = widget.data.prioritizeChecked == "1";
    publishToggle = widget.data.publishChecked == "1";
    recognizeToggle = widget.data.recognizeChecked == "1";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardChildFirstRow(widget.data);
  }

  Column _buildCardChildFirstRow(GoalDataForDevelopment data) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "SKILL/STRENGTH",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor2,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 9.sp,
                      maxLine: 10,
                      fontWeight: FontWeight.w700,
                    ),
                    5.sp.sbh,
                    CustomText(
                      text: data.skill.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.black,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 11.sp,
                      maxLine: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                )),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: "FREQUENCY",
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor2,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 9.sp,
                    maxLine: 10,
                    fontWeight: FontWeight.w700,
                  ),
                  5.sp.sbh,
                  CustomText(
                    text: data.difference.toString(),
                    textAlign: TextAlign.center,
                    color: AppColors.black,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    maxLine: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
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
                      if (data.prioritizeEnable == "1") {
                        setState(() {
                          prioritizeToggle = !prioritizeToggle;
                        });
                        toggle(true, prioritizeToggle, data);
                      }
                    },
                    isShowText: false,
                    isDisable: data.prioritizeEnable == "0",
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
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
                      if (data.publishEnable == "1" &&
                          prioritizeToggle == true) {
                        setState(() {
                          publishToggle = !publishToggle;
                        });

                        toggle(false, publishToggle, data);
                      }
                    },
                    isShowText: false,
                    isDisable: data.publishEnable == "0",
                  ),
                ],
              ),
            ),
          ],
        ),
        data.recognizeShow == "1"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.sp),
                    child: Column(
                      children: [
                        10.sp.sbh,
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
                            if (data.recognizeEnable == "1") {
                              setState(() {
                                recognizeToggle = !recognizeToggle;
                              });

                              updateRecognizeToggle(recognizeToggle, data);
                            }
                          },
                          isShowText: false,
                          isDisable: data.recognizeEnable != "1",
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : 0.sbh,
      ],
    );
  }

  toggle(bool isPrior, bool isTrue, GoalDataForDevelopment data) async {
    var result = await Get.find<DevelopmentController>().enableGoal(
      styleId: widget.styleId.toString(),
      areaId: widget.data.areaId.toString(),
      markingType: data.markingType.toString(),
      toUser: widget.userId.toString(),
      goalSelector: isTrue == true ? "1" : "0",
      dailyToBe: data.dailyToBe.toString(),
      behaviorDesc: data.behaviorDesc.toString(),
      suggesstedObj: data.suggesstedObj.toString(),
      difference: data.difference.toString(),
      isPrioritize: isPrior == true ? "1" : "0",
      context: context,
      isPriore: isPrior,
      area: widget.data.area.toString(),
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
              title: data.suggesstedObj.toString(),
              styleId: widget.styleId.toString(),
              userId: widget.userId.toString(),
            );
          },
        );
        if (res != null && res == true) {
          await widget.onReaload(false);
        }
      }
      if (isPrior == true) {
        await widget.onReaload(false);
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

  updateRecognizeToggle(bool isTrue, GoalDataForDevelopment data) async {
    bool? result = await Get.find<DevelopmentController>().enableRecognize(
      styleId: widget.styleId.toString(),
      areaId: widget.data.areaId.toString(),
      toUser: widget.userId.toString(),
      score: data.difference.toString(),
      isRecognize: isTrue ? "1" : "0",
      scaleId: data.scaleId ?? "0",
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
