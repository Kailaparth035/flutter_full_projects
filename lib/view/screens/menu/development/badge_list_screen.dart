import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/badge_legend_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BadgeListScreen extends StatefulWidget {
  const BadgeListScreen({super.key, required this.userId, required this.title});
  final String userId;
  final String title;
  @override
  State<BadgeListScreen> createState() => _BadgeListScreenState();
}

class _BadgeListScreenState extends State<BadgeListScreen> {
  late Future<BadgeLegendPopupData?> _futureCall;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    var map = <String, dynamic>{"user_id": widget.userId, "assignUser": "0"};
    setState(() {
      _futureCall = Get.find<DevelopmentController>().getBadgeLegendPopup(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor1,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: AppbarWithBackButton(
          appbarTitle: widget.title,
          onbackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildMainView(),
    );
  }

  Padding _buildView(BadgeLegendPopupData? data) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.sp.sbh,
            _buildTitleWithIcon(data!.popupTitle.toString()),
            5.sp.sbh,
            const Divider(
              height: 1,
              color: AppColors.black,
              thickness: 1,
            ),
            10.sp.sbh,
            ...data.mainList!.map(
              (e) => _buildBadgeList(e, data.descriptionTitle.toString()),
            )
          ],
        ),
      ),
    );
  }

  Column _buildBadgeList(MainList data, String descTitle) {
    return Column(
      children: [
        buildTitleWithBGAndEnd(data.title.toString(), data.count.toString()),

        Container(
          width: context.getWidth,
          padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 10.sp),
          decoration: BoxDecoration(
            boxShadow: CommonController.getBoxShadow,
            color: AppColors.labelColor47,
          ),
          child: Column(
            children: [...data.badgeList!.map((e) => _buildListTile(e))],
          ),
        ),
        // AlignedGridView.count(
        //   crossAxisCount: 2,
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   mainAxisSpacing: 10.sp,
        //   crossAxisSpacing: 10.sp,
        //   primary: false,
        //   itemCount: data.badgeList!.length,
        //   itemBuilder: (context, index) =>
        //       _buildListTile(data.badgeList![index]),
        // ),
        10.sp.sbh,
        data.description!.isNotEmpty
            ? _buildDescription(data.description, descTitle)
            : 0.sbh,
      ],
    );
  }

  Column _buildDescription(List<String>? description, String descTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
          color: AppColors.black.withOpacity(0.7),
          text: descTitle,
          maxLine: 2,
          textAlign: TextAlign.center,
          fontFamily: AppString.manropeFontFamily,
        ),
        ...description!.map(
          (e) => Padding(
            padding: EdgeInsets.only(left: 2.sp),
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(0, 2.sp),
                  child: Container(
                    height: 3.sp,
                    width: 3.sp,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.labelColor2,
                    ),
                  ),
                ),
                5.sp.sbw,
                CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  color: AppColors.labelColor2,
                  text: e.toString(),
                  maxLine: 2,
                  textAlign: TextAlign.center,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ],
            ),
          ),
        ),
        10.sp.sbh,
      ],
    );
  }

  FutureBuildWidget _buildMainView() {
    return FutureBuildWidget(
      onRetry: () {
        _loadData();
      },
      future: _futureCall,
      child: (BadgeLegendPopupData? data) {
        return _buildView(data);
      },
    );
  }

  _buildListTile(BadgeData badge) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        gradient: CommonController.getLinearGradientSecondryAndPrimary(),
        borderRadius: BorderRadius.circular(16.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.5.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.sp),
          child: Container(
            padding: EdgeInsets.all(10.sp),
            decoration: BoxDecoration(
              color: badge.isSelected == "1"
                  ? AppColors.labelColor19
                  : AppColors.white,
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: Row(
              children: [
                Center(
                    child: CustomImage(
                  height: 40.sp,
                  width: 40.sp,
                  image: badge.image.toString(),
                  fit: BoxFit.fill,
                )),
                10.sp.sbw,
                Expanded(
                  flex: 2,
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    color: AppColors.black,
                    text: badge.name.toString(),
                    maxLine: 1,
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: CustomText(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    color: AppColors.labelColor80,
                    text: badge.point.toString(),
                    maxLine: 1,
                    textAlign: TextAlign.end,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichText _buildTitleWithIcon(String title) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w600,
              color: AppColors.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
