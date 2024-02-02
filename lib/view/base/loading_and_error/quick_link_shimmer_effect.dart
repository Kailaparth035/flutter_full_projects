import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class QuickLinkShimmer extends StatelessWidget {
  const QuickLinkShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(
            colorOpacity: 0.5,
            duration: const Duration(seconds: 2),
            interval: const Duration(seconds: 0),
            enabled: true,
            child: Container(
              width: double.infinity,
              height: 140.sp,
              color: AppColors.grayColor,
            ),
          ),
          10.sp.sbh,
          Align(
            alignment: Alignment.centerRight,
            child: Shimmer(
              colorOpacity: 0.5,
              duration: const Duration(seconds: 2),
              interval: const Duration(seconds: 0),
              enabled: true,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grayColor,
                ),
                width: 35.sp,
                height: 35.sp,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(right: 10.sp),
              child: Row(
                children: [
                  ...[1, 2, 3, 4].map(
                    (e) => Container(
                      margin: EdgeInsets.only(
                          top: 10.sp, bottom: 10.sp, right: 10.sp),
                      child: Shimmer(
                        colorOpacity: 0.5,
                        duration: const Duration(seconds: 2),
                        interval: const Duration(seconds: 0),
                        enabled: true,
                        child: Container(
                          width: context.getWidth / 3 - 18.sp,
                          height: context.getWidth / 3 - 18.sp,
                          decoration: BoxDecoration(
                            color: AppColors.grayColor,
                            borderRadius: BorderRadius.circular(5.sp),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
