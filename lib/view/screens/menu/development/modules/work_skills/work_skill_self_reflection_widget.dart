import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/work_skill_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_self_reflect_model.dart';
import 'package:aspirevue/util/app_constants.dart';
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

class WorkSkillSelfReflectionWidget extends StatefulWidget {
  const WorkSkillSelfReflectionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<WorkSkillSelfReflectionWidget> createState() =>
      _WorkSkillSelfReflectionWidgetState();
}

class _WorkSkillSelfReflectionWidgetState
    extends State<WorkSkillSelfReflectionWidget> {
  final _workSkillController = Get.find<WorkSkillController>();
  @override
  void initState() {
    super.initState();
    _workSkillController.getSelfReflactData(true, widget.userId);
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
        await _workSkillController.getSelfReflactData(val, widget.userId);
      },
      ratingType: _workSkillController.dataSelfReflact!.ratingType.toString(),
      userId: _workSkillController.dataSelfReflact!.userId.toString(),
      type: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<WorkSkillController>(builder: (workSkillController) {
      if (workSkillController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (workSkillController.isErrorSelfReflact ||
          workSkillController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              workSkillController.getSelfReflactData(true, widget.userId);
            },
            text: workSkillController.isErrorSelfReflact
                ? workSkillController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return buildView(workSkillController.dataSelfReflact!);
      }
    });
  }

  CustomSlideUpAndFadeWidget buildView(WorkSkillSelfReflectDetailsData data) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _workSkillController.getSelfReflactData(true, widget.userId);
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
                        "Work Skills describe a person's abilities to function effectively in the workplace. On the Work Skills scales below, move the sliders to describe how you view your own competencies."),
                const DevelopmentSelfReflectImageWidget(),
                10.sp.sbh,
                buildTitleWithBG("Move slider to rate your self."),
                10.sp.sbh,
                ...data.sliderList!.map((e) =>
                    GetBuilder<DevelopmentController>(builder: (controller) {
                      return Column(
                        children: [
                          buildTitleWithUpperLowerLine(e.title.toString()),
                          10.sp.sbh,
                          ...e.value!.map((e) => DevelopmentSliderWithTitle(
                                title: e.areaName.toString(),
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
