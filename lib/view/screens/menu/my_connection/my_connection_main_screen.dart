import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_personal_growth_view.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_workplace_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/string.dart';

class MyConnctionMainScreen extends StatefulWidget {
  const MyConnctionMainScreen(
      {super.key, required this.isShowBottomSheet, required this.onBackPress});
  final bool isShowBottomSheet;
  final Function onBackPress;
  @override
  State<MyConnctionMainScreen> createState() => _MyConnctionMainScreenState();
}

class _MyConnctionMainScreenState extends State<MyConnctionMainScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.myConnections,
            onbackPress: () {
              widget.onBackPress();
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        // bottomNavigationBar: widget.isShowBottomSheet
        //     ? const BottomNavBar(
        //         isFromMain: false,
        //       )
        //     : 0.sbh,
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
          selectedIndex: 0,
          title1: AppString.workPlace,
          title2: AppString.personalGrowth,
          child: Expanded(
            child: TabBarView(
              children: sharedPrefController.profileData.value.isShowMyWorkplace
                          .toString() ==
                      "1"
                  ? const [
                      MyConnectionWorkplaceView(),
                      MyConnectionPersonalGrowthView(),
                    ]
                  : const [
                      MyConnectionPersonalGrowthView(),
                    ],
            ),
          ),
        );
      }),
    );
  }
}
