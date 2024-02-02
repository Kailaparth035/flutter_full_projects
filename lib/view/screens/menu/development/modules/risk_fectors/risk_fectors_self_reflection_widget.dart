import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/risk_factor_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/risk_factor_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_bottom_left_right_title.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RiskFectorsSelfReflectionWidget extends StatefulWidget {
  const RiskFectorsSelfReflectionWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<RiskFectorsSelfReflectionWidget> createState() =>
      _RiskFectorsSelfReflectionWidgetState();
}

class _RiskFectorsSelfReflectionWidgetState
    extends State<RiskFectorsSelfReflectionWidget> {
  final _riskFactorController = Get.find<RiskFactorController>();
  @override
  void initState() {
    super.initState();
    _riskFactorController.getSelfReflactData(true, widget.userId);
  }

  _callAPI(DevelopmentController controller, SliderData data,
      String newScore) async {
    controller.updateSelfReflaction(
      styleId: data.styleId.toString(),
      areaId: data.areaId.toString(),
      isMarked: data.isMarked.toString(),
      markingType: data.markingType.toString(),
      stylrParentId: data.stylrParentId.toString(),
      radioType: data.radioType.toString(),
      newScore: newScore,
      onReaload: (val) async {
        await _riskFactorController.getSelfReflactData(val, widget.userId);
      },
      ratingType: _riskFactorController.dataSelfReflact!.ratingType.toString(),
      userId: _riskFactorController.dataSelfReflact!.userId.toString(),
      type: "",
    );
  }

  _callAPICheckbox(DevelopmentController controller, SliderData data,
      String checkboxValue) async {
    controller.updateSelfReflaction(
      styleId: data.styleId.toString(),
      areaId: data.areaId.toString(),
      isMarked: checkboxValue,
      markingType: data.markingType.toString(),
      stylrParentId: data.stylrParentId.toString(),
      radioType: data.radioType.toString(),
      newScore: data.idealScale.toString(),
      onReaload: (val) async {
        await _riskFactorController.getSelfReflactData(val, widget.userId);
      },
      ratingType: _riskFactorController.dataSelfReflact!.ratingType.toString(),
      userId: _riskFactorController.dataSelfReflact!.userId.toString(),
      type: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<RiskFactorController>(builder: (riskFactorController) {
      if (riskFactorController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (riskFactorController.isErrorSelfReflact ||
          riskFactorController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              riskFactorController.getSelfReflactData(true, widget.userId);
            },
            text: riskFactorController.isErrorSelfReflact
                ? riskFactorController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(riskFactorController.dataSelfReflact!);
      }
    });
  }

  CustomSlideUpAndFadeWidget _buildView(
      RiskFactorSelfReflectDetailsData dataSelfReflact) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _riskFactorController.getSelfReflactData(true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: GetBuilder<DevelopmentController>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DevelopmentSelfReflectTitleWidget(
                      title:
                          "When things are going well, working with others feels easy. Teams are efficient and fun to work in. But the real challenge is when things are difficult or stressful. In those circumstances, negative attitudes create enormous challenges and we tend to revert to familiar patterns.\n On the scales below, move the sliders to describe how you view your own risk factors."),
                  10.sp.sbh,
                  buildButtonHowdo(title: "How do I see myself ?"),
                  10.sp.sbh,
                  buildTitleWithBG("Move slider to rate your self."),
                  10.sp.sbh,
                  ...dataSelfReflact.sliderList!.map(
                    (e) => DevelopmentSliderForBottomLeftRightTitle(
                      onChange: (val) {
                        controller.onDelayHandler(() {
                          _callAPI(controller, e, val.toString());
                        });
                      },
                      sliderValue: CommonController.getSliderValue(
                          e.idealScale.toString()),
                      leftTitle: e.leftMeaning.toString(),
                      rightTitle: e.rightMeaning.toString(),
                      isReset: controller.isReset,
                    ),
                  ),
                  ...dataSelfReflact.checkboxList!.map((e) => Column(
                        children: [
                          buildTitleWithTopAndBottomBorder(e.title.toString()),
                          10.sp.sbh,
                          ...e.value!.map((e1) => DevelopmentTitleWithCheckBox(
                                isReset: controller.isReset,
                                title: e1.areaName.toString(),
                                secondTitle: e1.leftMeaning.toString(),
                                isChecked: e1.isMarked == "1",
                                onChange: (val) {
                                  _callAPICheckbox(controller, e1,
                                      val == true ? "1" : "0".toString());
                                },
                              )),
                        ],
                      ))
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
