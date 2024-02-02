import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/emotions_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/data/model/response/development/emotion_graph_model.dart';
import 'package:aspirevue/data/model/response/development/emotions_assess_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_3_box_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/title_3_slider_2_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';

class EmotionsAspireVueTrainingWidget extends StatefulWidget {
  const EmotionsAspireVueTrainingWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<EmotionsAspireVueTrainingWidget> createState() =>
      _EmotionsAspireVueTrainingtState();
}

class _EmotionsAspireVueTrainingtState
    extends State<EmotionsAspireVueTrainingWidget> {
  final _developmentController = Get.find<DevelopmentController>();
  EmotionGraphData? grapgData;

  DropDownOptionItemMenu _ddValue =
      DropDownOptionItemMenu(id: "1", title: "Weekly");

  final List<DropDownOptionItemMenu> _ddList = [
    DropDownOptionItemMenu(id: "1", title: "Weekly"),
    DropDownOptionItemMenu(id: "2", title: "Monthly"),
    DropDownOptionItemMenu(id: "3", title: "Overall"),
  ];

  bool _isLoading = false;
  bool _isError = false;
  String _errorMessage = "";

  Future _loadData(bool showMainLoading) async {
    if (showMainLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    Map<String, dynamic> map = {
      "user_id": widget.userId.toString(),
      "chart_type": _ddValue.id,
    };

    try {
      var res = await _developmentController.emotionGraph(map);
      if (res != null) {
        if (mounted) {
          setState(() {
            _isError = false;
            _errorMessage = "";
            grapgData = res;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isError = true;
            _errorMessage = AppString.somethingWentWrong;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          String error = CommonController().getValidErrorMessage(e.toString());
          _errorMessage = error.toString();
        });
      }
    } finally {
      if (showMainLoading) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  final _emotionsController = Get.find<EmotionsController>();

  @override
  void initState() {
    super.initState();
    _loadData(true);
    _emotionsController.getTargetingDetails(widget.userId);
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
        await _emotionsController.getTargetingDetails(widget.userId);
      },
      ratingType: _emotionsController.dataTarget!.ratingType.toString(),
      userId: _emotionsController.dataTarget!.userId.toString(),
      type: "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<EmotionsController>(builder: (emotionsController) {
      if (emotionsController.isLoadingTarget) {
        return const Center(child: CustomLoadingWidget());
      }
      if (emotionsController.isErrorTarget ||
          emotionsController.dataTarget == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              _emotionsController.getTargetingDetails(widget.userId);
            },
            text: emotionsController.isErrorTarget
                ? emotionsController.errorMsgTarget
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return Stack(
          children: [
            _buildView(emotionsController.dataTarget!,
                emotionsController.titleListTarget, emotionsController),
            emotionsController.dataTarget!.isJourneyLicensePurchased == 0
                ? PurchasePopupWidget(
                    text: emotionsController
                        .dataTarget!.journeyLicensePurchaseText
                        .toString(),
                  )
                : 0.sbh
          ],
        );
      }
    });
  }

  Widget _buildView(EmotionsAssesData dataTarget, List titleListTarget,
      EmotionsController emotionsController) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _emotionsController.getTargetingDetails(widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlackTitle(
                    "Emotions Profile: Targeting My Ideal Self at My Best"),
                5.sp.sbh,
                buildGreyTitle(
                    "For each scale below, consider the various data sources and move the My Target slider to your ideal."),
                10.sp.sbh,
                buildDivider(),
                buildTitleLog(titleListTarget),
                buildDivider(),
                10.sp.sbh,
                dataTarget.relationWithLoginUser ==
                        AppConstants.userRoleSupervisor
                    ? 0.sbh
                    : Column(
                        children: [
                          _buildButtonwithIcon(
                              emotionsController.isSharedTargating),
                          15.sp.sbh,
                        ],
                      ),
                ...dataTarget.sliderList!.map((e) {
                  return GetBuilder<DevelopmentController>(
                      builder: (controller) {
                    return Column(
                      children: [
                        DevelopmentTitle3BoxWidget(
                          type: 4,
                          title: e.title.toString(),
                          fontColor: _getRamdomColor(
                                      dataTarget.sliderList!.indexOf(e)) ==
                                  null
                              ? AppColors.white
                              : AppColors.labelColor8,
                          bgColor: _getRamdomColor(
                              dataTarget.sliderList!.indexOf(e)),
                          reputationValue: e.repurationCount ?? "",
                          selfReflactionValue: e.reflactionCount ?? "",
                          assessValue: e.assessCount ?? "",
                          myTargetValue: e.mytargetCount ?? "",
                        ),
                        10.sp.sbh,
                        ...e.value!.map((e) => TitleSliderAndBottom2Title(
                              list: [
                                SliderModel(
                                  title: dataTarget.type1.toString(),
                                  color: AppColors.backgroundColor4,
                                  value: CommonController.getSliderValue(
                                      e.discoveryScale.toString()),
                                  isEnable: true,
                                  returnValue: (val) {
                                    controller.onDelayHandler(() {
                                      _callAPI(controller, e, val.toString());
                                    });
                                  },
                                ),
                                SliderModel(
                                  title: dataTarget.type3.toString(),
                                  color: AppColors.labelColor62,
                                  value: CommonController.getSliderValue(
                                      e.feelingCount.toString()),
                                  isEnable: false,
                                ),
                                SliderModel(
                                  title: dataTarget.type2.toString(),
                                  color: AppColors.labelColor57,
                                  value: CommonController.getSliderValue(
                                      e.reaslScale.toString()),
                                  isEnable: false,
                                ),
                                SliderModel(
                                  title: dataTarget.type4.toString(),
                                  color: AppColors.labelColor56,
                                  value: CommonController.getSliderValue(
                                      e.reputScale.toString()),
                                  isEnable: false,
                                ),
                              ],
                              mainTitle: e.areaName.toString(),
                              title: e.leftMeaning.toString(),
                              bottomLeftTitle: "",
                              bottomRightTitle: "",
                              isReset: controller.isReset,
                            ))
                      ],
                    );
                  });
                }),
                _buildGraph(),
                5.sp.sbh,
                buildGreyTitle(
                    "The emotions shown below were identified as ‘dominant’ due to their frequency, duration or intensity that they appeared within your experience."),
                5.sp.sbh,
                buildDivider(),
                5.sp.sbh,
                AlignedGridView.count(
                  crossAxisSpacing: 5.sp,
                  mainAxisSpacing: 2.sp,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: dataTarget.checkboxList!.length,
                  itemBuilder: (context, index) => Text(
                    dataTarget.checkboxList![index].areaName.toString(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.sp.sbh,
        buildBlackTitle("EMOTIONAL SELF-AWARENESS"),
        5.sp.sbh,
        buildGreyTitle(
            "Here is a graph of emotions you have endorsed on Insight Stream over time."),
        5.sp.sbh,
        buildDivider(),
        10.sp.sbh,
        CustomDropListForMessageTwo(
          _ddValue.title,
          _ddValue,
          _ddList,
          fontSize: 12.sp,
          borderColor: AppColors.labelColor,
          bgColor: AppColors.labelColor12,
          (selectedValue) {
            setState(() {
              _ddValue = selectedValue;
            });

            _loadData(true);
          },
        ),
        10.sp.sbh,
        _isLoading == true
            ? const Center(child: CustomLoadingWidget())
            : _isError == true
                ? Center(
                    child: CustomErrorWidget(
                      width: 20.h,
                      onRetry: () {
                        _loadData(true);
                      },
                      text: _errorMessage,
                    ),
                  )
                : _buildGraphView()
      ],
    );
  }

  _buildGraphView() {
    return SizedBox(
      width: context.width,
      height: context.width,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
            minimum: -5,
            maximum: grapgData!.chartData!
                    .where((element) =>
                        element.negative! > 0 || element.positive! > 0)
                    .isNotEmpty
                ? null
                : 5),
        legend: const Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          SplineSeries<ChartDatum, String>(
              dataSource: grapgData!.chartData!,
              width: 1.sp,
              name: "Positive",
              markerSettings: const MarkerSettings(isVisible: true),
              xValueMapper: (ChartDatum sales, _) => sales.label.toString(),
              yValueMapper: (ChartDatum sales, _) => sales.positive,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.green),
          SplineSeries<ChartDatum, String>(
              dataSource: grapgData!.chartData!,
              name: "Nagative",
              width: 1.sp,
              markerSettings: const MarkerSettings(isVisible: true),
              xValueMapper: (ChartDatum sales, _) => sales.label.toString(),
              yValueMapper: (ChartDatum sales, _) => sales.negative,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.red),
        ],
        // series: <ChartSeries<ChartDatum, String>>[
        //   SplineSeries<ChartDatum, String>(
        //       dataSource: grapgData!.chartData!,
        //       width: 1.sp,
        //       name: "Positive",
        //       markerSettings: const MarkerSettings(isVisible: true),
        //       xValueMapper: (ChartDatum sales, _) => sales.label.toString(),
        //       yValueMapper: (ChartDatum sales, _) => sales.positive,
        //       // dataLabelSettings: const DataLabelSettings(isVisible: true),
        //       color: Colors.green),
        //   SplineSeries<ChartDatum, String>(
        //       dataSource: grapgData!.chartData!,
        //       name: "Nagative",
        //       width: 1.sp,
        //       markerSettings: const MarkerSettings(isVisible: true),
        //       xValueMapper: (ChartDatum sales, _) => sales.label.toString(),
        //       yValueMapper: (ChartDatum sales, _) => sales.negative,
        //       // dataLabelSettings: const DataLabelSettings(isVisible: true),
        //       color: Colors.red),
        // ],
      ),
    );
  }

  Center _buildButtonwithIcon(bool isShared) {
    return Center(
      child: CustomButton2(
          buttonColor: AppColors.labelColor74.withOpacity(0.26),
          textColor: AppColors.labelColor74,
          icon: isShared
              ? AppImages.checkCircleGreenIc
              : AppImages.uncheckGreenCircleIc,
          buttonText: "Shared with Supervisor",
          radius: 5.sp,
          padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          onPressed: () {
            shareWithSupervisor(isShared);
          }),
    );
  }

  shareWithSupervisor(bool isChecked) async {
    bool? result = await Get.find<DevelopmentController>().shareWithSupervisor(
        styleId: _emotionsController.dataTarget!.styleId.toString(),
        userId: _emotionsController.dataTarget!.userId.toString(),
        assessId: isChecked == true ? "0" : "1");

    if (result != null && result == true) {
      _emotionsController.updateShareStatus();
    }
  }

  Color? _getRamdomColor(int index) {
    switch (index) {
      case 0:
        return null;

      default:
        return _colorArray[random(0, 3)];
    }
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  final List _colorArray = [
    AppColors.labelColor71,
    AppColors.labelColor72,
    AppColors.labelColor73
  ];
}
