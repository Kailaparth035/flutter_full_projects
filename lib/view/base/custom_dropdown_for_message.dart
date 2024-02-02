import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomDropListForMessage extends StatefulWidget {
  final String headingText;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final DropDownOptionItemMenu itemSelected;
  final DropListModel dropListModel;
  final Function(DropDownOptionItemMenu optionItem) onOptionSelected;

  const CustomDropListForMessage(this.headingText, this.itemSelected,
      this.dropListModel, this.onOptionSelected,
      {super.key, this.bgColor, this.borderColor, this.fontSize});

  @override
  State<CustomDropListForMessage> createState() =>
      _CustomDropListForMessageState();
}

class _CustomDropListForMessageState extends State<CustomDropListForMessage>
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
            borderRadius: BorderRadius.circular(3.sp),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.bgColor ?? AppColors.labelColor12,
              borderRadius: BorderRadius.circular(3.sp),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
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
                  color: AppColors.backgroundColor1,
                ),
                child: _buildDropListOptions(
                    widget.dropListModel.listOptionItems, context))),
      ],
    );
  }

  Container _buildDropListOptions(
      List<DropDownOptionItemMenu> items, BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 40.h),
      child: SingleChildScrollView(
        child: Column(
          children: items.map((item) => _buildSubMenu(item, context)).toList(),
        ),
      ),
    );
  }

  Widget _buildSubMenu(DropDownOptionItemMenu item, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.sp),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: widget.fontSize ?? 10.sp,
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
        onTap: () {
          isShow = false;
          expandController.reverse();
          widget.onOptionSelected(item);
        },
      ),
    );
  }
}
