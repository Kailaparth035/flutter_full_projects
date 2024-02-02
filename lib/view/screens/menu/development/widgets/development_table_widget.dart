import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DevelopmentTableWidget extends StatelessWidget {
  const DevelopmentTableWidget({
    super.key,
    required this.title1,
    required this.title2,
    required this.title3,
    this.flax1,
    this.flax2,
    this.flax3,
    required this.list,
  });
  final String title1;
  final String title2;
  final String title3;

  final double? flax1;
  final double? flax2;
  final double? flax3;

  final List list;

  @override
  Widget build(BuildContext context) {
    return _buildTableView();
  }

  _buildTableView() {
    return Table(
      columnWidths: {
        0: FlexColumnWidth(flax1 ?? 2),
        1: FlexColumnWidth(flax2 ?? 2),
        2: FlexColumnWidth(flax3 ?? 3),
      },
      border: TableBorder.all(
        color: AppColors.labelColor8,
      ),
      children: [
        _buildHeaderOfTable(title1, title2, title3),
        ...list.map(
          (e) => _buildRowOfTable(
              e['title1'], e['title2'], e['title3'], e['donwload_url']),
        )
      ],
    );
  }

  TableRow _buildRowOfTable(String firstTitle, String secondTitle,
      String thirdTitle, String? donwloadDrl) {
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
          child: CustomText(
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            color: AppColors.black,
            text: secondTitle,
            maxLine: 10,
            textAlign: TextAlign.left,
            fontFamily: AppString.manropeFontFamily,
          )),
      GestureDetector(
        onTap: () {
          if (donwloadDrl != null && donwloadDrl != "") {
            CommonController.downloadFile(donwloadDrl, Get.context!);
          }
        },
        child: Padding(
            padding: EdgeInsets.all(5.0.sp),
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: AppColors.black,
              text: thirdTitle,
              maxLine: 10,
              textAlign: TextAlign.left,
              fontFamily: AppString.manropeFontFamily,
            )),
      ),
    ]);
  }

  TableRow _buildHeaderOfTable(
      String firstTitle, String secondTitle, String thirdTitle) {
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
          Padding(
            padding: EdgeInsets.all(3.0.sp),
            child: CustomText(
              maxLine: 10,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              color: AppColors.white,
              text: thirdTitle,
              textAlign: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
            ),
          )
        ]);
  }
}
