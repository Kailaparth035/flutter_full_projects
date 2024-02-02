import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/director_supervisor/workplace_list_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_personal_growth_view.dart';
import 'package:flutter/material.dart';

class WorkPlaceDetailsListScreen extends StatefulWidget {
  const WorkPlaceDetailsListScreen({super.key, required this.title});
  final String title;
  @override
  State<WorkPlaceDetailsListScreen> createState() =>
      _WorkPlaceDetailsListScreenState();
}

class _WorkPlaceDetailsListScreenState
    extends State<WorkPlaceDetailsListScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.myConnections,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        // bottomNavigationBar: const BottomNavBar(
        //   isFromMain: false,
        // ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding),
          child: CustomTabBarWidget(
            selectedIndex: index,
            title1: AppString.workPlace,
            title2: AppString.personalGrowth,
            child: Expanded(
              child: TabBarView(
                children: [
                  WorkplaceScreen(title: widget.title),
                  const MyConnectionPersonalGrowthView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
