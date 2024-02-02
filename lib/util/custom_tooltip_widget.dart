import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  const MyTooltip({super.key, required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      padding: EdgeInsets.all(5.sp),
      margin: EdgeInsets.symmetric(horizontal: 10.sp),
      verticalOffset: 10.sp,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.sp)),
          color: AppColors.labelColor),
      message: parseHtmlString(message),
      textStyle: TextStyle(
        color: Colors.black,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;

    tooltip?.ensureTooltipVisible();
  }
}
