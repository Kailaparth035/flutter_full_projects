import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HashTagWidget extends StatelessWidget {
  const HashTagWidget({super.key, required this.data});
  final HashtagData data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                data.image == null
                    ? CircleAvatar(
                        radius: 18.sp,
                        backgroundColor: AppColors.labelColor12,
                        child: Center(
                          child: CustomText(
                            text: '#',
                            textAlign: TextAlign.start,
                            color: AppColors.labelColor13,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : CustomImageForProfile(
                        image: data.image.toString(),
                        radius: 18.sp,
                        nameInitials: '',
                        borderColor: AppColors.labelColor,
                      ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.name ?? data.title.toString(),
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor14,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        const Divider(
          color: AppColors.labelColor9,
          thickness: 0.1,
        ),
        SizedBox(height: 0.5.h),
      ],
    );
  }
}
