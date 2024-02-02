import 'package:aspirevue/data/model/card_model.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/growth_community_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/personal_growth_details_list_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/workplace_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyConnectionPersonalGrowthView extends StatefulWidget {
  const MyConnectionPersonalGrowthView({super.key});

  @override
  State<MyConnectionPersonalGrowthView> createState() =>
      _MyConnectionPersonalGrowthViewState();
}

class _MyConnectionPersonalGrowthViewState
    extends State<MyConnectionPersonalGrowthView> {
  List<CardModel?> menuList = [];

  @override
  void initState() {
    menuList.add(CardModel(
        icon: SvgImage.colleaguesIc,
        heading: AppString.colleagues,
        badge: '0',
        id: '0',
        onTap: () {
          Get.to(() => const PersonalGrowthDetailsListScreen(
                title: AppString.colleagues,
                currentIndex: 1,
              ));
        }));
    menuList.add(CardModel(
        icon: SvgImage.growthCommunityIc,
        heading: AppString.growthCommunity,
        badge: '0',
        id: '0',
        onTap: () {
          Get.to(() => const GrowthCommunityScreen(
                isShowUnselectedBottomSheet: false,
                title: AppString.growthCommunity,
                currentIndex: 1,
              ));
        }));
    menuList.add(CardModel(
        icon: SvgImage.circleOfInfluenceIc,
        heading: AppString.circleOfInfluence,
        badge: '0',
        id: '0',
        onTap: () {
          Get.to(() => const PersonalGrowthDetailsListScreen(
                title: AppString.circleOfInfluenceMyFollower,
                currentIndex: 1,
              ));
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 15.sp),
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
          ],
        ),
      ),
    );
  }
}
