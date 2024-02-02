import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/profile_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/screens/dashboard/action_items_list_screen.dart';
import 'package:aspirevue/view/screens/dashboard/forum_poll_list_screen.dart';
import 'package:aspirevue/view/screens/dashboard/widget/action_item_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/assigned_test_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/daily_iq_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/polls_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/post_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/video_and_quick_link_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/overlay_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/badge_list_screen.dart';
import 'package:aspirevue/view/screens/menu/store/store_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/insight_stream_controller.dart';
import '../../../util/colors.dart';
import '../../../util/string.dart';
import '../../base/custom_text.dart';
import '../insight_stream/widget/insight_view.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.scaffoldKey});
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _maincontroller = Get.find<MainController>();
  final developmentController = Get.find<DevelopmentController>();
  final profileController = Get.find<ProfileSharedPrefService>();

  @override
  void initState() {
    super.initState();

    if (profileController.isShowOverlayView.value == true) {
      Future.delayed(const Duration(seconds: 3), () {
        if (profileController.isFromNotification.value == false) {
          profileController.showOverLay(AppConstants.profileOverLayIndex);
        }
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            return _maincontroller.initController();
          },
          child: CommonController.getAnnanotaion(
            child: SafeArea(
              child: Scaffold(
                key: _scaffoldKey,
                backgroundColor: AppColors.white,
                body: _buildSliderAppbar(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: _buildFloadingIcon(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildSliderAppbar() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          key: Get.find<ProfileSharedPrefService>().appbarGlobalKey,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,

          flexibleSpace: _buildAppbar(),
          // snap: true,
          // floating: true,
          pinned: false,
          snap: false,
          floating: true,
          collapsedHeight: AppConstants.appBarHeight + 15.sp,
          expandedHeight: AppConstants.appBarHeight + 15.sp,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildMainView(), //ListTile
            childCount: 1,
          ),
        )
      ],
    );
  }

  _buildFloadingIcon() {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      if (dashboardController.quickLinkData != null &&
          dashboardController.quickLinkData!.isShowMyChecklist == 1) {
        return Stack(
          children: [
            buildFloatingIconForDashboard(),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: OverlayPopupWidget(
                  isShowFinishButtonButton: true,
                  isShowNextButton: false,
                  tooltipController: Get.find<ProfileSharedPrefService>()
                      .startUpMenuOverLayController,
                  title: AppConstants.startUpMenuOverLayDescription,
                  overlayStep: AppConstants.startUpMenuOverLayIndex,
                  child: 0.1.sbh,
                ),
              ),
            )
          ],
        );
      } else {
        return 0.sbh;
      }
    });
  }

  SingleChildScrollView _buildMainView() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: GetBuilder<ProfileSharedPrefService>(
        builder: (sharedPrefController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              1.h.sbh,
              // InkWell(
              //     onTap: () {
              //       Get.to(const OnBoardingScreen());
              //     },
              //     child: Text("text")),
              _buildTrialWidget(),
              _buildAssignTest(),
              Container(
                  key: Get.find<ProfileSharedPrefService>()
                      .videoANDQUickLinkGlobalKey,
                  child: const VideoAndQuickLinkWidget()),
              _buildTitle("Insight Stream"),
              15.sp.sbh,
              _buildPost(),
              5.sp.sbh,
              _buildInsightView(),
              _buildActionItem(),
              _buildDailyQSection(),
              _buildPollForum(),
              50.sp.sbh,
            ],
          );
        },
      ),
    );
  }

  _buildTitle(title) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Row(
        children: [
          Expanded(child: dashboardCardTitle(title)),
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.35),
                spreadRadius: -0.5,
                blurRadius: 5,
                offset: const Offset(0, 0.7),
              ),
            ]),
            child: Material(
              borderRadius: BorderRadius.circular(255),
              clipBehavior: Clip.none,
              child: InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getInsightStreamRoute());
                },
                borderRadius: BorderRadius.circular(255),
                child: Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: SvgPicture.asset(
                    SvgImage.insightIc,
                    height: 15.sp,
                    width: 15.sp,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTrialWidget() {
    return GetBuilder<ProfileSharedPrefService>(
        builder: (sharedPrefController) {
      return sharedPrefController.profileData.value.expirationText != ""
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.h),
              child: InkWell(
                onTap: () {
                  Get.to(() => const StoreMainScreen(isFromMenu: false));
                },
                child: Column(
                  children: [
                    5.sp.sbh,
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: CommonController.getBoxShadow,
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(6.sp)),
                          child: Container(
                            padding: EdgeInsets.all(8.sp),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color:
                                    AppColors.secondaryColor.withOpacity(0.38),
                                borderRadius: BorderRadius.circular(6.sp)),
                            child: CustomText(
                              fontWeight: FontWeight.w700,
                              fontSize: 11.sp,
                              color: AppColors.labelColor3,
                              text: sharedPrefController
                                  .profileData.value.expirationText
                                  .toString(),
                              textAlign: TextAlign.start,
                              fontFamily: AppString.manropeFontFamily,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -8.sp,
                          right: 1.sp,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 7.sp,
                                top: 1.sp,
                                bottom: 2.sp,
                                right: 7.sp),
                            decoration: BoxDecoration(
                                color: AppColors.labelColor17,
                                borderRadius: BorderRadius.circular(20.sp)),
                            child: CustomText(
                              fontWeight: FontWeight.w700,
                              fontSize: 9.sp,
                              color: AppColors.white,
                              text: "Activate AspireVue",
                              textAlign: TextAlign.start,
                              fontFamily: AppString.manropeFontFamily,
                            ),
                          ),
                        )
                      ],
                    ),
                    10.sp.sbh,
                  ],
                ),
              ),
            )
          : 0.sbh;
    });
  }

  Padding _buildPost() {
    return Padding(
      key: Get.find<ProfileSharedPrefService>().insightGlobalKey,
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: const PostWidget(),
    );
  }

  Padding _buildAppbar() {
    return Padding(
      padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 1.h, bottom: 1.h),
      child:
          GetBuilder<ProfileSharedPrefService>(builder: (sharedPrefController) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: _buildProfileIconAndBAdge(sharedPrefController)),
            sharedPrefController.profileData.value.badgePhoto == ""
                ? Expanded(
                    flex: 3,
                    child: 0.sbh,
                  )
                : Expanded(
                    flex: 3,
                    child: _buildBadge(sharedPrefController.profileData.value)),
            Expanded(
              flex: 10,
              child: sharedPrefController.profileData.value.companyPhoto != ""
                  ? Padding(
                      padding: EdgeInsets.only(left: 10.sp, right: 20.sp),
                      child: CustomImage(
                        height: 30.sp,
                        image: sharedPrefController
                            .profileData.value.companyPhoto
                            .toString(),
                        fit: BoxFit.contain,
                      ),
                    )
                  : const Spacer(),
            ),
            _buildNotificationICon(),
            Container(
              height: 30.sp,
              width: 40.sp,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    AppImages.aspireHeaderLogo,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProfileIconAndBAdge(
      ProfileSharedPrefService sharedPrefController) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            widget.scaffoldKey.currentState!.openEndDrawer();
          },
          child: FittedBox(
            child: CustomImageForProfile(
              image: sharedPrefController.profileData.value.photo.toString(),
              radius: 18.sp,
              nameInitials:
                  sharedPrefController.profileData.value.name![0].toString(),
              borderColor: AppColors.labelColor,
            ),
          ),
        ),
        Positioned.fill(
          // bottom: 0,
          // right: 15.sp,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: OverlayPopupWidget(
              isShowPreviousButton: false,
              tooltipController:
                  Get.find<ProfileSharedPrefService>().profileOverLayController,
              title: AppConstants.profileOverLayDescription,
              overlayStep: AppConstants.profileOverLayIndex,
              child: 0.1.sbh,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNotificationICon() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.notificationScreen);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 2.sp),
            child: Transform.translate(
              offset: Offset(0, 7.sp),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    SvgImage.notification,
                    colorFilter:
                        const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                    height: 19.sp,
                  ),
                  Obx(() => _maincontroller.notificationCount.value != 0
                      ? Positioned(
                          top: -3.sp,
                          right: 0.sp,
                          child: Container(
                            height: 8.sp,
                            width: 8.sp,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.white, width: 1.sp),
                              color: AppColors.labelColor92,
                              shape: BoxShape.circle,
                            ),
                          ))
                      : 0.sbw)
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
            // bottom: 0,
            // right: 15.sp,
            child: Align(
          alignment: Alignment.bottomCenter,
          child: OverlayPopupWidget(
            tooltipController: Get.find<ProfileSharedPrefService>()
                .notificationOverLayController,
            title: AppConstants.notificationOverLayDescription,
            overlayStep: AppConstants.notificationOverLayIndex,
            child: 0.1.sbh,
          ),
        ))
      ],
    );
  }

  Widget _buildBadge(ProfileData data) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BadgeListScreen(
            userId: data.id.toString(), title: "My Journey Summary"));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: CustomImage(
                image: data.badgePhoto.toString(),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          2.sp.sbh,
          Expanded(
            flex: 3,
            child: CustomText(
              text: data.badgeName.toString(),
              textAlign: TextAlign.center,
              color: AppColors.black,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  GetBuilder<InsightStreamController> _buildInsightView() {
    return GetBuilder<InsightStreamController>(builder: (mainController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InsightView(
            mainController,
            "",
            isShowCommnetSection: false,
          ),
          _buildInsightStreemViewAll(),
          5.sp.sbh
        ],
      );
    });
  }

  Padding _buildAssignTest() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: const AssignedTestWidget(
        isFromWidget: true,
      ),
    );
  }

  Padding _buildDailyQSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: GetBuilder(builder: (DashboardController dashboardController) {
        if (dashboardController.quickLinkData != null &&
            dashboardController.quickLinkData!.isShowDailyqSection == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              5.sp.sbh,
              dashboardCardTitle(AppString.dailyQ),
              10.sp.sbh,
              DailyIQWidget(
                isShowBullets:
                    dashboardController.quickLinkData!.isShowBullet == 1,
                isShowjournal:
                    dashboardController.quickLinkData!.isShowJournal == 1,
              ),
              15.sp.sbh,
            ],
          );
        } else {
          return 0.sbh;
        }
      }),
    );
  }

  Widget _buildPollForum() {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return Padding(
        key: Get.find<ProfileSharedPrefService>().forumPollGlobalKey,
        padding: EdgeInsets.symmetric(horizontal: 1.2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.8.h),
              child: Stack(
                children: [
                  dashboardCardTitle(AppString.forumPolls),
                  Positioned(
                    bottom: 0,
                    right: 20.sp,
                    child: OverlayPopupWidget(
                      tooltipController: Get.find<ProfileSharedPrefService>()
                          .forumPullOverLayController,
                      title: AppConstants.forumPullOverLayDescription,
                      overlayStep: AppConstants.forumPullOverLayIndex,
                      child: 0.1.sbh,
                    ),
                  )
                ],
              ),
            ),
            5.sp.sbh,
            const PollsWidget(),
            5.sp.sbh,
            _buildForumPollViewall(),
            15.sp.sbh,
          ],
        ),
      );
      // }
    });
  }

  Widget _buildForumPollViewall() {
    return InkWell(
      onTap: () {
        Get.to(() => const ForumPollListScreen());
      },
      child: buildViewALL(),
    );
  }

  Widget _buildInsightStreemViewAll() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      child: GestureDetector(
        onTap: () => Get.toNamed(RouteHelper.getInsightStreamRoute()),
        child: buildViewALL(),
      ),
    );
  }

  // Widget _buildPositionDescription() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 2.h),
  //     child: CustomText(
  //       fontWeight: FontWeight.w500,
  //       fontSize: 13.sp,
  //       color: AppColors.hintColor,
  //       text: "As of now, I’m in control here in the White House.",
  //       textAlign: TextAlign.start,
  //       maxLine: 10,
  //       fontFamily: AppString.manropeFontFamily,
  //     ),
  //   );
  // }

  // Widget _buildWecomeText(ProfileSharedPrefService sharedPrefController) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 2.h),
  //     child: CustomText(
  //       fontWeight: FontWeight.w700,
  //       fontSize: 13.sp,
  //       color: AppColors.labelColor3,
  //       text:
  //           "${AppString.welcome}, ${sharedPrefController.profileData.value.name}",
  //       textAlign: TextAlign.start,
  //       fontFamily: AppString.manropeFontFamily,
  //     ),
  //   );
  // }

  Widget _buildActionItem() {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      if (dashboardController.isErrorActionItemList == false &&
          dashboardController.isLoadingActionItemList == false &&
          dashboardController.actionItemList.isEmpty) {
        return 0.sbh;
      } else {
        return Padding(
          key: Get.find<ProfileSharedPrefService>().actionItemGlobalKey,
          padding: EdgeInsets.symmetric(horizontal: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  dashboardCardTitle(AppString.actionItems),
                  Positioned(
                    bottom: 0,
                    right: 20.sp,
                    child: OverlayPopupWidget(
                      tooltipController: Get.find<ProfileSharedPrefService>()
                          .actionItemOverLayController,
                      title: AppConstants.actionItemStreamOverLayDescription,
                      overlayStep: AppConstants.actionItemOverLayIndex,
                      child: 0.1.sbh,
                    ),
                  )
                ],
              ),
              10.sp.sbh,
              ActionItemWidget(
                dashboardController: dashboardController,
                isFromWidget: true,
              ),
              5.sp.sbh,
              InkWell(
                onTap: () {
                  Get.to(() => const ActionItemListScreen());
                },
                child: buildViewALL(),
              ),
            ],
          ),
        );
      }
    });
  }
}
