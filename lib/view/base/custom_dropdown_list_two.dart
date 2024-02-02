import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomDropListForMessageTwo extends StatefulWidget {
  final String headingText;
  final Color? bgColor;
  final Color? borderColor;
  final Color? itemBgColor;
  final Color? listTileBgColor;
  final double? fontSize;
  final DropDownOptionItemMenu itemSelected;
  final List<DropDownOptionItemMenu> list;
  final Function(DropDownOptionItemMenu optionItem) onOptionSelected;
  final double? radius;

  const CustomDropListForMessageTwo(
      this.headingText, this.itemSelected, this.list, this.onOptionSelected,
      {super.key,
      this.bgColor,
      this.borderColor,
      this.fontSize,
      this.radius,
      this.itemBgColor,
      this.listTileBgColor});

  @override
  State<CustomDropListForMessageTwo> createState() =>
      _CustomDropListForMessageState();
}

class _CustomDropListForMessageState extends State<CustomDropListForMessageTwo>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.borderColor ??
                    AppColors.labelColor9.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(widget.radius ?? 3.sp),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.bgColor ?? AppColors.labelColor12,
              borderRadius: BorderRadius.circular(widget.radius ?? 5.sp),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 7.sp),
            child: InkWell(
              onTap: () {
                isShow = !isShow;
                _runExpandCheck();
                setState(() {});
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 5.sp,
                  ),
                  widget.itemSelected.icon != null
                      ? Row(
                          children: [
                            Image.asset(
                              widget.itemSelected.icon.toString(),
                              height: 18.sp,
                            ),
                            SizedBox(
                              width: 5.sp,
                            ),
                          ],
                        )
                      : 0.sbh,
                  Expanded(
                    child: CustomText(
                      fontWeight: FontWeight.w500,
                      fontSize: widget.fontSize ?? 10.sp,
                      color: AppColors.black,
                      text: widget.headingText,
                      textAlign: TextAlign.start,
                      overFlow: TextOverflow.ellipsis,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ),
                  Icon(
                    isShow
                        ? Icons.keyboard_arrow_right
                        : Icons.keyboard_arrow_down,
                    color: AppColors.hintColor,
                    size: 15.sp,
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.only(bottom: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.sp),
                      bottomRight: Radius.circular(5.sp)),
                  color: widget.listTileBgColor ?? AppColors.backgroundColor1,
                ),
                child: _buildDropListOptions(widget.list, context))),
      ],
    );
  }

  Container _buildDropListOptions(
      List<DropDownOptionItemMenu> items, BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 40.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            int index = items.indexOf(item);
            bool isLast = items.length - 1 == index;
            if (item.subTitle != null) {
              return _viewForTitleSubTitle(item, context, isLast);
            } else {
              return _buildSubMenu(item, context);
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _viewForTitleSubTitle(
      DropDownOptionItemMenu item, BuildContext context, bool isLast) {
    return GestureDetector(
      onTap: () {
        isShow = false;
        expandController.reverse();
        widget.onOptionSelected(item);
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 2.sp),
        padding: EdgeInsets.all(3.sp),
        decoration: BoxDecoration(
            color: widget.itemBgColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.sp.sbh,
                CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                  color: AppColors.labelColor5,
                  text: item.title,
                  maxLine: 5,
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                CustomText(
                  fontWeight: FontWeight.w400,
                  fontSize: 8.sp,
                  color: AppColors.labelColor5,
                  text: item.subTitle!,
                  maxLine: 5,
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                5.sp.sbh,
                isLast
                    ? 0.sbh
                    : const Divider(
                        color: AppColors.labelColor,
                        height: 0,
                      ),
              ],
            )),
      ),
    );
  }

  Widget _buildSubMenu(DropDownOptionItemMenu item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        isShow = false;
        expandController.reverse();
        widget.onOptionSelected(item);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.sp),
        padding: EdgeInsets.all(2.sp),
        decoration: BoxDecoration(
            color: widget.itemBgColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.sp),
          child: Row(
            children: <Widget>[
              item.icon != null
                  ? Row(
                      children: [
                        Image.asset(
                          item.icon.toString(),
                          height: 18.sp,
                        ),
                        SizedBox(
                          width: 5.sp,
                        ),
                      ],
                    )
                  : 0.sbh,
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: CustomText(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: AppColors.labelColor5,
                    text: item.title,
                    maxLine: 5,
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
