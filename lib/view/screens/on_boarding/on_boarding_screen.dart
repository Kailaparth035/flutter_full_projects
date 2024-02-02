import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_button.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<OnbordingModel> _list = [
    OnbordingModel(
      image: AppImages.step1,
      title: "Insight",
      subTitle: "Elevate Your Growth Journey",
      subTitleList: [
        "10 Journeys",
        "Self-Reflection",
        "Assessments",
        "Reputation feedback"
      ],
    ),
    OnbordingModel(
      image: AppImages.step2,
      title: "Action",
      subTitle: "Elevate Your Growth Journey",
      subTitleList: [
        "eLearning Micro-courses",
        "AI driven OKR Goals",
        "Goal Targeting",
        "DailyQ Reminders",
        " Habit Bullets, Journaling",
      ],
    ),
    OnbordingModel(
      image: AppImages.step3,
      title: "Momentum",
      subTitle: "Elevate Your Growth Journey",
      subTitleList: [
        "Goal Sharing",
        "Coaching Support",
        "Community Cohorts",
        "Reputation feedback",
        "Progress Tracking",
      ],
    )
  ];

  @override
  void initState() {
    Get.find<ProfileSharedPrefService>().setOnboarding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: AppColors.white,
          height: 100.h,
          width: 100.w,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                AppImages.onboardingBg1,
                height: 45.h,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              _pageOneView(context),
            ],
          ),
        ),
      ),
    );
  }

  Column _pageOneView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45.h,
                      child: Column(
                        children: [
                          4.h.sbh,
                          Expanded(
                              flex: 3,
                              child: Image.asset(
                                _list[pageIndex].image,
                                height: double.infinity,
                                fit: BoxFit.fitHeight,
                              )),
                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.sp, vertical: 0.sp),
                                  child: CustomText(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.sp,
                                    color: AppColors.labelColor8,
                                    text: _list[pageIndex].title,
                                    textAlign: TextAlign.center,
                                    maxLine: 2,
                                    fontFamily: AppString.manropeFontFamily,
                                  ),
                                ),
                              )),
                          4.h.sbh,
                        ],
                      ),
                    ),
                    1.h.sbh,
                    Expanded(
                        child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.sp, vertical: 7.sp),
                              child: CustomText(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                color: AppColors.secondaryColor,
                                text: _list[pageIndex].subTitle,
                                textAlign: TextAlign.center,
                                maxLine: 3,
                                fontFamily: AppString.manropeFontFamily,
                              ),
                            ),
                            5.sp.sbh,
                            ..._list[pageIndex]
                                .subTitleList
                                .map((e) => _buildListTile(e)),
                            // ..._list[pageIndex].subTitleList.map(
                            //       (e) => Padding(
                            //         padding: EdgeInsets.all(4.sp),
                            //         child: Column(
                            //           children: [
                            //             Align(
                            //               alignment: _list[pageIndex]
                            //                               .subTitleList
                            //                               .indexOf(e) %
                            //                           2 ==
                            //                       0
                            //                   ? Alignment.centerLeft
                            //                   : Alignment.centerRight,
                            //               child: Container(
                            //                 padding: EdgeInsets.symmetric(
                            //                     horizontal: 10.w),
                            //                 decoration: BoxDecoration(
                            //                   color: AppColors.labelColor45
                            //                       .withOpacity(0.40),
                            //                   borderRadius:
                            //                       const BorderRadius.only(
                            //                     topLeft: Radius.circular(50),
                            //                     bottomRight:
                            //                         Radius.circular(50),
                            //                   ),
                            //                 ),
                            //                 child: Padding(
                            //                   padding: EdgeInsets.symmetric(
                            //                       horizontal: 20.sp,
                            //                       vertical: 2.sp),
                            //                   child: CustomText(
                            //                     fontWeight: FontWeight.w400,
                            //                     fontSize: 11.sp,
                            //                     color: AppColors.labelColor8,
                            //                     text: e,
                            //                     textAlign: TextAlign.left,
                            //                     maxLine: 3,
                            //                     fontFamily:
                            //                         AppString.manropeFontFamily,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     )
                          ],
                        ),
                      ),
                    ))
                  ],
                );
              }),
        ),
        10.sp.sbh,
        Column(
          children: [
            _buildIndicatior(),
            10.sp.sbh,
            Padding(
              padding: EdgeInsets.all(15.sp),
              child: CustomButton(
                  buttonText: _currentIndex != 2 ? "Next" : "Get Started",
                  width: MediaQuery.of(context).size.width,
                  radius: Dimensions.radiusDefault,
                  height: 6.5.h,
                  onPressed: () {
                    if (_currentIndex != 3) {
                      _pageController.animateToPage(
                        _currentIndex++,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                      );
                    } else {
                      Get.offAllNamed(
                          RouteHelper.getSignInRoute(RouteHelper.splash));
                    }
                  }),
            ),
            20.sp.sbh,
          ],
        ),
      ],
    );
  }

  Widget _buildListTile(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 50.sp),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: AppColors.secondaryColor,
              text: title,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          5.sp.sbw,
          SvgPicture.asset(
            SvgImage.switchImage,
            height: 14.sp,
          )
        ],
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
            margin: EdgeInsets.all(2.sp),
            height: 3.sp,
            width: _list.indexOf(e) == _currentIndex ? 45.sp : 12.sp,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              color: _list.indexOf(e) == _currentIndex
                  ? AppColors.black
                  : AppColors.labelColor94,
            ),
          ),
        )
      ],
    );
  }

  // Row _buildAlreadyHaveAcc() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       CustomText(
  //         text: "I have a account !",
  //         textAlign: TextAlign.start,
  //         color: AppColors.labelColor15,
  //         fontFamily: AppString.manropeFontFamily,
  //         fontSize: 11.sp,
  //         fontWeight: FontWeight.w400,
  //       ),
  //       SizedBox(width: 1.w),
  //       GestureDetector(
  //         onTap: () {},
  //         child: CustomText(
  //           text: "Sign In",
  //           textAlign: TextAlign.start,
  //           color: AppColors.labelColor17,
  //           fontFamily: AppString.manropeFontFamily,
  //           fontSize: 11.sp,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
