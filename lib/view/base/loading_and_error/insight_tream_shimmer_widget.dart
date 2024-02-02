import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class InsightFeedShimmer extends StatelessWidget {
  final String type;

  const InsightFeedShimmer(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: type == "" ? 3 : 10,
      itemBuilder: (context, index) {
        return Column(
          children: [
            SizedBox(height: 2.h),
            Shimmer(
              duration: const Duration(seconds: 2),
              color: AppColors.labelColor.withOpacity(0.5),
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      10.sp.sbw,
                      CircleAvatar(
                        radius: 18.sp,
                        backgroundColor: AppColors.labelColor.withOpacity(0.5),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(
                              AppConstants.screenHorizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2.h,
                                width: double.infinity,
                                color: AppColors.labelColor.withOpacity(0.5),
                              ),
                              10.sp.sbh,
                              Container(
                                height: 2.h,
                                width: 40.w,
                                color: AppColors.labelColor.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
