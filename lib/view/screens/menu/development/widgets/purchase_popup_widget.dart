import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/store/store_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PurchasePopupWidget extends StatelessWidget {
  const PurchasePopupWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return _buildPurchaseJourneyView(text);
  }

  Align _buildPurchaseJourneyView(String text) {
    return Align(
      child: Container(
        color: AppColors.black.withOpacity(0.3),
        height: 100.h,
        width: 100.w,
        child: Center(
          child: CustomSlideUpAndFadeWidget(
            direction: AnimationDirection.topTobottom,
            duration: const Duration(milliseconds: 1500),
            point: 2,
            child: Container(
              width: 90.w,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                boxShadow: CommonController.getBoxShadow,
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.sp),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: CustomText(
                      text: text,
                      textAlign: TextAlign.center,
                      color: AppColors.black,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.sp.sbh,
                  CustomButton2(
                      buttonText: "Learn More",
                      radius: 5.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 13.sp),
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      onPressed: () {
                        Navigator.pop(Get.context!, true);
                        Get.to(() => const StoreMainScreen(isFromMenu: false));
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
