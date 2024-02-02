import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/forum_poll_view_response_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ViewResponseChartDialog extends StatefulWidget {
  const ViewResponseChartDialog({
    super.key,
    required this.id,
    required this.question,
  });

  final String id;
  final String question;

  @override
  State<ViewResponseChartDialog> createState() =>
      _ViewResponseChartDialogState();
}

class _ViewResponseChartDialogState extends State<ViewResponseChartDialog> {
  final _dashboardController = Get.find<DashboardController>();

  bool _isLoading = false;
  bool isFirstSubmit = true;
  ForumPollViewResponseData? data;

  List<LabelDetail> _list = [];
  @override
  void initState() {
    super.initState();
    _loadData(true);
  }

  Future _loadData(bool showMainLoading) async {
    if (showMainLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    Map<String, dynamic> map = {
      "forum_question_id": widget.id.toString(),
    };

    try {
      ForumPollViewResponseData res =
          await _dashboardController.viewResponse(map);
      setState(() {
        data = res;
        _list = res.labelDetail!;
      });
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    } finally {
      if (showMainLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              Divider(
                height: 1.sp,
                color: AppColors.labelColor,
                thickness: 1,
              ),
              10.sp.sbh,
              _isLoading
                  ? const Center(
                      child: CustomLoadingWidget(),
                    )
                  : _buildView(),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildView() {
    return Column(
      children: [
        SizedBox(
          width: context.width,
          height: context.width,
          child: SfCartesianChart(
            enableAxisAnimation: true,
            primaryXAxis: CategoryAxis(
              isVisible: true,
              isInversed: true,
              maximumLabelWidth: 50.sp,
            ),
            primaryYAxis:
                const NumericAxis(minimum: 0, maximum: 100, interval: 20),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: [
              BarSeries<LabelDetail, String>(
                dataSource: _list,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  builder: (data1, point, series, pointIndex, seriesIndex) {
                    return CustomText(
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                      color: AppColors.labelColor8,
                      text: "${_list[pointIndex].percentage.toString()}%",
                      textAlign: TextAlign.start,
                      fontFamily: AppString.manropeFontFamily,
                    );
                  },
                ),
                xValueMapper: (LabelDetail data, _) => data.title,
                yValueMapper: (LabelDetail data, _) => data.percentage,
                color: AppColors.primaryColor,
              )
            ],
            // series: <ChartSeries<LabelDetail, String>>[
            //   BarSeries<LabelDetail, String>(
            //     dataSource: _list,
            //     dataLabelSettings: DataLabelSettings(
            //       isVisible: true,
            //       builder: (data1, point, series, pointIndex, seriesIndex) {
            //         return CustomText(
            //           fontWeight: FontWeight.w600,
            //           fontSize: 9.sp,
            //           color: AppColors.labelColor8,
            //           text: "${_list[pointIndex].percentage.toString()}%",
            //           textAlign: TextAlign.start,
            //           fontFamily: AppString.manropeFontFamily,
            //         );
            //       },
            //     ),
            //     xValueMapper: (LabelDetail data, _) => data.title,
            //     yValueMapper: (LabelDetail data, _) => data.percentage,
            //     color: AppColors.primaryColor,
            //   )
            // ],
          ),
        ),
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 9.sp,
          color: AppColors.labelColor8,
          text: "Total Response Count =${data!.count.toString()}",
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        10.sp.sbh,
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: AppColors.labelColor8,
              text: "Question: ${widget.question}",
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.labelColor15.withOpacity(0.5)),
              child: Icon(
                Icons.close,
                weight: 3,
                size: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
