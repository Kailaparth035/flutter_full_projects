import 'dart:math';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/action_item_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/custom_gradient_text.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/action_item_shimmer_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/screens/others/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ActionItemWidget extends StatefulWidget {
  const ActionItemWidget(
      {super.key,
      required this.dashboardController,
      required this.isFromWidget});
  final DashboardController dashboardController;
  final bool isFromWidget;
  @override
  State<ActionItemWidget> createState() => _ActionItemWidgetState();
}

class _ActionItemWidgetState extends State<ActionItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.dashboardController.isLoadingActionItemList
        ? ActionItemShimmerWidget(widget.isFromWidget)
        : widget.dashboardController.isErrorActionItemList
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.isFromWidget ? 0 : context.getHeight * 0.2),
                  child: CustomErrorWidget(
                      width: 40.w,
                      onRetry: () {
                        widget.dashboardController.getActionItems({});
                      },
                      text: widget.dashboardController.errorMsgActionItemList),
                ),
              )
            : widget.dashboardController.actionItemList.isEmpty
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
                            widget.dashboardController.getActionItems({});
                          },
                          text: widget
                              .dashboardController.errorMsgActionItemList),
                    ),
                  )
                : _buildList();
  }

  ListView _buildList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: widget.isFromWidget
          ? min(widget.dashboardController.actionItemList.length, 4)
          : widget.dashboardController.actionItemList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildListTile(index);
      },
    );
  }

  Padding _buildListTile(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.sp),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.labelColor90,
            width: 1.0,
          ),
          color: Colors.transparent,
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
        ),
        child: Column(
          children: [
            _buildFirstRow(index),
            _buildSecondRow(index),
          ],
        ),
      ),
    );
  }

  Container _buildSecondRow(int index) {
    return Container(
      color: AppColors.grayColor,
      child: Padding(
        padding:
            EdgeInsets.only(left: 1.5.h, top: 1.h, right: 1.5.h, bottom: 1.5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                    color: AppColors.labelColor2,
                    text: AppString.date.toUpperCase(),
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 9.sp,
                          color: AppColors.labelColor10,
                          text: widget.dashboardController.actionItemList[index]
                              .startDate
                              .toString(),
                          textAlign: TextAlign.start,
                          maxLine: 3,
                          fontFamily: AppString.manropeFontFamily,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 9.sp,
                          maxLine: 3,
                          color: AppColors.hintColor,
                          text: '',
                          textAlign: TextAlign.start,
                          fontFamily: AppString.manropeFontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                    color: AppColors.labelColor2,
                    text: AppString.dueDate.toUpperCase(),
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 9.sp,
                          color: AppColors.labelColor10,
                          text: widget
                              .dashboardController.actionItemList[index].endDate
                              .toString(),
                          textAlign: TextAlign.start,
                          maxLine: 3,
                          fontFamily: AppString.manropeFontFamily,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 9.sp,
                          maxLine: 3,
                          color: AppColors.hintColor,
                          text: '',
                          textAlign: TextAlign.start,
                          fontFamily: AppString.manropeFontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildFirstRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(
        children: [
          CustomImageForProfile(
            image: widget.dashboardController.actionItemList[index].photo
                .toString(),
            radius: 18.sp,
            nameInitials: '',
            borderColor: AppColors.labelColor,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: AppColors.labelColor10,
                  text: widget
                      .dashboardController.actionItemList[index].fullName
                      .toString(),
                  textAlign: TextAlign.start,
                  maxLine: 3,
                  fontFamily: AppString.manropeFontFamily,
                ),
                InkWell(
                  onTap: () async {
                    // CommonController.urlLaunchInApp(widget
                    //     .dashboardController.actionItemList[index].linkUrl
                    //     .toString());

                    if (widget.dashboardController.actionItemList[index]
                            .openType ==
                        OpenType.internal) {
                      // manage internal navigation

                      DevelopmentType? developmentType =
                          getStyleNameFromStyleId(widget
                              .dashboardController.actionItemList[index].styleId
                              .toString());

                      String? tabName = getTabName(widget
                          .dashboardController.actionItemList[index].tabName
                          .toString());

                      bool isSuperVisor = widget.dashboardController
                              .actionItemList[index].userType ==
                          AppConstants.userRoleSupervisor;

                      if (developmentType != null && tabName != "") {
                        // open development
                        navigateTODevelopmentScreen(
                            developmentType: developmentType,
                            userRole: isSuperVisor == true
                                ? UserRole.supervisor
                                : UserRole.self,
                            userId: widget.dashboardController
                                .actionItemList[index].userId
                                .toString(),
                            tabTypeRow: tabName,
                            isShowElarning: widget.dashboardController
                                    .actionItemList[index].isShowElarning ==
                                1);
                      }
                    } else if (widget.dashboardController.actionItemList[index]
                            .openType ==
                        OpenType.external) {
                      // open web view url screen

                      Get.to(WebViewScreen(
                        url: widget
                            .dashboardController.actionItemList[index].linkUrl
                            .toString(),
                      ));
                    } else {
                      // noting to do just show alert box
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmAlertDialLog(
                            isShowOkButton: true,
                            title: widget.dashboardController
                                .actionItemList[index].openTypeMsg
                                .toString(),
                          );
                        },
                      );
                    }
                  },
                  child: CustomGradientText(
                    fontWeight: FontWeight.w600,
                    text: widget
                        .dashboardController.actionItemList[index].linkText
                        .toString(),
                    decoration: TextDecoration.underline,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
