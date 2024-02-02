import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/leader_style_controller.dart';
import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_goal_card_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LeaderStyleGoalWidget extends StatefulWidget {
  const LeaderStyleGoalWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<LeaderStyleGoalWidget> createState() => LeaderStyleGoalWidgetState();
}

class LeaderStyleGoalWidgetState extends State<LeaderStyleGoalWidget> {
  final _leaderStyleController = Get.find<LeaderStyleController>();

  @override
  void initState() {
    super.initState();
    _leaderStyleController.getGoalData(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<LeaderStyleController>(builder: (leaderStyleController) {
      if (leaderStyleController.isLoadingGoal) {
        return const Center(child: CustomLoadingWidget());
      }
      if (leaderStyleController.isErrorGoal ||
          leaderStyleController.dataGoal == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              leaderStyleController.getGoalData(true, widget.userId);
            },
            text: leaderStyleController.isErrorGoal
                ? leaderStyleController.errorMsgGoal
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return Stack(
          children: [
            _buildView(leaderStyleController.dataGoal!),
            leaderStyleController.dataGoal!.isJourneyLicensePurchased == 0
                ? PurchasePopupWidget(
                    text: leaderStyleController
                        .dataGoal!.journeyLicensePurchaseText
                        .toString(),
                  )
                : 0.sbh
          ],
        );
      }
    });
  }

  Widget _buildView(TraitsGoalData dataGoal) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _leaderStyleController.getGoalData(true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlackTitle(
                    "Prioritizing and Selecting Development Objectives"),
                5.sp.sbh,
                buildGreyTitle(
                    "Potential development objectives have been created and listed below. They are based on your targeted goals. PRIORITIZE those goals that are most important to you and PUBLISH at least one goal to create a development objective for intentional priority and action. Published items will also appear in your list of Development objectives as well as on your DailyQ."),
                20.sp.sbh,
                ...dataGoal.sliderList!.map((e) => DevelopmentGoalCardWidget(
                      data: e,
                      type: DevelopmentType.leaderStyle,
                      styleId: dataGoal.styleId ?? "",
                      userId: dataGoal.userId ?? "",
                      onReload: (bool isShowLoading) async {
                        await _leaderStyleController.getGoalData(
                            isShowLoading, widget.userId);
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
