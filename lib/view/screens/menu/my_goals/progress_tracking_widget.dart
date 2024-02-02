import 'dart:math';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/progress_tracking_chart_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressTrackingWidget extends StatefulWidget {
  const ProgressTrackingWidget({super.key});

  @override
  State<ProgressTrackingWidget> createState() => _ProgressTrackingWidgetState();
}

class _ProgressTrackingWidgetState extends State<ProgressTrackingWidget> {
  final _developmentController = Get.find<DevelopmentController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildProgressTrackingChartBox();
  }

  Widget _buildProgressTrackingChartBox() {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
            _developmentController.prograssTrackingDDValue.value.title == ""
                ? 0.sbh
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: CustomDropListForMessageTwo(
                      _developmentController
                          .prograssTrackingDDValue.value.title,
                      _developmentController.prograssTrackingDDValue.value,
                      _developmentController.prograssTrackingDDList,
                      fontSize: 12.sp,
                      borderColor: AppColors.labelColor,
                      bgColor: AppColors.labelColor12,
                      (selectedValue) {
                        _developmentController.selectOption(selectedValue);

                        _developmentController.getProgressTrackings(true);
                      },
                    ),
                  ),
            10.sp.sbh,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: CustomDropListForMessageTwo(
                _developmentController.dropDownTwoValue.value.title,
                _developmentController.dropDownTwoValue.value,
                (_developmentController.prograssTrackingDDValue.value.title
                                .toLowerCase() ==
                            "performance reviews") ||
                        (_developmentController
                                .prograssTrackingDDValue.value.title
                                .toLowerCase() ==
                            "workplace performance")
                    ? _developmentController.ddList3
                    : _developmentController.ddList2,
                fontSize: 12.sp,
                borderColor: AppColors.labelColor,
                bgColor: AppColors.labelColor12,
                (selectedValue) {
                  _developmentController.selectOptionTwo(selectedValue);
                },
              ),
            ),
            10.sp.sbh,
            GetBuilder<DevelopmentController>(builder: (controller) {
              return controller.isLoadingProgressTracking == true
                  ? const Center(child: CustomLoadingWidget())
                  : controller.isErrorProgressTracking == false &&
                          controller.progressTracking == null
                      ? 0.sbh
                      : controller.isErrorProgressTracking == true
                          ? Center(
                              child: CustomErrorWidget(
                                onRetry: () {
                                  _developmentController
                                      .getProgressTrackings(true);
                                },
                                text: controller.errorMsgProgressTracking,
                              ),
                            )
                          : _buildProgressTrakingChart(
                              controller.progressTracking);
            })
          ],
        ),
      );
    });
  }

  _buildProgressTrakingChart(ProgressTrakingChartData? data) {
    return SizedBox(
      width: context.width,
      height: context.width,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          labelAlignment: LabelAlignment.center,
          minimum: _getMinValue(data),
          interval: _getXData(data, false)!.abs() > 0
              ? _getXData(data, false)!.abs()
              : 1,
        ),
        legend: const Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          SplineSeries<ProgressChartData, String>(
            dataSource: data!.chartData!,
            name: "Progress Tracking",
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (ProgressChartData sales, _) => sales.label,
            yValueMapper: (ProgressChartData sales, _) =>
                CommonController.getDoubleValue(sales.journeyCount!),
            color: AppColors.secondaryColor,
            cardinalSplineTension: 0,
            width: 1,
          ),
        ],
      ),
    );
  }

  double? _getMinValue(ProgressTrakingChartData? grapgData) {
    if (grapgData == null || grapgData.chartData!.isEmpty) {
      return 0;
    }
    var list = grapgData.chartData!
        .map((e) => CommonController.getDoubleValue(e.journeyCount!))
        .toList();

    if (list.where((element) => element >= 0).isEmpty) {
      return 0;
    } else {
      bool allSame = grapgData.chartData!.every((element) =>
          element.journeyCount == grapgData.chartData![0].journeyCount);
      if (allSame) {
        var value = CommonController.getDoubleValue(
            grapgData.chartData![0].journeyCount!);
        return value - value;
      } else {
        var maxTtem = list.reduce(max);
        var minTtem = list.reduce(min);

        var avrage =
            (maxTtem) / ((list.length > 10) ? (list.length / 2) : list.length);
        var cal =
            (CommonController().calculateNumber(avrage.round().toDouble()) *
                    -1) +
                minTtem;

        return cal + ((cal / 4).round());
      }
    }
  }

  double? _getXData(ProgressTrakingChartData? grapgData, bool isMax) {
    if (grapgData == null) {
      return 0;
    }
    var list =
        grapgData.chartData!.map((e) => double.parse(e.journeyCount!)).toList();

    if (list.where((element) => element >= 0).isEmpty) {
      return isMax ? 0 : 0;
    } else {
      if (isMax) {
        return null;
      } else {
        var maxTtem = list.reduce(max);
        var minTtem = list.reduce(min);

        var avrage =
            (maxTtem) / ((list.length > 10) ? (list.length / 2) : list.length);
        var cal =
            (CommonController().calculateNumber(avrage.round().toDouble()) *
                    -1) +
                minTtem;

        return cal + ((cal / 4).round());
      }
    }
  }
}
