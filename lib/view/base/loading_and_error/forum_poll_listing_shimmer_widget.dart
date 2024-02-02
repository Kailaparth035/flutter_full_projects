import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class ForumPollListingShimmerWidget extends StatelessWidget {
  const ForumPollListingShimmerWidget({super.key, required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < count; i++) _buildQuestionListTile(),
        ],
      ),
    );
  }

  Shimmer _buildQuestionListTile() {
    return Shimmer(
      duration: const Duration(seconds: 2),
      colorOpacity: 1,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding,
            vertical: AppConstants.screenHorizontalPadding),
        margin: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding,
            vertical: AppConstants.screenHorizontalPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: AppColors.labelColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20.sp,
              decoration: BoxDecoration(
                color: AppColors.labelColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3.sp),
              ),
            ),
            10.sp.sbh,
            Container(
              height: 30.sp,
              decoration: BoxDecoration(
                color: AppColors.labelColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3.sp),
              ),
            ),
            10.sp.sbh,
            Container(
              height: 30.sp,
              decoration: BoxDecoration(
                color: AppColors.labelColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3.sp),
              ),
            ),
            10.sp.sbh,
            Container(
              height: 30.sp,
              decoration: BoxDecoration(
                color: AppColors.labelColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3.sp),
              ),
            ),
            10.sp.sbh,
            Container(
              height: 30.sp,
              decoration: BoxDecoration(
                color: AppColors.labelColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3.sp),
              ),
            ),
            10.sp.sbh,
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 30.sp,
                width: 30.w,
                decoration: BoxDecoration(
                  color: AppColors.labelColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(3.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
