import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/dashboard/learn_more_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/overlay_popup_widget.dart';
import 'package:aspirevue/view/screens/main/main_screen.dart';
import 'package:aspirevue/view/screens/menu/side_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    super.key,
    required this.isFromMain,
    this.onchange,
  });

  final bool isFromMain;
  final Function(int)? onchange;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var mainController = Get.find<MainController>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _customBottomBar(),
      ],
    );
  }

  Widget _customBottomBar() {
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 4.sp),
        decoration: BoxDecoration(
          color: AppColors.labelColor4,
          borderRadius: BorderRadius.circular(0.sp),
        ),
        height: 56.sp,
        child: Row(
          children: [
            _buildBottomNavItem(
              SvgImage.homeBottom,
              AppString.dashboard,
              mainController.currentBottomSheetIndex.value ==
                  AppConstants.todayIndex,
              AppConstants.todayIndex,
            ),
            _buildBottomNavItem(
              SvgImage.connectionBotton,
              AppString.connections,
              mainController.currentBottomSheetIndex.value ==
                  AppConstants.connectionsIndex,
              AppConstants.connectionsIndex,
            ),
            _buildBottomNavItem(
              SvgImage.cartBottom,
              AppString.store,
              mainController.currentBottomSheetIndex.value ==
                  AppConstants.myProfileIndex,
              AppConstants.myProfileIndex,
            ),
            _buildBottomNavItem(
                SvgImage.discoveryBottom,
                AppString.discover,
                mainController.currentBottomSheetIndex.value ==
                    AppConstants.discoverIndex,
                AppConstants.discoverIndex),
            _buildBottomNavItem(
                SvgImage.menuBottom,
                AppString.menu,
                mainController.currentBottomSheetIndex.value ==
                    AppConstants.menuIndex,
                AppConstants.menuIndex),
          ],
        ),
      );
    });
  }

  Widget _buildBottomNavItem(
      String image, String title, bool isSelected, int tabIndex) {
    return Expanded(
        child: Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.white.withOpacity(0.20),
        onTap: () {
          _navigate(tabIndex);
        },
        borderRadius: BorderRadius.circular(5.sp),
        child: TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 1000),
            tween: ColorTween(
                begin: AppColors.white,
                end: isSelected ? AppColors.primaryColor : AppColors.white),
            builder: (_, Color? color, __) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInBack,
                decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.white.withOpacity(0.20)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5.sp)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    3.sp.sbh,
                    Expanded(
                      flex: 2,
                      child: AnimatedPadding(
                        padding: const EdgeInsets.all(0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInBack,
                        child: Center(
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                image,
                                colorFilter: ColorFilter.mode(
                                    color ?? Colors.transparent,
                                    BlendMode.srcIn),
                                height: isSelected ? 16.sp : 15.sp,
                              ),
                              _buildOverlay(title)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: CustomText(
                      fontWeight: FontWeight.w800,
                      fontSize: isSelected ? 7.8.sp : 7.5.sp,
                      // color: AppColors.white,
                      color: Colors.white,
                      text: title,
                      textAlign: TextAlign.start,
                      fontFamily: AppString.manropeFontFamily,
                    )),
                    5.sp.sbh,
                  ],
                ),
              );
            }),
      ),
    ));
  }

  _buildOverlay(String name) {
    if (name == AppString.connections) {
      return Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
          child: OverlayPopupWidget(
            tooltipController: Get.find<ProfileSharedPrefService>()
                .connectionOverLayController,
            title: AppConstants.connectionOverLayDescription,
            overlayStep: AppConstants.connectionOverLayIndex,
            child: 0.1.sbh,
          ),
        ),
      );
    } else if (name == AppString.store) {
      return Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
          child: OverlayPopupWidget(
            tooltipController:
                Get.find<ProfileSharedPrefService>().storeOverLayController,
            title: AppConstants.storeOverLayDescription,
            overlayStep: AppConstants.storeOverLayIndex,
            child: 0.1.sbh,
          ),
        ),
      );
    } else if (name == AppString.discover) {
      return Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
          child: OverlayPopupWidget(
            tooltipController:
                Get.find<ProfileSharedPrefService>().discoverOverLayController,
            title: AppConstants.discoverOverLayDescription,
            overlayStep: AppConstants.discoverOverLayIndex,
            child: 0.1.sbh,
          ),
        ),
      );
    } else if (name == AppString.menu) {
      return Positioned.fill(
        child: Align(
          alignment: Alignment.topCenter,
          child: OverlayPopupWidget(
            tooltipController:
                Get.find<ProfileSharedPrefService>().menuOverLayController,
            title: AppConstants.menuOverLayDescription,
            overlayStep: AppConstants.menuOverLayIndex,
            child: 0.1.sbh,
          ),
        ),
      );
    } else {
      return 0.sbh;
    }
  }

  _navigate(int val) {
    if (val == AppConstants.menuIndex || val == AppConstants.discoverIndex) {
      if (mainController.currentBottomSheetIndex.value != val) {
        if (val == AppConstants.discoverIndex) {
          Navigator.of(context).push(_goToMenu(const LearnMoreScreen()));
        } else {
          // mainController.addToStackAndNavigate(AppConstants.unSelectedIndex);
          Navigator.of(context).push(_goToMenu(const SideMenuScreen()));
        }
      }
    } else {
      mainController.addToStackAndNavigate(val);
      if (!widget.isFromMain) {
        Get.offAll(const MainScreen(
          isLoadData: false,
        ));
      }
    }
  }

  Route _goToMenu(Widget widgetToGO) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widgetToGO,
      transitionDuration: const Duration(milliseconds: 700),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
