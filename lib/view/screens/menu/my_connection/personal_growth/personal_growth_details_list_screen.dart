import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_workplace_view.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/personal_growth_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PersonalGrowthDetailsListScreen extends StatefulWidget {
  const PersonalGrowthDetailsListScreen(
      {super.key,
      required this.title,
      required this.currentIndex,
      this.isShowBottomNav = true});
  final String title;
  final int currentIndex;
  final bool isShowBottomNav;
  @override
  State<PersonalGrowthDetailsListScreen> createState() =>
      _PersonalGrowthDetailsListScreenState();
}

class _PersonalGrowthDetailsListScreenState
    extends State<PersonalGrowthDetailsListScreen>
    with TickerProviderStateMixin {
  int index = 0;
  final _myConnectionController = Get.find<MyConnectionController>();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    index = widget.currentIndex;
    var map = <String, dynamic>{};
    if (widget.title == AppString.colleagues) {
      _myConnectionController.getColleaguesData(map);
    }

    if (widget.title == AppString.circleOfInfluenceMyFollower) {
      _myConnectionController.getInfluenceList(map);
    }
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
          // bottomNavigationBar: widget.isShowBottomNav
          //     ? const BottomNavBar(
          //         isFromMain: false,
          //       )
          //     : null,
          body: _buildView()),
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
                      PersonalGrowthListScreen(
                          title: widget.title, loadData: loadData)
                    ]
                  : [
                      PersonalGrowthListScreen(
                          title: widget.title, loadData: loadData)
                    ],
            ),
          ),
        );
      }),
    );
  }
}
