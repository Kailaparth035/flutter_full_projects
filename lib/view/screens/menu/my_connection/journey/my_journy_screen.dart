import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/development/my_journey_graph_model.dart';
import 'package:aspirevue/data/model/response/development/my_journey_model.dart';
import 'package:aspirevue/data/model/response/development/progress_tracking_chart_model.dart';
import 'package:aspirevue/util/animation.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/badge_list_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/widgets/my_jouney_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

class MyJournyScreen extends StatefulWidget {
  const MyJournyScreen(
      {super.key, required this.userId, required this.userRole});
  final String userId;
  final UserRole userRole;

  @override
  State<MyJournyScreen> createState() => _MyJournyScreenState();
}

class _MyJournyScreenState extends State<MyJournyScreen> {
  // final ScrollController _controller = ScrollController();
  final PageController _pageController = PageController();

  DropListModel mainMenuList2 = DropListModel([
    DropDownOptionItemMenu(id: "1", title: "Everyone"),
    DropDownOptionItemMenu(id: "2", title: "My Growth Community"),
    DropDownOptionItemMenu(id: "3", title: "My Circle of Influence"),
    DropDownOptionItemMenu(id: "3", title: "My Colleagues"),
    DropDownOptionItemMenu(id: "3", title: "My Workplace"),
  ]);
  DropDownOptionItemMenu optionMenuItem2 =
      DropDownOptionItemMenu(id: null, title: "Everyone");

  DropDownOptionItemMenu _ddValue =
      DropDownOptionItemMenu(id: "1", title: "Daily");

  final List<DropDownOptionItemMenu> _ddList = [
    DropDownOptionItemMenu(id: "1", title: "Daily"),
    DropDownOptionItemMenu(id: "2", title: "Weekly"),
    DropDownOptionItemMenu(id: "3", title: "Monthly"),
    DropDownOptionItemMenu(id: "4", title: "Yearly"),
  ];

  DropDownOptionItemMenu? _prograssTrackingDDValue;
  final List<DropDownOptionItemMenu> _prograssTrackingDDList = [];

  DropDownOptionItemMenu _ddValue2 =
      DropDownOptionItemMenu(id: "2", title: "Weekly (Recent 6 Weeks)");

  final List<DropDownOptionItemMenu> _ddList2 = [
    DropDownOptionItemMenu(id: "2", title: "Weekly (Recent 6 Weeks)"),
    DropDownOptionItemMenu(id: "3", title: "Monthly"),
  ];

  final List<DropDownOptionItemMenu> _ddList3 = [
    DropDownOptionItemMenu(id: "2", title: "Weekly (Recent 6 Weeks)"),
    DropDownOptionItemMenu(id: "3", title: "Monthly"),
    DropDownOptionItemMenu(id: "4", title: "Yearly"),
  ];

  bool _isShowBadgeAnimation = false;
  bool _isShowBadgeImage = false;

  late Future<MyJourneyData?> _futureCall;
  final _developmentController = Get.find<DevelopmentController>();

  @override
  void initState() {
    _getBadgeLegendPopup();
    _loadData(true);
    _reFreshData();
    super.initState();
  }

  _getBadgeLegendPopup() {
    var map = <String, dynamic>{"user_id": widget.userId, "assignUser": "0"};
    Get.find<DevelopmentController>().getBadgeLegendPopup(map);
  }

  _reFreshData() async {
    _futureCall = _developmentController
        .getmyJourney({"user_id": widget.userId, "assignUser": "0"});
  }

  bool _isFistCall = true;

  _initDropDownData(MyJourneyData? data) {
    if (_prograssTrackingDDList.isEmpty) {
      for (var element in data!.reviewType!) {
        _prograssTrackingDDList.add(DropDownOptionItemMenu(
            id: element.value.toString(), title: element.title.toString()));
      }

      _prograssTrackingDDValue = _prograssTrackingDDList.isNotEmpty
          ? _prograssTrackingDDList.first
          : null;

      Future.delayed(const Duration(milliseconds: 100), () {
        _getProgressTrackingChart(true);
      });
    }
  }

  _showAnimation(MyJourneyData? data) {
    _initDropDownData(data);

    _isFistCall = false;

    if (data!.showAnimation == "1" && widget.userRole == UserRole.self) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isShowBadgeAnimation = true;
        });
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _isShowBadgeImage = true;
        });
      });
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          _isShowBadgeAnimation = false;
        });
      });
    } else {
      _isShowBadgeImage = true;
    }
  }

  bool _isLoading = false;
  bool _isError = false;
  String _errorMessage = "";
  MyJourneyGrowthChartData? grapgData;

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
      var res = await _developmentController.myJourneyGrowthChart(map);
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

  bool _isLoadingProgressTraking = false;
  bool _isErrorProgressTraking = false;
  String _errorMessageProgressTraking = "";
  ProgressTrakingChartData? grapgDataProgressTraking;

  Future _getProgressTrackingChart(bool showMainLoading) async {
    if (showMainLoading) {
      setState(() {
        _isLoadingProgressTraking = true;
      });
    }

    Map<String, dynamic> map = {
      "user_id": widget.userId.toString(),
      "chart_type": _ddValue2.id,
      "review_type": _prograssTrackingDDValue != null
          ? _prograssTrackingDDValue!.id.toString()
          : "",
    };

    try {
      var res = await _developmentController.getProgressTrackingChart(map);
      if (res != null) {
        if (mounted) {
          setState(() {
            _isErrorProgressTraking = false;
            _errorMessageProgressTraking = "";
            grapgDataProgressTraking = res;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isErrorProgressTraking = true;
            _errorMessageProgressTraking = AppString.somethingWentWrong;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isErrorProgressTraking = true;
          String error = CommonController().getValidErrorMessage(e.toString());
          _errorMessageProgressTraking = error.toString();
        });
      }
    } finally {
      if (showMainLoading) {
        if (mounted) {
          setState(() {
            _isLoadingProgressTraking = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: widget.userRole == UserRole.self
                ? AppString.myJourneySummary
                : "Their Journey Summary",
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        body: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Stack(
            children: [
              _buildBuilder(),
              Positioned(
                bottom: 0,
                child: _isShowBadgeAnimation
                    ? Container(
                        child: Lottie.asset(
                          AppAnimation.celebrationAnimation,
                          height: 90.h,
                          width: 100.w,
                          fit: BoxFit.fill,
                          repeat: true,
                          reverse: false,
                          animate: true,
                        ),
                      )
                    : 0.sbh,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildBuilder() {
    return FutureBuildWidget(
      onRetry: () {
        _reFreshData();
      },
      future: _futureCall,
      child: (MyJourneyData? data) {
        return _buildMainView(data);
      },
    );
  }

  SafeArea _buildMainView(MyJourneyData? data) {
    if (_isFistCall == true) {
      _showAnimation(data);
    }
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(data),
              10.sp.sbh,
              _buildSecondCard(data),
              10.sp.sbh,
              widget.userRole == UserRole.self
                  ? Column(
                      children: [
                        _buildChartBox(),
                        10.sp.sbh,
                        _buildProgressTrackingChartBox(),
                        10.sp.sbh,
                      ],
                    )
                  : 0.sbh,
              widget.userRole == UserRole.self
                  ? _buildJournyTimeLine(data)
                  : 0.sbh,
            ],
          ),
        ),
      ),
    );
  }

  _buildGrowthChart() {
    return SizedBox(
      width: context.width,
      height: context.width,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          labelAlignment: LabelAlignment.center,
          minimum: grapgData == null && grapgData!.chartData!.isEmpty
              ? 0
              : _getMinValue(grapgData!.chartData!),
          interval: _getXData(false)!.abs() > 0 ? _getXData(false)!.abs() : 1,
        ),
        legend: const Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          SplineSeries<ChartData, String>(
              dataSource: grapgData!.chartData!,
              name: "Growth Over Time",
              markerSettings: const MarkerSettings(isVisible: true),
              xValueMapper: (ChartData sales, _) => sales.label,
              yValueMapper: (ChartData sales, _) => sales.journeyCount,
              color: AppColors.secondaryColor,
              width: 1),
        ],
      ),
    );
  }

  double? _getMinValue(List<ChartData> chartData) {
    var list =
        chartData.map((e) => double.parse(e.journeyCount.toString())).toList();

    if (list.where((element) => element >= 0).isEmpty) {
      return 0;
    } else {
      bool allSame = chartData.every(
          (element) => element.journeyCount == chartData[0].journeyCount);
      if (allSame) {
        var value = CommonController.getDoubleValue(
            chartData[0].journeyCount!.toString());
        return value - value;
      } else {
        var maxTtem = list.reduce(max);
        var minTtem = list.reduce(min);

        var avrage =
            (maxTtem) / ((list.length > 10) ? (list.length / 2) : list.length);
        var cal = (calculateNumber(avrage.round().toDouble()) * -1) + minTtem;

        return cal + ((cal / 4).round());
      }
    }
  }

  _buildProgressTrakingChart() {
    return SizedBox(
      width: context.width,
      height: context.width,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        primaryYAxis: NumericAxis(
          labelAlignment: LabelAlignment.center,
          // visibleMinimum: _getXDataForTracking() - _getXDataForTracking(),
          minimum: _getMinValueDataForTracking(),
          interval: _getXDataForTracking().abs() > 0
              ? _getXDataForTracking().abs()
              : 1,
        ),
        legend: const Legend(isVisible: false),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          SplineSeries<ProgressChartData, String>(
              dataSource: grapgDataProgressTraking!.chartData!,
              name: "Progress Tracking",
              markerSettings: const MarkerSettings(isVisible: true),
              xValueMapper: (ProgressChartData sales, _) => sales.label,
              yValueMapper: (ProgressChartData sales, _) =>
                  CommonController.getDoubleValue(sales.journeyCount!),
              color: AppColors.secondaryColor,
              width: 1),
        ],
      ),
    );
  }

  double? _getXData(bool isMax) {
    var list = grapgData!.chartData!.map((e) => e.journeyCount!).toList();
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
        var cal = (calculateNumber(avrage.round().toDouble()) * -1) + minTtem;

        return cal + ((cal / 3).round());
      }
    }
  }

  double _getMinValueDataForTracking() {
    if (grapgDataProgressTraking == null ||
        grapgDataProgressTraking!.chartData!.isEmpty) {
      return 0;
    } else {
      var list = grapgDataProgressTraking!.chartData!
          .map((e) => CommonController.getDoubleValue(e.journeyCount!))
          .toList();
      if (list.where((element) => element >= 0).isEmpty) {
        return 0;
      } else {
        bool allSame = grapgDataProgressTraking!.chartData!.every((element) =>
            element.journeyCount ==
            grapgDataProgressTraking!.chartData![0].journeyCount);

        if (allSame) {
          var value = CommonController.getDoubleValue(
              grapgDataProgressTraking!.chartData![0].journeyCount!);
          return value - value;
        } else {
          var maxTtem = list.reduce(max);
          var minTtem = list.reduce(min);

          var avrage = (maxTtem) /
              ((list.length > 10) ? (list.length / 2) : list.length);

          var cal = (calculateNumber(avrage.round().toDouble()) * -1) + minTtem;

          return cal.round().toDouble();
        }
      }
    }
  }

  double _getXDataForTracking() {
    if (grapgDataProgressTraking == null) {
      return 0;
    } else {
      var list = grapgDataProgressTraking!.chartData!
          .map((e) => CommonController.getDoubleValue(e.journeyCount!))
          .toList();
      if (list.where((element) => element >= 0).isEmpty) {
        return 0;
      } else {
        var maxTtem = list.reduce(max);
        var minTtem = list.reduce(min);

        var avrage =
            (maxTtem) / ((list.length > 10) ? (list.length / 2) : list.length);

        var cal = (calculateNumber(avrage.round().toDouble()) * -1) + minTtem;

        return cal.round().toDouble();
      }
    }
  }

  double calculateNumber(double number) {
    int valueToDivide = 0;

    if (number >= 0 && number <= 5) {
      valueToDivide = 5;
    } else if (number >= 6 && number <= 15) {
      valueToDivide = 15;
    } else if (number >= 16 && number <= 30) {
      valueToDivide = 30;
    } else if (number >= 31 && number <= 50) {
      valueToDivide = 50;
    } else if (number >= 51 && number <= 1000) {
      valueToDivide = 100;
    } else if (number >= 1001 && number <= 10000) {
      valueToDivide = 200;
    } else if (number >= 10001 && number <= 100000) {
      valueToDivide = 1000;
    } else {
      valueToDivide = 10000;
    }

    double a = number % valueToDivide;

    if (a > 0) {
      return (number ~/ valueToDivide) * valueToDivide +
          valueToDivide.toDouble();
    }

    return number;
  }

  Container _buildChartBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor9.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        children: [
          _buildJournyTimeListChild1("Growth Over Time",
              "Track your overall Development Journeys progress and celebrate your success!"),
          Divider(
            height: 1.sp,
            color: AppColors.labelColor,
            thickness: 1,
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: CustomDropListForMessageTwo(
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
          ),
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
                  : _buildGrowthChart()
        ],
      ),
    );
  }

  Container _buildProgressTrackingChartBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor9.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        children: [
          _buildJournyTimeListChild1("Progress Tracking", ""),
          Divider(
            height: 1.sp,
            color: AppColors.labelColor,
            thickness: 1,
          ),
          10.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: CustomDropListForMessageTwo(
              _prograssTrackingDDValue != null
                  ? _prograssTrackingDDValue!.title
                  : "",
              _prograssTrackingDDValue != null
                  ? _prograssTrackingDDValue!
                  : DropDownOptionItemMenu(id: "", title: ""),
              _prograssTrackingDDList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (selectedValue) {
                setState(() {
                  _prograssTrackingDDValue = selectedValue;
                });

                if ((_prograssTrackingDDValue != null &&
                        _prograssTrackingDDValue!.title.toLowerCase() ==
                            "performance reviews") ||
                    (_prograssTrackingDDValue != null &&
                        _prograssTrackingDDValue!.title.toLowerCase() ==
                            "workplace performance")) {
                } else {
                  if (_ddValue2.title == "Yearly") {
                    setState(() {
                      _ddValue2 = _ddList2.first;
                    });
                  }
                }

                _getProgressTrackingChart(true);
              },
            ),
          ),
          10.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: CustomDropListForMessageTwo(
              _ddValue2.title,
              _ddValue2,
              (_prograssTrackingDDValue != null &&
                          _prograssTrackingDDValue!.title.toLowerCase() ==
                              "performance reviews") ||
                      (_prograssTrackingDDValue != null &&
                          _prograssTrackingDDValue!.title.toLowerCase() ==
                              "workplace performance")
                  ? _ddList3
                  : _ddList2,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (selectedValue) {
                setState(() {
                  _ddValue2 = selectedValue;
                });

                _getProgressTrackingChart(true);
              },
            ),
          ),
          10.sp.sbh,
          _isLoadingProgressTraking == true
              ? const Center(child: CustomLoadingWidget())
              : _isErrorProgressTraking == false &&
                      grapgDataProgressTraking == null
                  ? 0.sbh
                  : _isErrorProgressTraking == true
                      ? Center(
                          child: CustomErrorWidget(
                            isNoData: true,
                            isShowCustomMessage: true,
                            onRetry: () {
                              _getProgressTrackingChart(true);
                            },
                            text: _errorMessageProgressTraking,
                          ),
                        )
                      : _buildProgressTrakingChart()
        ],
      ),
    );
  }

  Container _buildJournyTimeLine(MyJourneyData? data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor9.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        children: [
          _buildJournyTimeListChild1(
              AppString.journeyTimeline, AppString.foreachScale),
          Divider(
            height: 1.sp,
            color: AppColors.labelColor,
            thickness: 1,
          ),
          _buildJournyListTile2(data),
          Divider(
            height: 1.sp,
            color: AppColors.labelColor,
            thickness: 1,
          ),
          // 10.sp.sbh,
          MyJournyTimeLineChart(
            timelinedetails: data!.timelinedetails!,
          )
        ],
      ),
    );
  }

  Column _buildJournyListTile2(MyJourneyData? data) {
    return Column(
      children: [
        _buildUserListTile(data!.photo.toString(),
            "${data.firstName.toString()} ${data.lastName.toString()}", ""),
        5.sp.sbh,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.sp.sbw,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.sp),
                  color: AppColors.labelColor25,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icStar,
                      height: 16.sp,
                    ),
                    10.sp.sbw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CustomText(
                              text: AppString.totalJourneyPoints,
                              textAlign: TextAlign.start,
                              color: AppColors.primaryColor,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          3.sp.sbh,
                          CustomText(
                            text: data.totalJourneyPoints.toString(),
                            textAlign: TextAlign.start,
                            color: AppColors.white,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            10.sp.sbw,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.sp),
                  color: AppColors.labelColor25,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icTime,
                      height: 16.sp,
                    ),
                    10.sp.sbw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CustomText(
                              text: AppString.journeyStarted,
                              textAlign: TextAlign.start,
                              color: AppColors.primaryColor,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          3.sp.sbh,
                          CustomText(
                            text: data.totalJourneyTime.toString(),
                            textAlign: TextAlign.start,
                            color: AppColors.white,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            10.sp.sbw,
          ],
        ),
        10.sp.sbh,
      ],
    );
  }

  Padding _buildUserListTile(String image, String name, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        children: [
          10.sp.sbw,
          CircleAvatar(
            backgroundColor: AppColors.labelColor27,
            radius: 20.sp,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              padding: EdgeInsets.all(1.sp),
              child: CircleAvatar(
                backgroundColor: AppColors.white,
                radius: 18.sp,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: CustomImage(
                    height: 60.sp,
                    width: 60.sp,
                    image: image,
                    // fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "$name’s ${AppString.journeySummary}",
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildJournyTimeListChild1(String title, String subTitle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: title,
                textAlign: TextAlign.start,
                color: AppColors.labelColor25,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          // 5.sp.sbh,
          subTitle == "" ? 0.sbh : 5.sp.sbh,
          subTitle == ""
              ? 0.sbh
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset(
                    //   AppImages.icExlamation,
                    //   width: 13.sp,
                    // ),
                    // 3.sp.sbw,
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                          children: [
                            TextSpan(
                              text: subTitle,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontFamily: AppString.manropeFontFamily,
                                fontWeight: FontWeight.w500,
                                color: AppColors.hintColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  Container _buildSecondCard(MyJourneyData? data) {
    return Container(
      width: context.getWidth,
      decoration: BoxDecoration(
        color: AppColors.labelColor24,
        border: Border.all(
          color: AppColors.labelColor24,
        ),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  text: "Overall Growth Level",
                  textAlign: TextAlign.center,
                  color: AppColors.secondaryColor,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
                10.sp.sbh,
                !_isShowBadgeImage ? 0.sbh : _buildBadgeImageAndTitle(data),
              ],
            ),
          ),
          data!.badgeDetails!.isNotEmpty
              ? Column(
                  children: [
                    10.sp.sbh,
                    Divider(
                      height: 1.sp,
                      color: AppColors.labelColor,
                      thickness: 1,
                    ),
                    10.sp.sbh,
                    _buildSliderBadges(data.badgeDetails!)
                  ],
                )
              : 0.sbh,

          10.sp.sbh,
          // _buildPreviousBadgeText(),
          // 10.sp.sbh,
        ],
      ),
    );
  }

  Widget _buildBadgeImageAndTitle(MyJourneyData? data) {
    return CustomSlideUpAndFadeWidget(
      duration: Duration(seconds: widget.userRole == UserRole.self ? 5 : 0),
      point: 0.2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImage(
              height: 50.sp,
              image: data!.badgImage.toString(),
              fit: BoxFit.fitHeight,
            ),
            10.sp.sbh,
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 20.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.greenColor,
                    AppColors.greenColor.withOpacity(0.5)
                  ],
                ),
              ),
              child: CustomText(
                text: "+ ${data.overallLifeTotal.toString()}",
                textAlign: TextAlign.start,
                color: AppColors.white,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            5.sp.sbh,
            InkWell(
              onTap: () {
                Get.to(() => BadgeListScreen(
                      userId: widget.userId,
                      title: widget.userRole == UserRole.self
                          ? AppString.myJourneySummary
                          : "Their Journey Summary",
                    ));
              },
              child: CustomText(
                text: data.badgeName.toString(),
                textAlign: TextAlign.start,
                color: AppColors.black,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            5.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget buildList(List<BadgeDetail> badgeDetails) {
    return SizedBox(
      width: double.infinity,
      height: 100.sp,
      child: PageView.builder(
        controller: _pageController,
        itemCount: (badgeDetails.length / 3).ceil(), // Number of pages
        itemBuilder: (context, pageIndex) {
          int startIndex = pageIndex * 3;
          int endIndex = (startIndex + 3 < badgeDetails.length)
              ? startIndex + 3
              : badgeDetails.length;

          List<BadgeDetail> pageItems =
              badgeDetails.sublist(startIndex, endIndex);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: pageItems.map((item) => _buildBadgeItem(item)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildBadgeItem(BadgeDetail badgeDetail) {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: CustomImage(
              image: badgeDetail.image.toString(),
              fit: BoxFit.fitHeight,
            ),
          ),
          3.sp.sbh,
          Expanded(
            flex: 2,
            child: CustomText(
              text: badgeDetail.title.toString(),
              textAlign: TextAlign.center,
              color: AppColors.black,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 8.sp,
              maxLine: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildSliderBadges(List<BadgeDetail> badgeDetails) {
    return Row(
      children: [
        IconButton(
          constraints: const BoxConstraints(),
          splashRadius: 0.1,
          padding: EdgeInsets.all(3.sp),
          onPressed: () {
            _pageController.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            size: 15.sp,
          ),
        ),
        Expanded(child: buildList(badgeDetails)),
        IconButton(
          constraints: const BoxConstraints(),
          splashRadius: 0.1,
          padding: EdgeInsets.all(3.sp),
          onPressed: () {
            _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          icon: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15.sp,
          ),
        ),
      ],
    );
  }

  // Row _buildSliderBadges(List<BadgeDetail> badgeDetails) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       IconButton(
  //         constraints: const BoxConstraints(),
  //         padding: EdgeInsets.all(3.sp),
  //         onPressed: () {
  //           _controller.animateTo(
  //             _controller.position.pixels -
  //                 MediaQuery.of(context).size.width -
  //                 70.sp,
  //             duration: const Duration(milliseconds: 500),
  //             curve: Curves.ease,
  //           );
  //         },
  //         icon: Icon(
  //           Icons.arrow_back_ios_rounded,
  //           size: 15.sp,
  //         ),
  //       ),
  //       Expanded(
  //         child: Center(
  //           child: SizedBox(
  //             height: 70.sp,
  //             child: AlignedGridView.count(
  //               controller: _controller,
  //               scrollDirection: Axis.horizontal,
  //               crossAxisCount: 1,
  //               shrinkWrap: true,
  //               mainAxisSpacing: 5.sp,
  //               crossAxisSpacing: 5.sp,
  //               primary: false,
  //               itemCount: badgeDetails.length,
  //               itemBuilder: (context, index) => SizedBox(
  //                 width: context.isTablet
  //                     ? (MediaQuery.of(context).size.width / 3) - 18.sp
  //                     : (MediaQuery.of(context).size.width / 3) - 30.sp,
  //                 child: Center(
  //                   child: Column(
  //                     children: [
  //                       Expanded(
  //                         flex: 5,
  //                         child: CustomImage(
  //                           image: badgeDetails[index].image.toString(),
  //                           fit: BoxFit.fitHeight,
  //                         ),
  //                       ),
  //                       3.sp.sbh,
  //                       Expanded(
  //                         flex: 2,
  //                         child: CustomText(
  //                           text: badgeDetails[index].title.toString(),
  //                           textAlign: TextAlign.center,
  //                           color: AppColors.black,
  //                           fontFamily: AppString.manropeFontFamily,
  //                           fontSize: 8.sp,
  //                           maxLine: 2,
  //                           fontWeight: FontWeight.w700,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //       IconButton(
  //         constraints: const BoxConstraints(),
  //         padding: EdgeInsets.all(3.sp),
  //         onPressed: () {
  //           _controller.animateTo(
  //             _controller.position.pixels +
  //                 MediaQuery.of(context).size.width -
  //                 70.sp,
  //             duration: const Duration(milliseconds: 500),
  //             curve: Curves.ease,
  //           );
  //         },
  //         icon: Icon(
  //           Icons.arrow_forward_ios_rounded,
  //           size: 15.sp,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Container _buildProfileCard(MyJourneyData? data) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.labelColor9.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 40.sp,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.labelColor19,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.sp),
                      topRight: Radius.circular(9.sp),
                    ),
                  ),
                ),
                Center(
                  child: Transform.translate(
                    offset: Offset(0, 10.sp),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.labelColor9.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(2000),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2000),
                        child: CustomImage(
                          height: 60.sp,
                          width: 60.sp,
                          image: data!.photo.toString(),
                          // fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            20.sbh,
            CustomText(
              text: "${data.firstName.toString()} ${data.lastName.toString()}",
              textAlign: TextAlign.start,
              color: AppColors.black,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            CustomText(
              text: data.roleName.toString(),
              textAlign: TextAlign.start,
              color: AppColors.hintColor,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            20.sp.sbh,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              height: 70.sp,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.labelColor19,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9.sp),
                  bottomRight: Radius.circular(9.sp),
                ),
              ),
              child: Row(
                children: [
                  _buildFirstCartBottomListTile(
                    AppImages.icRoundedTime,
                    AppString.journeyTime,
                    data.totalJourneyTime.toString(),
                  ),
                  _buildFirstCartBottomListTile(
                    AppImages.icRoundedStar,
                    AppString.growthPoints,
                    data.totalJourneyPoints.toString(),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Expanded _buildFirstCartBottomListTile(
      String icon, String topTitle, String bottomTitle) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              icon,
            ),
          ),
          10.sbw,
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: topTitle,
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor23,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                2.sp.sbh,
                CustomText(
                  text: bottomTitle,
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
