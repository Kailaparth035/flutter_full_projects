import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/development/graph_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_gradient_text.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/modules/behaviors/behaviors_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/character_strengths/character_strengths_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/cognitive/cognitive_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/compentency/compentency_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/emotions/emotions_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/leader_style/leader_style_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/risk_fectors/risk_fectors_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/traits/traits_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/values/values_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/work_skills/work_skill_module_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile_nic/timeline_tile.dart';

class JournyTimeLineChart extends StatefulWidget {
  const JournyTimeLineChart(
      {super.key,
      required this.timelinedetails,
      required this.developmentType,
      required this.userId,
      required this.userRole});
  final DevelopmentType developmentType;
  final List<Timelinedetail>? timelinedetails;
  final String userId;
  final UserRole userRole;

  @override
  State<JournyTimeLineChart> createState() => _JournyTimeLineChartState();
}

class _JournyTimeLineChartState extends State<JournyTimeLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor28,
        borderRadius: BorderRadius.all(
          Radius.circular(10.sp),
        ),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.timelinedetails!.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 10.sp),
              child: TimelineTile(
                alignment: TimelineAlign.start,
                isFirst: index == 0,
                isLast: index == widget.timelinedetails!.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 50.sp,
                  height: 50.sp,
                  indicatorXY: 0,
                  indicator: _buildIndicators(index),
                ),
                beforeLineStyle: LineStyle(
                  color: widget
                              .timelinedetails![
                                  widget.timelinedetails!.length - 1 == index
                                      ? index
                                      : index + 1]
                              .completed ==
                          "1"
                      ? AppColors.primaryColor
                      : AppColors.labelColor54,
                  thickness: 10,
                ),
                endChild: _getEndChild(index),
              ),
            ),
          );
        },
      ),
    );
  }

  _getEndChild(index) {
    if (widget.timelinedetails![index].isFlagShow == "1") {
      if (widget.timelinedetails![index].flagShow == "1") {
        return middleTile(index);
      } else {
        return 40.sp.sbh;
      }
    } else {
      return mainTile(index);
    }

    // if (widget.timelinedetails![index].flagShow == "1" &&
    //     widget.timelinedetails![index].isFlagShow == "1") {
    //   if (widget.timelinedetails![index].isFlagShow != "1") {
    //     return 100.sp.sbh;
    //   } else {
    //     return middleTile(index);
    //   }
    // } else {
    //   return mainTile(index);
    // }
  }

  Widget mainTile(
    int index,
  ) {
    return SizedBox(
      height: 95.sp,
      child: Padding(
        padding: EdgeInsets.only(left: 10.sp),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomGradientText(
              fontWeight: FontWeight.w600,
              text: widget.timelinedetails![index].date.toString(),
              fontFamily: AppString.manropeFontFamily,
              fontSize: 14.sp,
            ),
            CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
              color: AppColors.black,
              text: widget.timelinedetails![index].title.toString(),
              textAlign: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
            ),
            CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 9.sp,
              color: AppColors.labelColor2,
              text: widget.timelinedetails![index].subtitle.toString(),
              textAlign: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
            ),
            // 53.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget middleTile(int index) {
    return SizedBox(
      height: 40.sp,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: Offset(context.isTablet ? -25.sp : -21.sp, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: 1.sp,
                  color: AppColors.primaryColor,
                ),
                Transform.translate(
                  offset: Offset(context.isTablet ? -15.sp : -12.sp,
                      context.isTablet ? -3.sp : -0.5.sp),
                  child: Image.asset(
                    AppImages.icFlagDown,
                    height: 20.sp,
                    width: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Transform.translate(
              offset: Offset(-25.sp, -15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.timelinedetails![index].flagText.toString() != ""
                      ? CustomText(
                          fontWeight: FontWeight.w500,
                          fontSize: 9.sp,
                          color: AppColors.labelColor2,
                          text: widget.timelinedetails![index].flagText
                              .toString(),
                          maxLine: 2,
                          textAlign: TextAlign.start,
                          fontFamily: AppString.manropeFontFamily,
                        )
                      : 0.sbh,

                  Container(
                    margin: EdgeInsets.only(
                        top: widget.timelinedetails![index].date.toString() ==
                                    "" ||
                                widget.timelinedetails![index].flagText
                                        .toString() ==
                                    ""
                            ? 5.sp
                            : 0.sp),
                    padding:
                        EdgeInsets.symmetric(vertical: 1.sp, horizontal: 4.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.greenColor,
                          AppColors.greenColor.withOpacity(0.5)
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                              "+${widget.timelinedetails![index].flagPoint.toString()}",
                          textAlign: TextAlign.start,
                          color: AppColors.white,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        3.sp.sbw,
                        Image.asset(
                          AppImages.icRound,
                          height: 10.sp,
                        )
                      ],
                    ),
                  ),
                  // 20.sp.sbh,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildIndicators(int index) {
    if (widget.timelinedetails![index].flagShow == "1" ||
        widget.timelinedetails![index].isFlagShow == "1") {
      if (widget.timelinedetails![index].isFlagShow == "1") {
        return SizedBox(
          height: 1.sp,
        );
      } else {
        return SizedBox(
          height: 1.sp,
        );
      }
    } else if (index == 0) {
      return Container(
        width: 50.sp,
        height: 50.sp,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        child: Center(
          child: Container(
            width: 40.sp,
            height: 40.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: CommonController.getLinearGradientSecondryAndPrimary(),
            ),
            child: Center(
              child: Image.asset(
                AppImages.icStartFly,
                height: 20.sp,
                width: 20.sp,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      );
    } else if (widget.timelinedetails![index].completed == "1") {
      return InkWell(
        onTap: () {
          _navigate(widget.timelinedetails![index].eventType.toString(),
              widget.timelinedetails);
        },
        child: Container(
          width: 50.sp,
          height: 50.sp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: CommonController.getLinearGradientSecondryAndPrimary(),
          ),
          child: Center(
            child: Container(
              width: 40.sp,
              height: 40.sp,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: Center(
                child: Image.asset(
                  AppImages.icTrue,
                  height: 50.sp,
                  width: 50.sp,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          _navigate(widget.timelinedetails![index].eventType.toString(),
              widget.timelinedetails);
        },
        child: Container(
          width: 50.sp,
          height: 50.sp,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.labelColor29,
          ),
          child: Center(
            child: Container(
              width: 40.sp,
              height: 40.sp,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              child: Center(
                child: Image.asset(
                  AppImages.icPlus,
                  height: 15.sp,
                  width: 15.sp,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  _navigate(String type, List<Timelinedetail>? timelinedetails) {
    bool isLearningShow = timelinedetails!
        .where((element) => element.eventType == "eLearning")
        .toList()
        .isNotEmpty;

    if (widget.developmentType == DevelopmentType.workSkills) {
      String tabName = getTabName(type);

      if (tabName != "") {
        Get.to(() => WorkSkillModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.competencies) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(() => CompetencyModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.traits) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(() => TraitsModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.values1) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(
          () => ValuesModuleScreen(
            isShowLearning: isLearningShow,
            tabName: tabName,
            userId: widget.userId,
            userRole: widget.userRole,
          ),
        );
      }
    } else if (widget.developmentType == DevelopmentType.riskFactors) {
      String tabName = getTabName(type);

      if (tabName != "") {
        Get.to(() => RiskFectorsModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.leaderStyle) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(() => LeaderStyleModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.characterStrengths) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(() => CharacterStrengthsModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.emotions) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(() => EmotionsModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.cognitive) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(() => CognitiveModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else if (widget.developmentType == DevelopmentType.behaviors) {
      String tabName = getTabName(type);
      if (tabName != "") {
        Get.to(() => BehaviorsModuleScreen(
              isShowLearning: isLearningShow,
              tabName: tabName,
              userId: widget.userId,
              userRole: widget.userRole,
            ));
      }
    } else {}
  }
}
