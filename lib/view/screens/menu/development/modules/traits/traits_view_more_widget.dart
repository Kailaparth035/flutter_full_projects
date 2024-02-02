import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/traits_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_with_left_right_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TraitsViewMoreWidget extends StatefulWidget {
  const TraitsViewMoreWidget({super.key, required this.userId});
  final String userId;
  @override
  State<TraitsViewMoreWidget> createState() => _TraitsViewMoreWidgetState();
}

class _TraitsViewMoreWidgetState extends State<TraitsViewMoreWidget> {
  final _traitsController = Get.find<TraitsController>();
  @override
  void initState() {
    _traitsController.getReputationFeedbackSliderList(true, widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<TraitsController>(builder: (traitsController) {
      if (traitsController.isLoadingReputationSlider) {
        return const Center(child: CustomLoadingWidget());
      }
      if (traitsController.isErrorReputationSlider ||
          traitsController.dataReputationSlider == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              traitsController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: traitsController.isErrorReputationSlider
                ? traitsController.errorMsgReputationSlider
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildViewMoreWidget(traitsController.dataReputationSlider!);
      }
    });
  }

  Widget _buildViewMoreWidget(ReputationSliderData dataReputationSlider) {
    return Column(
      children: [
        buildTitleWithBG("Reputation Feedback"),
        10.sp.sbh,
        GetBuilder<DevelopmentController>(builder: (controller) {
          return Column(
            children: [
              ...dataReputationSlider.reputationFeedback!
                  .map((e) => DevelopmentSliderWithLeftRightTitle(
                        isReset: controller.isReset,
                        headerTitle: e.areaName,
                        topTitle: e.leftMeaning.toString(),
                        topSecondTitle: e.rightMeaning.toString(),
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
                      )),
            ],
          );
        })
      ],
    );
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
        await _traitsController.getReputationFeedbackSliderList(
            val, widget.userId);
      },
      ratingType: data.ratingType ?? "",
      userId: _traitsController.dataReputationUser!.userId.toString(),
      type: "",
    );
  }
}
