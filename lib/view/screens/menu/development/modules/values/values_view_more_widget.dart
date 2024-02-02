import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/values_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_left_right_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_expanded_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_radio_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ValuesViewMoreWidget extends StatefulWidget {
  const ValuesViewMoreWidget({super.key, required this.userId});
  final String userId;
  @override
  State<ValuesViewMoreWidget> createState() => _ValuesViewMoreWidgetState();
}

class _ValuesViewMoreWidgetState extends State<ValuesViewMoreWidget> {
  final _valuesController = Get.find<ValuesController>();
  @override
  void initState() {
    _valuesController.getReputationFeedbackSliderList(true, widget.userId);
    super.initState();
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
          await _valuesController.getReputationFeedbackUserListUri(
              val, widget.userId);
        },
        ratingType: data.ratingType ?? "",
        userId: _valuesController.dataReputationUser!.userId.toString(),
        type: type,
        radioType: radioValue);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<ValuesController>(builder: (valuesController) {
      if (valuesController.isLoadingReputationSlider) {
        return const Center(child: CustomLoadingWidget());
      }
      if (valuesController.isErrorReputationSlider ||
          valuesController.dataReputationSlider == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              valuesController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: valuesController.isErrorReputationSlider
                ? valuesController.errorMsgReputationSlider
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildViewMoreWidget(valuesController.dataReputationSlider!);
      }
    });
  }

  Widget _buildViewMoreWidget(ReputationSliderData dataReputationSlider) {
    return Column(
      children: [
        GetBuilder<DevelopmentController>(builder: (controller) {
          return Column(
            children: [
              buildTitleWithBG("Reputation Feedback"),
              10.sp.sbh,
              GetBuilder<DevelopmentController>(builder: (controller) {
                return Column(
                  children: [
                    ...dataReputationSlider.reputationFeedback!.map(
                      (e) => DevelopmentSliderWithLeftRightTitle(
                        isReset: false,
                        headerTitle: e.areaName,
                        topTitle: "",
                        topSecondTitle: "",
                        bottomTitle: e.leftMeaning.toString(),
                        bottomSecondTitle: e.rightMeaning.toString(),
                        onChange: (p0) {
                          if (dataReputationSlider.isEnableSlider.toString() ==
                              "1") {
                            controller.onDelayHandler(() {
                              _callAPI(controller, e, p0.toString());
                            });
                          }
                        },
                        sliderValue:
                            CommonController.getSliderValue(e.score.toString()),
                        isEnable:
                            dataReputationSlider.isEnableSlider.toString() ==
                                "1",
                      ),
                    ),
                  ],
                );
              }),
              dataReputationSlider.relationWithLoginUser.toString() ==
                      AppConstants.userRoleSupervisor
                  ? _buildRadioListOneForSuperVisor(dataReputationSlider)
                  : 0.sbh,
              buildBorderWithText(
                  dataReputationSlider.listFirst!.title1.toString()),
              10.sp.sbh,
              buildBackGroundWithText(
                  dataReputationSlider.listFirst!.subtitle1.toString()),
              10.sp.sbh,
              ...dataReputationSlider.listFirst!.list!
                  .map((e) => DevelopmentTitleWithExpandedWidget(
                        mainTitle: e.areaName.toString(),
                        title: e.leftMeaning.toString(),
                        list: [
                          {
                            "title": dataReputationSlider.listFirst!.subtitle2,
                            "value": e.leastCount,
                          },
                          {
                            "title": dataReputationSlider.listFirst!.subtitle3,
                            "value": e.mostCount,
                          }
                        ],
                      )),
              buildBorderWithText(
                  dataReputationSlider.listSecond!.title1.toString()),
              10.sp.sbh,
              dataReputationSlider.listSecond!.subtitle1 != null
                  ? buildBackGroundWithText(
                      dataReputationSlider.listSecond!.subtitle1.toString())
                  : 0.sbh,
              dataReputationSlider.listSecond!.subtitle1 != null
                  ? 10.sp.sbh
                  : 0.sbh,
              ...dataReputationSlider.listSecond!.list!
                  .map((e) => DevelopmentTitleWithExpandedWidget(
                        mainTitle: e.areaName.toString(),
                        title: "",
                        list: [
                          {
                            "title": dataReputationSlider.listSecond!.subtitle2,
                            "value": e.notImportant,
                          },
                          {
                            "title": dataReputationSlider.listSecond!.subtitle3,
                            "value": e.moderatelyCount,
                          },
                          {
                            "title": dataReputationSlider.listSecond!.subtitle4,
                            "value": e.highlyCount,
                          }
                        ],
                      )),
            ],
          );
        })
      ],
    );
  }

  _buildRadioListOneForSuperVisor(ReputationSliderData dataReputationSlider) {
    return Column(
      children: [
        buildBorderWithText(
            dataReputationSlider.listFirstSupervisor!.title1.toString()),
        10.sp.sbh,
        buildBackGroundWithText(
            dataReputationSlider.listFirstSupervisor!.subtitle1.toString()),
        GetBuilder<DevelopmentController>(builder: (controller) {
          return Column(
            children: [
              ...dataReputationSlider.listFirstSupervisor!.listFirst!
                  .map((e) => DevelopmentTitleWithRadioWidget(
                        isReset: controller.isReset,
                        mainTitle: e.areaName.toString(),
                        title: e.leftMeaning.toString(),
                        cbTitle1: dataReputationSlider
                            .listFirstSupervisor!.subtitle2
                            .toString(),
                        cbTitle2: dataReputationSlider
                            .listFirstSupervisor!.subtitle3
                            .toString(),
                        cbTitle3: dataReputationSlider
                            .listFirstSupervisor!.subtitle4
                            .toString(),
                        cbTitle1Flex: 2,
                        cbTitle2Flex: 2,
                        cbTitle3Flex: 2,
                        value1: "1",
                        value2: "2",
                        value3: "6",
                        selectedIndex: e.radioType,
                        callBack: (val) {
                          _callAPI(controller, e, e.idealScale.toString(),
                              radioValue: val, type: "1");
                        },
                      ))
            ],
          );
        }),
        10.sp.sbh,
        buildBorderWithText(
            dataReputationSlider.listSecondSupervisor!.title1.toString()),
        10.sp.sbh,
        buildBackGroundWithText(
            dataReputationSlider.listSecondSupervisor!.subtitle1.toString()),
        10.sp.sbh,
        GetBuilder<DevelopmentController>(builder: (controller) {
          return Column(
            children: [
              ...dataReputationSlider.listSecondSupervisor!.listFirst!
                  .map((e) => DevelopmentTitleWithRadioWidget(
                        isReset: controller.isReset,
                        mainTitle: e.areaName.toString(),
                        title: "",
                        cbTitle1: dataReputationSlider
                            .listSecondSupervisor!.subtitle2
                            .toString(),
                        cbTitle2: dataReputationSlider
                            .listSecondSupervisor!.subtitle3
                            .toString(),
                        cbTitle3: dataReputationSlider
                            .listSecondSupervisor!.subtitle4
                            .toString(),
                        cbTitle1Flex: 2,
                        cbTitle2Flex: 2,
                        cbTitle3Flex: 2,
                        value1: "3",
                        value2: "4",
                        value3: "5",
                        selectedIndex: e.radioType,
                        callBack: (val) {
                          _callAPI(
                            controller,
                            e,
                            e.idealScale.toString(),
                            radioValue: val,
                          );
                        },
                      ))
            ],
          );
        }),
      ],
    );
  }
}
