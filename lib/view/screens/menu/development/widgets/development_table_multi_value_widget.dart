import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentMultiValueTableWidget extends StatelessWidget {
  const DevelopmentMultiValueTableWidget({
    super.key,
    required this.title1,
    required this.title2,
    required this.list,
  });
  final String title1;
  final String title2;

  final List list;
  @override
  Widget build(BuildContext context) {
    return _buildTableView();
  }

  _buildTableView() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(3),
      },
      border: TableBorder.all(
        color: AppColors.labelColor8,
      ),
      children: [
        _buildHeaderOfTable(title1, title2),
        ...list.map(
          (e) => _buildRowOfTable(e['title1'], e['title2'] as List<String>),
        )
      ],
    );
  }

  TableRow _buildRowOfTable(String firstTitle, List<String> secondTitle) {
    return TableRow(children: [
      Padding(
        padding: EdgeInsets.all(5.0.sp),
        child: CustomText(
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
          color: AppColors.black,
          text: firstTitle,
          maxLine: 10,
          textAlign: TextAlign.left,
          fontFamily: AppString.manropeFontFamily,
        ),
      ),
      Padding(
          padding: EdgeInsets.all(5.0.sp),
          child: Column(
            children: [
              ...secondTitle.map(
                (e) => CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                  color: AppColors.black,
                  text: e,
                  maxLine: 10,
                  textAlign: TextAlign.left,
                  fontFamily: AppString.manropeFontFamily,
                ),
              )
            ],
          )),
    ]);
  }

  TableRow _buildHeaderOfTable(String firstTitle, String secondTitle) {
    return TableRow(
        decoration: const BoxDecoration(color: AppColors.labelColor45),
        children: [
          Padding(
            padding: EdgeInsets.all(3.0.sp),
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              maxLine: 10,
              color: AppColors.white,
              text: firstTitle,
              textAlign: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(3.0.sp),
            child: CustomText(
              maxLine: 10,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              color: AppColors.white,
              text: secondTitle,
              textAlign: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ]);
  }
}
