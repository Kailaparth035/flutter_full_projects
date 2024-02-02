import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/quick_link_and_video_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/quick_link_box_shimmer_effect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomAlertForAddQuickLink extends StatefulWidget {
  const CustomAlertForAddQuickLink({super.key});

  @override
  State<CustomAlertForAddQuickLink> createState() =>
      _CustomAlertForAddQuickLinkState();
}

class _CustomAlertForAddQuickLinkState
    extends State<CustomAlertForAddQuickLink> {
  final _dashboardController = Get.find<DashboardController>();
  // final List _quickLinkList = [
  //   {
  //     "title": "Goal 1",
  //     "is_selected": true,
  //   },
  //   {
  //     "title": "Goal 2",
  //     "is_selected": false,
  //   },
  //   {
  //     "title": "Goal 3",
  //     "is_selected": false,
  //   },
  //   {
  //     "title": "Goal 4",
  //     "is_selected": false,
  //   }
  // ];

  _toggle(index) {
    _dashboardController.setCheckedInQuickLink(index);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        width: context.getWidth,
        child: _buildView(context),
      ),
    );
  }

  _buildBuilder() {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      if (dashboardController.isLoadingQuickLinkData) {
        return const QuickLinkBoxShimmer();
      }
      if (dashboardController.isErrorQuickLinkData ||
          dashboardController.quickLinkData == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              dashboardController
                  .getDashboardVideoQuickLinkDetails({}, isShowLoading: true);
            },
            text: dashboardController.isErrorQuickLinkData
                ? dashboardController.errorMsgQuickLinkData
                : AppString.somethingWentWrong,
          ),
        );
      }

      return _buildOutputView(dashboardController.quickLinksPopupMain);
    });
  }

  SingleChildScrollView _buildView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(),
          10.sp.sbh,
          _buildBuilder(),
        ],
      ),
    );
  }

  _buildOutputView(List<QuickLinksPopup> quickLinksPopup) {
    return Column(
      children: [
        GridView.builder(
          itemCount: quickLinksPopup.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 5.sp, mainAxisSpacing: 5.sp),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              borderRadius: BorderRadius.circular(5.sp),
              onTap: () {
                _toggle(index);
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                        color: quickLinksPopup[index].isSelected == 1
                            ? AppColors.primaryColor
                            : Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.labelColor91.withOpacity(0.40),
                        spreadRadius: 0.5,
                        blurRadius: 9,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5.sp),
                  ),
                  child: buildQuickLinkColumn(
                      quickLinksPopup[index].icon.toString(),
                      quickLinksPopup[index].title.toString())
                  // Column(
                  //   children: [
                  //     7.sp.sbh,
                  //     Expanded(
                  //       flex: 8,
                  //       child: CustomImage(
                  //         image: quickLinksPopup[index].icon.toString(),
                  //         fit: BoxFit.fitHeight,
                  //       ),
                  //     ),
                  //     Expanded(
                  //         flex: 10,
                  //         child: Align(
                  //           alignment: Alignment.center,
                  //           child: Padding(
                  //             padding: EdgeInsets.symmetric(
                  //                 vertical: 0.sp, horizontal: 5.sp),
                  //             child: CustomText(
                  //               fontWeight: FontWeight.w600,
                  //               fontSize: 10.sp,
                  //               color: AppColors.labelColor3,
                  //               text: quickLinksPopup[index].title.toString(),
                  //               textAlign: TextAlign.center,
                  //               fontFamily: AppString.manropeFontFamily,
                  //             ),
                  //           ),
                  //         )),
                  //     // 5.sp.sbh,
                  //   ],
                  // ),
                  ),
            );
          },
        ),
        10.sp.sbh,
        CustomButton2(
            buttonText: "Apply Changes",
            radius: 20.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
            onPressed: () async {
              bool? res = await _dashboardController.updateToViewQuickLinks(
                  quickLinksPopup: quickLinksPopup);

              if (res != null && res == true) {
                Navigator.pop(Get.context!);
              }
            })
      ],
    );
  }

  Row _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: "Add/Remove Quicklinks",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
        10.sp.sbw,
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
    );
  }
}
