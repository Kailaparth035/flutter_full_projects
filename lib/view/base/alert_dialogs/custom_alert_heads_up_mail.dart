import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomAlertForHeadsUp extends StatefulWidget {
  const CustomAlertForHeadsUp({
    super.key,
    required this.mailContent,
  });

  final String mailContent;

  @override
  State<CustomAlertForHeadsUp> createState() => _CustomAlertForHeadsUpState();
}

class _CustomAlertForHeadsUpState extends State<CustomAlertForHeadsUp> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onWillPop: () => Future.value(true),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: SizedBox(
          width: context.width,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              Divider(
                height: 1.sp,
                color: AppColors.labelColor,
                thickness: 1,
              ),
              Padding(
                padding: EdgeInsets.all(10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CustomText(
                    //   fontWeight: FontWeight.w400,
                    //   fontSize: 10.sp,
                    //   color: AppColors.black,
                    //   text: widget.mailContent,
                    //   textAlign: TextAlign.start,
                    //   fontFamily: AppString.manropeFontFamily,
                    // ),

                    Html(data: widget.mailContent, style: {
                      "p": Style(
                        fontSize: FontSize(10.sp),
                        fontWeight: FontWeight.w400,
                      ),
                    })
                  ],
                ),
              )
            ],
          )),
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
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: "Headsup Mail",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
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
