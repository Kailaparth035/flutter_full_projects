import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/growth_community_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_workplace_view.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/growth_community_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GrowthCommunityScreen extends StatefulWidget {
  const GrowthCommunityScreen(
      {super.key,
      required this.title,
      required this.currentIndex,
      required this.isShowUnselectedBottomSheet});
  final String title;
  final int currentIndex;
  final bool isShowUnselectedBottomSheet;
  @override
  State<GrowthCommunityScreen> createState() => _GrowthCommunityScreenState();
}

class _GrowthCommunityScreenState extends State<GrowthCommunityScreen>
    with TickerProviderStateMixin {
  final _growthCommunityController = Get.find<GrowthCommunityController>();

  @override
  void initState() {
    super.initState();

    _growthCommunityController.getGrowthCommunityUserWithPagination(true, "");
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.myConnections,
            isShowSearchIcon: true,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        // bottomNavigationBar: widget.isShowUnselectedBottomSheet
        //     ? null
        //     : const BottomNavBar(
        //         isFromMain: false,
        //       ),
        body: _buildView(),
      ),
    );
  }

  Padding _buildView() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child:
          GetBuilder<ProfileSharedPrefService>(builder: (sharedPrefController) {
        return CustomTabBarWidget(
          length: sharedPrefController.profileData.value.isShowMyWorkplace
                      .toString() ==
                  "1"
              ? 2
              : 1,
          selectedIndex: sharedPrefController
                      .profileData.value.isShowMyWorkplace
                      .toString() ==
                  "1"
              ? widget.currentIndex
              : 0,
          title1: AppString.workPlace,
          title2: AppString.personalGrowth,
          child: Expanded(
            child: TabBarView(
              children: sharedPrefController.profileData.value.isShowMyWorkplace
                          .toString() ==
                      "1"
                  ? [
                      const MyConnectionWorkplaceView(),
                      GrowthCommunityListScreen(
                          title: widget.title, loadData: (searchText) {})
                    ]
                  : [
                      GrowthCommunityListScreen(
                          title: widget.title, loadData: (searchText) {})
                    ],
            ),
          ),
        );
      }),
    );
  }
}
