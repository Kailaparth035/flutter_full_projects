import 'package:aspirevue/controller/development/leader_style_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/leader_style_self_reflect_mode.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_radio_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LeaderStyleSelfReflectionWidget extends StatefulWidget {
  const LeaderStyleSelfReflectionWidget({
    super.key,
    required this.userId,
  });
  final String userId;
  @override
  State<LeaderStyleSelfReflectionWidget> createState() =>
      _LeaderStyleSelfReflectionWidgetState();
}

class _LeaderStyleSelfReflectionWidgetState
    extends State<LeaderStyleSelfReflectionWidget> {
  final _leaderStyleController = Get.find<LeaderStyleController>();
  @override
  void initState() {
    super.initState();
    _leaderStyleController.getSelfReflactData(true, widget.userId);
  }

  _callAPI(DevelopmentController controller, SliderData data,
      {String type = "", String radioValue = ""}) {
    controller.updateSelfReflaction(
        styleId: data.styleId.toString(),
        areaId: data.areaId.toString(),
        isMarked: "1",
        markingType: data.markingType.toString(),
        stylrParentId: data.stylrParentId ?? "0",
        newScore: data.idealScale.toString(),
        onReaload: (val) async {
          await _leaderStyleController.getSelfReflactData(val, widget.userId);
        },
        ratingType:
            _leaderStyleController.dataSelfReflact!.ratingType.toString(),
        userId: _leaderStyleController.dataSelfReflact!.userId.toString(),
        type: type,
        radioType: radioValue);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<LeaderStyleController>(builder: (leaderStyleController) {
      if (leaderStyleController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (leaderStyleController.isErrorSelfReflact ||
          leaderStyleController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              leaderStyleController.getSelfReflactData(true, widget.userId);
            },
            text: leaderStyleController.isErrorSelfReflact
                ? leaderStyleController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(
            leaderStyleController.dataSelfReflact!, leaderStyleController);
      }
    });
  }

  CustomSlideUpAndFadeWidget _buildView(
      LeaderStyleSelfReflectDetailsData dataSelfReflact,
      LeaderStyleController leaderStyleController) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _leaderStyleController.getSelfReflactData(true, widget.userId);
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
                        "Behavior exists on a continuum, with too little at one end and too much at the other. Between these two extremes lies a place of balance, where we display just enough strength to accomplish what we want effectively and efficiently. Drawing from your own perspective, select the Top 7 characteristics that you might increase or decrease to improve effectiveness at work. Fill in the blank: For this behavior characteristic [________], I'd like to see ..."),
                10.sp.sbh,
                buildButtonHowdo(
                    title:
                        "My Self-Perceptions of my Leader Style Characteristics"),
                10.sp.sbh,
                buildTitleWithBG(
                    "Select intentional behavior to expand your impact:"),
                10.sp.sbh,
                ...dataSelfReflact.radioList!.map((e) =>
                    GetBuilder<DevelopmentController>(builder: (controller) {
                      return DevelopmentTitleWithRadioWidget(
                        isReset: controller.isReset,
                        mainTitle: e.areaName.toString(),
                        title: "",
                        cbTitle1: "LESS OF THIS TRAIT",
                        cbTitle2: "NO CHANGE, A NICE BALANCE",
                        cbTitle3: "MORE OF THIS TRAIT",
                        cbTitle1Flex: 1,
                        cbTitle2Flex: 1,
                        cbTitle3Flex: 1,
                        value1: "3",
                        value2: "4",
                        value3: "5",
                        selectedIndex: e.radioType,
                        callBack: (val) {
                          _callAPI(controller, e, radioValue: val);
                        },
                      );
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
