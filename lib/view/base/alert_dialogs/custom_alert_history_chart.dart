import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/data/model/response/dailyq_history_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HistyoryChartDialog extends StatefulWidget {
  const HistyoryChartDialog({
    super.key,
    required this.userId,
    required this.type,
    required this.styleId,
    required this.goalId,
  });

  final String userId;
  final String type;
  final String styleId;
  final String goalId;

  @override
  State<HistyoryChartDialog> createState() => _HistyoryChartDialogState();
}

class _HistyoryChartDialogState extends State<HistyoryChartDialog> {
  final _myGoalController = Get.find<MyGoalController>();
  final TextEditingController _dateTextController = TextEditingController();

  bool _isLoading = false;
  bool isFirstSubmit = true;
  List<DailyQData> dailyQlist = [];
  late TrackballBehavior _trackballBehavior;
  @override
  void initState() {
    super.initState();
    _getInitialDate();
    _loadGoalMessages(true);
    _trackballBehavior = TrackballBehavior(enable: true);
  }

  _getInitialDate() {
    String formattedStartDate = DateFormat('MM/dd/yyyy').format(DateTime.now());

    setState(() {
      _dateTextController.text = "$formattedStartDate - $formattedStartDate";
    });
  }

  Future _loadGoalMessages(bool showMainLoading) async {
    if (showMainLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    Map<String, dynamic> map = {
      "id": widget.goalId.toString(),
      "Goal_type": widget.type.toString(),
      "style_id": widget.styleId.toString(),
      "user_id": widget.userId.toString(),
    };

    if (_dateTextController.text.isNotEmpty) {
      var startData = _dateTextController.text.split(" - ");
      map['start_date'] = startData.first;
      map['end_date'] = startData.last;
    } else {
      map['start_date'] = "";
      map['end_date'] = "";
    }

    try {
      List<DailyQData> list = await _myGoalController.getDailyqHistory(map);
      setState(() {
        dailyQlist = list;
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

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    var result = await CommonController().pickMulitpleDates(context);

    if (result != null) {
      String formattedStartDate = DateFormat('MM/dd/yyyy').format(result.start);
      String formattedEndDate = DateFormat('MM/dd/yyyy').format(result.end);
      setState(() {
        _dateTextController.text = "$formattedStartDate - $formattedEndDate";
      });

      _loadGoalMessages(true);
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 5.sp,
                ),
                child: SizedBox(
                  height: 35.sp,
                  child: CustomTextFormFieldForMessage(
                    onTap: () {
                      _selectDate(context);
                    },
                    borderColor: AppColors.labelColor,
                    isReadOnly: true,
                    inputAction: TextInputAction.done,
                    labelText: AppString.selectDate,
                    inputType: TextInputType.text,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    lineCount: 1,
                    editColor: AppColors.labelColor12,
                    textEditingController: _dateTextController,
                  ),
                ),
              ),
              _isLoading
                  ? const Center(
                      child: CustomLoadingWidget(),
                    )
                  : _buildChart(context),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _buildChart(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: context.width,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        legend: const Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        trackballBehavior: _trackballBehavior,
        series: [
          LineSeries<DailyQData, String>(
            dataSource: dailyQlist,
            name: AppString.dailyQ,
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (DailyQData sales, _) => sales.finalDate,
            yValueMapper: (DailyQData sales, _) => sales.finalScore,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
        // series: <ChartSeries<DailyQData, String>>[
        //   LineSeries<DailyQData, String>(
        //     dataSource: dailyQlist,
        //     name: AppString.dailyQ,
        //     markerSettings: const MarkerSettings(isVisible: true),
        //     xValueMapper: (DailyQData sales, _) => sales.finalDate,
        //     yValueMapper: (DailyQData sales, _) => sales.finalScore,
        //     dataLabelSettings: const DataLabelSettings(isVisible: true),
        //   )
        // ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: AppString.dailyQHistoryChart,
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
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
