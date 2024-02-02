import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/risk_factor_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/title_3_slider_2_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RiskFactorAspireVueTargetingWidget extends StatefulWidget {
  const RiskFactorAspireVueTargetingWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<RiskFactorAspireVueTargetingWidget> createState() =>
      _RiskFactorAspireVueTargetingState();
}

class _RiskFactorAspireVueTargetingState
    extends State<RiskFactorAspireVueTargetingWidget> {
  final _riskFactorController = Get.find<RiskFactorController>();
  @override
  void initState() {
    super.initState();
    _riskFactorController.getTargetData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<RiskFactorController>(builder: (riskFactorController) {
      if (riskFactorController.isLoadingTarget) {
        return const Center(child: CustomLoadingWidget());
      }
      if (riskFactorController.isErrorTarget ||
          riskFactorController.dataTarget == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              riskFactorController.getTargetData(widget.userId);
            },
            text: riskFactorController.isErrorTarget
                ? riskFactorController.errorMsgTarget
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return Stack(
          children: [
            _buildView(riskFactorController.dataTarget!,
                riskFactorController.titleListTarget, riskFactorController),
            riskFactorController.dataTarget!.isJourneyLicensePurchased == 0
                ? PurchasePopupWidget(
                    text: riskFactorController
                        .dataTarget!.journeyLicensePurchaseText
                        .toString(),
                  )
                : 0.sbh
          ],
        );
      }
    });
  }

  Widget _buildView(TraitAssesData dataTarget, List titleListTarget,
      RiskFactorController riskFactorController) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return riskFactorController.getTargetData(widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlackTitle(
                    "Risk factors Profiler: Targeting My Ideal Self at My Best"),
                5.sp.sbh,
                buildGreyTitle(
                    "Consider the different data sources for this individual, then move to the Goal Selector tab."),
                20.sp.sbh,
                buildDivider(),
                buildTitleLog(titleListTarget),
                buildDivider(),
                15.sp.sbh,
                dataTarget.relationWithLoginUser ==
                        AppConstants.userRoleSupervisor
                    ? 0.sbh
                    : Column(
                        children: [
                          _buildButtonwithIcon(
                              riskFactorController.isSharedTargating),
                          15.sp.sbh,
                        ],
                      ),
                ...dataTarget.sliderList!.map(
                  (e) =>
                      GetBuilder<DevelopmentController>(builder: (controller) {
                    return TitleSliderAndBottom2Title(
                      list: [
                        SliderModel(
                          title: dataTarget.type1.toString(),
                          color: AppColors.labelColor62,
                          value: CommonController.getSliderValue(
                              e.assessScale.toString()),
                          isEnable: false,
                        ),
                        SliderModel(
                          title: dataTarget.type2.toString(),
                          color: AppColors.labelColor57,
                          value: CommonController.getSliderValue(
                              e.reaslScale.toString()),
                          isEnable: false,
                        ),
                        SliderModel(
                          title: dataTarget.type3.toString(),
                          color: AppColors.labelColor56,
                          value: CommonController.getSliderValue(
                              e.reputScale.toString()),
                          isEnable: false,
                        ),
                      ],
                      mainTitle: e.areaName.toString(),
                      title: "",
                      bottomLeftTitle: e.leftMeaning.toString(),
                      bottomRightTitle: e.rightMeaning.toString(),
                      isReset: controller.isReset,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center _buildButtonwithIcon(bool isShared) {
    return Center(
      child: CustomButton2(
          buttonColor: AppColors.labelColor74.withOpacity(0.26),
          textColor: AppColors.labelColor74,
          icon: isShared == true
              ? AppImages.checkCircleGreenIc
              : AppImages.uncheckGreenCircleIc,
          buttonText: "Shared with Supervisor",
          radius: 5.sp,
          padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          onPressed: () {
            shareWithSupervisor(isShared);
          }),
    );
  }

  shareWithSupervisor(bool isShared) async {
    bool? result = await Get.find<DevelopmentController>().shareWithSupervisor(
        styleId: _riskFactorController.dataTarget!.styleId.toString(),
        userId: _riskFactorController.dataTarget!.userId.toString(),
        assessId: isShared == true ? "0" : "1");

    if (result != null && result == true) {
      _riskFactorController.updateShareStatus();
    }
  }
}
