import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/traits_controller.dart';
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

class TraitsGoalWidget extends StatefulWidget {
  const TraitsGoalWidget({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<TraitsGoalWidget> createState() => TraitsGoalWidgetState();
}

class TraitsGoalWidgetState extends State<TraitsGoalWidget> {
  final _traitsController = Get.find<TraitsController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    _traitsController.getGoalData(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<TraitsController>(builder: (traitsController) {
      if (traitsController.isLoadingGoal) {
        return const Center(child: CustomLoadingWidget());
      }
      if (traitsController.isErrorGoal || traitsController.dataGoal == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              traitsController.getGoalData(true, widget.userId);
            },
            text: traitsController.isErrorGoal
                ? traitsController.errorMsgGoal
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(traitsController.dataGoal!);
      }
    });
  }

  Widget _buildView(TraitsGoalData dataGoal) {
    return Stack(
      children: [
        CustomSlideUpAndFadeWidget(
          child: RefreshIndicator(
            onRefresh: () {
              return _traitsController.getGoalData(true, widget.userId);
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
                    ...dataGoal.sliderList!.map(
                      (e) => DevelopmentGoalCardWidget(
                          data: e,
                          type: DevelopmentType.traits,
                          styleId: dataGoal.styleId ?? "",
                          userId: dataGoal.userId ?? "",
                          onReload: (bool isShowLoading) async {
                            await _traitsController.getGoalData(
                                isShowLoading, widget.userId);
                          }),
                    )
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
