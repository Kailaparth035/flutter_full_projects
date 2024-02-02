import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:aspirevue/view/base/alert_dialogs/alert_for_completed_steps.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../base/custom_text.dart';

class OverlayPopupWidget extends StatefulWidget {
  const OverlayPopupWidget(
      {super.key,
      required this.child,
      required this.title,
      this.isShowNextButton = true,
      this.isShowPreviousButton = true,
      this.isShowFinishButtonButton = false,
      required this.tooltipController,
      required this.overlayStep});
  final Widget child;
  final String title;
  final bool? isShowNextButton;
  final bool? isShowPreviousButton;
  final bool? isShowFinishButtonButton;
  final int overlayStep;
  final AlignedTooltipController tooltipController;

  @override
  State<OverlayPopupWidget> createState() => _OverlayPopupWidgetState();
}

class _OverlayPopupWidgetState extends State<OverlayPopupWidget> {
  final _profileController = Get.find<ProfileSharedPrefService>();
  final _dashboardController = Get.find<DashboardController>();
  // final _mainController = Get.find<MainController>();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlignedTooltip(
      onShow: () {
        if (_profileController.isShowOverlayView.value == false) {
          widget.tooltipController.hideTooltip();
        }
      },
      onDismiss: () {
        // _profileController.setOverlaySetting(false);
      },
      barrierBuilder: (context, asda, asd) {
        return Container(
          color: Colors.black.withOpacity(0.5),
        );
      },
      barrierDismissible: false,
      backgroundColor: AppColors.backgroundColor1,
      controller: widget.tooltipController,
      shadow: const Shadow(color: Colors.transparent),
      isModal: true,
      content: _buildView(),
      child: widget.child,
    );
  }

  Widget _buildView() => Container(
        width: context.getWidth - 20.sp,
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor1,
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              5.sp.sbh,
              _buildCheckBox(),
              _buildButtons(),
            ],
          ),
        ),
      );

  Widget _buildCheckBox() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.sp),
            child: CustomCheckBox(
              onTap: () {
                _changeStatus();
              },
              borderColor: AppColors.labelColor8,
              fillColor: AppColors.labelColor8,
              isChecked: isChecked,
            ),
          ),
          5.sp.sbw,
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
              color: AppColors.labelColor64,
              text: "Don’t Show Me Again",
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  _changeStatus() async {
    setState(() {
      isChecked = !isChecked;
    });

    // pass 0 for hide tour overlay
    var res =
        await _dashboardController.updateTourOverlayFlag(isChecked ? "0" : "1");
    if (res != null && res == true) {
      setState(() {
        _profileController.isShowOverlayView.value = false;
        _profileController.closeOverLay(widget.overlayStep);
      });
    }

    setState(() {
      isChecked = !isChecked;
    });
  }

  _buildButtons() {
    return Row(
      children: [
        widget.isShowPreviousButton == true
            ? Padding(
                padding: EdgeInsets.only(right: 5.sp),
                child: CustomButton2(
                  buttonText: AppString.previous,
                  radius: 3.sp,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  onPressed: () {
                    _previos();
                  },
                ),
              )
            : 0.sp.sbh,
        widget.isShowNextButton == true
            ? Padding(
                padding: EdgeInsets.only(right: 5.sp),
                child: CustomButton2(
                  buttonText: AppString.next,
                  radius: 3.sp,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  onPressed: () {
                    _navigate();
                  },
                ),
              )
            : 0.sp.sbh,
        widget.isShowFinishButtonButton == true
            ? Padding(
                padding: EdgeInsets.only(right: 5.sp),
                child: CustomButton2(
                  buttonText: "Finish",
                  radius: 3.sp,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  onPressed: () {
                    _profileController.closeOverLay(widget.overlayStep);
                    _profileController.isShowOverlayView.value = false;
                    // _profileController.isOverlayStarted.value = false;

                    showDialog(
                      context: Get.context!,
                      builder: (BuildContext context) {
                        return const AlertForCompletedSteps();
                      },
                    );
                  },
                ),
              )
            : 0.sp.sbh,
      ],
    );
  }

  _navigate() {
    final dashboardController = Get.find<DashboardController>();

    _profileController.closeOverLay(widget.overlayStep);

    Future.delayed(const Duration(milliseconds: 300), () {
      // check condition for action item
      if (widget.overlayStep + 1 == AppConstants.actionItemOverLayIndex) {
        if (dashboardController.actionItemList.isNotEmpty) {
          _profileController.showOverLay(widget.overlayStep + 1);
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep + 2);
        }

        // check condition for action item
      } else if (widget.overlayStep + 1 ==
          AppConstants.getStartVideoOverLayIndex) {
        if (dashboardController.quickLinkData != null &&
            dashboardController.quickLinkData!.videos != null &&
            dashboardController.quickLinkData!.videos!.isNotEmpty) {
          _profileController.showOverLay(widget.overlayStep + 1);
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep + 2);
        }

        // check developement
      } else if (widget.overlayStep + 1 ==
          AppConstants.personalGrowthOverLayIndex) {
        if (dashboardController.quickLinkData != null &&
            dashboardController.quickLinkData!.quickLinks != null &&
            dashboardController.quickLinkData!.quickLinks!.isNotEmpty) {
          if (dashboardController.quickLinkData!.quickLinks!
              .where((element) => element.navKey == "development")
              .isNotEmpty) {
            _profileController.showOverLay(widget.overlayStep + 1);
          } else {
            _profileController.showOverLay(widget.overlayStep + 2);
          }
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep + 2);
        }

        // check goal
      } else if (widget.overlayStep + 1 == AppConstants.goalOverLayIndex) {
        if (dashboardController.quickLinkData != null &&
            dashboardController.quickLinkData!.quickLinks != null &&
            dashboardController.quickLinkData!.quickLinks!.isNotEmpty) {
          if (dashboardController.quickLinkData!.quickLinks!
              .where((element) => element.navKey == "mygoals")
              .isNotEmpty) {
            _profileController.showOverLay(widget.overlayStep + 1);
          } else {
            _profileController.showOverLay(widget.overlayStep + 2);
          }
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep + 2);
        }
      } else {
        _profileController.showOverLay(widget.overlayStep + 1);
      }
    });
  }

  _previos() {
    final dashboardController = Get.find<DashboardController>();

    _profileController.closeOverLay(widget.overlayStep);

    Future.delayed(const Duration(milliseconds: 300), () {
      // check condition for action item
      if (widget.overlayStep - 1 == AppConstants.actionItemOverLayIndex) {
        if (dashboardController.actionItemList.isNotEmpty) {
          _profileController.showOverLay(widget.overlayStep - 1);
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep - 2);
        }

        // check condition for action item
      } else if (widget.overlayStep - 1 ==
          AppConstants.getStartVideoOverLayIndex) {
        if (dashboardController.quickLinkData != null &&
            dashboardController.quickLinkData!.videos != null &&
            dashboardController.quickLinkData!.videos!.isNotEmpty) {
          _profileController.showOverLay(widget.overlayStep - 1);
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep - 2);
        }

        // check developement
      } else if (widget.overlayStep - 1 ==
          AppConstants.personalGrowthOverLayIndex) {
        if (dashboardController.quickLinkData != null &&
            dashboardController.quickLinkData!.quickLinks != null &&
            dashboardController.quickLinkData!.quickLinks!.isNotEmpty) {
          if (dashboardController.quickLinkData!.quickLinks!
              .where((element) => element.navKey == "development")
              .isNotEmpty) {
            _profileController.showOverLay(widget.overlayStep - 1);
          } else {
            _profileController.showOverLay(widget.overlayStep - 2);
          }
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep - 2);
        }

        // check goal
      } else if (widget.overlayStep + 1 == AppConstants.goalOverLayIndex) {
        if (dashboardController.quickLinkData != null &&
            dashboardController.quickLinkData!.quickLinks != null &&
            dashboardController.quickLinkData!.quickLinks!.isNotEmpty) {
          if (dashboardController.quickLinkData!.quickLinks!
              .where((element) => element.navKey == "mygoals")
              .isNotEmpty) {
            _profileController.showOverLay(widget.overlayStep - 1);
          } else {
            _profileController.showOverLay(widget.overlayStep - 2);
          }
        } else {
          // if empty then move to onother index
          _profileController.showOverLay(widget.overlayStep - 2);
        }
      } else {
        _profileController.showOverLay(widget.overlayStep - 1);
      }
    });
  }

  Widget _buildTitle() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              color: AppColors.labelColor64,
              text: widget.title,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
