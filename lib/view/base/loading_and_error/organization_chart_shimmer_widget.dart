import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class OrganizationChartShimmerWidget extends StatelessWidget {
  const OrganizationChartShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.sp),
      child: Column(
        children: [
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
          _buildListTile(),
        ],
      ),
    );
  }

  Widget _buildListTile() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.sp),
      child: Shimmer(
        color: AppColors.shimmerColor,
        duration: const Duration(seconds: 2),
        enabled: true,
        child: Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.labelColor),
            // color: AppColors.labelColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.sp),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 40.sp,
                width: 40.sp,
                decoration: BoxDecoration(
                  color: AppColors.labelColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
              ),
              10.sp.sbw,
              Flexible(
                child: Column(
                  children: [
                    Container(
                      height: 15.sp,
                      decoration: BoxDecoration(
                        color: AppColors.labelColor.withOpacity(0.9),
                      ),
                    ),
                    5.sp.sbh,
                    Container(
                      margin: EdgeInsets.only(right: 30.sp),
                      height: 10.sp,
                      decoration: BoxDecoration(
                        color: AppColors.labelColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              20.sp.sbw,
              Container(
                height: 20.sp,
                width: 20.sp,
                decoration: BoxDecoration(
                  color: AppColors.labelColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
              ),
              3.sp.sbw,
              Container(
                height: 20.sp,
                width: 20.sp,
                decoration: BoxDecoration(
                  color: AppColors.labelColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
              ),
              3.sp.sbw,
              Container(
                height: 20.sp,
                width: 20.sp,
                decoration: BoxDecoration(
                  color: AppColors.labelColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
