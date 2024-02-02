import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/emotions_controller.dart';
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

class EmotionsGoalWidget extends StatefulWidget {
  const EmotionsGoalWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<EmotionsGoalWidget> createState() => EmotionsGoalWidgetState();
}

class EmotionsGoalWidgetState extends State<EmotionsGoalWidget> {
  final _emotionsController = Get.find<EmotionsController>();

  @override
  void initState() {
    super.initState();
    _emotionsController.getGoalAchievementsDetails(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<EmotionsController>(builder: (emotionsController) {
      if (emotionsController.isLoadingGoal) {
        return const Center(child: CustomLoadingWidget());
      }
      if (emotionsController.isErrorGoal ||
          emotionsController.dataGoal == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              emotionsController.getGoalAchievementsDetails(
                  true, widget.userId);
            },
            text: emotionsController.isErrorGoal
                ? emotionsController.errorMsgGoal
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return Stack(
          children: [
            _buildView(emotionsController.dataGoal!),
            emotionsController.dataGoal!.isJourneyLicensePurchased == 0
                ? PurchasePopupWidget(
                    text: emotionsController
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
          return _emotionsController.getGoalAchievementsDetails(
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
                    "Prioritizing and Selecting Development Objectives"),
                5.sp.sbh,
                buildGreyTitle(
                    "Potential development objectives have been created and listed below. They are based on your targeted goals. PRIORITIZE those goals that are most important to you and PUBLISH at least one goal to create a development objective for intentional priority and action. Published items will also appear in your list of Development objectives as well as on your DailyQ."),
                20.sp.sbh,
                ...dataGoal.sliderList!.map((e) => DevelopmentGoalCardWidget(
                      data: e,
                      type: DevelopmentType.emotions,
                      styleId: dataGoal.styleId ?? "",
                      userId: dataGoal.userId ?? "",
                      onReload: (bool isShowLoading) async {
                        await _emotionsController.getGoalAchievementsDetails(
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
