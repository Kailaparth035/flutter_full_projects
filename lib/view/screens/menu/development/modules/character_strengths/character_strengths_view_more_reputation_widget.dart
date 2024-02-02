import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/character_strengths_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_slider_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_radio_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/title_3_slider_2_title_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CharacterStrengthViewMoreReputaionWidget extends StatefulWidget {
  const CharacterStrengthViewMoreReputaionWidget(
      {super.key, required this.userId});
  final String userId;
  @override
  State<CharacterStrengthViewMoreReputaionWidget> createState() =>
      _CharacterStrengthViewMoreReputaionWidgetState();
}

class _CharacterStrengthViewMoreReputaionWidgetState
    extends State<CharacterStrengthViewMoreReputaionWidget> {
  final _characterStrengthsController =
      Get.find<CharacterStrengthsController>();

  @override
  void initState() {
    _characterStrengthsController.getReputationFeedbackSliderList(
        true, widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CharacterStrengthsController>(
        builder: (characterStrengthsController) {
      if (characterStrengthsController.isLoadingReputationSlider) {
        return const Center(child: CustomLoadingWidget());
      }
      if (characterStrengthsController.isErrorReputationSlider ||
          characterStrengthsController.dataReputationSlider == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              characterStrengthsController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: characterStrengthsController.isErrorReputationSlider
                ? characterStrengthsController.errorMsgReputationSlider
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildViewMoreWidget(
            characterStrengthsController.dataReputationSlider!,
            characterStrengthsController.titleList);
      }
    });
  }

  Widget _buildViewMoreWidget(
      WorkSkillReputaionSliderData dataReputationSlider, List titleList) {
    return Column(children: [
      buildTitleWithBG("Reputation Feedback"),
      dataReputationSlider.relationWithLoginUser ==
              AppConstants.userRoleSupervisor
          ? _buildRadioButtonViewForUservisor(dataReputationSlider)
          : 0.sbh,
      Padding(
        padding: EdgeInsets.all(10.sp),
        child: Column(
          children: [
            buildGreyTitle(
                "Please consider how others perceive your Character Strengths."),
          ],
        ),
      ),
      buildDivider(),
      buildTitleLog(titleList),
      buildDivider(),
      10.sp.sbh,
      ...dataReputationSlider.reputationFeedback!.map((e) => Column(children: [
            buildTitleWithUpperLowerLine(e.title.toString(),
                isFullBorder: true),
            10.sp.sbh,
            ...e.value!.map((e) => TitleSliderAndBottom2Title(
                  list: [
                    SliderModel(
                      interval: 0.01,
                      title: dataReputationSlider.type1.toString(),
                      color: AppColors.labelColor56,
                      value: CommonController.getSliderValue(
                          e.idealScale.toString()),
                      isEnable:
                          dataReputationSlider.isEnableSlider.toString() == "1",
                    ),
                    SliderModel(
                      interval: 0.01,
                      title: dataReputationSlider.type2.toString(),
                      color: AppColors.labelColor57,
                      value: CommonController.getSliderValue(
                          e.selfIdealScale.toString()),
                      isEnable:
                          dataReputationSlider.isEnableSlider.toString() == "1",
                    ),
                    SliderModel(
                      interval: 0.01,
                      title: dataReputationSlider.type3.toString(),
                      color: AppColors.labelColor59,
                      value: CommonController.getSliderValue(
                          e.superIdealScale.toString()),
                      isEnable:
                          dataReputationSlider.isEnableSlider.toString() == "1",
                    ),
                    SliderModel(
                      interval: 0.01,
                      title: dataReputationSlider.type4.toString(),
                      color: AppColors.labelColor58,
                      value: CommonController.getSliderValue(
                          e.peersIdealScale.toString()),
                      isEnable:
                          dataReputationSlider.isEnableSlider.toString() == "1",
                    ),
                    SliderModel(
                      interval: 0.01,
                      title: dataReputationSlider.type5.toString(),
                      color: AppColors.labelColor60,
                      value: CommonController.getSliderValue(
                          e.reportIdealScale.toString()),
                      isEnable:
                          dataReputationSlider.isEnableSlider.toString() == "1",
                    ),
                  ],
                  mainTitle: e.areaName.toString(),
                  mainBGColor: AppColors.backgroundColor1,
                  title: e.leftMeaning.toString(),
                  bottomLeftTitle: "",
                  bottomRightTitle: "",
                  isReset: false,
                ))
          ])),
    ]);
  }

  Widget _buildRadioButtonViewForUservisor(
      WorkSkillReputaionSliderData dataReputationSlider) {
    return Column(
      children: [
        10.sp.sbh,
        dataReputationSlider.reputationFeedbackSupervisor!.isNotEmpty
            ? GetBuilder<DevelopmentController>(builder: (controller) {
                return Column(
                  children: [
                    ...dataReputationSlider.reputationFeedbackSupervisor!
                        .map((e) => Column(
                              children: [
                                buildBorderWithText(e.title.toString()),
                                10.sp.sbh,
                                ...e.value!
                                    .map((e) => DevelopmentTitleWithRadioWidget(
                                          isReset: controller.isReset,
                                          mainTitle: e.areaName.toString(),
                                          title: "",
                                          cbTitle1: dataReputationSlider
                                              .type2Supervisor
                                              .toString(),
                                          cbTitle2: dataReputationSlider
                                              .type3Supervisor
                                              .toString(),
                                          cbTitle3: dataReputationSlider
                                              .type4Supervisor
                                              .toString(),
                                          cbTitle1Flex: 2,
                                          cbTitle2Flex: 2,
                                          cbTitle3Flex: 2,
                                          value1: "1",
                                          value2: "2",
                                          value3: "3",
                                          selectedIndex: e.radioType,
                                          callBack: (val) {
                                            _callAPI(controller, e,
                                                e.idealScale.toString(),
                                                radioValue: val);
                                          },
                                        ))
                              ],
                            )),
                  ],
                );
              })
            : 0.sbh,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton2(
                buttonText: "Start Survey",
                buttonColor: AppColors.circleGreen,
                radius: 15.sp,
                padding:
                    EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                onPressed: () {
                  CommonController.urlLaunch(
                      dataReputationSlider.surveyUrl.toString());
                }),
          ],
        ),
        10.sp.sbh,
        buildDivider(),
      ],
    );
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
          await _characterStrengthsController.getReputationFeedbackSliderList(
              val, widget.userId);
        },
        ratingType: data.ratingType ?? "",
        userId:
            _characterStrengthsController.dataReputationUser!.userId.toString(),
        type: type,
        radioType: radioValue);
  }
}
