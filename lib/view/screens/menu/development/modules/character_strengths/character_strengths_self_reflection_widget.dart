import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/character_strengths_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_self_reflect_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_image_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CharacterStrengthsSelfReflectionWidget extends StatefulWidget {
  const CharacterStrengthsSelfReflectionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<CharacterStrengthsSelfReflectionWidget> createState() =>
      _CharacterStrengthsReflectionWidgetState();
}

class _CharacterStrengthsReflectionWidgetState
    extends State<CharacterStrengthsSelfReflectionWidget> {
  final _characterStrengthsController =
      Get.find<CharacterStrengthsController>();
  @override
  void initState() {
    super.initState();
    _characterStrengthsController.getSelfReflactData(true, widget.userId);
  }

  _callAPI(DevelopmentController controller, SliderData data, String newScore) {
    controller.updateSelfReflaction(
      styleId: data.styleId.toString(),
      areaId: data.areaId.toString(),
      isMarked: data.isMarked.toString(),
      markingType: data.markingType.toString(),
      stylrParentId: data.stylrParentId.toString(),
      radioType: data.radioType.toString(),
      newScore: newScore,
      onReaload: (val) async {
        await _characterStrengthsController.getSelfReflactData(
            val, widget.userId);
      },
      ratingType:
          _characterStrengthsController.dataSelfReflact!.ratingType.toString(),
      userId: _characterStrengthsController.dataSelfReflact!.userId.toString(),
      type: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CharacterStrengthsController>(
        builder: (characterStrengthsController) {
      if (characterStrengthsController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (characterStrengthsController.isErrorSelfReflact ||
          characterStrengthsController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              characterStrengthsController.getSelfReflactData(
                  true, widget.userId);
            },
            text: characterStrengthsController.isErrorSelfReflact
                ? characterStrengthsController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(characterStrengthsController.dataSelfReflact!);
      }
    });
  }

  CustomSlideUpAndFadeWidget _buildView(
      WorkSkillSelfReflectDetailsData dataSelfReflact) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _characterStrengthsController.getSelfReflactData(
              true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DevelopmentSelfReflectTitleWidget(
                    title:
                        "When you discover your greatest strengths, you learn to use them to handle stress and life challenges, become happier, and develop relationships with those who matter most to you.On each scale below, move the slider to describe how you perceive your use of that particular Character Strength. Consider the reality that strengths can be over-used or under-used. A Signature Strength score would indicate that you have found an effective balance between over and under-use."),
                10.sp.sbh,
                buildButtonHowdo(
                    title:
                        "Character Strengths Profiler : How do I see myself?"),
                const DevelopmentSelfReflectImageWidget(),
                10.sp.sbh,
                buildTitleWithBG("Move slider to rate your self."),
                10.sp.sbh,
                ...dataSelfReflact.sliderList!.map((e) =>
                    GetBuilder<DevelopmentController>(builder: (controller) {
                      return Column(
                        children: [
                          buildTitleWithUpperLowerLine(e.title.toString()),
                          10.sp.sbh,
                          ...e.value!.map((e) => DevelopmentSliderWithTitle(
                                topBgColor:
                                    AppColors.labelColor15.withOpacity(0.85),
                                title: e.areaName.toString(),
                                middleTitle: e.leftMeaning.toString(),
                                onChange: (val) {
                                  controller.onDelayHandler(() {
                                    _callAPI(controller, e, val.toString());
                                  });
                                },
                                isReset: controller.isReset,
                                sliderValue: CommonController.getSliderValue(
                                    e.idealScale.toString()),
                                isEnable: true,
                              )),
                        ],
                      );
                    }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
