import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/compentencies_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/comp_reflect_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_slider_for_competency.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_table_multi_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CompentencySelfReflectionWidget extends StatefulWidget {
  const CompentencySelfReflectionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<CompentencySelfReflectionWidget> createState() =>
      _CompentencySelfReflectionWidgetState();
}

class _CompentencySelfReflectionWidgetState
    extends State<CompentencySelfReflectionWidget> {
  final _compentenciesController = Get.find<CompentenciesController>();

  @override
  void initState() {
    super.initState();
    _compentenciesController.getSelfReflactData(true, widget.userId);
  }

  _callAPI(DevelopmentController controller, SliderListForCompetancy data,
      String newScore) async {
    controller.updateCompentencyDetails(
      styleId: _compentenciesController.dataSelfReflact!.styleId.toString(),
      newScore: newScore,
      onReaload: (val) async {
        await _compentenciesController.getSelfReflactData(val, widget.userId);
      },
      userId: _compentenciesController.dataSelfReflact!.userId.toString(),
      corecompetencyId: data.corecompetencyId.toString(),
      positionDetail: data.positionDetail.toString(),
      positionId: data.positionId.toString(),
      scoringType: data.scoringType.toString(),
      sliderType: data.sliderType.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CompentenciesController>(
        builder: (conpentenciesController) {
      if (conpentenciesController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (conpentenciesController.isErrorSelfReflact ||
          conpentenciesController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              conpentenciesController.getSelfReflactData(true, widget.userId);
            },
            text: conpentenciesController.isErrorSelfReflact
                ? conpentenciesController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return buildView(conpentenciesController.dataSelfReflact!);
      }
    });
  }

  Widget buildView(CompReflectDetailsData dataSelfReflact) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _compentenciesController.getSelfReflactData(
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
                        "Competency : Competencies reflect a person's skills, knowledge, and abilities. On the competencies scales below, move the slider to describe how you view your own competency levels."),
                10.sp.sbh,
                buildTitleWithBG("Move slider to rate your self."),
                10.sp.sbh,
                ...dataSelfReflact.sliderList!.map(
                  (e) =>
                      GetBuilder<DevelopmentController>(builder: (controller) {
                    return DevelopmentSliderForCompetency(
                      onChange: (val) {
                        controller.onDelayHandler(() {
                          _callAPI(controller, e, val.toString());
                        });
                      },
                      isReset: controller.isReset,
                      sliderValue: CommonController.getSliderValue(
                          e.reflectScore.toString()),
                      title: e.title.toString(),
                      data: e,
                    );
                  }),
                ),
                dataSelfReflact.suggetionList!.isNotEmpty
                    ? DevelopmentMultiValueTableWidget(
                        title1: "Competency",
                        title2: "Suggestion",
                        list: [
                          ...dataSelfReflact.suggetionList!.map(
                            (e) => {
                              "title1": e.title.toString(),
                              "title2": e.list,
                            },
                          )
                        ],
                      )
                    : 0.sbh,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
