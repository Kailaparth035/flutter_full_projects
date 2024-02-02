import 'package:aspirevue/controller/development/leader_style_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/leader_style_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_expanded_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_with_radio_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LeaderStyleViewMoreRepurationWidget extends StatefulWidget {
  const LeaderStyleViewMoreRepurationWidget({super.key, required this.userId});
  final String userId;
  @override
  State<LeaderStyleViewMoreRepurationWidget> createState() =>
      _LeaderStyleViewMoreRepurationWidgetState();
}

class _LeaderStyleViewMoreRepurationWidgetState
    extends State<LeaderStyleViewMoreRepurationWidget> {
  final _leaderStyleController = Get.find<LeaderStyleController>();
  @override
  void initState() {
    _leaderStyleController.getReputationFeedbackSliderList(true, widget.userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<LeaderStyleController>(builder: (leaderStyleController) {
      if (leaderStyleController.isLoadingReputationSlider) {
        return const Center(child: CustomLoadingWidget());
      }
      if (leaderStyleController.isErrorReputationSlider ||
          leaderStyleController.dataReputationSlider == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              leaderStyleController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: leaderStyleController.isErrorReputationSlider
                ? leaderStyleController.errorMsgReputationSlider
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildViewMoreWidget(
            leaderStyleController.dataReputationSlider!);
      }
    });
  }

  Widget _buildViewMoreWidget(
      LeaderStyleReputaionSliderData dataReputationSlider) {
    return Column(
      children: [
        buildTitleWithBG("Reputation Feedback"),
        dataReputationSlider.relationWithLoginUser ==
                AppConstants.userRoleSupervisor
            ? _buildRadioButtonViewForUservisor(dataReputationSlider)
            : 0.sbh,
        Padding(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            children: [
              buildBlackTitle(
                  dataReputationSlider.reputationFeedback!.title1.toString()),
              buildGreyTitle(
                  "Behavior exists on a continuum, with too little at one end and too much at the other. Between these two extremes lies a place of balance, where we display just enough strength to accomplish what we want effectively and efficiently."),
              5.sp.sbh,
              buildGreyTitle(
                  "Drawing from your perspective, select the Top 7 characteristics that you believe could be increased or decreased to improve this individual’s effectiveness at work. Fill in the blank:"),
              5.sp.sbh,
              buildGreyTitle(
                  "For this behavior characteristic [________], I'd like to see ..."),
            ],
          ),
        ),
        ...dataReputationSlider.reputationFeedback!.list!.map(
          (e) => DevelopmentTitleWithExpandedWidget(
            mainTitle: e.areaName.toString(),
            title: "",
            list: [
              {
                "title": "INCREASE",
                "value": e.increaseType.toString(),
              },
              {
                "title": "DECREASE",
                "value": e.decreaseType.toString(),
              },
              {
                "title": "NET ACTION",
                "value": e.action.toString(),
                "color": e.action.toString().toLowerCase() == "increase"
                    ? AppColors.greenColor
                    : AppColors.redColor
              }
            ],
          ),
        )
      ],
    );
  }

  _buildRadioButtonViewForUservisor(
      LeaderStyleReputaionSliderData dataReputationSlider) {
    return Column(
      children: [
        dataReputationSlider.reputationFeedbackSupervisor!.list!.isNotEmpty
            ? GetBuilder<DevelopmentController>(builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildBlackTitle(dataReputationSlider
                              .reputationFeedbackSupervisor!.title1
                              .toString()),
                          5.sp.sbh,
                          buildGreyTitle(
                              "Behavior exists on a continuum, with too little at one end and too much at the other. Between these two extremes lies a place of balance, where we display just enough strength to accomplish what we want effectively and efficiently."),
                          5.sp.sbh,
                          buildGreyTitle(
                              "Drawing from your perspective, select the Top 7 characteristics that you believe this person should increase or decrease to improve their effectiveness at work:"),
                          5.sp.sbh,
                          buildGreyTitle(
                              "Fill in the blank as appropriate : [_____________________]"),
                        ],
                      ),
                    ),
                    ...dataReputationSlider.reputationFeedbackSupervisor!.list!
                        .map((e) => Column(
                              children: [
                                DevelopmentTitleWithRadioWidget(
                                  isReset: controller.isReset,
                                  mainTitle: e.areaName.toString(),
                                  title: "",
                                  cbTitle1: "LESS OF THIS TRAIT",
                                  cbTitle2: "NO CHANGE, A NICE BALANCE",
                                  cbTitle3: "MORE OF THIS TRAIT",
                                  cbTitle1Flex: 2,
                                  cbTitle2Flex: 2,
                                  cbTitle3Flex: 2,
                                  value1: "7",
                                  value2: "4",
                                  value3: "6",
                                  selectedIndex: e.radioType,
                                  callBack: (val) {
                                    _callAPI(
                                        controller, e, e.idealScale.toString(),
                                        radioValue: val);
                                  },
                                )
                              ],
                            )),
                  ],
                );
              })
            : 0.sbh,
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
          await _leaderStyleController.getReputationFeedbackSliderList(
              val, widget.userId);
        },
        ratingType: data.ratingType ?? "",
        userId: _leaderStyleController.dataReputationUser!.userId.toString(),
        type: type,
        radioType: radioValue);
  }
}
