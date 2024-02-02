import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_gradient_text.dart';
import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';

class SelfReflactViewPopUp extends StatefulWidget {
  const SelfReflactViewPopUp(
      {super.key,
      required this.child,
      required this.title,
      required this.desc,
      required this.isHtml});
  final Widget child;
  final String title;
  final String desc;
  final bool isHtml;
  @override
  State<SelfReflactViewPopUp> createState() => _SelfReflactViewPopUpState();
}

class _SelfReflactViewPopUpState extends State<SelfReflactViewPopUp> {
  final tooltipController = AlignedTooltipController();
  @override
  Widget build(BuildContext context) {
    return AlignedTooltip(
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: AppColors.backgroundColor1,
      controller: tooltipController,
      shadow: const Shadow(color: Colors.transparent),
      isModal: true,
      content: _buildView(),
      child: GestureDetector(
          onTap: () {
            tooltipController.showTooltip();
          },
          child: widget.child),
    );
  }

  Widget _buildView() => Container(
        width: context.getWidth,
        height: widget.isHtml ? context.getWidth : null,
        constraints: BoxConstraints(
          maxHeight: context.getWidth,
        ),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor1,
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomGradientText(
                fontWeight: FontWeight.w500,
                text: widget.title,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
              ),
              const Divider(),
              widget.isHtml
                  ? Html(
                      data: widget.desc,
                      style: {
                        "*": Style(
                          padding: HtmlPaddings.all(0.sp),
                          margin: Margins.symmetric(
                              vertical: 5.sp, horizontal: 5.sp),
                        )
                      },
                    )
                  : Text(widget.desc),

              // Html(
              //   data: widget.desc,
              //   style: {
              //     "*": Style(
              //       padding: HtmlPaddings.all(0.sp),
              //       margin: Margins.symmetric(vertical: 5.sp, horizontal: 5.sp),
              //     )
              //   },
              // ),
            ],
          ),
        ),
      );
}

class SelfReflactViewPopUpWithChild extends StatefulWidget {
  const SelfReflactViewPopUpWithChild(
      {super.key, required this.child, required this.showChild});
  final Widget child;
  final Widget showChild;

  @override
  State<SelfReflactViewPopUpWithChild> createState() =>
      _SelfReflactViewPopUpWithChildState();
}

class _SelfReflactViewPopUpWithChildState
    extends State<SelfReflactViewPopUpWithChild> {
  final tooltipController = AlignedTooltipController();
  @override
  Widget build(BuildContext context) {
    return AlignedTooltip(
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: AppColors.backgroundColor1,
      controller: tooltipController,
      shadow: const Shadow(color: Colors.transparent),
      isModal: true,
      content: widget.showChild,
      child: GestureDetector(
          onTap: () {
            tooltipController.showTooltip();
          },
          child: widget.child),
    );
  }
}
