import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/hashtag_controller.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/hashtag_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/hashtag_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HashTagListForInsightStreamScreen extends StatefulWidget {
  const HashTagListForInsightStreamScreen({
    super.key,
  });

  @override
  State<HashTagListForInsightStreamScreen> createState() =>
      _HashTagListForInsightStreamScreenState();
}

class _HashTagListForInsightStreamScreenState
    extends State<HashTagListForInsightStreamScreen> {
  final _hastagController = Get.find<HashTagController>();
  @override
  void initState() {
    _hastagController.getHashtags();
    _hastagController.followedHashtagList();
    super.initState();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return CustomTabBarWidget(
      bgColor: Colors.white,
      selectedIndex: 0,
      title1: "Followed",
      title2: "All",
      child: Expanded(
        child: TabBarView(
          children: [
            _buildFollowedHashtag(false),
            _buildFollowedHashtag(true),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowedHashtag(bool isAll) {
    return Padding(
      padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 1.h),
      child: FollowedHashTagView(
        isAll: isAll,
        onTap: (selectedHashtag) async {
          Get.to(() => HashTagPostStreamScreen(
                hashTag: selectedHashtag,
                isFrom: PostTypeEnum.insight,
              ));

          // if (res != null && res == true) {
          //   setState(() {
          //     selectedIndex = 0;
          //   });
          //   pageController.animateToPage(
          //     0,
          //     duration: const Duration(milliseconds: 200),
          //     curve: Curves.easeIn,
          //   );
          // }
        },
      ),
    );
  }

  // Widget _buildHashtagView(bool isAll) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 1.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 SizedBox(height: 0.5.h),
  //                 FollowedHashTagView(
  //                   isAll: isAll,
  //                   onTap: (selectedHashtag) async {
  //                     var res = await Get.to(() => HashTagPostStreamScreen(
  //                           hashTag: selectedHashtag,
  //                           isFrom: PostTypeEnum.insight,
  //                         ));

  //                     // if (res != null && res == true) {
  //                     //   setState(() {
  //                     //     selectedIndex = 0;
  //                     //   });
  //                     //   pageController.animateToPage(
  //                     //     0,
  //                     //     duration: const Duration(milliseconds: 200),
  //                     //     curve: Curves.easeIn,
  //                     //   );
  //                     // }
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
