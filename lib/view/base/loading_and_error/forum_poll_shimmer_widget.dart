import 'package:aspirevue/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class ForumPollShimmerWidget extends StatelessWidget {
  const ForumPollShimmerWidget({super.key, required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.sp),
      child: Shimmer(
        duration: const Duration(seconds: 2),
        colorOpacity: 1,
        child: Column(
          children: [
            for (int i = 0; i < count; i++) _buildListTile(),
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
          Container(
            height: 40.sp,
            decoration: BoxDecoration(
              color: AppColors.labelColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(3.sp),
            ),
          ),
        ],
      ),
    );
  }
}
