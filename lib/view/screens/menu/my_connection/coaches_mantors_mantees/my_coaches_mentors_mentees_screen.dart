import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/mentees_controller.dart';
import 'package:aspirevue/controller/my_coaches_controller.dart';
import 'package:aspirevue/controller/my_mentors_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_tab_bar_style.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/coaches_mantors_mantees/mentess_view.dart';
import 'package:aspirevue/view/screens/menu/my_connection/coaches_mantors_mantees/mentors_view.dart';
import 'package:aspirevue/view/screens/menu/my_connection/coaches_mantors_mantees/my_coach_view.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_personal_growth_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyCoachMentorsMenteesScreen extends StatefulWidget {
  const MyCoachMentorsMenteesScreen(
      {super.key,
      required this.title,
      required this.currentIndex,
      required this.isShowUnSelectedBottom});
  final String title;
  final int currentIndex;
  final bool isShowUnSelectedBottom;
  @override
  State<MyCoachMentorsMenteesScreen> createState() =>
      _MyCoachMentorsMenteesScreenState();
}

class _MyCoachMentorsMenteesScreenState
    extends State<MyCoachMentorsMenteesScreen> with TickerProviderStateMixin {
  int index = 0;
  @override
  void initState() {
    index = widget.currentIndex;
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    var map = <String, dynamic>{};

    if (widget.title == AppString.coaches) {
      Get.find<MyCoachesController>().getMyCoachesList(map);
    } else if (widget.title == AppString.mentors) {
      Get.find<MyMentorsController>().getMyMentorsList(map);
    } else if (widget.title == AppString.mentees) {
      Get.find<MenteesController>().getMenteesList(map);
    } else {
      Get.find<MyCoachesController>().getMyCoachesList(map);
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
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        // bottomNavigationBar: widget.isShowUnSelectedBottom
        //     ? null
        //     // const BottomNavBarUnselected(
        //     //     isFromMain: false,
        //     //   )
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
          selectedIndex: 0,
          title1: AppString.workPlace,
          title2: AppString.personalGrowth,
          child: Expanded(
            child: TabBarView(
              children: sharedPrefController.profileData.value.isShowMyWorkplace
                          .toString() ==
                      "1"
                  ? [
                      _buildView1(),
                      const MyConnectionPersonalGrowthView(),
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

  Widget _buildView1() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: 10.sp,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: AppColors.black,
                  text: widget.title,
                  textAlign: TextAlign.center,
                  fontFamily: AppString.manropeFontFamily,
                ),
                const Spacer(),
              ],
            ),
          ),
          _getPage()
        ],
      ),
    );
  }

  Widget _getPage() {
    if (widget.title == AppString.coaches) {
      return const MyCoachView();
    } else if (widget.title == AppString.mentors) {
      return const MentorsView();
    } else {
      return const MenteesView();
    }
  }

  Widget tabSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedTabBar(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.labelColor,
                width: 2.0,
              ),
            ),
          ),
          tabBar: TabBar(
            isScrollable: false,
            indicatorPadding: const EdgeInsets.only(top: 0.5),
            indicatorWeight: 2.0,
            labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
            indicator: const ShapeDecoration(
                shape: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 2.0,
                        style: BorderStyle.solid)),
                gradient: LinearGradient(colors: [
                  AppColors.primaryColor,
                  AppColors.secondaryColor
                ])),
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              StatefulBuilder(builder: (context, setState) {
                DefaultTabController.of(context).addListener(() {
                  setState(() {
                    index = DefaultTabController.of(context).index;
                  });
                });
                return Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: AppColors.backgroundColor1,
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color:
                        index == 0 ? AppColors.black : const Color(0xff808191),
                    text: AppString.workPlace,
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                );
              }),
              StatefulBuilder(builder: (context, setState) {
                DefaultTabController.of(context).addListener(() {
                  setState(() {
                    index = DefaultTabController.of(context).index;
                  });
                });
                return Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: AppColors.backgroundColor1,
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color:
                        index == 1 ? AppColors.black : const Color(0xff808191),
                    text: AppString.personalGrowth,
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
