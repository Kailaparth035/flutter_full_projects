import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/slider_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CompentencyReputaionWidget extends StatefulWidget {
  const CompentencyReputaionWidget({super.key});

  @override
  State<CompentencyReputaionWidget> createState() =>
      _CompentencyReputaionWidgetState();
}

class _CompentencyReputaionWidgetState
    extends State<CompentencyReputaionWidget> {
  final _reputationList = [
    {
      "title": "Reputation",
      "color": AppColors.labelColor56,
    },
    {
      "title": "Self-Reflection",
      "color": AppColors.labelColor57,
    },
    {
      "title": "Peer",
      "color": AppColors.labelColor58,
    },
    {
      "title": "Superviser ",
      "color": AppColors.labelColor59,
    },
    {
      "title": "Direct Reports",
      "color": AppColors.labelColor60,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  Widget _buildView() {
    return Expanded(
      child: CustomSlideUpAndFadeWidget(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DevelopmentSelfReflectTitleWidget(
                    title:
                        "Discover your Work Skills reputation below by viewing perceptions and leveraging feedback from others."),
                20.sp.sbh,
                _buildRates(),
                20.sp.sbh,
                _userListTile(),
                _userListTile(),
                _userListTile(),
                _userListTile(),
                _buildInviteOtherTile(),
                10.sp.sbh,
                _buildTitleWithBG(),
                Image.asset(
                  AppImages.selfReflactionImage,
                  width: context.getWidth,
                ),
                10.sp.sbh,
                buildDivider(),
                buildTitleLog(_reputationList),
                buildDivider(),
                10.sp.sbh,
                _buildTitle("Communication Skills"),
                10.sp.sbh,
                _buildSliderTile("Listing")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildSliderTile(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
        color: AppColors.white,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.sp),
                bottomLeft: Radius.circular(5.sp),
              ),
              color: AppColors.backgroundColor1,
            ),
            width: double.infinity,
            child: Column(
              children: [
                SliderWidget(
                  sliderColor: AppColors.labelColor56,
                  isEnable: true,
                  value: 50,
                  returnValue: (val) {},
                ),
                SliderWidget(
                  sliderColor: AppColors.labelColor57,
                  isEnable: true,
                  value: 50,
                  returnValue: (val) {},
                ),
                SliderWidget(
                  sliderColor: AppColors.labelColor58,
                  isEnable: true,
                  value: 50,
                  returnValue: (val) {},
                ),
                SliderWidget(
                  sliderColor: AppColors.labelColor59,
                  isEnable: true,
                  value: 50,
                  returnValue: (val) {},
                ),
                SliderWidget(
                  sliderColor: AppColors.labelColor60,
                  isEnable: true,
                  value: 50,
                  returnValue: (val) {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor15.withOpacity(0.5),
        ),
        color: AppColors.labelColor36,
      ),
      width: double.infinity,
      child: CustomText(
        text: title,
        textAlign: TextAlign.center,
        color: AppColors.labelColor8,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 12.sp,
        maxLine: 2,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Container _buildTitleWithBG() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
      color: AppColors.labelColor19,
      width: double.infinity,
      child: CustomText(
        text: "Reputation Feedback",
        textAlign: TextAlign.start,
        color: AppColors.black,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 13.sp,
        maxLine: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Row _buildInviteOtherTile() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: CustomText(
            text: "* Add people to my community in order to gather feedback.",
            textAlign: TextAlign.start,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            maxLine: 3,
            fontWeight: FontWeight.w400,
          ),
        ),
        10.sp.sbw,
        Expanded(
          flex: 1,
          child: CustomButton2(
              buttonText: "Invite others",
              radius: 5.sp,
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              onPressed: () {}),
        )
      ],
    );
  }

  Widget _userListTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
        color: AppColors.white,
      ),
      width: double.infinity,
      child: Column(
        children: [
          _buildListTop(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5.sp),
                bottomLeft: Radius.circular(5.sp),
              ),
              color: AppColors.backgroundColor1,
            ),
            child: Padding(
              padding: EdgeInsets.all(7.sp),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "INVITED DATE",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor2,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 9.sp,
                        maxLine: 3,
                        fontWeight: FontWeight.w800,
                      ),
                      CustomText(
                        text: "11/02/2022",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor8,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 9.sp,
                        maxLine: 3,
                        fontWeight: FontWeight.w600,
                      )
                    ],
                  )),
                  Expanded(
                      child: Center(
                    child: CustomButton2(
                        buttonText: "Invited",
                        radius: 5.sp,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.sp, horizontal: 10.sp),
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                        onPressed: () {}),
                  )),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton2(
                          buttonText: "Remind",
                          radius: 5.sp,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.sp, horizontal: 10.sp),
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                          onPressed: () {}),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Padding _buildListTop() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageForProfile(
            image: "",
            radius: 22.sp,
            nameInitials: "AJ",
            borderColor: AppColors.labelColor8.withOpacity(0.6),
          ),
          10.sp.sbw,
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: "Robert Wilson ",
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor8,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 12.sp,
                          maxLine: 3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      5.sp.sbw,
                      CustomButton2(
                          buttonText: "Peer",
                          radius: 5.sp,
                          buttonColor: AppColors.labelColor55.withOpacity(0.2),
                          textColor: AppColors.labelColor40,
                          padding: EdgeInsets.symmetric(
                              vertical: 3.sp, horizontal: 10.sp),
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                          onPressed: () {})
                    ],
                  ),
                  CustomText(
                    text: "CEO",
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor15,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  CustomText(
                    text: "rob2wilson@yopmail.com",
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center _buildRates() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.labelColor8,
          ),
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 14.sp,
              width: 14.sp,
              child: Image.asset(AppImages.userBlueIc),
            ),
            CustomText(
              text: " # of raters",
              textAlign: TextAlign.center,
              color: AppColors.labelColor15,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              maxLine: 500,
              fontWeight: FontWeight.w600,
            ),
            10.sp.sbw,
            Container(
              height: 16.sp,
              width: 16.sp,
              decoration: BoxDecoration(
                color: AppColors.labelColor8,
                borderRadius: BorderRadius.circular(3.sp),
              ),
              child: Center(
                child: CustomText(
                  text: "1",
                  textAlign: TextAlign.center,
                  color: AppColors.white,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  maxLine: 700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
