import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/store/store_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class JourneyPurchaseAlertDialog extends StatefulWidget {
  const JourneyPurchaseAlertDialog({super.key, required this.text});
  final String text;
  @override
  State<JourneyPurchaseAlertDialog> createState() =>
      _JourneyPurchaseAlertDialogState();
}

class _JourneyPurchaseAlertDialogState
    extends State<JourneyPurchaseAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onWillPop: () {
      //   return Future.value(true);
      // },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: Container(
          constraints: BoxConstraints(maxHeight: context.getWidth),
          width: context.getWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: CustomText(
                    text: widget.text,
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
                    padding:
                        EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    onPressed: () {
                      Navigator.pop(Get.context!, true);
                      Get.to(
                        () => const StoreMainScreen(isFromMenu: true),
                      );
                    }),
                10.sp.sbh
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          0.sbw,
          // CustomText(
          //   fontWeight: FontWeight.w600,
          //   fontSize: 12.sp,
          //   color: AppColors.labelColor8,
          //   text: "Offers for you",
          //   textAlign: TextAlign.start,
          //   fontFamily: AppString.manropeFontFamily,
          // ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.labelColor15.withOpacity(0.5)),
              child: Icon(
                Icons.close,
                weight: 3,
                size: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
