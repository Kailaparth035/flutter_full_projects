import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PurchaseWidgetForReputation extends StatelessWidget {
  const PurchaseWidgetForReputation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomButton2(
              isDisable: false,
              buttonText: "How to others view me?",
              radius: 5.sp,
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
              buttonColor: AppColors.hintColor,
              onPressed: () {}),
          10.sp.sbh,
          CustomText(
            text:
                "Check your blind spot by gathering the perceptions of others.",
            textAlign: TextAlign.start,
            color: AppColors.labelColor15,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
          5.sp.sbh,
          CustomText(
            text:
                "Select this tool to invite candid, honest, and confidential feedback from a few trusted friends, colleagues, or family members.  Discovering how your reputation differs from your self-perception will help you create intelligent goals that make a difference.  Would you like to leverage feedback from others?  Invite up to 15 people!",
            textAlign: TextAlign.start,
            color: AppColors.labelColor15,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
          10.sp.sbh,
          CustomButton2(
              isDisable: false,
              isBoarder: true,
              buttonText: "Gather Feedback Purchase Now",
              radius: 5.sp,
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
              fontWeight: FontWeight.w700,
              fontSize: 10.sp,
              buttonColor: AppColors.white,
              textColor: AppColors.primaryColor,
              borderColor: AppColors.primaryColor,
              onPressed: () {}),
          5.sp.sbh,
        ],
      ),
    );
  }
}
