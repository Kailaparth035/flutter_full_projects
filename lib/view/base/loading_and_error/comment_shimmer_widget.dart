import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class CommentShimmerWidget extends StatelessWidget {
  const CommentShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildComment(),
        _buildComment(),
      ],
    );
  }

  Widget _buildComment() {
    return Shimmer(
      duration: const Duration(seconds: 2),
      colorOpacity: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14.sp,
                  backgroundColor: AppColors.labelColor.withOpacity(0.5),
                ),
                7.sp.sbw,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40.sp,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 5.sp),
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
      ),
    );
  }
}
