import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DevelopmentCommentTableWidget extends StatelessWidget {
  const DevelopmentCommentTableWidget({
    super.key,
    required this.title,
    required this.list,
  });

  final String title;
  final List list;
  @override
  Widget build(BuildContext context) {
    return _buildTableView();
  }

  _buildTableView() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(),
      },
      border: TableBorder.all(
        color: AppColors.labelColor8,
      ),
      children: [
        _buildHeaderOfTable(
          title,
        ),
        ...list.map(
          (e) => _buildRowOfTable(e),
        )
      ],
    );
  }

  TableRow _buildRowOfTable(
    String firstTitle,
  ) {
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
    ]);
  }

  TableRow _buildHeaderOfTable(String firstTitle) {
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
        ]);
  }
}
