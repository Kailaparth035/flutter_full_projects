import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile_nic/timeline_tile.dart';

class HowJourneyWorkStepScreen extends StatefulWidget {
  const HowJourneyWorkStepScreen({super.key});

  @override
  State<HowJourneyWorkStepScreen> createState() =>
      _HowJourneyWorkStepScreenState();
}

class _HowJourneyWorkStepScreenState extends State<HowJourneyWorkStepScreen> {
  final List<OnbordingModel> _tileList = [
    OnbordingModel(
      image: SvgImage.password,
      title: "Today",
      subTitle:
          "Get instant access to Journeys. Take the tour. Learn how to create early successes by watching the short Quickstart Videos. Define your aspirational identity and start gaining insight by reflecting on patterns.",
      subTitleList: [],
    ),
    OnbordingModel(
      image: SvgImage.notificationWhite,
      title: "Day 10",
      subTitle:
          "We’ll remind you with an email or notification that your Journey trial is ending soon.",
      subTitleList: [],
    ),
    OnbordingModel(
      image: SvgImage.startWhite,
      title: "Day 14",
      subTitle:
          "You’ll be notified that your AspireVue APP is downgraded to a basic version to AspireVue Community and Goal-setting with various paid subscription options still available.",
      subTitleList: [],
    )
  ];
  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  SingleChildScrollView _buildView() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.h.sbh,
        Padding(
          padding: EdgeInsets.all(5.h),
          child: Center(
            child: welcomeScreenTitle("How your Journeys trial works"),
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _tileList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(left: 20.sp),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.sp),
                child: TimelineTile(
                  alignment: TimelineAlign.start,
                  indicatorStyle: IndicatorStyle(
                    indicatorXY: 0,
                    height: 32.sp,
                    width: 22.sp,
                    indicator: _buildIndicator(_tileList[index].image),
                  ),
                  beforeLineStyle: LineStyle(
                    color: AppColors.labelColor,
                    thickness: 2.sp,
                  ),
                  endChild: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        5.sp.sbh,
                        _buildTileTitle(_tileList[index].title),
                        _buildTileSubTitle(_tileList[index].subTitle),
                        5.sp.sbh,
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    ));
  }

  CustomText _buildTileSubTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w400,
      fontSize: 12.sp,
      color: AppColors.labelColor15,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  CustomText _buildTileTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      color: AppColors.labelColor8,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Widget _buildIndicator(String image) {
    return Container(
      height: 25.sp,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.sp),
        gradient: CommonController.getLinearGradientSecondryAndPrimary(),
      ),
      child: Center(
        child: SvgPicture.asset(
          image,
          height: 16.sp,
          width: 15.sp,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
