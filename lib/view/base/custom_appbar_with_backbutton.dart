import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AppbarWithBackButton extends StatelessWidget {
  const AppbarWithBackButton({
    super.key,
    required this.appbarTitle,
    this.onbackPress,
    this.isShowBackButton = true,
    this.bgColor,
    this.fontSize,
    this.elevation = 0,
    this.leftPadding,
    this.isShowHelpIcon = false,
    this.isShowSearchIcon = false,
    this.onHelpTap,
  });
  final String appbarTitle;

  final bool isShowBackButton;

  final double elevation;
  final Color? bgColor;
  final Function? onbackPress;
  final double? leftPadding;
  final double? fontSize;
  final bool isShowHelpIcon;
  final bool isShowSearchIcon;
  final Function? onHelpTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: elevation,
        toolbarHeight: 45.sp,
        backgroundColor: bgColor ?? AppColors.backgroundColor1,
        leadingWidth: 0,
        centerTitle: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            isShowBackButton == true
                ? InkWell(
                    onTap: () {
                      if (onbackPress == null) {
                        Get.back();
                      } else {
                        onbackPress!();
                      }
                    },
                    borderRadius: BorderRadius.circular(1110),
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10.sp, right: 10.sp, bottom: 10.sp),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: leftPadding != null
                                ? (context.isTablet
                                    ? leftPadding! + 6.sp
                                    : leftPadding!)
                                : (context.isTablet ? 6.sp : 0.sp)),
                        child: Image.asset(
                          AppImages.appbarBackIc,
                          width: context.isTablet ? 12.sp : 16.sp,
                          height: context.isTablet ? 12.sp : 16.sp,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            context.isTablet ? 0.sp.sbw : 5.sp.sbw,
            Expanded(
              child: CustomText(
                text: appbarTitle,
                textAlign: TextAlign.start,
                color: AppColors.labelColor8,
                fontFamily: AppString.manropeFontFamily,
                fontSize: fontSize ?? 18.sp,
                maxLine: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            isShowHelpIcon
                ? InkWell(
                    onTap: () {
                      if (onHelpTap != null) {
                        onHelpTap!();
                      }
                    },
                    borderRadius: BorderRadius.circular(500),
                    child: Padding(
                      padding: EdgeInsets.all(2.sp),
                      child: SvgPicture.asset(
                        SvgImage.questionGradient,
                        height: 20.sp,
                      ),
                    ),
                  )
                : 0.sbw,
            isShowSearchIcon
                ? InkWell(
                    borderRadius: BorderRadius.circular(500),
                    onTap: () async {
                      Get.to(
                          () => const SearchScreen(isFromHashTagScreen: false));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: CommonController.getBoxShadow,
                        gradient: CommonController
                            .getLinearGradientSecondryAndPrimary(),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        color: AppColors.white,
                        size: 15.sp,
                      ),
                    ),
                  )
                : 0.sbw,
          ],
        ),
      ),
    );
  }
}
