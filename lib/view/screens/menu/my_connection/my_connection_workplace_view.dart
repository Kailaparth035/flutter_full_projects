import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/data/model/card_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/coaches_mantors_mantees/my_coaches_mentors_mentees_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/director_supervisor/work_place_details_list_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/workplace_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyConnectionWorkplaceView extends StatefulWidget {
  const MyConnectionWorkplaceView({super.key});

  @override
  State<MyConnectionWorkplaceView> createState() =>
      _MyConnectionWorkplaceViewState();
}

class _MyConnectionWorkplaceViewState extends State<MyConnectionWorkplaceView> {
  List<CardModel> menuList = [];

  final _mainController = Get.find<MainController>();
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  _loadData() {
    if (_mainController.workplaceData != null) {
      if (_mainController.workplaceData!.organizationChart.toString() ==
          "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.organizationChartIc,
            heading: AppString.organizationChart,
            badge: '0',
            id: '0',
            onTap: () {
              Get.toNamed(RouteHelper.getOrganizationChartRoute());
            }));
      }
      if (_mainController.workplaceData!.supervisors.toString() == "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.userWorkplaceIc,
            heading: AppString.supervisors,
            badge: '0',
            id: '0',
            onTap: () {
              Get.to(() => const WorkPlaceDetailsListScreen(
                    title: AppString.supervisors,
                  ));
            }));
      }
      if (_mainController.workplaceData!.peers.toString() == "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.userWorkplaceIc,
            heading: AppString.peers,
            badge: '0',
            id: '0',
            onTap: () {
              Get.to(() => const WorkPlaceDetailsListScreen(
                    title: AppString.peers,
                  ));
            }));
      }

      if (_mainController.workplaceData!.directReports.toString() == "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.directReportsIc,
            heading: AppString.directReports,
            badge: '0',
            id: '0',
            onTap: () {
              Get.to(() => const WorkPlaceDetailsListScreen(
                    title: AppString.directReports,
                  ));
            }));
      }
      if (_mainController.workplaceData!.community.toString() == "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.communityIc,
            heading: AppString.community,
            badge: '0',
            id: '0',
            onTap: () {
              Get.to(() => const WorkPlaceDetailsListScreen(
                    title: AppString.community,
                  ));
            }));
      }
      if (_mainController.workplaceData!.coaches.toString() == "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.cochesIc,
            heading: AppString.coaches,
            badge: '0',
            id: '0',
            onTap: () {
              Get.to(() => const MyCoachMentorsMenteesScreen(
                    isShowUnSelectedBottom: false,
                    title: AppString.coaches,
                    currentIndex: 0,
                  ));
            }));
      }
      if (_mainController.workplaceData!.mentors.toString() == "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.userWorkplaceIc,
            heading: AppString.mentors,
            badge: '0',
            id: '0',
            onTap: () {
              Get.to(() => const MyCoachMentorsMenteesScreen(
                    isShowUnSelectedBottom: false,
                    title: AppString.mentors,
                    currentIndex: 0,
                  ));
            }));
      }
      if (_mainController.workplaceData!.mentees.toString() == "Yes") {
        menuList.add(CardModel(
            icon: SvgImage.userWorkplaceIc,
            heading: AppString.mentees,
            badge: '0',
            id: '0',
            onTap: () {
              Get.to(() => const MyCoachMentorsMenteesScreen(
                    isShowUnSelectedBottom: false,
                    title: AppString.mentees,
                    currentIndex: 0,
                  ));
            }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  _buildMainView() {
    return GetBuilder<MainController>(builder: (mainController) {
      return mainController.isLoadingworkplaceData
          ? Padding(
              padding: EdgeInsets.only(top: 0.h),
              child: const Center(child: CustomLoadingWidget()),
            )
          : mainController.isErrorworkplaceData
              ? Padding(
                  padding: EdgeInsets.only(top: 0.h),
                  child: Center(
                    child: CustomErrorWidget(
                      onRetry: () async {
                        await mainController.getMyworkplaceMenuList();
                        _loadData();
                      },
                      text: mainController.errorMessageworkplaceData.toString(),
                    ),
                  ),
                )
              : menuList.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 0.h),
                      child: Center(
                        child: CustomErrorWidget(
                          isNoData: true,
                          onRetry: () async {
                            await mainController.getMyworkplaceMenuList();
                            _loadData();
                          },
                          text: mainController.errorMessageworkplaceData
                              .toString(),
                        ),
                      ),
                    )
                  : _buildView();
    });
  }

  Widget _buildView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 15.sp),
        child: AlignedGridView.count(
          crossAxisCount: context.isTablet ? 3 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10.sp,
          crossAxisSpacing: 10.sp,
          primary: false,
          itemCount: menuList.length,
          itemBuilder: (context, index) => WorkplaceCards(
            object: menuList[index],
          ),
        ),
      ),
    );
  }
}
