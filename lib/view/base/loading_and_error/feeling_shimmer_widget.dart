import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class FeelingShimmerWidget extends StatelessWidget {
  const FeelingShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        colorOpacity: 1,
        child: Column(
          children: [
            _buildListTile(),
            _buildListTile(),
            _buildListTile(),
            _buildListTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20.sp,
                      decoration: BoxDecoration(
                        color: AppColors.labelColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3.sp),
                      ),
                    ),
                  ],
                ),
              ),
              7.sp.sbw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20.sp,
                      decoration: BoxDecoration(
                        color: AppColors.labelColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(3.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
