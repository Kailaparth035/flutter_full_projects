import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/screens/dashboard/widget/assigned_test_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AssignTestListScreen extends StatefulWidget {
  const AssignTestListScreen({super.key});

  @override
  State<AssignTestListScreen> createState() => _AssignTestScreeListState();
}

class _AssignTestScreeListState extends State<AssignTestListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              appbarTitle: AppString.assignedTest,
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
                return Get.find<DashboardController>().getAssignedTests({});
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AssignedTestWidget(isFromWidget: false),
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
