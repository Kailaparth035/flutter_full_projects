import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/data/model/response/badge_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BadgeDetailScreen extends StatefulWidget {
  const BadgeDetailScreen(
      {super.key, required this.userId, required this.userName});
  final String userId;
  final String userName;
  @override
  State<BadgeDetailScreen> createState() => _BadgeDetailScreenState();
}

class _BadgeDetailScreenState extends State<BadgeDetailScreen> {
  late Future<List<BadgeData>> _futureCall;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    var map = <String, dynamic>{"user_id": widget.userId};
    setState(() {
      _futureCall =
          Get.find<MyConnectionController>().getAssessmentBadgesDetail(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor1,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: AppbarWithBackButton(
          appbarTitle: AppString.myConnections,
          onbackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildMainView(),
    );
  }

  Padding _buildView(List<BadgeData> data) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.sp.sbh,
            _buildTitleWithIcon(),
            10.sp.sbh,
            AlignedGridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10.sp,
              crossAxisSpacing: 10.sp,
              primary: false,
              itemCount: data.length,
              itemBuilder: (context, index) => _buildListTile(data[index]),
            ),
            10.sp.sbh,
          ],
        ),
      ),
    );
  }

  FutureBuildWidget _buildMainView() {
    return FutureBuildWidget(
      onRetry: () {
        _loadData();
      },
      isList: true,
      future: _futureCall,
      child: (List<BadgeData> data) {
        return _buildView(data);
      },
    );
  }

  _buildListTile(BadgeData badge) {
    return Container(
      height: 40.w,
      decoration: BoxDecoration(
        gradient: CommonController.getLinearGradientSecondryAndPrimary(),
        borderRadius: BorderRadius.circular(16.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.5.sp),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.sp),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15.sp),
            ),
            child: InkWell(
              onTap: () {},
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  10.sp.sbh,
                  Expanded(
                    flex: 2,
                    child: CustomImage(image: badge.productPath.toString()),
                  ),
                  5.sp.sbh,
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.sp),
                      child: CustomText(
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        color: AppColors.black.withOpacity(0.7),
                        text: badge.productName.toString(),
                        maxLine: 2,
                        textAlign: TextAlign.center,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  RichText _buildTitleWithIcon() {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.bottom,
            child: Image.asset(
              AppImages.awardIc,
              height: 16.sp,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.bottom,
            child: 5.sp.sbw,
          ),
          TextSpan(
            text: "${widget.userName} - Assessment Badges",
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w600,
              color: AppColors.labelColor8,
            ),
          ),
        ],
      ),
    );
  }
}
