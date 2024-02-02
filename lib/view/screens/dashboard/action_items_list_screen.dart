import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/screens/dashboard/widget/action_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ActionItemListScreen extends StatefulWidget {
  const ActionItemListScreen({super.key});

  @override
  State<ActionItemListScreen> createState() => _ActionItemListScreenState();
}

class _ActionItemListScreenState extends State<ActionItemListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: PopScope(
        canPop: true,
        // onWillPop: () {
        //   return Future.value(true);
        // },
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              appbarTitle: AppString.actionItems,
              onbackPress: () {
                Navigator.pop(context);
              },
            ),
          ),
          // bottomNavigationBar: const BottomNavBar(
          //   isFromMain: false,
          // ),
          backgroundColor: AppColors.backgroundColor1,
          body: Container(
            padding: EdgeInsets.only(
                top: AppConstants.screenHorizontalPadding,
                left: AppConstants.screenHorizontalPadding,
                right: AppConstants.screenHorizontalPadding),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: RefreshIndicator(
              onRefresh: () {
                return Get.find<DashboardController>().getActionItems({});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<DashboardController>(
                        builder: (dashboardController) {
                      return ActionItemWidget(
                        dashboardController: dashboardController,
                        isFromWidget: false,
                      );
                    }),
                    SizedBox(
                      height: 30.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
