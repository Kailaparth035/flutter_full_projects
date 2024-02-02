import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/values_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/data/model/response/development/values_self_reflect_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_bottom_left_right_title.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_radio_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ValuesSelfReflectionWidget extends StatefulWidget {
  const ValuesSelfReflectionWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<ValuesSelfReflectionWidget> createState() =>
      _ValuesSelfReflectionWidgetState();
}

class _ValuesSelfReflectionWidgetState
    extends State<ValuesSelfReflectionWidget> {
  final _valuesController = Get.find<ValuesController>();
  @override
  void initState() {
    super.initState();
    _valuesController.getSelfReflactData(true, widget.userId);
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
          await _valuesController.getSelfReflactData(val, widget.userId);
        },
        ratingType: _valuesController.dataSelfReflact!.ratingType.toString(),
        userId: _valuesController.dataSelfReflact!.userId.toString(),
        type: type,
        radioType: radioValue);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<ValuesController>(builder: (valuesController) {
      if (valuesController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (valuesController.isErrorSelfReflact ||
          valuesController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              valuesController.getSelfReflactData(true, widget.userId);
            },
            text: valuesController.isErrorSelfReflact
                ? valuesController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return buildView(valuesController.dataSelfReflact!, valuesController);
      }
    });
  }

  // Widget _buildView() {
  //   return widget.isloading
  //       ? const Center(
  //           child: CustomLoadingWidget(),
  //         )
  //       : widget.isError
  //           ? Center(
  //               child: CustomErrorWidget(
  //                 onRetry: () {
  //                   widget.onReaload(true);
  //                 },
  //                 text: widget.errorMsg,
  //               ),
  //             )
  //           : _buildMainView();
  // }

  Widget buildView(ValuesSelfReflectDetailsData dataSelfReflact,
      ValuesController valuesController) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _valuesController.getSelfReflactData(true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: GetBuilder<DevelopmentController>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildBlackTitle("What is Important to You?"),
                  5.sp.sbh,
                  buildGreyTitle(
                      "Take no more than 2 minutes to reflect and respond to the question below. Note: Your response will be included in the Signature section of About within your Profile."),
                  5.sp.sbh,
                  buildBlackTitle(
                      "What would you like others to know that you care about ?"),
                  5.sp.sbh,
                  _buildTextField(dataSelfReflact.userId.toString(), controller,
                      valuesController),
                  5.sp.sbh,
                  const Divider(
                    color: AppColors.labelColor,
                  ),
                  5.sp.sbh,
                  const DevelopmentSelfReflectTitleWidget(
                      title:
                          "Values are strongly linked to motivation, aspirations, and identity. While personality and risk inventories describe WHAT a person does, a value inventory explores the WHY behind a person's actions and reactions."),
                  10.sp.sbh,
                  buildButtonHowdo(title: "How do I see myself ?"),
                  10.sp.sbh,
                  const DevelopmentSelfReflectTitleWidget(
                      title:
                          "Move the sliders to describe the degree to which you are motivated by each driver."),
                  10.sp.sbh,
                  buildTitleWithBG("Move slider to rate your self."),
                  10.sp.sbh,
                  ...dataSelfReflact.sliderList!
                      .map((e) => DevelopmentSliderForBottomLeftRightTitle(
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
                          )),
                  buildBorderWithText(
                      "Values are traits or qualities that are considered worthwhile; they represent your highest priorities and deeply held driving forces. When you are part of any organization, you bring your deeply held values and beliefs to the organization.\nIn terms of what you consider driving forces, select 3 statements of LEAST importance and 3 of GREATEST priority to you."),
                  10.sp.sbh,
                  buildBackGroundWithText(
                      "IN TERMS OF WHAT YOU CONSIDER TO BE DRIVING FORCES, SELECT 3 VALUE DESCRIPTORS THAT ARE LEAST OFTEN PRIORITIZED AND 3 THAT ARE MOST OFTEN PRIORITIZED IN YOUR DECISIONS."),
                  10.sp.sbh,
                  dataSelfReflact.radioList!.isNotEmpty
                      ? Column(
                          children: [
                            ...dataSelfReflact.radioList!.first.radioList1!
                                .map((e) => DevelopmentTitleWithRadioWidget(
                                      isReset: controller.isReset,
                                      mainTitle: e.areaName.toString(),
                                      title: e.leftMeaning.toString(),
                                      cbTitle1: "LEAST IMPORTANT (SELECT 3)",
                                      cbTitle2: "MOST IMPORTANT (SELECT 3)",
                                      cbTitle3: "NONE",
                                      cbTitle1Flex: 2,
                                      cbTitle2Flex: 2,
                                      cbTitle3Flex: 1,
                                      value1: "1",
                                      value2: "2",
                                      value3: "3",
                                      selectedIndex: e.radioType,
                                      callBack: (val) {
                                        _callAPI(
                                          controller,
                                          e,
                                          val.toString(),
                                          type: "1",
                                          radioValue: val,
                                        );
                                      },
                                    )),
                          ],
                        )
                      : 0.sbh,
                  buildBorderWithText(
                      "Values direct people’s thoughts and behaviors toward efforts that they consider important. Think about how you would spend your time, money or energy, if there were no limits or other demands.Rank how important or satisfying each of the pursuits listed below would be for you."),
                  10.sp.sbh,
                  buildBlackTitle("CATEGORIZE EACH PURSUIT"),
                  Divider(
                    height: 5.sp,
                  ),
                  5.sp.sbh,
                  dataSelfReflact.radioList!.isNotEmpty
                      ? Column(
                          children: [
                            ...dataSelfReflact.radioList!.first.radioList2!
                                .map((e) => DevelopmentTitleWithRadioWidget(
                                      isReset: controller.isReset,
                                      mainTitle: e.areaName.toString(),
                                      title: e.leftMeaning.toString(),
                                      cbTitle1: "NOT IMPORTANT (SELECT < 5)",
                                      cbTitle2: "MODERATELY IMPORTANT",
                                      cbTitle3: "HIGHLY IMPORTANT (SELECT < 5)",
                                      cbTitle1Flex: 8,
                                      cbTitle2Flex: 6,
                                      cbTitle3Flex: 9,
                                      value1: "3",
                                      value2: "4",
                                      value3: "5",
                                      selectedIndex: e.radioType,
                                      callBack: (val) {
                                        _callAPI(controller, e, val.toString(),
                                            type: "", radioValue: val);
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

  CustomTextFormFieldForMessage _buildTextField(String userId,
      DevelopmentController controller, ValuesController valuesController) {
    return CustomTextFormFieldForMessage(
      borderColor: AppColors.labelColor9.withOpacity(0.2),
      inputAction: TextInputAction.done,
      labelText: " ",
      inputType: TextInputType.text,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      lineCount: 1,
      maxLine: 2,
      textColor: AppColors.black,
      editColor: AppColors.labelColor12,
      textEditingController: valuesController.textTextController,
      onChanged: (val) {},
      onEditingComplete: () {
        CommonController.hideKeyboard(context);
        if (valuesController.textTextController.text.isNotEmpty) {
          _updateImportant(
              userId, controller, valuesController.textTextController.text);
        } else {
          showCustomSnackBar("Please enter value.");
        }
      },
      // onTapSufixIcon: () {},
    );
  }

  _updateImportant(
      String userId, DevelopmentController controller, String text) {
    controller.updateImportantDataUri(
        userId: userId, text: text, onReaload: (isShowLoading) async {});
  }
}
