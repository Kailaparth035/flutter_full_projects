import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/response/other_user_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/user_insight_stream_screen.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/profile/profile_about_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.userId});
  final String userId;
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    _reFreshData();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
  }

  late Future<OtherUserData?> _futureCall;

  _reFreshData() async {
    setState(() {
      isShowBack = true;
      _futureCall = Get.find<InsightStreamController>()
          .getOtherUserProfileDetail(widget.userId);
    });
  }

  bool isShowBack = true;

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      color: Colors.transparent,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: FutureBuildWidget(
            onRetry: () {
              _reFreshData();
            },
            isList: false,
            future: _futureCall,
            isShowBackArrowInError: true,
            child: (OtherUserData? data) {
              return _buildMainView(context, data);
            },
          )),
    );
  }

  Widget _buildMainView(BuildContext context, OtherUserData? data) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        // physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileMainView(context, data),
            buildDivider(),
            20.sp.sbh,
            data!.lockProfile == 1
                ? _buildLockProfile()
                : _buildBottomCard(
                    data,
                  ),
          ],
        ),
      ),
    );
  }

  Center _buildLockProfile() {
    return Center(
      child: Column(
        children: [
          20.h.sbh,
          Image.asset(
            AppImages.lockIc2,
            height: 20.sp,
          ),
          7.sp.sbh,
          CustomText(
            text: AppString.profileCurrentlyLocked,
            textAlign: TextAlign.start,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            maxLine: 600,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Container _buildBottomCard(OtherUserData? data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAbout(),
          10.sp.sbh,
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 12.sp),
          //   child: CustomText(
          //     text: data!.aboutMe.toString(),
          //     textAlign: TextAlign.start,
          //     color: AppColors.black,
          //     fontFamily: AppString.manropeFontFamily,
          //     fontSize: 12.sp,
          //     maxLine: 500,
          //     fontWeight: FontWeight.w400,
          //   ),
          // ),
          // 5.sp.sbh,
          // const Divider(
          //   height: 1,
          //   color: AppColors.labelColor,
          //   thickness: 1,
          // ),
          // 5.sp.sbh,
          // _buildTitleWithDesc(AppString.position, data.positionName.toString()),
          // 5.sp.sbh,
          // const Divider(
          //   height: 1,
          //   color: AppColors.labelColor,
          //   thickness: 1,
          // ),
          // 5.sp.sbh,
          // _buildTitleWithSubTitle(data.positionDescription.toString()),
          // 20.sp.sbh,
          ProfileAboutWidget(userId: widget.userId),
          _buildButton(
              AppString.getCircleInfluencerFollower(
                  data!.circleOfInfluence.toString()),
              AppImages.myCircleIc,
              () {}),
          10.sp.sbh,
          _buildButton(AppString.insightStream, AppImages.myPostIc, () {
            Get.to(() => UserInsightStreamScreen(
                  userId: data.id.toString(),
                  userName: data.name.toString(),
                  streamType: UserInsightStreamEnumType.otherUser,
                ));
          }),
          50.sp.sbh,
        ],
      ),
    );
  }

  Widget _buildButton(String title, String icon, Function onTap) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        decoration: BoxDecoration(
          gradient: CommonController.getLinearGradientSecondryAndPrimary(),
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 12.sp,
            ),
            7.sp.sbw,
            Flexible(
              child: CustomText(
                text: title,
                textAlign: TextAlign.center,
                fontSize: 11.sp,
                color: AppColors.white,
                maxLine: 2,
                fontWeight: FontWeight.w600,
                fontFamily: AppString.manropeFontFamily,
                textSpacing: 0.5.sp,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildTitleWithSubTitle(String vallue) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 12.sp),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomText(
  //           text: AppString.positionDescription1,
  //           textAlign: TextAlign.start,
  //           color: AppColors.labelColor6,
  //           fontFamily: AppString.manropeFontFamily,
  //           fontSize: 12.sp,
  //           maxLine: 500,
  //           fontWeight: FontWeight.w600,
  //         ),
  //         5.sp.sbh,
  //         CustomText(
  //           text: vallue,
  //           textAlign: TextAlign.start,
  //           color: AppColors.black,
  //           fontFamily: AppString.manropeFontFamily,
  //           fontSize: 12.sp,
  //           maxLine: 500,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildTitleWithDesc(String title, String subTitle) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 12.sp),
  //     child: Text.rich(
  //       TextSpan(
  //         style: const TextStyle(
  //           fontSize: 17,
  //         ),
  //         children: [
  //           TextSpan(
  //             text: title,
  //             style: TextStyle(
  //               fontSize: 12.sp,
  //               fontFamily: AppString.manropeFontFamily,
  //               fontWeight: FontWeight.w600,
  //               color: AppColors.labelColor6,
  //             ),
  //           ),
  //           TextSpan(
  //             text: subTitle,
  //             style: TextStyle(
  //               fontSize: 12.sp,
  //               fontFamily: AppString.manropeFontFamily,
  //               fontWeight: FontWeight.w400,
  //               color: AppColors.black,
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Container _buildAbout() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor1,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: AppString.about,
            textAlign: TextAlign.start,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMainView(BuildContext context, OtherUserData? data) {
    return SizedBox(
      child: Column(
        children: [
          _buildCoverImage(data),
          // 9.h.sbh,
        ],
      ),
    );
    // return Container(
    //   decoration: const BoxDecoration(
    //     image: DecorationImage(
    //       image: AssetImage(
    //         AppImages.profileBgImage,
    //       ),
    //       fit: BoxFit.fill,
    //     ),
    //   ),
    //   width: context.getWidth,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       20.sp.sbh,
    //       _buildAppbarTitle(),
    //       Column(
    //         children: [
    //           10.sp.sbh,
    //           _buildProfileCard(data),
    //           10.sp.sbh,
    //           _buildBoxContainer(data),
    //         ],
    //       ),
    //       20.sp.sbh,
    //     ],
    //   ),
    // );
  }

  Widget _buildCoverImage(OtherUserData? data) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.sp),
            bottomRight: Radius.circular(10.sp),
          ),
          child: Stack(
            children: [
              CustomImage(
                height: context.width * 0.35,
                width: context.width,
                image: data!.coverPhoto.toString(),
                fit: BoxFit.fitWidth,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        AppColors.black.withOpacity(0.8),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                          stops: const [
                        0.0,
                        0.9,
                        0.9,
                      ])),
                ),
              ),
              _buildAppbarTitle(),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(0, -6.5.h),
          child: Column(
            children: [
              _buildProfileCard(
                data,
              ),
              5.sp.sbh,
              _buildBoxContainer(data)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoxContainer(OtherUserData? data) {
    return Column(
      children: [
        CustomText(
          text: data!.name.toString(),
          textAlign: TextAlign.start,
          color: AppColors.black,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        CustomText(
          text: data.roleName.toString(),
          textAlign: TextAlign.start,
          color: AppColors.black,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
        ),
        // 10.sp.sbh,
      ],
    );
  }

  Center _buildProfileCard(OtherUserData? data) {
    return Center(
      child: Stack(
        children: [
          CustomImageForProfile(
              image: data!.photo.toString(),
              borderWidth: 3.sp,
              radius: 40.sp,
              nameInitials: '',
              borderColor: AppColors.white),
        ],
      ),
    );
  }

  Widget _buildAppbarTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.sp,
      ),
      child: Column(
        children: [
          5.h.sbh,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: AppColors.white,
                      size: 3.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
          10.sp.sbh,
        ],
      ),
    );
  }
}
