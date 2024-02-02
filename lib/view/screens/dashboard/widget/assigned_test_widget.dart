import 'dart:math';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/assign_test_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/assign_test_shimmer_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/screens/dashboard/assign_test_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AssignedTestWidget extends StatefulWidget {
  const AssignedTestWidget({super.key, required this.isFromWidget});
  final bool isFromWidget;
  @override
  State<AssignedTestWidget> createState() => _AssignedTestWidgetState();
}

class _AssignedTestWidgetState extends State<AssignedTestWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return (dashboardController.isLoadingAssignTestList == false) &&
              dashboardController.assignTestList.isEmpty &&
              dashboardController.isErrorAssignTestList == false &&
              widget.isFromWidget
          ? 0.sbh
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.isFromWidget
                    ? Column(
                        children: [
                          dashboardCardTitle(
                            AppString.assignedTest,
                          ),
                          SizedBox(height: 10.sp),
                        ],
                      )
                    : 0.sbh,
                dashboardController.isLoadingAssignTestList
                    ? AssignTestShimmer(widget.isFromWidget)
                    : dashboardController.isErrorAssignTestList
                        ? Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: widget.isFromWidget
                                      ? 0
                                      : context.getHeight * 0.2),
                              child: CustomErrorWidget(
                                  width: 40.w,
                                  onRetry: () {
                                    dashboardController.getAssignedTests({});
                                  },
                                  text: dashboardController
                                      .errorMsgAssignTestList),
                            ),
                          )
                        : dashboardController.assignTestList.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: widget.isFromWidget
                                          ? 0
                                          : context.getHeight * 0.2),
                                  child: CustomErrorWidget(
                                      width: widget.isFromWidget ? 40.w : 50.w,
                                      isNoData: true,
                                      onRetry: () {
                                        dashboardController
                                            .getAssignedTests({});
                                      },
                                      text: dashboardController
                                          .errorMsgAssignTestList),
                                ),
                              )
                            : _buildList(dashboardController),
                widget.isFromWidget
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.sp),
                        child: InkWell(
                          onTap: () {
                            Get.to(() => const AssignTestListScreen());
                          },
                          child: buildViewALL(),
                        ),
                      )
                    : 0.sbh,
              ],
            );
    });
  }

  Widget _buildList(DashboardController controller) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor90,
          width: 1.0,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
      ),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.isFromWidget
            ? min(controller.assignTestList.length, 2)
            : controller.assignTestList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          int index1 = controller.assignTestList
              .indexOf(controller.assignTestList[index]);
          bool isLast = controller.assignTestList.length - 1 == index1;

          int count = min(controller.assignTestList.length, 2);
          bool isLast2 = count - 1 == index1;

          return _buildListTile(controller.assignTestList[index], controller,
              widget.isFromWidget ? isLast2 : isLast);
        },
      ),
    );
  }

  Padding _buildListTile(AssignedTestsData assignData,
      DashboardController controller, bool isLast) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: Container(
        margin: EdgeInsets.only(bottom: isLast ? 0.sp : 10.sp),
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: AppColors.labelColor90,
        //     width: 1.0,
        //   ),
        //   color: Colors.transparent,
        //   borderRadius:
        //       BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.all(1.5.h),
            //   child: CustomText(
            //     fontWeight: FontWeight.w600,
            //     fontSize: 12.sp,
            //     maxLine: 2,
            //     color: AppColors.labelColor10,
            //     text: AppString.assignedTest,
            //     textAlign: TextAlign.start,
            //     fontFamily: AppString.manropeFontFamily,
            //   ),
            // ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.grayColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
              ),
              child: Padding(
                padding: EdgeInsets.all(1.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          CommonController.urlLaunch(assignData.url.toString());
                        },
                        child: CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: AppColors.labelColor10,
                          text: assignData.titleName.toString(),
                          textAlign: TextAlign.start,
                          maxLine: 2,
                          fontFamily: AppString.manropeFontFamily,
                        ),
                      ),
                    ),
                    CustomButton2(
                        buttonText: AppString.start,
                        buttonColor: AppColors.labelColor7,
                        radius: Dimensions.radiusDefault,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.sp, horizontal: 15.sp),
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        onPressed: () {
                          _saveAssesstment(
                              controller, assignData.id.toString());
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _saveAssesstment(DashboardController controller, String id) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.iConfirmcompleteTest,
        );
      },
    );

    if (res != null) {
      try {
        // ignore: use_build_context_synchronously
        buildLoading(context);
        var response = await controller.saveAssessmentLink(id);
        if (response.isSuccess == true) {
          showCustomSnackBar(response.message, isError: false);
          controller.getAssignedTests({});
        } else {
          showCustomSnackBar(response.message);
        }
      } catch (e) {
        String error = CommonController().getValidErrorMessage(e.toString());
        showCustomSnackBar(error.toString());
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }
}

class ActionItemModel {
  String name;
  String review;
  String date;
  String dueDate;
  String time;
  String dueTime;

  ActionItemModel(
      this.name, this.review, this.date, this.dueDate, this.time, this.dueTime);
}
