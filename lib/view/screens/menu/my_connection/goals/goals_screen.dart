import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/data/model/response/goals_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_slider.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/my_goals/goals_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({
    super.key,
    required this.userId,
  });
  final String userId;
  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late Future<List<GoalsData>?> _futureCall;

  @override
  void initState() {
    super.initState();

    _reFreshData();
  }

  _reFreshData() async {
    setState(() {
      _futureCall =
          Get.find<MyConnectionController>().getGoalsList(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.goal,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.labelColor47,
        // bottomNavigationBar: const BottomNavBar(
        //   isFromMain: false,
        // ),
        body: _buildMainView(),
      ),
    );
  }

  SafeArea _buildMainView() {
    return SafeArea(
      child: RefreshIndicator(
          onRefresh: () {
            return _reFreshData();
          },
          child: FutureBuildWidget(
            onRetry: () {
              _reFreshData();
            },
            isList: true,
            future: _futureCall,
            child: (List<GoalsData>? data) {
              return _buildView(data);
            },
          )),
    );
  }

  Widget _buildView(List<GoalsData>? data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Center(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...data!.map(
                (e) => _buildCard(e),
              )
            ],
          ),
        )),
      ),
    );
  }

  InkWell _buildCard(GoalsData goals) {
    return InkWell(
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
              percent: goals.score == ""
                  ? 0
                  : double.parse(goals.score!.replaceAll("%", "")) / 100,
              isEditable: false,
            ),
            5.sp.sbh,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: "${AppString.targetDate}${goals.targetDate.toString()}",
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                  maxLine: 3,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                CustomText(
                  text: "${AppString.startDate}${goals.startDate.toString()}",
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
    );
  }

  Padding _buidListTile(GoalsData goals) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.sp),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.circleGreen,
            radius: 20.sp,
            child: CircleAvatar(
              backgroundColor: AppColors.white,
              backgroundImage: NetworkImage(
                goals.photo.toString(),
              ),
              radius: 20.sp,
            ),
          ),
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
