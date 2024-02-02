import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class AssignTestShimmer extends StatelessWidget {
  final bool isFromWidget;

  const AssignTestShimmer(this.isFromWidget, {super.key});

  @override
  Widget build(BuildContext context) {
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
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: isFromWidget ? 2 : 10,
        itemBuilder: (context, index) {
          return Shimmer(
            colorOpacity: 0.5,
            duration: const Duration(seconds: 2),
            interval: const Duration(seconds: 0),
            enabled: true,
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   color: AppColors.labelColor90,
                  //   width: 1.0,
                  // ),
                  // color: Colors.transparent,
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
                ),
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
                    //     text: "             ",
                    //     textAlign: TextAlign.start,
                    //     fontFamily: AppString.manropeFontFamily,
                    //   ),
                    // ),
                    Container(
                      color: AppColors.grayColor,
                      child: Padding(
                        padding: EdgeInsets.all(1.5.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomText(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: AppColors.labelColor10,
                                text: "                   ",
                                textAlign: TextAlign.start,
                                maxLine: 2,
                                fontFamily: AppString.manropeFontFamily,
                              ),
                            ),
                            Container(
                              width: 20.w,
                              height: 4.5.h,
                              decoration: BoxDecoration(
                                color: AppColors.labelColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.radiusDefault),
                                ),
                              ),
                              child: Center(
                                child: CustomText(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                  color: AppColors.white,
                                  text: "",
                                  textAlign: TextAlign.center,
                                  fontFamily: AppString.manropeFontFamily,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
