import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class HashTagShimmerWidget extends StatelessWidget {
  const HashTagShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.sp.sbh,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              10.sp.sbw,
              CircleAvatar(
                radius: 18.sp,
                backgroundColor: AppColors.labelColor.withOpacity(0.5),
              ),
              10.sp.sbw,
              Expanded(
                child: Container(
                  height: 20.sp,
                  color: AppColors.labelColor.withOpacity(0.5),
                ),
              ),
              20.sp.sbw,
            ],
          ),
          10.sp.sbh,
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        ],
      ),
    );
  }
}
