import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_app_bar.dart';
import 'package:aspirevue/view/screens/insight_stream/hashtag_list_for_insight_stream.dart';
import 'package:aspirevue/view/screens/insight_stream/post_list_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/search_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/insight_view.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/personal_growth_details_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key, this.selectedIndex});
  final int? selectedIndex;
  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen>
    with TickerProviderStateMixin {
  final _streamController = Get.find<InsightStreamController>();
  final _scrollcontroller = ScrollController();

  PageController pageController = PageController(initialPage: 0);

  TabController? _controller;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _streamController.getFollowersCount();
    if (widget.selectedIndex != null) {
      selectedIndex = widget.selectedIndex!;
    }
    _controller = TabController(
        length: 4,
        vsync: this,
        initialIndex: 0,
        animationDuration: const Duration(seconds: 1));

    _controller!.addListener(() {
      setState(() {
        selectedIndex = _controller!.index;
      });
    });

    _selectIndex();
    initData();
  }

  _selectIndex() {
    if (widget.selectedIndex != null) {
      selectedIndex = widget.selectedIndex!;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (widget.selectedIndex == 3) {
          if (_scrollcontroller.offset !=
              _scrollcontroller.position.maxScrollExtent) {
            _scrollcontroller.animateTo(
                _scrollcontroller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn);
          }
        }
      });
    }
  }

  initData() {
    _streamController.getInsightFeed(true);
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppbar(context),
          backgroundColor: AppColors.white,
          body: _buildView(context),
        ),
      ),
    );
  }

  GestureDetector _buildView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: GetBuilder<InsightStreamController>(
          builder: (insightStreamController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.sp.sbh,
                buildFeedAndHashTagButton(
                    scrollController: _scrollcontroller,
                    selectedIndex: selectedIndex,
                    onTap: (val) {
                      if (val == 0) {
                        if (_scrollcontroller.offset !=
                            _scrollcontroller.position.minScrollExtent) {
                          _scrollcontroller.jumpTo(
                            _scrollcontroller.position.minScrollExtent,
                          );
                        }

                        _streamController.getInsightFeed(true);
                        _controller!.animateTo(
                          0,
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.easeIn,
                        );
                        setState(() {
                          selectedIndex = val;
                        });
                      }

                      if (val == 1) {
                        setState(() {
                          selectedIndex = val;
                        });
                        _controller!.animateTo(
                          1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }

                      if (val == 2) {
                        setState(() {
                          selectedIndex = val;
                        });
                        _controller!.animateTo(
                          2,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }
                      if (val == 3) {
                        setState(() {
                          selectedIndex = val;
                        });

                        if (_scrollcontroller.offset !=
                            _scrollcontroller.position.maxScrollExtent) {
                          _scrollcontroller.jumpTo(
                            _scrollcontroller.position.maxScrollExtent,
                          );
                        }

                        _controller!.animateTo(
                          3,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }

                      if (val == 4) {
                        Get.to(() => const PersonalGrowthDetailsListScreen(
                              isShowBottomNav: false,
                              title: AppString.circleOfInfluenceMyFollower,
                              currentIndex: 1,
                            ));
                      }
                    }),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    children: [
                      _buildInsightView(),
                      const HashTagListForInsightStreamScreen(),
                      const PostListWidget(
                          streamType: UserInsightStreamEnumType.currentUser,
                          userId: ""),
                      const PostListWidget(
                          streamType: UserInsightStreamEnumType.savedPost,
                          userId: ""),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget _buildHashtagView() {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 1.h),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomText(
  //           text: AppString.followedHashTag,
  //           textAlign: TextAlign.start,
  //           color: AppColors.labelColor3,
  //           fontFamily: AppString.manropeFontFamily,
  //           fontSize: 13.sp,
  //           fontWeight: FontWeight.w600,
  //         ),
  //         Expanded(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 const Divider(
  //                   color: AppColors.labelColor9,
  //                   thickness: 0.1,
  //                 ),
  //                 SizedBox(height: 0.5.h),
  //                 FollowedHashTagView(
  //                   onTap: (selectedHashtag) async {
  //                     var res = await Get.to(() => HashTagPostStreamScreen(
  //                           hashTag: selectedHashtag,
  //                           isFrom: PostTypeEnum.insight,
  //                         ));

  //                     if (res != null && res == true) {
  //                       setState(() {
  //                         selectedIndex = 0;
  //                       });
  //                       pageController.animateToPage(
  //                         0,
  //                         duration: const Duration(milliseconds: 200),
  //                         curve: Curves.easeIn,
  //                       );
  //                     }
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

  Widget _buildInsightView() {
    return InsightView(
      _streamController,
      "insight",
      isShowCommnetSection: true,
    );
  }

  CustomAppBar _buildAppbar(BuildContext context) {
    return CustomAppBar(
      isShowSearchPost: true,
      onSearch: () {
        CommonController.hideKeyboard(context);
        Get.to(const SearchScreen(isFromHashTagScreen: false));
      },
      onPressed: () async {
        var result = await Get.toNamed(RouteHelper.getCreatePostRoute());

        if (result != null && result == true) {
          _streamController.getInsightFeed(true);
        }
      },
      title: AppString.insightStream,
      onBackPressed: () {
        Get.back();
      },
      showActionIcon: true,
      textColor: AppColors.labelColor8,
      iconButtonColor: AppColors.labelColor5,
      context: context,
    );
  }
}
