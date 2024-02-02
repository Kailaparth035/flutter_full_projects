import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';

import 'package:aspirevue/view/screens/menu/other_menu_view.dart';
import 'package:aspirevue/view/screens/menu/shortcut_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({super.key});

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  var mainController = Get.find<MainController>();
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (va) {
        // mainController.remoteToStackAndNavigateBack(false);
      },
      child: CommonController.getAnnanotaion(
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor1,
            body: _buildMainView(),
          ),
        ),
      ),
    );
  }

  final tooltipController = AlignedTooltipController();

  void showTooltip() {
    tooltipController.showTooltip();
  }

  Widget _buildMainView() {
    return SizedBox(
      height: context.getHeight,
      width: context.getWidth,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            0.sp.sbh,
            _buildBackIcon(),
            Expanded(
              child: CustomTabBarWidget(
                selectedIndex: index,
                title1: AppString.shortcut,
                title2: "Others",
                child: const Expanded(
                  child: TabBarView(
                    children: [
                      ShortcutMenuView(),
                      OtherMenuView(),
                    ],
                  ),
                ),
              ),
            ),
            3.sp.sbh,
            _buildAppVersion(),
            3.sp.sbh,
          ],
        ),
      ),
    );
  }

  SizedBox _buildAppVersion() {
    return SizedBox(
      width: double.infinity,
      child: CustomText(
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
        color: AppColors.black,
        text: AppConstants.appVersionLable,
        textAlign: TextAlign.center,
        fontFamily: AppString.manropeFontFamily,
      ),
    );
  }

  InkWell _buildBackIcon() {
    return InkWell(
      onTap: () {
        // mainController.remoteToStackAndNavigateBack(false);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(1110),
      child: Container(
        padding: EdgeInsets.only(
            top: 10.sp, left: 10.sp, right: 10.sp, bottom: 10.sp),
        child: Padding(
          padding: EdgeInsets.only(left: (context.isTablet ? 6.sp : 0.sp)),
          child: Image.asset(
            AppImages.appbarBackIc,
            width: context.isTablet ? 12.sp : 17.sp,
            height: context.isTablet ? 12.sp : 17.sp,
          ),
        ),
      ),
    );
  }
}
