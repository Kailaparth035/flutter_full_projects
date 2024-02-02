import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:aspirevue/view/screens/profile/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ProfileViewPopUp extends StatefulWidget {
  const ProfileViewPopUp(
      {super.key, required this.child, required this.userDetails});
  final Widget child;
  final TagLine userDetails;

  @override
  State<ProfileViewPopUp> createState() => _ProfileViewPopUpState();
}

class _ProfileViewPopUpState extends State<ProfileViewPopUp> {
  // late InfoPopupController _infoPopupController;
  // @override
  // Widget build(BuildContext context) {
  //   return InfoPopupWidget(
  //       contentMaxWidth: 50.w,
  //       customContent: _buildView(),
  //       arrowTheme: const InfoPopupArrowTheme(
  //         color: AppColors.labelColor,
  //         arrowDirection: ArrowDirection.up,
  //       ),
  //       dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,
  //       areaBackgroundColor: Colors.transparent,
  //       indicatorOffset: Offset.zero,
  //       contentOffset: Offset(15.sp, 0),
  //       onControllerCreated: (InfoPopupController controller) {
  //         setState(() {
  //           _infoPopupController = controller;
  //         });
  //       },
  //       onAreaPressed: (InfoPopupController controller) {
  //         controller.dismissInfoPopup();
  //       },
  //       child: widget.child);
  // }

  final tooltipController = AlignedTooltipController();
  @override
  Widget build(BuildContext context) {
    return AlignedTooltip(
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: AppColors.backgroundColor1,
      controller: tooltipController,
      shadow: const Shadow(color: Colors.transparent),
      isModal: true,
      content: _buildView(),
      child: widget.child,
    );
  }

  Widget _buildView() => Container(
        width: context.getWidth / 1.5,
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor1,
          border: Border.all(
            color: AppColors.labelColor,
          ),
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.userDetails.userType == "self") {
                  Get.to(() => MyProfileScreen(
                        isFromMain: true,
                        onBackPress: () {
                          Navigator.pop(Get.context!);
                        },
                      ));
                } else {
                  Get.to(UserProfileScreen(
                    userId: widget.userDetails.id.toString(),
                  ));
                }
              },
              child: CustomImageForProfile(
                image: widget.userDetails.photo.toString(),
                radius: 15.sp,
                nameInitials: '',
                borderColor: AppColors.labelColor,
              ),
            ),
            10.sp.sbw,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: widget.userDetails.name.toString(),
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor14,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  maxLine: 5,
                  fontWeight: FontWeight.w600,
                ),
                5.sp.sbh,
                _buildListTile(widget.userDetails.companyName.toString(),
                    AppImages.buildingIc),
                5.sp.sbh,
                _buildListTile(widget.userDetails.position.toString(),
                    AppImages.positionIc),
                5.sp.sbh,
                CustomButton2(
                    buttonText: AppString.about,
                    radius: 5.sp,
                    padding:
                        EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    onPressed: () {
                      if (widget.userDetails.userType == "self") {
                        // var mainController = Get.find<MainController>();
                        // mainController
                        //     .addToStackAndNavigate(AppConstants.myProfileIndex);
                        Get.to(() => MyProfileScreen(
                              isFromMain: true,
                              onBackPress: () {
                                Navigator.pop(Get.context!);
                              },
                            ));
                      } else {
                        Get.to(UserProfileScreen(
                          userId: widget.userDetails.id.toString(),
                        ));
                      }
                      tooltipController.hideTooltip();
                    })
              ],
            ))
          ],
        ),
      );

  Row _buildListTile(String name, String image) {
    return Row(
      children: [
        Image.asset(
          image,
          height: 15.sp,
        ),
        5.sp.sbw,
        Expanded(
          child: CustomText(
            text: name,
            textAlign: TextAlign.start,
            color: AppColors.labelColor9,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 8.sp,
            maxLine: 20,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
