import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/card_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WorkplaceCards extends StatefulWidget {
  final CardModel? object;
  final bool isDynamicHeight;
  const WorkplaceCards({super.key, this.object, this.isDynamicHeight = false});

  @override
  State<WorkplaceCards> createState() => _WorkplaceCardsState();
}

class _WorkplaceCardsState extends State<WorkplaceCards> {
  @override
  Widget build(BuildContext context) {
    return widget.isDynamicHeight
        ? _buildDynamicHeightContainer()
        : _buildFixedHeightContainer();
  }

  Widget _buildDynamicHeightContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: CommonController.getLinearGradientSecondryAndPrimary(),
        borderRadius: BorderRadius.circular(context.isTablet ? 10.sp : 16.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.sp),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.sp),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius:
                BorderRadius.circular(context.isTablet ? 9.sp : 15.sp),
          ),
          child: InkWell(
            onTap: () {
              widget.object!.onTap();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 1, child: 0.sbh),
                Expanded(
                  flex: 2,
                  child: Center(
                      child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(7.sp),
                        child: SvgPicture.asset(
                          widget.object!.icon,
                        ),
                      ),
                      widget.object!.badge != "" && widget.object!.badge != "0"
                          ? _buildBadge()
                          : 0.sbh
                    ],
                  )),
                ),
                5.sp.sbh,
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.sp),
                    child: CustomText(
                      fontWeight: FontWeight.w500,
                      fontSize: context.isTablet ? 8.sp : 11.sp,
                      color: AppColors.black.withOpacity(0.7),
                      text: widget.object?.heading ?? "",
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
    );
  }

  Container _buildFixedHeightContainer() {
    return Container(
      height: context.isTablet
          ? context.getWidth / 3 - 20.sp
          : context.getWidth / 2 - 30.sp,
      decoration: BoxDecoration(
        gradient: CommonController.getLinearGradientSecondryAndPrimary(),
        borderRadius: BorderRadius.circular(context.isTablet ? 10.sp : 16.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.sp),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.sp),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius:
                BorderRadius.circular(context.isTablet ? 9.sp : 15.sp),
          ),
          child: InkWell(
            onTap: () {
              widget.object!.onTap();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                context.isTablet
                    ? (context.getWidth / 11).sbh
                    : (context.getWidth / 7).sbh,
                Center(
                    child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SvgPicture.asset(
                      widget.object!.icon,
                      width: 4.h,
                      height: 4.h,
                    ),
                    widget.object!.badge != "" && widget.object!.badge != "0"
                        ? _buildBadge()
                        : 0.sbh
                  ],
                )),
                5.sp.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.sp),
                  child: CustomText(
                    fontWeight: FontWeight.w500,
                    fontSize: context.isTablet ? 8.sp : 11.sp,
                    color: AppColors.black.withOpacity(0.7),
                    text: widget.object?.heading ?? "",
                    maxLine: 2,
                    textAlign: TextAlign.center,
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

  Positioned _buildBadge() {
    return Positioned(
        right: -8.sp,
        top: -8.sp,
        child: Container(
          height: 15.sp,
          width: 15.sp,
          decoration: BoxDecoration(
              color: AppColors.labelColor16,
              borderRadius: BorderRadius.circular(5.sp)),
          child: FittedBox(
            child: CustomText(
              fontWeight: FontWeight.w800,
              fontSize: 9.sp,
              color: AppColors.white,
              text: widget.object!.badge.toString(),
              maxLine: 1,
              textAlign: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ));
  }
}
