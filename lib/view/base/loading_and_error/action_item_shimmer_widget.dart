import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class ActionItemShimmerWidget extends StatelessWidget {
  final bool isFromWidget;

  const ActionItemShimmerWidget(this.isFromWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: isFromWidget ? 4 : 10,
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
                border: Border.all(
                  color: AppColors.labelColor90,
                  width: 1.0,
                ),
                color: Colors.transparent,
                borderRadius:
                    BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(7.sp),
                    height: 40.sp,
                    width: 40.sp,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.grayColor,
                    ),
                  ),
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
    );
  }
}
