import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TimeLineForStore extends StatelessWidget {
  const TimeLineForStore(
      {super.key, required this.currentIndex, required this.callback});
  final int currentIndex;
  final Function(int) callback;
  @override
  Widget build(BuildContext context) {
    return _buildTopTimeLine();
  }

  Widget _buildTopTimeLine() {
    return Container(
      padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          AppColors.labelColor82.withOpacity(0.17),
          AppColors.labelColor81.withOpacity(0.22),
        ], stops: const [
          0.0,
          0.7,
        ]),
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildBox(1, currentIndex >= 1),
              Expanded(
                child: Container(
                  height: 2.sp,
                  color: currentIndex >= 2
                      ? AppColors.secondaryColor
                      : AppColors.labelColor83,
                ),
              ),
              _buildBox(2, currentIndex > 1),
              Expanded(
                child: Container(
                  height: 2.sp,
                  color: currentIndex >= 3
                      ? AppColors.secondaryColor
                      : AppColors.labelColor83,
                ),
              ),
              _buildBox(3, currentIndex >= 3),
            ],
          ),
          5.sp.sbh,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _subTitle(" Licenses  ", currentIndex >= 1),
              _subTitle("Assessment", currentIndex > 1),
              _subTitle("Coaching", currentIndex >= 3),
            ],
          ),
        ],
      ),
    );
  }

  _subTitle(String title, bool isChecked) {
    return CustomText(
      fontWeight: FontWeight.w500,
      fontSize: 9.sp,
      color: isChecked ? AppColors.secondaryColor : AppColors.labelColor9,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Widget _buildBox(int title, bool isChecked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(6.sp),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6.sp),
              onTap: () {
                // if (currentIndex == 1) {}

                // if (currentIndex == 2) {
                //   if (title == 1) {
                //     callback(title);
                //   }
                // }
                // if (currentIndex == 3) {
                //   if (title == 1 || title == 2) {
                //     callback(title);
                //   }
                // }

                callback(title);
              },
              child: Container(
                height: 40.sp,
                width: 40.sp,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.sp),
                ),
                child: Center(
                  child: isChecked
                      ? Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.labelColor82,
                                AppColors.labelColor81,
                              ],
                              stops: [
                                0.0,
                                0.8,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(3.sp),
                          ),
                          height: 15.sp,
                          width: 15.sp,
                          child: Icon(
                            Icons.done,
                            color: AppColors.white,
                            weight: 5,
                            size: 15.sp,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppColors.labelColor,
                            borderRadius: BorderRadius.circular(3.sp),
                          ),
                          height: 15.sp,
                          width: 15.sp,
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
