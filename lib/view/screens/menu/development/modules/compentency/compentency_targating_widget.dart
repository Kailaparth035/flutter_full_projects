import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/compentencies_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/data/model/response/development/comp_targatting_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_dropdown_for_message.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/title_3_slider_2_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CompentencyTargatingWidget extends StatefulWidget {
  const CompentencyTargatingWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<CompentencyTargatingWidget> createState() =>
      _CompentencyTargatingWidgetState();
}

class _CompentencyTargatingWidgetState
    extends State<CompentencyTargatingWidget> {
  final _compentenciesController = Get.find<CompentenciesController>();

  @override
  void initState() {
    super.initState();
    _compentenciesController.getTargatingData(true, widget.userId);
  }

  _callAPI(DevelopmentController controller, SliderListForTargating data,
      String newScore) async {
    controller.updateCompentencyDetails(
      styleId: _compentenciesController.dataTargating!.styleId.toString(),
      newScore: newScore,
      onReaload: (loading) async {
        await _compentenciesController.getTargatingData(loading, widget.userId);
      },
      userId: _compentenciesController.dataTargating!.userId.toString(),
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
      if (conpentenciesController.isLoadingTargating) {
        return const Center(child: CustomLoadingWidget());
      }
      if (conpentenciesController.isErrorTargating ||
          conpentenciesController.dataTargating == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              conpentenciesController.getTargatingData(true, widget.userId);
            },
            text: conpentenciesController.isErrorTargating
                ? conpentenciesController.errorMsgTargating
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return buildView(
            conpentenciesController.dataTargating!,
            conpentenciesController.titleListForTargating,
            conpentenciesController);
      }
    });
  }

  Widget buildView(
      CompTargattingDetailsData dataTargating,
      List titleListForTargating,
      CompentenciesController conpentenciesController) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _compentenciesController.getTargatingData(true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlackTitle(
                    "Competency Profiler: Targeting my Ideal Self."),
                5.sp.sbh,
                buildGreyTitle(
                    "1. Select the position to identify list the associated competencies. "),
                3.sp.sbh,
                buildGreyTitle("2. Move the My Target slider to your ideal."),
                5.sp.sbh,
                buildDivider(),
                buildTitleLog(titleListForTargating),
                buildDivider(),
                10.sp.sbh,
                _buildFilterDD(conpentenciesController),
                10.sp.sbh,
                buildDivider(),
                10.sp.sbh,
                ...dataTargating.sliderList!.map(
                  (e) =>
                      GetBuilder<DevelopmentController>(builder: (controller) {
                    return TitleSliderAndBottom2Title(
                      isShowtooltip: true,
                      description: e.description,
                      list: [
                        SliderModel(
                          title: "",
                          color: AppColors.primaryColor,
                          value: CommonController.getSliderValue(
                              e.targetScore.toString()),
                          isEnable: true,
                          max: 100,
                          returnValue: (val) {
                            controller.onDelayHandler(() {
                              _callAPI(controller, e, val.toString());
                            });
                          },
                        ),
                        SliderModel(
                            title: "",
                            color: AppColors.labelColor62,
                            value: CommonController.getSliderValue(
                                e.reflectScore.toString()),
                            isEnable: false,
                            max: 100),
                        SliderModel(
                            title: "",
                            color: AppColors.labelColor57,
                            value: CommonController.getSliderValue(
                                e.peerScore.toString()),
                            isEnable: false,
                            max: 100),
                        SliderModel(
                            title: "",
                            color: AppColors.labelColor56,
                            value: CommonController.getSliderValue(
                                e.reportScore.toString()),
                            isEnable: false,
                            max: 100),
                        SliderModel(
                            title: "",
                            color: AppColors.labelColor97,
                            value: CommonController.getSliderValue(
                                e.supervisorScore.toString()),
                            isEnable: false,
                            max: 100),
                      ],
                      title: e.title.toString(),
                      bottomLeftTitle: "",
                      bottomRightTitle: "",
                      isReset: controller.isReset,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildFilterDD(CompentenciesController conpentenciesController) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: CustomDropListForMessage(
        conpentenciesController.ddFilterValue.title,
        conpentenciesController.ddFilterValue,
        conpentenciesController.ddFilterList,
        (optionItem) {
          conpentenciesController.onDDChange(optionItem, widget.userId);
        },
        fontSize: 12.sp,
        bgColor: AppColors.labelColor12,
        borderColor: AppColors.labelColor,
      ),
    );
  }
}
