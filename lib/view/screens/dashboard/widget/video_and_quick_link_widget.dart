import 'dart:ui';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/quick_link_and_video_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/webview_widget.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_add_quick_links.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/quick_link_shimmer_effect.dart';
import 'package:aspirevue/view/screens/dashboard/my_learning_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/search_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/overlay_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/development_screen.dart';
import 'package:aspirevue/view/screens/menu/enterprice/enterprice_main_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/coaches_mantors_mantees/my_coaches_mentors_mentees_screen.dart';
import 'package:aspirevue/view/screens/menu/my_goals/my_goals_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class VideoAndQuickLinkWidget extends StatefulWidget {
  const VideoAndQuickLinkWidget({super.key});

  @override
  State<VideoAndQuickLinkWidget> createState() =>
      _VideoAndQuickLinkWidgetState();
}

class _VideoAndQuickLinkWidgetState extends State<VideoAndQuickLinkWidget> {
  final _dashboardController = Get.find<DashboardController>();

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      if (dashboardController.isLoadingQuickLinkData) {
        return const QuickLinkShimmer();
      }
      if (dashboardController.isErrorQuickLinkData ||
          dashboardController.quickLinkData == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              dashboardController
                  .getDashboardVideoQuickLinkDetails({}, isShowLoading: true);
            },
            text: dashboardController.isErrorQuickLinkData
                ? dashboardController.errorMsgQuickLinkData
                : AppString.somethingWentWrong,
          ),
        );
      }

      return Column(children: [
        _buildWistiaSliderWidet(dashboardController.quickLinkData!.videos!),
        _buildQuickLinkSection(dashboardController.quickLinkData!),
      ]);
    });
  }

  int currentIndex = 0;
  Widget _buildWistiaSliderWidet(List<VideoForDashboard> videos) {
    if (videos.isEmpty) {
      return 0.sbh;
    } else {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dashboardCardTitle("Getting Started with AspireVue"),
                10.sp.sbh,
                Stack(
                  children: [
                    CarouselSlider.builder(
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          initialPage: 0,
                          height: 150.sp,
                          enlargeCenterPage: true,
                          viewportFraction: 1,
                          reverse: false,
                          autoPlay: false,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          onPageChanged: (index, re) {
                            setState(() {
                              currentIndex = index;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                        itemCount: videos.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                            int pageViewIndex) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  height: context.getWidth,
                                  width: context.getWidth,
                                  child: Stack(
                                    children: [
                                      WebViewWidgetViewForIFrame(
                                          wisatiaID: videos[itemIndex]
                                              .videoLink!
                                              .split("/")
                                              .last),
                                      itemIndex == videos.length - 1
                                          ? _buildHideSection()
                                          : 0.sbh
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    Positioned(
                      bottom: 0,
                      right: 20.sp,
                      child: OverlayPopupWidget(
                        tooltipController: Get.find<ProfileSharedPrefService>()
                            .getStartVideoOverLayController,
                        title: AppConstants.getStartVideoOverLayDescription,
                        overlayStep: AppConstants.getStartVideoOverLayIndex,
                        child: 0.1.sbh,
                      ),
                    )
                  ],
                ),
                5.sp.sbh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...videos.map((e) => Padding(
                          padding: EdgeInsets.only(right: 3.sp),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentIndex == videos.indexOf(e)
                                  ? AppColors.black
                                  : AppColors.labelColor78,
                            ),
                            height: 7.sp,
                            width: 7.sp,
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
          10.sp.sbh,
        ],
      );
    }
  }

  Positioned _buildHideSection() {
    return Positioned(
        top: 10.sp,
        right: 10.sp,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.sp),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.sp),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 3.sp),
                  color: Colors.white.withOpacity(0.1),
                  child: Row(
                    children: [
                      CustomCheckBox(
                        onTap: () {
                          _hideVieoApi();
                        },
                        borderColor: AppColors.labelColor8,
                        fillColor: AppColors.labelColor8,
                        isChecked: false,
                      ),
                      5.sp.sbw,
                      CustomText(
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                        color: AppColors.labelColor3,
                        text: "Hide All",
                        textAlign: TextAlign.start,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _buildQuickLinkSection(QuickLinkAndVideoData data) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: dashboardCardTitle("Quick Links")),
              20.sp.sbw,
              Transform.translate(
                offset: Offset(0, 3.sp),
                child: Stack(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(500),
                      onTap: () async {
                        Get.to(() =>
                            const SearchScreen(isFromHashTagScreen: false));
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
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: OverlayPopupWidget(
                          tooltipController:
                              Get.find<ProfileSharedPrefService>()
                                  .gloabalOverLayController,
                          title: AppConstants.gloabalOverLayDescription,
                          overlayStep: AppConstants.gloabalSearchOverLayIndex,
                          child: 0.5.sp.sbh,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              5.sp.sbw,
              Transform.translate(
                offset: Offset(0, 3.sp),
                child: Stack(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(500),
                      onTap: () async {
                        await Get.find<DashboardController>()
                            .setQuickLinksPopupMain();
                        showDialog(
                          context: Get.context!,
                          builder: (BuildContext context) {
                            return const CustomAlertForAddQuickLink();
                          },
                        );
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
                          Icons.add_rounded,
                          color: AppColors.white,
                          size: 15.sp,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: OverlayPopupWidget(
                          tooltipController:
                              Get.find<ProfileSharedPrefService>()
                                  .quickLinkOverLayController,
                          title: AppConstants.quickLinkOverLayDescription,
                          overlayStep: AppConstants.quickLinkOverLayIndex,
                          child: 0.5.sp.sbh,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        10.sp.sbh,
        _buildSliderBadges(data.quickLinks!),
        10.sp.sbh,
      ],
    );
  }

  Widget _buildSliderBadges(List<QuickLink> quickLinks) {
    return IntrinsicHeight(
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: 5.sp, right: 2.sp, top: 10.sp, bottom: 10.sp),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 15.sp,
                color: AppColors.backgroundColor12,
              ),
            ),
          ),
          Expanded(child: _buildList(quickLinks)),
          InkWell(
            onTap: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  left: 5.sp, right: 2.sp, top: 10.sp, bottom: 10.sp),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15.sp,
                color: AppColors.backgroundColor12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<QuickLink> quickLinks) {
    return SizedBox(
      width: context.getWidth,
      height: 100.sp,
      child: PageView.builder(
        controller: _pageController,
        itemCount: (quickLinks.length / 3).ceil(), // Number of pages
        itemBuilder: (context, pageIndex) {
          int startIndex = pageIndex * 3;
          int endIndex = (startIndex + 3 < quickLinks.length)
              ? startIndex + 3
              : quickLinks.length;

          List<QuickLink> pageItems = quickLinks.sublist(startIndex, endIndex);

          return _getGridView(pageItems);
        },
      ),
    );
  }

  Widget _getGridView(List<QuickLink> data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 7.sp),
      child: GridView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 3.sp, mainAxisSpacing: 3.sp),
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              children: [
                _buildQuickLinkListTile(data[index]),
                data[index].navKey == "development"
                    ? Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: OverlayPopupWidget(
                            tooltipController:
                                Get.find<ProfileSharedPrefService>()
                                    .personalGrowthOverLayController,
                            title:
                                AppConstants.personalGrowthOverLayDescription,
                            overlayStep:
                                AppConstants.personalGrowthOverLayIndex,
                            child: 0.1.sbh,
                          ),
                        ),
                      )
                    : 0.sbh,
                data[index].navKey == "mygoals"
                    ? Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: OverlayPopupWidget(
                            tooltipController:
                                Get.find<ProfileSharedPrefService>()
                                    .goalOverLayController,
                            title: AppConstants.goalOverLayDescription,
                            overlayStep: AppConstants.goalOverLayIndex,
                            child: 0.1.sbh,
                          ),
                        ),
                      )
                    : 0.sbh
              ],
            );
          }),
    );
  }

  Widget _buildQuickLinkListTile(QuickLink quickLink) {
    return Container(
      margin: EdgeInsets.only(
        right: 2.sp,
        left: 2.sp,
        // top: 4.sp,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.labelColor91.withOpacity(0.40),
                  spreadRadius: 0.5,
                  blurRadius: 9,
                  offset: const Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5.sp),
              child: Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(5.sp),
                  onTap: () {
                    _navigate(quickLink.navKey.toString(),
                        quickLink.refernceId.toString(),
                        launchUrl: quickLink.linkUrl);
                  },
                  child: buildQuickLinkColumn(
                      quickLink.icon.toString(), quickLink.title.toString()),
                ),
              ),
            ),
          ),
          quickLink.isShowBadge == 1
              ? Positioned(
                  top: -7.sp,
                  right: -7.sp,
                  child: Container(
                    height: 18.sp,
                    width: 18.sp,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                      AppImages.warningBlackIc,
                    ))),
                  ),
                )
              : 0.sbh
        ],
      ),
    );
  }

  _hideVieoApi() async {
    // var res = await showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return const ConfirmAlertDialLog(
    //       title: "All video will be hide after that!",
    //     );
    //   },
    // );

    Map<String, dynamic> jsonData = {
      "data": [
        {"nav_key": "gettingstartedvideo", "is_selected": 1}
      ],
    };
    bool? res = await _dashboardController
        .updateToViewQuickLinks(quickLinksPopup: [], defaultJsonData: jsonData);

    if (res != null && res == true) {}
  }

  _navigate(String key, String referanceId, {String? launchUrl}) {
    switch (key) {
      case "mygoals":
        Get.to(() => const MyGoalsScreen());
        break;

      case "enterprise":
        Get.to(() => EnterpriceScreen(enterpriseId: referanceId));
        break;

      case "development":
        Get.to(() => const DevelopmentScreen());
        break;

      case "mycoach":
        Get.to(() => const MyCoachMentorsMenteesScreen(
            isShowUnSelectedBottom: true,
            title: AppString.coaches,
            currentIndex: 0));
        break;

      case "mylearning":
        Get.to(() => const MyLearningScreen());
        break;

      case "externallink":
        if (launchUrl != null && launchUrl != "") {
          CommonController.urlLaunch(launchUrl);
        }
        break;

      default:
    }
  }
}
