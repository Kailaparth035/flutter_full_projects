import 'package:aspirevue/data/model/response/development/my_journey_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/showcase_journey_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:timeline_tile_nic/timeline_tile.dart';
import 'package:aspirevue/controller/common_controller.dart';

class MyJournyTimeLineChart extends StatefulWidget {
  const MyJournyTimeLineChart({
    super.key,
    required this.timelinedetails,
  });

  final List<TimelinedetailForMyjourny>? timelinedetails;
  @override
  State<MyJournyTimeLineChart> createState() => _MyJournyTimeLineChartState();
}

class _MyJournyTimeLineChartState extends State<MyJournyTimeLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor28,
        borderRadius: BorderRadius.all(
          Radius.circular(10.sp),
        ),
      ),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.timelinedetails!.length,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 10.sp),
              child: TimelineTile(
                alignment: TimelineAlign.start,
                isFirst: index == 0,
                isLast: index == widget.timelinedetails!.length - 1,
                indicatorStyle: IndicatorStyle(
                  width: 50.sp,
                  height: 50.sp,
                  indicatorXY: 0,
                  indicator: _buildIndicators(index),
                ),
                beforeLineStyle: LineStyle(
                  color: widget.timelinedetails![index].isCompleted == "1"
                      ? AppColors.primaryColor
                      : AppColors.labelColor54,
                  thickness: 10,
                ),
                endChild: mainTile(index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget mainTile(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.sp.sbh,
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
            color: AppColors.black,
            text: widget.timelinedetails![index].title.toString(),
            textAlign: TextAlign.center,
            fontFamily: AppString.manropeFontFamily,
          ),
          50.sp.sbh,
        ],
      ),
    );
  }

  Widget _buildIndicators(int index) {
    if (widget.timelinedetails![index].title.toString() ==
        "Showcase My Journey") {
      return InkWell(
        onTap: () {
          Get.to(() => const ShowCaseJourneyScreen());
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
                bottom: -10.sp,
                right: 15.5.sp,
                child: SvgPicture.asset(
                  SvgImage.journeyBottomTileIc,
                  height: 20.sp,
                  width: 20.sp,
                  fit: BoxFit.fill,
                )),
            Container(
              width: 50.sp,
              height: 50.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryColor.withOpacity(1),
                      AppColors.secondaryColor.withOpacity(1),
                    ],
                    stops: const [
                      0.0,
                      0.7,
                    ]),
              ),
              child: Center(
                child: Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  child: Center(
                    child: CustomText(
                      text: "${widget.timelinedetails![index].point}%",
                      textAlign: TextAlign.start,
                      color: AppColors.black,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      // return SizedBox(
      //   child: Stack(
      //     children: [
      //       Transform.translate(
      //         offset: Offset(1.sp, 0),
      //         child: Transform.scale(
      //           scale: 1.1,
      //           child: SvgPicture.asset(
      //             SvgImage.badgeBgIc,
      //             fit: BoxFit.contain,
      //           ),
      //         ),
      //       ),
      //       Positioned.fill(
      //           child: Center(
      //         child: Transform.translate(
      //           offset: Offset(0, -4.sp),
      //           child: CustomText(
      //             text: "${widget.timelinedetails![index].point}%",
      //             textAlign: TextAlign.start,
      //             color: AppColors.black,
      //             fontFamily: AppString.manropeFontFamily,
      //             fontSize: 10.sp,
      //             fontWeight: FontWeight.w600,
      //           ),
      //         ),
      //       ))
      //     ],
      //   ),
      // );
    } else {
      if (index == 0) {
        return Container(
          width: 50.sp,
          height: 50.sp,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
          ),
          child: Center(
            child: Container(
              width: 40.sp,
              height: 40.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    CommonController.getLinearGradientSecondryAndPrimary(),
              ),
              child: Center(
                child: Image.asset(
                  AppImages.icStartFly,
                  height: 20.sp,
                  width: 20.sp,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        );
      } else {
        return InkWell(
          onTap: () {
            if (widget.timelinedetails![index].isLink == "1") {
              CommonController.urlLaunch(
                  widget.timelinedetails![index].link.toString());
            }
          },
          child: Container(
            width: 50.sp,
            height: 50.sp,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: Center(
              child: Container(
                width: 40.sp,
                height: 40.sp,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient:
                      CommonController.getLinearGradientSecondryAndPrimary(),
                ),
                child: Center(
                  child: CustomText(
                    text: "${widget.timelinedetails![index].point}%",
                    textAlign: TextAlign.start,
                    color: AppColors.white,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
