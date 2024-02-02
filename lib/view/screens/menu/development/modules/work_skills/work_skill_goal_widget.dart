import 'package:aspirevue/controller/development/work_skill_controller.dart';
import 'package:aspirevue/data/model/response/development/work_skill_goal_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_goal_expandable_card_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WorkSkillGoalWidget extends StatefulWidget {
  const WorkSkillGoalWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<WorkSkillGoalWidget> createState() => _WorkSkillGoalWidgetState();
}

class _WorkSkillGoalWidgetState extends State<WorkSkillGoalWidget> {
  final _workSkillController = Get.find<WorkSkillController>();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    _workSkillController.getGoalAchievementsDetails(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<WorkSkillController>(builder: (workSkillController) {
      if (workSkillController.isLoadingGoal) {
        return const Center(child: CustomLoadingWidget());
      }
      if (workSkillController.isErrorGoal ||
          workSkillController.dataGoal == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              workSkillController.getGoalAchievementsDetails(
                  true, widget.userId);
            },
            text: workSkillController.isErrorGoal
                ? workSkillController.errorMsgGoal
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(workSkillController.dataGoal!);
      }
    });
  }

  Widget _buildView(WorkskillGoalData dataGoal) {
    return Stack(
      children: [
        CustomSlideUpAndFadeWidget(
          child: RefreshIndicator(
            onRefresh: () {
              return _workSkillController.getGoalAchievementsDetails(
                  true, widget.userId);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBlackTitle(
                        "Work Skills: Prioritizing and Selecting Development Objectives."),
                    5.sp.sbh,
                    buildGreyTitle(
                        "Potential development objectives are listed below based on Reputation feedback. Select the category to explore scores and suggested objectives. Select PRIORITIZE to target areas that you would like to focus on in the future. Then, select PUBLISH to create a development objective for action. Published items will also appear in the list of Development Objectives as well as on the DailyQ."),
                    20.sp.sbh,
                    ...dataGoal.sliderList!
                        .map((e) => DevelopmentGoalExpandableCardWidget(
                              data: e,
                              styleId: dataGoal.styleId.toString(),
                              userId: dataGoal.userId.toString(),
                              onReaload: (val) async {
                                await _workSkillController
                                    .getGoalAchievementsDetails(
                                        val, widget.userId);
                              },
                            ))
                  ],
                ),
              ),
            ),
          ),
        ),
        dataGoal.isJourneyLicensePurchased == 0
            ? PurchasePopupWidget(
                text: dataGoal.journeyLicensePurchaseText.toString(),
              )
            : 0.sbh
      ],
    );
  }
}
