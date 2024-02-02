import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/emotions_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/emotions_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EmotionsReputaionViewmoreWidget extends StatefulWidget {
  const EmotionsReputaionViewmoreWidget({super.key, required this.userId});
  final String userId;
  @override
  State<EmotionsReputaionViewmoreWidget> createState() =>
      _EmotionsReputaionViewmoreWidgetState();
}

class _EmotionsReputaionViewmoreWidgetState
    extends State<EmotionsReputaionViewmoreWidget> {
  final _emotionsController = Get.find<EmotionsController>();
  @override
  void initState() {
    _emotionsController.getReputationFeedbackSliderList(true, widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<EmotionsController>(builder: (emotionsController) {
      if (emotionsController.isLoadingReputationSlider) {
        return const Center(child: CustomLoadingWidget());
      }
      if (emotionsController.isErrorReputationSlider ||
          emotionsController.dataReputationSlider == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              emotionsController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: emotionsController.isErrorReputationSlider
                ? emotionsController.errorMsgReputationSlider
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildViewMoreWidget(emotionsController.dataReputationSlider!);
      }
    });
  }

  Widget _buildViewMoreWidget(
      EmotionsReputaionSliderData dataReputationSlider) {
    return GetBuilder<DevelopmentController>(builder: (controller) {
      return Column(children: [
        buildTitleWithBG("Reputation Feedback"),
        Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBlackTitle(dataReputationSlider.mainTitle.toString()),
              5.sp.sbh,
              buildGreyTitle(dataReputationSlider.mainSubTitle.toString()),
            ],
          ),
        ),
        10.sp.sbh,
        ...dataReputationSlider.reputationFeedback!.map((e) {
          int index = dataReputationSlider.reputationFeedback!.indexOf(e);
          return Column(
            children: [
              index == 0
                  ? buildTitleWithBoxAndGradientBG(
                      "${e.title.toString()} :", e.average.toString())
                  : buildTitleWithTopAndBottomBorderWithBox(
                      "${e.title.toString()} :",
                      e.average.toString(),
                      AppColors.labelColor36,
                      isFullBorder: true,
                    ),
              10.sp.sbh,
              ...e.value!.map(
                (slider) => DevelopmentSliderWithTitle(
                  isReset: false,
                  onChange: (val) {
                    controller.onDelayHandler(() {
                      _callAPI(controller, slider, val.toString());
                    });
                  },
                  middleTitle: slider.leftMeaning.toString(),
                  sliderValue: CommonController.getSliderValue(
                      slider.idealScale.toString()),
                  title: slider.areaName.toString(),
                  topBgColor: AppColors.labelColor15.withOpacity(0.85),
                  isEnable:
                      dataReputationSlider.isEnableSlider.toString() == "1",
                ),
              )
            ],
          );
        }),
        10.sp.sbh,
      ]);
    });
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
        await _emotionsController.getReputationFeedbackUserListUri(
            val, widget.userId);
      },
      ratingType: data.ratingType ?? "",
      userId: _emotionsController.dataReputationUser!.userId.toString(),
      type: "",
    );
  }
}
