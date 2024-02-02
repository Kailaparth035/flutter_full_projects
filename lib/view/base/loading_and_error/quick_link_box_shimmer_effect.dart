import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class QuickLinkBoxShimmer extends StatelessWidget {
  const QuickLinkBoxShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            itemCount: 6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.sp,
                mainAxisSpacing: 5.sp),
            itemBuilder: (BuildContext context, int index) {
              return Shimmer(
                colorOpacity: 0.5,
                duration: const Duration(seconds: 2),
                interval: const Duration(seconds: 0),
                enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: Colors.transparent),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.labelColor91.withOpacity(0.40),
                        spreadRadius: 0.5,
                        blurRadius: 9,
                        offset: const Offset(0, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5.sp),
                  ),
                  child: Column(
                    children: [
                      10.sp.sbh,
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.grayColor,
                          ),
                          height: 10.sp,
                          width: 30.sp,
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.sp, horizontal: 10.sp),
                              child: Container(
                                color: AppColors.grayColor,
                                height: 20.sp,
                              ),
                            ),
                          )),
                      5.sp.sbh,
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
