import 'package:aspirevue/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../util/images.dart';
import '../../../../util/string.dart';
import '../../../base/custom_text.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 20.h,
              width: 16.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.labelColor17,
                ),
              ),
              child: Image.asset(AppImages.avtar),
            ),
            Container(
              height: 2.5.h,
              width: 5.w,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.labelColor17,
                  ),
                  color: AppColors.backgroundColor2),
              child: Center(
                child: CustomText(
                  text: "3",
                  textAlign: TextAlign.center,
                  color: AppColors.labelColor17,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 2.w)
      ],
    );
  }
}
