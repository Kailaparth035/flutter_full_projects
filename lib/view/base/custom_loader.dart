import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

buildLoading(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        // onWillPop: () async => false,
        child: Center(
          child: Container(
              padding: EdgeInsets.all(15.sp),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(5.sp),
              ),
              child: SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: Transform.scale(
                  scale: 1.2.sp,
                  child: const CupertinoActivityIndicator(
                    color: AppColors.black,
                  ),
                ),
              )),
        ),
      );
    },
  );
}

buildDownloadLoading(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return PopScope(
        canPop: false,
        // onWillPop: () async => false,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(15.sp),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // GetPlatform.isIOS
                //     ? const CupertinoActivityIndicator()
                //     : const CircularProgressIndicator(),

                SizedBox(
                  height: 20.sp,
                  width: 20.sp,
                  child: Transform.scale(
                    scale: 1.2.sp,
                    child: const CupertinoActivityIndicator(
                      color: AppColors.black,
                    ),
                  ),
                ),
                10.sp.sbh,
                CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: AppColors.black,
                  text: AppString.downloading,
                  textAlign: TextAlign.start,
                  maxLine: 20,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
