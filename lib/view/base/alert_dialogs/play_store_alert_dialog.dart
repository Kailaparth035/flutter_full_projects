import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlaystoreAlertDialogWidget extends StatefulWidget {
  const PlaystoreAlertDialogWidget({
    super.key,
  });

  @override
  State<PlaystoreAlertDialogWidget> createState() =>
      _PlaystoreAlertDialogWidgetState();
}

class _PlaystoreAlertDialogWidgetState
    extends State<PlaystoreAlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        width: 80.w,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              10.sp.sbh,
              Container(
                  padding: EdgeInsets.all(5.sp),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "!",
                      style: TextStyle(
                        inherit: false,
                        fontSize: 20.sp,
                        color: Colors.orange,
                        fontWeight: FontWeight.w300,
                        fontFamily: Icons.error_outline.fontFamily,
                      ),
                    ),
                  )),
              10.sp.sbh,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                  color: AppColors.hintColor,
                  text:
                      "You don't have any apps that can open this type of file.you can search for one in the Play Store.",
                  textAlign: TextAlign.center,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ),
              10.sp.sbh,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton2(
                      buttonText: "Search",
                      buttonColor: AppColors.primaryColor,
                      radius: 15.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 15.sp),
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      onPressed: () {
                        Navigator.pop(context, true);
                      }),
                  10.sp.sbw,
                  CustomButton2(
                      buttonText: "Cancel",
                      buttonColor: AppColors.redColor,
                      radius: 15.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 15.sp),
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ],
              ),
              10.sp.sbh,
            ],
          ),
        ),
      ),
    );
  }
}
