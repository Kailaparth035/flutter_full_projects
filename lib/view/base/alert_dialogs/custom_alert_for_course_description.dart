import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';

class CustomAlertForCourseDescription extends StatefulWidget {
  const CustomAlertForCourseDescription({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
  @override
  State<CustomAlertForCourseDescription> createState() =>
      _CustomAlertForCourseDescriptionState();
}

class _CustomAlertForCourseDescriptionState
    extends State<CustomAlertForCourseDescription> {
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
          // constraints: BoxConstraints(maxHeight: context.getWidth),
          width: context.getWidth,
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
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                child: SizedBox(
                  width: context.getWidth,
                  child: Html(
                    data: widget.description,
                    style: {
                      "*": Style(
                          color: AppColors.labelColor15,
                          fontFamily: AppString.manropeFontFamily,
                          padding: HtmlPaddings.all(0.sp),
                          margin: Margins.all(0),
                          fontSize: FontSize(10.sp)),
                    },
                  ),
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
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: AppColors.labelColor8,
              text: widget.title,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
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
