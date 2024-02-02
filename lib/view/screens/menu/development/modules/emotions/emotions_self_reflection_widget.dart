import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/emotions_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/emotions_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_reminder.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_title.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/emotions_checkbox_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EmotionsSelfReflectionWidget extends StatefulWidget {
  const EmotionsSelfReflectionWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<EmotionsSelfReflectionWidget> createState() =>
      _EmotionsSelfReflectionWidgetState();
}

class _EmotionsSelfReflectionWidgetState
    extends State<EmotionsSelfReflectionWidget> {
  final _emotionsController = Get.find<EmotionsController>();
  @override
  void initState() {
    super.initState();
    _emotionsController.getSelfReflactData(true, widget.userId);
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
          await _emotionsController.getSelfReflactData(val, widget.userId);
        },
        ratingType: _emotionsController.dataSelfReflact!.ratingType.toString(),
        userId: _emotionsController.dataSelfReflact!.userId.toString(),
        type: type,
        radioType: radioValue);
  }

  _callAPICheckbox(
      DevelopmentController controller, SliderData data, String checkboxValue,
      {String type = ""}) async {
    controller.updateSelfReflaction(
      styleId: data.styleId.toString(),
      areaId: data.areaId.toString(),
      isMarked: checkboxValue,
      markingType: data.markingType.toString(),
      stylrParentId: data.stylrParentId.toString(),
      radioType: data.radioType.toString(),
      newScore: data.idealScale.toString(),
      onReaload: (val) async {
        await _emotionsController.getSelfReflactData(val, widget.userId);
      },
      ratingType: _emotionsController.dataSelfReflact!.ratingType.toString(),
      userId: _emotionsController.dataSelfReflact!.userId.toString(),
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<EmotionsController>(builder: (emotionsController) {
      if (emotionsController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (emotionsController.isErrorSelfReflact ||
          emotionsController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              emotionsController.getSelfReflactData(true, widget.userId);
            },
            text: emotionsController.isErrorSelfReflact
                ? emotionsController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(
            emotionsController.dataSelfReflact!, emotionsController);
      }
    });
  }

  CustomSlideUpAndFadeWidget _buildView(
      EmotionsSelfReflectDetailsData dataSelfReflact,
      EmotionsController emotionsController) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _emotionsController.getSelfReflactData(true, widget.userId);
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
                          "A person's Emotional Intelligence impacts their level of effectiveness when working with colleagues, supervisors, and clients. Move the sliders to register your perspective as you describe your level of mastery."),
                  10.sp.sbh,
                  buildButtonHowdo(
                      title: "How do I describe my emotional awareness?"),
                  10.sp.sbh,
                  buildTitleWithBG("Move slider to rate your self."),
                  10.sp.sbh,
                  ...dataSelfReflact.sliderList!.map(
                    (e) {
                      int index = dataSelfReflact.sliderList!.indexOf(e);
                      return Column(
                        children: [
                          index == 0
                              ? buildTitleWithBoxAndGradientBG(
                                  "${e.title.toString()} :",
                                  e.average.toString())
                              : buildTitleWithTopAndBottomBorderWithBox(
                                  "${e.title.toString()} :",
                                  e.average.toString(),
                                  _getColor(index)),
                          10.sp.sbh,
                          ...e.value!.map(
                            (e1) => DevelopmentSliderWithTitle(
                              isReset: controller.isReset,
                              onChange: (val) {
                                controller.onDelayHandler(() {
                                  _callAPI(controller, e1, val.toString());
                                });
                              },
                              title: e1.areaName.toString(),
                              middleTitle: e1.leftMeaning.toString(),
                              sliderValue: CommonController.getSliderValue(
                                  e1.idealScale.toString()),
                              topBgColor:
                                  AppColors.labelColor15.withOpacity(0.85),
                              isEnable: true,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  10.sp.sbh,
                  buildTitleWithAns("EMOTIONAL SELF-AWARENESS: ",
                      "Situations, events, and relationships can trigger strong emotions that, in turn, color how we experience the world. Throughout your life, you likely have experienced certain emotions with greater frequency, duration, or intensity than others."),
                  10.sp.sbh,
                  buildTitleWithAns("Positive Emotions: ",
                      "are listed below. If you have endorsed positive emotions in your Insight Stream, their frequency is shown. Reflect on your own history and identify the positive emotions that seem most familiar or common to your experience. (Choose the Top 5)."),
                  15.sp.sbh,
                  CustomButton2(
                      icon: AppImages.settingWhiteIc,
                      buttonText: "Track emotions for 30 days",
                      radius: 3.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 7.sp, horizontal: 7.sp),
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ReminderAlertDialog(
                              goalId: "",
                              styleId: "",
                              userId: "",
                              type: "",
                              fromModule: "Emotions",
                            );
                          },
                        );
                      }),
                  10.sp.sbh,
                  _buildPositiveView(controller, dataSelfReflact),
                  10.sp.sbh,
                  buildTitleWithAns("Negative Emotions: ",
                      "should be acknowledged, not avoided. This awareness is essential to emotional well-being. If you have endorsed negative emotions in your Insight Stream, their frequency is shown. Reflect on your own history and identify the negative emotions that seem most familiar or common to your experience. (Choose the Top 5)."),
                  15.sp.sbh,
                  _buildNegativeView(controller, dataSelfReflact)
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildPositiveView(DevelopmentController controller,
      EmotionsSelfReflectDetailsData dataSelfReflact) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: AlignedGridView.count(
        crossAxisSpacing: 5.sp,
        mainAxisSpacing: 5.sp,
        crossAxisCount: 2,
        shrinkWrap: true,
        primary: false,
        itemCount: dataSelfReflact.checkboxList!.first.positiveEmotions!.length,
        itemBuilder: (context, index) => EmotionsCheckboxListtile(
          feelingCount: dataSelfReflact
              .checkboxList!.first.positiveEmotions![index].feelingCount
              .toString(),
          isReset: controller.isReset,
          title: dataSelfReflact
              .checkboxList!.first.positiveEmotions![index].areaName
              .toString(),
          isChecked: dataSelfReflact
                  .checkboxList!.first.positiveEmotions![index].isMarked ==
              "1",
          onChange: (value) {
            _callAPICheckbox(
              controller,
              dataSelfReflact.checkboxList!.first.positiveEmotions![index],
              value == true ? "1" : "0".toString(),
              type: "1",
            );
          },
        ),
      ),
    );
  }

  Widget _buildNegativeView(DevelopmentController controller,
      EmotionsSelfReflectDetailsData dataSelfReflact) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: AlignedGridView.count(
        crossAxisSpacing: 5.sp,
        mainAxisSpacing: 5.sp,
        crossAxisCount: 2,
        shrinkWrap: true,
        primary: false,
        itemCount: dataSelfReflact.checkboxList!.first.negativeEmotions!.length,
        itemBuilder: (context, index) => EmotionsCheckboxListtile(
          feelingCount: dataSelfReflact
              .checkboxList!.first.negativeEmotions![index].feelingCount
              .toString(),
          isReset: false,
          title: dataSelfReflact
              .checkboxList!.first.negativeEmotions![index].areaName
              .toString(),
          isChecked: dataSelfReflact
                  .checkboxList!.first.negativeEmotions![index].isMarked ==
              "1",
          onChange: (value) {
            _callAPICheckbox(
              controller,
              dataSelfReflact.checkboxList!.first.negativeEmotions![index],
              value == true ? "1" : "0".toString(),
              type: " ",
            );
          },
        ),
      ),
    );
  }

  Color _getColor(int color) {
    return AppColors.labelColor36;
  }
}
