import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/data/model/response/goals_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_slider.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/cutom_tabbar_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/my_goals/add_goal_screen.dart';
import 'package:aspirevue/view/screens/menu/my_goals/goals_details_screen.dart';
import 'package:aspirevue/view/screens/menu/my_goals/progress_tracking_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyGoalsScreen extends StatefulWidget {
  const MyGoalsScreen({
    super.key,
  });

  @override
  State<MyGoalsScreen> createState() => _MyGoalsScreenState();
}

class _MyGoalsScreenState extends State<MyGoalsScreen> {
  final _myGoalController = Get.find<MyGoalController>();
  final _developmentController = Get.find<DevelopmentController>();
  final _scrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollcontroller.addListener(_loadMore);
    _loadData();
  }

  _loadData() async {
    _myGoalController.getMyGoal(
      true,
    );
    await _developmentController.getProgressTrackingOptionTests();
    _developmentController.getProgressTrackings(true);
  }

  _reFreshData() async {
    _myGoalController.getMyGoal(
      true,
    );
  }

  void _loadMore() async {
    if (!_myGoalController.isnotMoreData) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_myGoalController.isLoading1 == false &&
            _myGoalController.isLoadMoreRunning == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _myGoalController.isLoadMoreRunning = true;

          _myGoalController.pageNo += 1;
          await _myGoalController.getMyGoal(
            false,
          );

          _myGoalController.isLoadMoreRunning = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (va) {},
      child: CommonController.getAnnanotaion(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              appbarTitle: AppString.myGoals,
              onbackPress: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: AppColors.labelColor47,
          bottomNavigationBar: null,
          // const BottomNavBarUnselected(
          //   isFromMain: false,
          // ),
          body: CustomTabBarWidget(
            selectedIndex: 0,
            title1: AppString.myGoals,
            title2: "Progress Tracking",
            child: Expanded(
              child: TabBarView(
                children: [
                  _buildMyGoalView(),
                  Padding(
                    padding: EdgeInsets.all(10.sp),
                    child: const ProgressTrackingWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMyGoalView() {
    return Column(
      children: [
        10.sp.sbh,
        _buildCreateGoal(),
        10.sp.sbh,
        _buildMyGoalConditionView()
      ],
    );
  }

  _buildMyGoalConditionView() {
    return GetBuilder<MyGoalController>(builder: (growthCommunityController) {
      if (growthCommunityController.isLoading1) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 0.h),
            child: const Center(
              child: CustomLoadingWidget(),
            ),
          ),
        );
      }

      if (growthCommunityController.isError1) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 0.h),
            child: Center(
              child: CustomErrorWidget(
                onRetry: () {
                  _reFreshData();
                },
                text: growthCommunityController.errorMessage,
              ),
            ),
          ),
        );
      }

      return _buildView(growthCommunityController);
    });
  }

  Widget _buildView(MyGoalController growthCommunityController) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () {
          return _reFreshData();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding),
          child: Column(
            children: [
              growthCommunityController.goalList!.isEmpty
                  ? Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.h),
                        child: Center(
                          child: CustomErrorWidget(
                            isNoData: true,
                            onRetry: () {
                              _reFreshData();
                            },
                            text: growthCommunityController.errorMessage,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        controller: _scrollcontroller,
                        scrollDirection: Axis.vertical,
                        itemCount: growthCommunityController.goalList!.length,
                        itemBuilder: (context, index) {
                          bool isLast =
                              growthCommunityController.goalList!.length ==
                                  index + 1;

                          return _buildCard(
                              growthCommunityController.goalList![index],
                              isLast,
                              growthCommunityController.isLoadMoreRunning);
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateGoal() {
    return Padding(
      padding: EdgeInsets.only(right: AppConstants.screenHorizontalPadding),
      child: Align(
        alignment: Alignment.centerRight,
        child: CustomButton2(
            buttonText: AppString.createGoal,
            radius: 15.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
            onPressed: () async {
              await Get.to(() => const AddGoalScreen(
                    isEdit: false,
                  ));
            }),
      ),
    );
  }

  int age = 10;

  Widget _buildCard(GoalsData goals, bool isLast, bool isShowLoading) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            var result = await Get.to(() => GoalsDetailsScreen(
                  goalId: goals.id.toString(),
                  styleId: goals.styleId.toString(),
                  type: goals.goalType.toString(),
                  userId: goals.userId.toString(),
                ));

            if (result != null && result == true) {
              _reFreshData();
            }
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              bottom: 10.sp,
            ),
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            decoration: BoxDecoration(
              color: AppColors.labelColor12,
              border: Border.all(color: AppColors.labelColor48),
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buidListTile(goals),
                5.sp.sbh,
                CustomText(
                  text: goals.title.toString(),
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor15,
                  maxLine: 3,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
                5.sp.sbh,
                CustomText(
                  text: goals.objectiveTitle.toString(),
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor15,
                  maxLine: 3,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                5.sp.sbh,
                CustomSlider(
                  percent: goals.score == "" ? 0 : double.parse(goals.score!),
                  isEditable: false,
                ),
                5.sp.sbh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text:
                          "${AppString.targetDate}${goals.targetDate.toString()}",
                      textAlign: TextAlign.start,
                      color: AppColors.black,
                      maxLine: 3,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      text:
                          "${AppString.startDate}${goals.startDate.toString()}",
                      textAlign: TextAlign.start,
                      color: AppColors.black,
                      maxLine: 3,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        isLast
            ? isShowLoading
                ? Column(
                    children: [
                      const Center(
                        child: CustomLoadingWidget(),
                      ),
                      40.sp.sbh
                    ],
                  )
                : 80.sp.sbh
            : 0.sp.sbh
      ],
    );
  }

  Padding _buidListTile(GoalsData goals) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.sp),
      child: Row(
        children: [
          CustomImageForProfile(
              image: goals.photo.toString(),
              radius: 20.sp,
              nameInitials: "",
              borderColor: Colors.transparent),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: goals.goalType.toString(),
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 3.sp,
                  ),
                  CustomText(
                    text: goals.styleName.toString(),
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor15,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
