import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomExpansionWidget extends StatefulWidget {
  const CustomExpansionWidget({
    super.key,
    required this.index,
    required this.selected,
    required this.onTap,
    required this.headingText,
    required this.child,
    this.bgColor,
    this.bottomBgColor,
    this.borderColor,
    this.isGredient,
    this.bottomborderColor,
    this.fontWeight,
    this.isShow,
    this.fontSize,
  });
  final int index;
  final int selected;
  final Function(int) onTap;

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
  @override
  State<CustomExpansionWidget> createState() => _CustomExpansionWidgetState();
}

class _CustomExpansionWidgetState extends State<CustomExpansionWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ListTileTheme(
        contentPadding: EdgeInsets.zero,
        dense: true,
        horizontalTitleGap: 0,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          key: Key(widget.index.toString()),
          initiallyExpanded: widget.index == widget.selected,
          title: _buildTitleWidget(),
          onExpansionChanged: ((newState) {
            if (newState) {
              widget.onTap(widget.index);
            } else {
              widget.onTap(widget.selected - 1);
            }
          }),
          children: [widget.child],
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: widget.borderColor ?? AppColors.secondaryColor),
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
              // isShow = !isShow;
              // if (widget.onTap != null) {
              //   widget.onTap!(isShow);
              // }
              // runExpandCheck();
              // setState(() {});
            },
            child: Row(
              children: [
                SizedBox(
                  width: 5.sp,
                ),
                CustomText(
                  fontWeight: widget.fontWeight ?? FontWeight.w600,
                  fontSize: 10.sp,
                  color: widget.isGredient != null && widget.isGredient == true
                      ? AppColors.white
                      : AppColors.black,
                  text: widget.headingText,
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                const Spacer(),
                Icon(
                  widget.selected == widget.index
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_down,
                  color: widget.isGredient != null && widget.isGredient == true
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
    );
  }
}
