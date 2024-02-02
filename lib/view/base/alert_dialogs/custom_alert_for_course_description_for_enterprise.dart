import 'package:aspirevue/data/model/response/development/courses_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';

class CustomAlertForCourseDescriptionForEnterPrise extends StatefulWidget {
  const CustomAlertForCourseDescriptionForEnterPrise({
    super.key,
    required this.course,
  });

  final Course course;
  @override
  State<CustomAlertForCourseDescriptionForEnterPrise> createState() =>
      _CustomAlertForCourseDescriptionForEnterPriseState();
}

class _CustomAlertForCourseDescriptionForEnterPriseState
    extends State<CustomAlertForCourseDescriptionForEnterPrise> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onPopInvoked: (va) {},
      // onWillPop: () => Future.value(true),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: SizedBox(
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
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // _buildBoxWithTitle(context),
                    // _buildTitle2(),
                    // _buildDivider(),
                    _buildHtmlContent(widget.course.shortDesc.toString()),
                    _buildHtmlContent(widget.course.longDesc.toString()),
                    _buildDivider(),
                    _buildRow("Price : ", widget.course.price.toString()),
                    _buildDivider(),
                    widget.course.presenter.toString() != ""
                        ? _buildRow(
                            "Presenter : ", widget.course.presenter.toString())
                        : 0.sbh,
                    _buildDivider(),
                    _buildRow(
                        "Course Type : ", widget.course.courseType.toString()),
                    10.sp.sbh,
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Container _buildHtmlContent(String text) {
    return Container(
      padding: EdgeInsets.all(0.sp),
      width: context.getWidth,
      child: Html(
        data: text,
        style: {
          "*": Style(
            color: AppColors.labelColor15,
            fontFamily: AppString.manropeFontFamily,
            fontSize: FontSize(11.sp),
            padding: HtmlPaddings.all(1.sp),
            margin: Margins.all(0),
          )
        },
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      height: 0.sp,
      color: AppColors.labelColor,
      thickness: 1,
    );
  }

  // Padding _buildTitle2() {
  //   return Padding(
  //     padding: EdgeInsets.all(5.sp),
  //     child: CustomText(
  //       fontWeight: FontWeight.w400,
  //       fontSize: 10.sp,
  //       color: AppColors.labelColor5,
  //       text: widget.course.course.toString(),
  //       textAlign: TextAlign.start,
  //       fontFamily: AppString.manropeFontFamily,
  //     ),
  //   );
  // }

  // Container _buildBoxWithTitle(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.all(5.sp),
  //     width: context.getWidth,
  //     color: AppColors.labelColor15.withOpacity(0.65),
  //     child: CustomText(
  //       fontWeight: FontWeight.w600,
  //       fontSize: 11.sp,
  //       color: AppColors.white,
  //       text: widget.course.course.toString(),
  //       textAlign: TextAlign.start,
  //       fontFamily: AppString.manropeFontFamily,
  //     ),
  //   );
  // }

  Widget _buildRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: EdgeInsets.all(5.sp),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(
          text: title,
          style: TextStyle(
            color: AppColors.secondaryColor,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextSpan(
          text: value,
          style: TextStyle(
            color: AppColors.labelColor14,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ])),
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
              text: widget.course.course.toString(),
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
