import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/overlay_popup_widget.dart';
import 'package:aspirevue/view/screens/profile/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({super.key});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final _streamController = Get.find<InsightStreamController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => MyProfileScreen(
                          isFromMain: true,
                          onBackPress: () {
                            Navigator.pop(Get.context!);
                          },
                        ));
                  },
                  child: GetBuilder<ProfileSharedPrefService>(
                      builder: (sharedPrefController) {
                    return CustomImageForProfile(
                      image: sharedPrefController.profileData.value.photo
                          .toString(),
                      radius: 18.sp,
                      nameInitials: sharedPrefController
                          .profileData.value.name![0]
                          .toString(),
                      borderColor: AppColors.labelColor,
                    );
                  }),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      var result =
                          await Get.toNamed(RouteHelper.getCreatePostRoute());

                      if (result != null && result == true) {
                        _streamController.getInsightFeed(true);
                      }
                    },
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: AppColors.labelColor9.withOpacity(0.1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dimensions.radiusExtraLarge),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: CustomText(
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            color: AppColors.labelColor9,
                            text: AppString.whatYourMind,
                            textAlign: TextAlign.start,
                            fontFamily: AppString.manropeFontFamily,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 20.sp,
              child: OverlayPopupWidget(
                tooltipController: Get.find<ProfileSharedPrefService>()
                    .insightStreamOverLayController,
                title: AppConstants.insightStreamOverLayDescription,
                overlayStep: AppConstants.insightStreamOverLayIndex,
                child: 0.1.sbh,
              ),
            )
          ],
        ),
        // AlignedTooltip(
        //   barrierBuilder: (context, asda, asd) {
        //     return Container(
        //       color: Colors.red,
        //     );
        //   },
        //   isModal: true,
        //   child: Material(
        //     color: Colors.grey.shade800,
        //     shape: const CircleBorder(),
        //     elevation: 4.0,
        //     child: const Padding(
        //       padding: EdgeInsets.all(8.0),
        //       child: Icon(
        //         Icons.add,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        //   content: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Column(
        //       children: [
        //         IconButton(
        //             onPressed: () {},
        //             icon: Icon(
        //               Icons.add,
        //               color: Colors.red,
        //             )),
        //         Text(
        //           'Bacon ipsum dolor amet kevin turducken brisket pastrami, salami ribeye spare ribs tri-tip sirloin shoulder venison shank burgdoggen chicken pork belly. Short loin filet mignon shoulder rump beef ribs meatball kevin.',
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(height: 1.5.h),
        Divider(
          height: 0.sp,
          color: AppColors.labelColor9,
          thickness: 0.1,
        ),
      ],
    );
  }
}
