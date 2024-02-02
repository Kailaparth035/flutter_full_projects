import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomDropList extends StatefulWidget {
  final String headingIcon;
  final String headingText;
  final DropDownOptionItemMenu itemSelected;
  final DropListModel dropListModel;
  final Function? onTap;
  final Function(DropDownOptionItemMenu optionItem) onOptionSelected;

  const CustomDropList(this.headingIcon, this.headingText, this.itemSelected,
      this.dropListModel, this.onOptionSelected,
      {super.key, this.onTap});

  @override
  State<CustomDropList> createState() => _CustomDropListState();
}

class _CustomDropListState extends State<CustomDropList>
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
            gradient: isShow
                ? CommonController.getLinearGradientSecondryAndPrimary()
                : const LinearGradient(
                    colors: [
                      AppColors.backgroundColor1,
                      AppColors.backgroundColor1,
                    ],
                  ),
            borderRadius: BorderRadius.circular(8.sp),
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: isShow ? AppColors.white : AppColors.backgroundColor1,
              borderRadius: BorderRadius.circular(7.sp),
            ),
            padding: EdgeInsets.all(5.sp),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!();
                    } else {
                      isShow = !isShow;
                      _runExpandCheck();
                      setState(() {});
                    }
                  },
                  child: Row(
                    children: [
                      Image.asset(widget.headingIcon, height: 14.sp),
                      SizedBox(
                        width: 5.sp,
                      ),
                      CustomText(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: AppColors.black,
                        text: widget.headingText,
                        textAlign: TextAlign.start,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                      const Spacer(),
                      Icon(
                        !isShow
                            ? Icons.keyboard_arrow_right
                            : Icons.keyboard_arrow_down,
                        color: AppColors.black,
                        size: 13.sp,
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
        ),
        SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: animation,
            child: Container(
                margin: EdgeInsets.only(bottom: 1.h),
                padding: EdgeInsets.only(bottom: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.sp),
                      bottomRight: Radius.circular(10.sp)),
                  color: AppColors.backgroundColor1,
                ),
                child: _buildDropListOptions(
                    widget.dropListModel.listOptionItems, context))),
      ],
    );
  }

  Column _buildDropListOptions(
      List<DropDownOptionItemMenu> items, BuildContext context) {
    return Column(
      children: items.map((item) => _buildSubMenu(item, context)).toList(),
    );
  }

  Widget _buildSubMenu(DropDownOptionItemMenu item, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.sp),
      child: Material(
        child: InkWell(
          onTap: () {
            isShow = false;
            expandController.reverse();
            widget.onOptionSelected(item);
          },
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(6.sp),
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
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
