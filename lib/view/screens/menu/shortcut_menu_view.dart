import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/data/model/card_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/screens/dashboard/forum_poll_list_screen.dart';
import 'package:aspirevue/view/screens/main/main_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/coaches_mantors_mantees/my_coaches_mentors_mentees_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/workplace_card.dart';
import 'package:aspirevue/view/screens/menu/my_goals/my_goals_screen.dart';
import 'package:aspirevue/view/screens/menu/store/store_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ShortcutMenuView extends StatefulWidget {
  const ShortcutMenuView({super.key});

  @override
  State<ShortcutMenuView> createState() => _ShortcutMenuViewState();
}

class _ShortcutMenuViewState extends State<ShortcutMenuView> {
  List<CardModel> menuList = [];
  var developmentController = Get.find<DevelopmentController>();
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    menuList = [];
    super.dispose();
  }

  _navigateToMyconnection() {
    var mainController = Get.find<MainController>();
    mainController.addToStackAndNavigate(AppConstants.connectionsIndex);
    Get.offAll(() => const MainScreen(isLoadData: false));
  }

  _loadData() {
    menuList.add(CardModel(
        icon: SvgImage.myConnectionIc,
        heading: AppString.myConnection,
        badge: '0',
        id: '0',
        onTap: () {
          _navigateToMyconnection();
        }));

    if (developmentController.isShowMyCoachModule.value == true) {
      menuList.add(CardModel(
          icon: SvgImage.profileIc,
          heading: AppString.shortcutMyCoach,
          badge: '0',
          id: '0',
          onTap: () {
            // var mainController = Get.find<MainController>();
            // mainController.addToStackAndNavigate(AppConstants.connectionsIndex);
            Get.to(() => const MyCoachMentorsMenteesScreen(
                  isShowUnSelectedBottom: true,
                  title: AppString.coaches,
                  currentIndex: 0,
                ));
          }));
    }
    menuList.add(CardModel(
        icon: SvgImage.cartIc,
        heading: AppString.store,
        badge: '0',
        id: '0',
        onTap: () {
          Get.to(() => const StoreMainScreen(isFromMenu: false));
          // Get.toNamed(RouteHelper.getStoreRoute());
        }));
    menuList.add(CardModel(
        icon: SvgImage.goalIc,
        heading: AppString.myGoals,
        badge: '0',
        id: '0',
        onTap: () {
          // var mainController = Get.find<MainController>();
          // mainController.addToStackAndNavigate(AppConstants.unSelectedIndex);
          Get.to(() => const MyGoalsScreen());
        }));

    menuList.add(CardModel(
        icon: SvgImage.pollForumIc,
        heading: AppString.pollForums,
        badge: '0',
        id: '0',
        onTap: () {
          Get.to(() => const ForumPollListScreen());
        }));

    if (developmentController.isShowDevelopmentModule.value == true) {
      menuList.add(CardModel(
          icon: SvgImage.developmentIc,
          heading: AppString.shortcutDevelopment,
          badge: '0',
          id: '0',
          onTap: () {
            Get.toNamed(RouteHelper.getDevelopmentRoute());
          }));
    }

    menuList.add(CardModel(
        icon: SvgImage.insightIc,
        heading: AppString.insightStream,
        badge: '0',
        id: '0',
        onTap: () {
          Get.toNamed(RouteHelper.getInsightStreamRoute());
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          context.isTablet ? 15.sp.sbh : 15.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.sp),
            child: AlignedGridView.count(
              crossAxisCount: context.isTablet ? 3 : 2,
              shrinkWrap: true,
              mainAxisSpacing: 10.sp,
              crossAxisSpacing: 10.sp,
              primary: false,
              itemCount: menuList.length,
              itemBuilder: (context, index) => WorkplaceCards(
                object: menuList[index],
              ),
            ),
          ),

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25.sp),
          //   child: GridView.builder(
          //       itemCount: menuList.length,
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 2,
          //           crossAxisSpacing: 10.sp,
          //           mainAxisSpacing: 10.sp),
          //       itemBuilder: (BuildContext context, int index) {
          //         return WorkplaceCards(
          //           object: menuList[index],
          //           isDynamicHeight: true,
          //         );
          //       }),
          // )
        ],
      ),
    );
  }
}
