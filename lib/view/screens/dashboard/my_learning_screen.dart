import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/my_learning_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/e_learning_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyLearningScreen extends StatefulWidget {
  const MyLearningScreen({super.key});

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> {
  final _dashboardController = Get.find<DashboardController>();
  @override
  void initState() {
    _dashboardController.getMyLearning(isShowLoading: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              bgColor: AppColors.white,
              appbarTitle: "My Learning",
              onbackPress: () async {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: AppColors.white,
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: _buildMainView(),
          )),
    );
  }

  Widget _buildMainView() {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      if (dashboardController.isLoadingMyLearning) {
        return const Center(child: CustomLoadingWidget());
      }
      if (dashboardController.isErrorMyLearning ||
          dashboardController.myLearning == null ||
          dashboardController.myLearning!.isEmpty) {
        return Center(
          child: CustomErrorWidget(
            isNoData: dashboardController.isErrorMyLearning == false,
            onRetry: () {
              dashboardController.getMyLearning(isShowLoading: true);
            },
            text: dashboardController.errorMsgMyLearning,
          ),
        );
      } else {
        return _buildView(dashboardController.myLearning!);
      }
    });
  }

  SingleChildScrollView _buildView(List<MyLearningData> myLearning) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ...[1, 3, 4, 5].map(
          //   (e) => ELearningCardWidget(
          //     isEnterPrise: true,
          //     course: Course(
          //         courseId: 2,
          //         course: "Test",
          //         photo:
          //             "https://images.unsplash.com/photo-1682687220866-c856f566f1bd?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHwxfHx8ZW58MHx8fHx8",
          //         launchBtn: "Launch Course"),
          //     onReload: () {
          //       // _reloadData(false);
          //     },
          //     userId: "4",
          //   ),
          // )

          ...myLearning.map((e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dashboardCardTitle(e.title.toString()),
                  10.sp.sbh,
                  ...e.courses!.map(
                    (cour) => ELearningCardWidget(
                      isEnterPrise: true,
                      course: cour,
                      onReload: () {
                        // _reloadData(false);
                      },
                      userId: Get.find<ProfileSharedPrefService>()
                          .profileData
                          .value
                          .id
                          .toString(),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
