import 'package:aspirevue/controller/common_controller.dart';
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

class DevelopmentGoalCardWidget extends StatefulWidget {
  const DevelopmentGoalCardWidget({
    super.key,
    required this.data,
    required this.type,
    required this.styleId,
    required this.userId,
    required this.onReload,
  });
  final String styleId;
  final String userId;
  final DevelopmentType type;
  final GoalDataForDevelopment data;
  final Future Function(bool) onReload;

  @override
  State<DevelopmentGoalCardWidget> createState() =>
      _DevelopmentGoalCardWidgetState();
}

class _DevelopmentGoalCardWidgetState extends State<DevelopmentGoalCardWidget> {
  bool prioritizeToggle = false;
  bool publishToggle = false;
  bool recognizeToggle = false;
  @override
  void initState() {
    prioritizeToggle = widget.data.prioritizeChecked == "1";
    publishToggle = widget.data.publishChecked == "1";
    recognizeToggle = widget.data.recognizeShow == "1";
    super.initState();
  }

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
        text: widget.type == DevelopmentType.behaviors
            ? "Aspirational Identity: ${widget.data.skill.toString()}"
            : "SKILL/STRENGTH : ${widget.data.skill.toString()}",
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
          _buildCardChildFirstRow(),
          5.sp.sbh,
          widget.type == DevelopmentType.emotions
              ? _buildListTileForEmotions()
              : 0.sbh,
          widget.type == DevelopmentType.leaderStyle
              ? _buildListTileForLeaderStyle()
              : 0.sbh,
          widget.type == DevelopmentType.riskFactors
              ? _buildListTileForRiskFactor()
              : 0.sbh,
          widget.type == DevelopmentType.riskFactors2
              ? _buildListTileForRiskFactor2()
              : 0.sbh,
          widget.type == DevelopmentType.valuesStyle2
              ? _buildListTileForValues()
              : 0.sbh,
          _buildDivider(),
          5.sp.sbh,
          _buildTitleDescription(
              widget.type == DevelopmentType.behaviors
                  ? "VALUE DRIVERS"
                  : "BEHAVIORAL DESCRIPTION",
              widget.type == DevelopmentType.behaviors
                  ? widget.data.valueDrivers ?? "--"
                  : widget.data.behaviorDesc.toString(),
              false),
          _buildTitleDescription("SUGGESTED OBJECTIVES",
              widget.data.suggesstedObj.toString(), true),
        ],
      ),
    );
  }

  Widget _buildListTileForValues() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "PURSUITS : ",
                style: TextStyle(
                  fontSize: 9.sp,
                  fontFamily: AppString.manropeFontFamily,
                  fontWeight: FontWeight.w700,
                  color: AppColors.labelColor2,
                ),
              ),
              TextSpan(
                text: widget.data.pursuits.toString(),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontFamily: AppString.manropeFontFamily,
                  fontWeight: FontWeight.w600,
                  color: AppColors.labelColor35,
                ),
              )
            ],
          ),
        ),
        5.sp.sbh,
      ],
    );
  }

  Widget _buildListTileForRiskFactor2() {
    return Column(
      children: [
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "DAILY-Q : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.dailyToBe.toString(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            ),
            20.sp.sbw,
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "ACTION : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.action.toString(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        5.sp.sbh,
      ],
    );
  }

  Widget _buildListTileForEmotions() {
    return Column(
      children: [
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "DAILY-Q : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.dailyq.toString(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            ),
            20.sp.sbw,
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "ACTION : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.action.toString(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        5.sp.sbh,
      ],
    );
  }

  Widget _buildListTileForLeaderStyle() {
    return Column(
      children: [
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "BE MORE : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.beMore.toString(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            ),
            20.sp.sbw,
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "ACTION : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.action.toString(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        5.sp.sbh,
      ],
    );
  }

  Widget _buildListTileForRiskFactor() {
    return Column(
      children: [
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
        Row(
          children: [
            Expanded(
              child: CustomText(
                text: widget.data.title.toString(),
                textAlign: TextAlign.start,
                color: AppColors.labelColor2,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 9.sp,
                maxLine: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            20.sp.sbw,
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "ACTION : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: widget.data.riskScore.toString(),
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        5.sp.sbh,
      ],
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

  Row _buildCardChildFirstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: _getFirstTitle(),
                  textAlign: TextAlign.center,
                  color: AppColors.labelColor2,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 9.sp,
                  maxLine: 10,
                  fontWeight: FontWeight.w700,
                ),
                5.sp.sbh,
                Center(
                  child: CustomText(
                    text: _getFirstTitleValue(),
                    textAlign: TextAlign.center,
                    color: AppColors.black,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    maxLine: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )),
        widget.data.recognizeShow == "1"
            ? Expanded(
                flex: 2,
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
                        updateRecognizeToggle(recognizeToggle, widget.data);
                      },
                      isShowText: false,
                      isDisable: false,
                    ),
                  ],
                ),
              )
            : 0.sbh,
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
                  if (widget.data.prioritizeEnable == "1") {
                    setState(() {
                      prioritizeToggle = !prioritizeToggle;
                    });
                    toggle(true, prioritizeToggle);
                  }
                },
                isShowText: false,
                isDisable: widget.data.prioritizeEnable == "0",
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
                  if (widget.data.publishEnable == "1" &&
                      prioritizeToggle == true) {
                    setState(() {
                      publishToggle = !publishToggle;
                    });

                    toggle(false, publishToggle);
                  }
                },
                isShowText: false,
                isDisable: widget.data.publishEnable == "0",
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getFirstTitle() {
    switch (widget.type) {
      case DevelopmentType.traits:
        return "DIFFERENCE";
      case DevelopmentType.riskFactors:
        return "Area";
      case DevelopmentType.riskFactors2:
        return "Area";
      case DevelopmentType.leaderStyle:
        return "FREQ";
      case DevelopmentType.values1:
        return "DIFFERENCE";
      case DevelopmentType.valuesStyle2:
        return "DAILY Q TO BE";

      case DevelopmentType.cognitive:
        return "DIFFERENCE";
      case DevelopmentType.cognitiveStyle2:
        return "ACTION";

      case DevelopmentType.emotions:
        return "DIFFERENCE";

      case DevelopmentType.behaviors:
        return "ACTION";
      default:
        return "";
    }
  }

  String _getFirstTitleValue() {
    switch (widget.type) {
      case DevelopmentType.traits:
        return widget.data.difference.toString();
      case DevelopmentType.riskFactors:
        return widget.data.area.toString();
      case DevelopmentType.riskFactors2:
        return widget.data.area.toString();

      case DevelopmentType.leaderStyle:
        return widget.data.area.toString();

      case DevelopmentType.values1:
        return widget.data.difference.toString();
      case DevelopmentType.valuesStyle2:
        return widget.data.dailyq.toString();
      case DevelopmentType.cognitive:
        return widget.data.difference.toString();
      case DevelopmentType.cognitiveStyle2:
        return widget.data.action.toString();

      case DevelopmentType.emotions:
        return widget.data.difference.toString();

      case DevelopmentType.behaviors:
        return widget.data.action ?? "";
      default:
        return "";
    }
  }

  Divider _buildDivider() {
    return const Divider(
      height: 1,
      color: AppColors.labelColor,
      thickness: 1,
    );
  }

  toggle(bool isPrior, bool isTrue) async {
    var result = await Get.find<DevelopmentController>().enableGoal(
      styleId: widget.styleId,
      areaId: widget.data.areaId.toString(),
      markingType: widget.data.markingType.toString(),
      toUser: widget.userId,
      goalSelector: isTrue == true ? "1" : "0",
      dailyToBe: widget.data.dailyToBe.toString(),
      behaviorDesc: widget.data.behaviorDesc.toString(),
      suggesstedObj: widget.data.suggesstedObj.toString(),
      difference: widget.data.difference.toString(),
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
              title: widget.data.suggesstedObj.toString(),
              styleId: widget.styleId,
              userId: widget.userId,
            );
          },
        );
        if (res != null && res == true) {
          await widget.onReload(false);
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
