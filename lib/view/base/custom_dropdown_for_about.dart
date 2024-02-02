import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomDropForAbout extends StatefulWidget {
  const CustomDropForAbout({
    super.key,
    required this.headingText,
    required this.child,
    required this.index,
    required this.selected,
    this.bgColor,
    this.bottomBgColor,
    this.borderColor,
    this.isGredient,
    this.bottomborderColor,
    this.fontWeight,
    this.isShow,
    required this.onTap,
    this.fontSize,
  });
  final String headingText;
  final Widget child;
  final Color? bgColor;
  final Color? borderColor;
  final Color? bottomBgColor;
  final Color? bottomborderColor;
  final double? fontSize;
  final bool? isGredient;
  final bool? isShow;
  final FontWeight? fontWeight;
  final Function(int) onTap;
  final int index;
  final int selected;
  @override
  State<CustomDropForAbout> createState() => _CustomDropForAboutState();
}

class _CustomDropForAboutState extends State<CustomDropForAbout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.index == widget.selected) {
          widget.onTap(1000000);
        } else {
          widget.onTap(widget.index);
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.borderColor ?? AppColors.secondaryColor),
              gradient: widget.isGredient != null && widget.isGredient == true
                  ? CommonController.getLinearGradientSecondryAndPrimary()
                  : null,
              color: widget.bgColor ?? AppColors.labelColor21,
              borderRadius: BorderRadius.circular(3.sp),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (widget.index == widget.selected) {
                      widget.onTap(1000000);
                    } else {
                      widget.onTap(widget.index);
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.sp,
                      ),
                      CustomText(
                        fontWeight: widget.fontWeight ?? FontWeight.w600,
                        fontSize: 10.sp,
                        color: widget.isGredient != null &&
                                widget.isGredient == true
                            ? AppColors.white
                            : AppColors.black,
                        text: widget.headingText,
                        textAlign: TextAlign.start,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                      const Spacer(),
                      Icon(
                        widget.index == widget.selected
                            ? Icons.keyboard_arrow_right
                            : Icons.keyboard_arrow_down,
                        color: widget.isGredient != null &&
                                widget.isGredient == true
                            ? AppColors.white
                            : AppColors.hintColor,
                        size: 15.sp,
                      ),
                      SizedBox(
                        width: 5.sp,
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          widget.index == widget.selected
              ? InkWell(
                  onTap: () {},
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 1.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: widget.bottomborderColor ?? Colors.transparent,
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.sp),
                          bottomRight: Radius.circular(5.sp)),
                      color: widget.bottomBgColor ?? AppColors.labelColor22,
                    ),
                    child: widget.child,
                  ),
                )
              : 0.sbh,
        ],
      ),
    );
  }
}
