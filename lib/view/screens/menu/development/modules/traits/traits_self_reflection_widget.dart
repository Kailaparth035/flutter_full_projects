import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/traits_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/data/model/response/development/traits_self_reflect_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_left_right_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TraitsSelfReflectionWidget extends StatefulWidget {
  const TraitsSelfReflectionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<TraitsSelfReflectionWidget> createState() =>
      _TraitsSelfReflectionWidgetState();
}

class _TraitsSelfReflectionWidgetState
    extends State<TraitsSelfReflectionWidget> {
  final _traitsController = Get.find<TraitsController>();

  @override
  void initState() {
    super.initState();
    _traitsController.getSelfReflactData(true, widget.userId);
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
        await _traitsController.getSelfReflactData(val, widget.userId);
      },
      ratingType: _traitsController.dataSelfReflact!.ratingType.toString(),
      userId: _traitsController.dataSelfReflact!.userId.toString(),
      type: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<TraitsController>(builder: (traitsController) {
      if (traitsController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (traitsController.isErrorSelfReflact ||
          traitsController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              traitsController.getSelfReflactData(true, widget.userId);
            },
            text: traitsController.isErrorSelfReflact
                ? traitsController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(traitsController.dataSelfReflact!);
      }
    });
  }

  CustomSlideUpAndFadeWidget _buildView(
      TraitsSelfReflectDetailsData dataSelfReflact) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _traitsController.getSelfReflactData(true, widget.userId);
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
                        "Personality traits reflect a person's characteristic way of responding to their environment. On the personality scales below, move the sliders to describe how you view your own personality traits."),
                10.sp.sbh,
                buildButtonHowdo(title: "How do I see myself?"),
                15.sp.sbh,
                buildTitleWithBG("Move slider to rate your self."),
                10.sp.sbh,
                ...dataSelfReflact.sliderList!.map((e) =>
                    GetBuilder<DevelopmentController>(builder: (controller) {
                      return DevelopmentSliderWithLeftRightTitle(
                        topTitle: e.leftMeaning.toString(),
                        topSecondTitle: e.rightMeaning.toString(),
                        onChange: (p0) {
                          controller.onDelayHandler(() {
                            _callAPI(controller, e, p0.toString());
                          });
                        },
                        isReset: controller.isReset,
                        sliderValue: CommonController.getSliderValue(
                            e.idealScale.toString()),
                        isEnable: true,
                      );
                    })),
                10.sp.sbh,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
