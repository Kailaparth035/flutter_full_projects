import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../util/colors.dart';
import '../../util/dimension.dart';
import '../../util/images.dart';
import '../../util/string.dart';
import 'custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final bool isBorder;
  final Function onBackPressed;
  final bool showActionIcon;
  final BuildContext context;
  final Function? onPressed;
  final Function? onSearch;

  final Color backgroundColor;
  final Color textColor;
  final Color iconButtonColor;
  final String actionImage;

  final bool isShowCreatePost;
  final bool isShowSearchPost;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.isBackButtonExist = true,
      this.isBorder = true,
      required this.onBackPressed,
      this.showActionIcon = false,
      this.onPressed,
      this.onSearch,
      required this.context,
      this.backgroundColor = AppColors.white,
      this.textColor = AppColors.primaryColor,
      this.iconButtonColor = AppColors.primaryColor,
      this.isShowCreatePost = true,
      this.isShowSearchPost = false,
      this.actionImage = AppImages.addWidget});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: CustomText(
        color: textColor,
        text: title,
        textAlign: TextAlign.start,
        fontFamily: AppString.manropeFontFamily,
        fontSize: context.isTablet ? 10.sp : 18.sp,
        fontWeight: FontWeight.w600,
      ),
      actions: showActionIcon
          ? [
              isShowSearchPost == true
                  ? GestureDetector(
                      onTap: () {
                        if (onSearch != null) {
                          onSearch!();
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            right: isShowCreatePost ? 5.sp : 10.sp),
                        decoration: BoxDecoration(
                            boxShadow: CommonController.getBoxShadow,
                            borderRadius: BorderRadius.circular(200),
                            gradient: CommonController
                                .getLinearGradientSecondryAndPrimary()),
                        child: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Icon(
                            Icons.search,
                            color: AppColors.white,
                            size: 4.w,
                          ),
                        ),
                      ),
                    )
                  : 0.sbh,
              isShowCreatePost == true
                  ? GestureDetector(
                      onTap: () => onPressed!(),
                      child: Container(
                        margin: EdgeInsets.only(right: 10.sp),
                        decoration: BoxDecoration(
                            boxShadow: CommonController.getBoxShadow,
                            borderRadius: BorderRadius.circular(200),
                            gradient: CommonController
                                .getLinearGradientSecondryAndPrimary()),
                        child: Padding(
                          padding: EdgeInsets.all(3.sp),
                          child: Icon(
                            Icons.add,
                            color: AppColors.white,
                            size: 5.w,
                          ),
                        ),
                      ))
                  : 0.sbh,
            ]
          : null,
      titleSpacing: 0,
      centerTitle: false,
      shape: isBorder
          ? const Border(
              bottom: BorderSide(color: AppColors.labelColor9, width: 0.2))
          : null,
      leading: isBackButtonExist
          ? IconButton(
              icon: const Icon(Icons.arrow_back_outlined),
              color: iconButtonColor,
              iconSize: 3.5.h,
              onPressed: () {
                onBackPressed();
              },
            )
          : const SizedBox(),
      leadingWidth: isBackButtonExist ? 12.w : 2.w,
      backgroundColor: backgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize =>
      Size(Dimensions.webMixWidth, context.isTablet ? 60 : 50);
}
