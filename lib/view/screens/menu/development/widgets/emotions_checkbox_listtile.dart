import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmotionsCheckboxListtile extends StatefulWidget {
  const EmotionsCheckboxListtile({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onChange,
    required this.isReset,
    required this.feelingCount,
  });
  final String title;
  final bool isChecked;
  final Function(bool) onChange;
  final String feelingCount;
  final bool isReset;
  @override
  State<EmotionsCheckboxListtile> createState() =>
      _EmotionsCheckboxListtileState();
}

class _EmotionsCheckboxListtileState extends State<EmotionsCheckboxListtile> {
  bool isChecked = false;
  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EmotionsCheckboxListtile oldWidget) {
    if (widget.isReset == true) {
      setState(() {
        isChecked = widget.isChecked;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.sp),
            child: CustomCheckBox(
              onTap: () {
                widget.onChange(!isChecked);
                setState(() {
                  isChecked = !isChecked;
                });
              },
              borderColor: AppColors.labelColor8,
              fillColor: AppColors.labelColor8,
              isChecked: isChecked,
            ),
          ),
          5.sp.sbw,
          Expanded(
            flex: 1,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.title,
                    style: TextStyle(
                      color: AppColors.labelColor5,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: widget.feelingCount == "0"
                        ? ""
                        : "  ${widget.feelingCount}",
                    style: TextStyle(
                      color: AppColors.labelColor5,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          )
          // Expanded(
          //   flex: 1,
          //   child: CustomText(
          //     fontWeight: FontWeight.w500,
          //     fontSize: 10.sp,
          //     color: AppColors.labelColor5,
          //     text:
          //         "${widget.title} ${widget.feelingCount == "0" ? "" : widget.feelingCount}",
          //     maxLine: 5,
          //     textAlign: TextAlign.start,
          //     fontFamily: AppString.manropeFontFamily,
          //   ),
          // ),
        ],
      ),
    );
  }
}
