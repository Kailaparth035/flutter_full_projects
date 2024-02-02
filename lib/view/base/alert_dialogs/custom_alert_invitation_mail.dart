import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomAlertForInvitationMail extends StatefulWidget {
  const CustomAlertForInvitationMail({
    super.key,
    required this.name,
    required this.date,
    required this.link,
  });

  final String name;
  final String date;
  final String link;
  @override
  State<CustomAlertForInvitationMail> createState() =>
      _CustomAlertForInvitationMailState();
}

class _CustomAlertForInvitationMailState
    extends State<CustomAlertForInvitationMail> {
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
          // height: context.getHeight,
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
                    CustomText(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: AppColors.black,
                      text: "Hello ",
                      textAlign: TextAlign.start,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                    5.sp.sbh,
                    _buildFirstLine(),
                    5.sp.sbh,
                    _buildSecondLine(),
                    5.sp.sbh,
                    CustomText(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: AppColors.black,
                      text: "If you have any questions, let me know. ",
                      textAlign: TextAlign.start,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                    5.sp.sbh,
                    CustomText(
                      fontWeight: FontWeight.w500,
                      fontSize: 10.sp,
                      color: AppColors.black,
                      text: "Thanks!",
                      textAlign: TextAlign.start,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  RichText _buildFirstLine() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${widget.name} ",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          TextSpan(
            text: "sent you an invitation via Support@AspireVue.com ",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          TextSpan(
            text: "${widget.date}, ",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          TextSpan(
            text:
                "enabling you to confidentially provide feedback to target development goals. Your input is still needed so I am resending this link to you today.",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  RichText _buildSecondLine() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Here is the link: ",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          TextSpan(
            text: widget.link,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                CommonController.urlLaunch(widget.link);
              },
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
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
            text: "Invitation Mail",
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
