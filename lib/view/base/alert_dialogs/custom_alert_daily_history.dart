import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/dailyq_habit_journal_history_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_dropdown_for_message.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DailyQHistoryAlertDialog extends StatefulWidget {
  const DailyQHistoryAlertDialog({
    super.key,
    required this.isBullets,
  });

  final bool isBullets;

  @override
  State<DailyQHistoryAlertDialog> createState() =>
      _DailyQHistoryAlertDialogState();
}

class _DailyQHistoryAlertDialogState extends State<DailyQHistoryAlertDialog> {
  final _dashboardController = Get.find<DashboardController>();

  DropListModel mainMenuList2 = DropListModel([
    DropDownOptionItemMenu(id: "1", title: AppString.lastWeek),
    DropDownOptionItemMenu(id: "2", title: AppString.lastMonth),
    DropDownOptionItemMenu(id: "3", title: AppString.lastYear),
  ]);
  DropDownOptionItemMenu optionMenuItem2 =
      DropDownOptionItemMenu(id: "", title: "Select Range");
  bool _isLoading = false;

  List<DailyqHabitJournalHistoryData> list = [];
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
      "type": widget.isBullets ? "1" : "2",
      "search": optionMenuItem2.id
    };

    try {
      List<DailyqHabitJournalHistoryData> list1 =
          await _dashboardController.getDailyqHabitJournalHistory(map);
      setState(() {
        list = list1;
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
        width: 100.w,
        // constraints: BoxConstraints(maxHeight: 50.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildDivider(),
            _buildDropDown(),
            _isLoading
                ? const Center(
                    child: CustomLoadingWidget(),
                  )
                : list.isEmpty
                    ? Center(
                        child: CustomErrorWidget(
                            width: 20.h,
                            isShowCustomMessage: true,
                            isShowRetriyButton: false,
                            isNoData: true,
                            onRetry: () {},
                            text: "Create a habit"),
                      )
                    : _buildTableRow(widget.isBullets),
            10.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(bool isHabbit) {
    return Flexible(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(8),
                  1: FlexColumnWidth(4),
                },
                border: TableBorder.all(
                  color: AppColors.labelColor8,
                ),
                children: [
                  _buildHeaderOfTable(widget.isBullets, AppString.habitBullets,
                      AppString.frequency),
                  ...list.map(
                    (e) => _buildRowOfTable(isHabbit, e.name.toString(),
                        e.reminderCount.toString()),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildHeaderOfTable(
      bool isHabbit, String firstTitle, String secondTitle) {
    if (isHabbit) {
      return TableRow(children: [
        Container(
          color: AppColors.labelColor45,
          child: Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: AppColors.white,
              text: firstTitle,
              textAlign: TextAlign.left,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ),
        Container(
          color: AppColors.labelColor45,
          child: Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: AppColors.white,
              text: secondTitle,
              textAlign: TextAlign.left,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        )
      ]);
    } else {}
    return TableRow(children: [
      Container(
        color: AppColors.labelColor45,
        child: Padding(
          padding: EdgeInsets.all(5.0.sp),
          child: CustomText(
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: AppColors.white,
            text: firstTitle,
            textAlign: TextAlign.left,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
      ),
    ]);
  }

  TableRow _buildRowOfTable(
      bool isHabbit, String firstTitle, String secondTitle) {
    if (isHabbit) {
      return TableRow(children: [
        Padding(
          padding: EdgeInsets.all(5.0.sp),
          child: CustomText(
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: AppColors.black,
            text: firstTitle,
            textAlign: TextAlign.left,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
        Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: AppColors.black,
              text: secondTitle,
              textAlign: TextAlign.left,
              fontFamily: AppString.manropeFontFamily,
            )),
      ]);
    } else {
      return TableRow(children: [
        Padding(
          padding: EdgeInsets.all(5.0.sp),
          child: CustomText(
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: AppColors.black,
            text: firstTitle,
            textAlign: TextAlign.left,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
      ]);
    }
  }

  Widget _buildDropDown() {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: CustomDropListForMessage(
        bgColor: AppColors.labelColor12,
        borderColor: AppColors.labelColor,
        optionMenuItem2.title,
        optionMenuItem2,
        mainMenuList2,
        (optionItem) {
          optionMenuItem2 = optionItem;
          setState(() {});
          _loadData(true);
        },
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      height: 1,
      color: AppColors.labelColor,
      thickness: 1,
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
            text: widget.isBullets
                ? AppString.dailyQHabitBulletsHistory
                : AppString.personalJournalHistory,
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
