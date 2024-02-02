import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';

import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/screens/welcome_screens/congratulations_screen.dart';
import 'package:aspirevue/view/screens/welcome_screens/how_journey_work_step_screen.dart';
import 'package:aspirevue/view/screens/welcome_screens/import_contact_step_screen.dart';
import 'package:aspirevue/view/screens/welcome_screens/notification_allow_screen.dart';
import 'package:aspirevue/view/screens/welcome_screens/profile_update_step_screen.dart';
import 'package:aspirevue/view/screens/welcome_screens/welcome_step_screen.dart';
import 'package:aspirevue/view/screens/welcome_screens/what_interest_step_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WelcomeMainScreen extends StatefulWidget {
  const WelcomeMainScreen({super.key});

  @override
  State<WelcomeMainScreen> createState() => _WelcomeMainScreenState();
}

class _WelcomeMainScreenState extends State<WelcomeMainScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int _currentIndex = 0;
  List<Widget> _list = [];

  @override
  void initState() {
    Get.find<MainController>().getWelcomeHashtags();
    bool isShow =
        Get.find<ProfileSharedPrefService>().isShowTrailScreen.value == true;
    if (isShow) {
      _list = [
        const WelcomeStepScreen(),
        const HowJourneyWorkStepScreen(),
        ImportContactsStepScreen(onPageChage: () {
          _changePage();
        }),
        const WhatInterestStepsScreen(),
        const ProfileUpdateStepScreen(),
        const NotificationAllowScreen(),
      ];
    } else {
      _list = [
        ImportContactsStepScreen(onPageChage: () {
          _changePage();
        }),
        const WhatInterestStepsScreen(),
        const ProfileUpdateStepScreen(),
        const NotificationAllowScreen(),
      ];
    }

    super.initState();
  }

  _changePage() {
    setState(() {
      _currentIndex++;
    });
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CommonController.getAnnanotaion(
        color: Colors.transparent,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 40.sp),
            child: buildFloatingIconForWelcome(onTap: () {
              if (_currentIndex + 1 == _list.length) {
                Get.to(const CongratulationScreen());
              } else {
                setState(() {
                  _currentIndex++;
                  _pageController.animateToPage(
                    _currentIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                });
              }
            }),
          ),
          body: SizedBox(
            height: context.getHeight,
            width: context.getWidth,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (val) {
                      setState(() {
                        _currentIndex = val;
                      });
                    },
                    itemCount: _list.length, // Number of pages
                    itemBuilder: (context, pageIndex) {
                      return _list[pageIndex];
                    },
                  ),
                ),
                _buildIndicatior(),
                20.h.sbh
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildIndicatior() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._list.map(
          (e) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.all(3.sp),
            height: _list.indexOf(e) == _currentIndex ? 7.sp : 6.sp,
            width: _list.indexOf(e) == _currentIndex ? 7.sp : 6.sp,
            decoration: BoxDecoration(
              gradient: _list.indexOf(e) == _currentIndex
                  ? CommonController.getLinearGradientSecondryAndPrimary()
                  : null,
              borderRadius: BorderRadius.circular(200),
              color: AppColors.editBoarderColor1,
            ),
          ),
        )
      ],
    );
  }
}
