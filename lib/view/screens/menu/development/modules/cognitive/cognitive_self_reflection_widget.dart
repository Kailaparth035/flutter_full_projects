import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/cognitive_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/risk_factor_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_title.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_radio_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CognitiveSelfReflectionWidget extends StatefulWidget {
  const CognitiveSelfReflectionWidget({super.key, required this.userId});

  final String userId;
  @override
  State<CognitiveSelfReflectionWidget> createState() =>
      _CognitiveSelfReflectionWidgetState();
}

class _CognitiveSelfReflectionWidgetState
    extends State<CognitiveSelfReflectionWidget> {
  final _cognitiveController = Get.find<CognitiveController>();

  @override
  void initState() {
    super.initState();
    _cognitiveController.getSelfReflactData(true, widget.userId);
  }

  _callAPI(DevelopmentController controller, SliderData data, String newScore,
      {String type = "", String radioValue = ""}) {
    controller.updateSelfReflaction(
        styleId: data.styleId.toString(),
        areaId: data.areaId.toString(),
        isMarked: data.isMarked.toString(),
        markingType: data.markingType.toString(),
        stylrParentId: data.stylrParentId.toString(),
        newScore: newScore,
        onReaload: (val) async {
          await _cognitiveController.getSelfReflactData(val, widget.userId);
        },
        ratingType: _cognitiveController.dataSelfReflact!.ratingType.toString(),
        userId: _cognitiveController.dataSelfReflact!.userId.toString(),
        type: type,
        radioType: radioValue);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CognitiveController>(builder: (cognitiveController) {
      if (cognitiveController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (cognitiveController.isErrorSelfReflact ||
          cognitiveController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              cognitiveController.getSelfReflactData(true, widget.userId);
            },
            text: cognitiveController.isErrorSelfReflact
                ? cognitiveController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(cognitiveController.dataSelfReflact!);
      }
    });
  }

  Widget _buildView(RiskFactorSelfReflectDetailsData dataSelfReflact) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _cognitiveController.getSelfReflactData(true, widget.userId);
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
                          "Critical Thinking is an intellectual model for reasoning through issues to reach well-founded conclusions.Move the sliders to rate your perceived ability / skill level compared to other leaders:"),
                  10.sp.sbh,
                  buildButtonHowdo(
                      title: "How do I see my critical thinking skills?"),
                  10.sp.sbh,
                  buildTitleWithBG("Move slider to rate your self."),
                  10.sp.sbh,
                  ...dataSelfReflact.sliderList!.map(
                    (e) => DevelopmentSliderWithTitle(
                      isReset: controller.isReset,
                      title: e.leftMeaning.toString(),
                      onChange: (val) {
                        controller.onDelayHandler(() {
                          _callAPI(controller, e, val.toString());
                        });
                      },
                      sliderValue: CommonController.getSliderValue(
                          e.idealScale.toString()),
                      isEnable: true,
                    ),
                  ),
                  _buildBlackTitle("Cognitive Obstacles"),
                  Divider(
                    color: AppColors.labelColor,
                    height: 5.sp,
                  ),
                  10.sp.sbh,
                  buildBackGroundWithText(
                      "IN TERMS OF YOUR OWN AWARENESS, SELECT THE THINKING TENDENCIES THAT MIGHT OCCASIONALLY SURFACE WITHIN YOURSELF."),
                  10.sp.sbh,
                  dataSelfReflact.radioList!.isNotEmpty
                      ? Column(
                          children: [
                            ...dataSelfReflact.radioList!
                                .map((e) => DevelopmentTitleWithRadioWidget(
                                      isReset: controller.isReset,
                                      mainTitle: e.areaName.toString(),
                                      title: e.leftMeaning.toString(),
                                      cbTitle1: "RARELY",
                                      cbTitle2: "SOMETIMES",
                                      cbTitle3: "OFTEN",
                                      cbTitle1Flex: 2,
                                      cbTitle2Flex: 2,
                                      cbTitle3Flex: 2,
                                      value1: "3",
                                      value2: "4",
                                      value3: "5",
                                      selectedIndex: e.radioType,
                                      callBack: (val) {
                                        _callAPI(controller, e,
                                            e.idealScale.toString(),
                                            radioValue: val);
                                      },
                                    )),
                          ],
                        )
                      : 0.sbh,
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  CustomText _buildBlackTitle(title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 11.sp,
      fontWeight: FontWeight.w600,
    );
  }
}
