import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomImageForProfile extends StatelessWidget {
  final String image;
  final String nameInitials;
  final Color? borderColor;
  final double radius;

  final double? borderWidth;
  const CustomImageForProfile({
    super.key,
    required this.image,
    required this.radius,
    this.borderWidth,
    required this.nameInitials,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: borderColor,
      radius: borderWidth != null ? radius + borderWidth! : radius + 1,
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        radius: radius,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: CachedNetworkImage(
            imageUrl: image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            errorListener: (obj) {
              debugPrint("====> $obj");
            },
            errorWidget: (context, url, error) => nameInitials == ""
                ? Image.asset(
                    AppImages.userPlaceholder,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor
                        ],
                      ),
                    ),
                    child: Center(
                      child: CustomText(
                        text: nameInitials,
                        textAlign: TextAlign.center,
                        color: AppColors.white,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
