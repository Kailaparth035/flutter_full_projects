import 'package:aspirevue/controller/development/leader_style_controller.dart';
import 'package:aspirevue/data/model/response/development/leader_style_target_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_expanded_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LeaderStyleAspireVueTrainingWidget extends StatefulWidget {
  const LeaderStyleAspireVueTrainingWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<LeaderStyleAspireVueTrainingWidget> createState() =>
      _LeaderStyleAspireVueTrainingWidgetState();
}

class _LeaderStyleAspireVueTrainingWidgetState
    extends State<LeaderStyleAspireVueTrainingWidget> {
  final _leaderStyleController = Get.find<LeaderStyleController>();
  @override
  void initState() {
    super.initState();
    _leaderStyleController.getTargetData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<LeaderStyleController>(builder: (leaderStyleController) {
      if (leaderStyleController.isLoadingTarget) {
        return const Center(child: CustomLoadingWidget());
      }
      if (leaderStyleController.isErrorTarget ||
          leaderStyleController.dataTarget == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              leaderStyleController.getTargetData(widget.userId);
            },
            text: leaderStyleController.isErrorTarget
                ? leaderStyleController.errorMsgTarget
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return Stack(
          children: [
            _buildView(leaderStyleController.dataTarget!),
            leaderStyleController.dataTarget!.isJourneyLicensePurchased == 0
                ? PurchasePopupWidget(
                    text: leaderStyleController
                        .dataTarget!.journeyLicensePurchaseText
                        .toString(),
                  )
                : 0.sbh
          ],
        );
      }
    });
  }

  Widget _buildView(LeaderStyleTargetDataList dataTarget) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _leaderStyleController.getTargetData(widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitleWithBG("Leader Style Characteristic"),
                10.sp.sbh,
                ...dataTarget.sliderList!.map(
                  (e) => DevelopmentTitleWithExpandedWidget(
                    mainTitle: e.title.toString(),
                    title: "",
                    list: [
                      {
                        "title": "SELF-REFLECTION",
                        "value": e.selfReflection.toString(),
                        "color": e.selfReflection
                                .toString()
                                .toUpperCase()
                                .contains("INCREASE")
                            ? AppColors.greenColor
                            : e.selfReflection
                                    .toString()
                                    .toUpperCase()
                                    .contains("DECREASE")
                                ? AppColors.redColor
                                : null,
                        "count_value": e.selfReflectionCount.toString() == "0"
                            ? ""
                            : e.selfReflectionCount.toString()
                      },
                      {
                        "title": "REPUTATION",
                        "value": e.reputation.toString(),
                        "color": e.reputation
                                .toString()
                                .toUpperCase()
                                .contains("INCREASE")
                            ? AppColors.greenColor
                            : e.reputation
                                    .toString()
                                    .toString()
                                    .toUpperCase()
                                    .contains("DECREASE")
                                ? AppColors.redColor
                                : null,
                        "count_value": e.reputationCount.toString() == "0"
                            ? ""
                            : e.reputationCount.toString()
                      },
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
