import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/cognitive_controller.dart';
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

class CognitiveGoalWidget extends StatefulWidget {
  const CognitiveGoalWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<CognitiveGoalWidget> createState() => CognitiveGoalWidgetState();
}

class CognitiveGoalWidgetState extends State<CognitiveGoalWidget> {
  final _cognitiveController = Get.find<CognitiveController>();

  @override
  void initState() {
    super.initState();
    _cognitiveController.getGoalData(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CognitiveController>(builder: (cognitiveController) {
      if (cognitiveController.isLoadingGoal) {
        return const Center(child: CustomLoadingWidget());
      }
      if (cognitiveController.isErrorGoal ||
          cognitiveController.dataGoal == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              cognitiveController.getGoalData(true, widget.userId);
            },
            text: cognitiveController.isErrorGoal
                ? cognitiveController.errorMsgGoal
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return Stack(
          children: [
            _buildView(cognitiveController.dataGoal!),
            cognitiveController.dataGoal!.isJourneyLicensePurchased == 0
                ? PurchasePopupWidget(
                    text: cognitiveController
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
          return _cognitiveController.getGoalData(true, widget.userId);
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
                      type: DevelopmentType.cognitive,
                      styleId: dataGoal.styleId ?? "",
                      userId: dataGoal.userId ?? "",
                      onReload: (bool isShowLoading) async {
                        await _cognitiveController.getGoalData(
                            isShowLoading, widget.userId);
                      },
                    )),
                ...dataGoal.sliderListRadio!
                    .map((e) => DevelopmentGoalCardWidget(
                          data: e,
                          type: DevelopmentType.cognitiveStyle2,
                          styleId: dataGoal.styleId ?? "",
                          userId: dataGoal.userId ?? "",
                          onReload: (bool isShowLoading) async {
                            await _cognitiveController.getGoalData(
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
