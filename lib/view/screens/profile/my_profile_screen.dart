import 'dart:io';

import 'package:aspirevue/controller/auth_controller.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/profile_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/insight_screen.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/personal_growth_details_list_screen.dart';
import 'package:aspirevue/view/screens/profile/personal_info_screen.dart';
import 'package:aspirevue/view/screens/profile/profile_about_widget.dart';
import 'package:aspirevue/view/screens/profile/profile_drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sizer/sizer.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    super.key,
    required this.onBackPress,
    required this.isFromMain,
    this.isOpenedSideBar = false,
    this.scaffoldKey,
  });
  final Function onBackPress;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool isFromMain;
  final bool isOpenedSideBar;
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
    if (widget.isOpenedSideBar) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _scaffoldKey.currentState!.openEndDrawer();
      });
    }
  }

  final _profileController = Get.find<ProfileSharedPrefService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _updateImage(CroppedFile? cropedFile) async {
    try {
      buildLoading(Get.context!);
      var response =
          await _profileController.uploadProfilePicture(File(cropedFile!.path));
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  _pickImage() async {
    var file = await CommonController.pickImage();
    if (file != null) {
      var cropedFile =
          // ignore: use_build_context_synchronously
          await CommonController.cropImage(file, context, isProfile: true);
      if (cropedFile != null) {
        _updateImage(cropedFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      color: Colors.transparent,
      child: PopScope(
        canPop: true,
        onPopInvoked: (va) {
          if (widget.isFromMain) {
          } else {
            var mainController = Get.find<MainController>();
            mainController.remoteToStackAndNavigateBack(false);
          }
        },
        // onWillPop: () {
        //   if (widget.isFromMain) {
        //     return Future.value(true);
        //   } else {
        //     var mainController = Get.find<MainController>();

        //     mainController.remoteToStackAndNavigateBack(AppConstants.todayIndex);

        //     return Future.value(true);
        //   }
        // },
        child: Scaffold(
          key: _scaffoldKey,
          endDrawer: const ProfileDrawer(isFromAboutScreen: true),
          backgroundColor: Colors.white,
          body: _buildMainView(context),
          // bottomSheet: widget.isFromMain
          //     ? null
          //     : BottomNavBar(
          //         isFromMain: widget.isFromMain,
          //         onchange: (val) {},
          //       ),
        ),
      ),
    );
  }

  GetBuilder<ProfileSharedPrefService> _buildMainView(BuildContext context) {
    return GetBuilder<ProfileSharedPrefService>(
        builder: (sharedPrefController) {
      return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildProfileMainView(context, sharedPrefController),
              buildDivider(),
              20.sp.sbh,
              _buildBottomCard(sharedPrefController),
            ],
          ),
        ),
      );
    });
  }

  Container _buildBottomCard(ProfileSharedPrefService sharedPrefController) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAbout(
              sharedPrefController.profileData.value.aboutMe.toString()),
          10.sp.sbh,
          ProfileAboutWidget(
              userId: sharedPrefController.profileData.value.id.toString()),
          _buildButton(
              AppString.getCircleInfluencerFollower(sharedPrefController
                  .profileData.value.circleOfInfluence
                  .toString()),
              AppImages.myCircleIc, () {
            Get.to(() => const PersonalGrowthDetailsListScreen(
                  isShowBottomNav: false,
                  title: AppString.circleOfInfluenceMyFollower,
                  currentIndex: 1,
                ));
          }),
          8.sp.sbh,
          _buildButton(AppString.myPosts, AppImages.myPostIc, () {
            Get.to(() => const InsightScreen(
                  selectedIndex: 2,
                ));
            // Get.to(() => UserInsightStreamScreen(
            //       userId: "",
            //       userName:
            //           sharedPrefController.profileData.value.name.toString(),
            //       streamType: UserInsightStreamEnumType.currentUser,
            //     ));
          }),
          8.sp.sbh,
          _buildButton("Saved Posts", AppImages.savePostIc, () {
            // Get.to(() => UserInsightStreamScreen(
            //       userId: "",
            //       userName:
            //           sharedPrefController.profileData.value.name.toString(),
            //       streamType: UserInsightStreamEnumType.savedPost,
            //     ));

            Get.to(() => const InsightScreen(
                  selectedIndex: 3,
                ));
          }),
          8.sp.sbh,
          _buildDeleteAccound(),
          50.sp.sbh,
        ],
      ),
    );
  }

  Widget _buildDeleteAccound() {
    return Container(
      padding: const EdgeInsets.all(1.5),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor13.withOpacity(0.5),
          borderRadius: BorderRadius.circular(7.sp),
        ),
        padding: EdgeInsets.all(5.sp),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: InkWell(
              onTap: () {
                _deleteAccount();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    size: 15.sp,
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: AppColors.black,
                    text: "Delete Account",
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 5.sp,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  // Widget _buildBoxTile(String title, String icon, Function onTap) {
  //   return Expanded(
  //     child: InkWell(
  //       onTap: () {
  //         onTap();
  //       },
  //       child: Container(
  //         constraints: const BoxConstraints.expand(),
  //         decoration: BoxDecoration(
  //           gradient: CommonController.getLinearGradientSecondryAndPrimary(),
  //           boxShadow: CommonController.getBoxShadow,
  //           borderRadius: BorderRadius.circular(5.sp),
  //         ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             SizedBox(height: 15.sp, child: Image.asset(icon)),
  //             5.sp.sbh,
  //             CustomText(
  //               text: title,
  //               textAlign: TextAlign.center,
  //               color: AppColors.white,
  //               fontFamily: AppString.manropeFontFamily,
  //               fontSize: 10.sp,
  //               overFlow: TextOverflow.ellipsis,
  //               maxLine: 3,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

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

  Container _buildAbout(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor1,
        borderRadius: BorderRadius.circular(8.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: CustomText(
              text: AppString.about,
              textAlign: TextAlign.start,
              color: AppColors.black,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.scaffoldKey != null) {
                widget.scaffoldKey!.currentState?.openEndDrawer();
              } else {
                _scaffoldKey.currentState?.openEndDrawer();
              }
            },
            child: Padding(
              padding: EdgeInsets.all(3.0.sp),
              child: Icon(
                Icons.more_horiz,
                color: AppColors.secondaryColor,
                size: 15.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCoverImage(ProfileSharedPrefService sharedPrefController) {
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
                image: sharedPrefController.profileData.value.coverPhoto
                    .toString(),
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
              Positioned.fill(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    _pickImageForProfileCover();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(1.2.h),
                    child: Container(
                      padding: EdgeInsets.all(0.6.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.sp),
                        border: Border.all(color: AppColors.backgroundColor13),
                        gradient: CommonController
                            .getLinearGradientSecondryAndPrimary(),
                      ),
                      child: SvgPicture.asset(
                        SvgImage.editProfileIc,
                        height: 1.2.h,
                        width: 1.2.h,
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(0, -6.5.h),
          child: Column(
            children: [
              _buildProfileCard(
                sharedPrefController.profileData.value,
              ),
              5.sp.sbh,
              _buildBoxContainer(sharedPrefController.profileData.value)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMainView(
      BuildContext context, ProfileSharedPrefService sharedPrefController) {
    return SizedBox(
      child: Column(
        children: [
          _buildCoverImage(sharedPrefController),
          // 9.h.sbh,
        ],
      ),
    );

    // return Container(
    //   // height:  50.h,
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
    //           _buildProfileCard(sharedPrefController.profileData.value),
    //           10.sp.sbh,
    //           _buildBoxContainer(sharedPrefController.profileData.value),
    //           10.sp.sbh,
    //         ],
    //       ),
    //       10.sp.sbh,
    //     ],
    //   ),
    // );
  }

  Widget _buildBoxContainer(ProfileData data) {
    return Column(
      children: [
        CustomText(
          text: data.name.toString(),
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
        10.sp.sbh,
        // _buildBoxRow(),
      ],
    );
  }

  Center _buildProfileCard(ProfileData data) {
    return Center(
      child: Stack(
        children: [
          CustomImageForProfile(
              image: data.photo.toString(),
              borderWidth: 3.sp,
              radius: 40.sp,
              nameInitials: '',
              borderColor: AppColors.white),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                _pickImage();
              },
              child: CircleAvatar(
                backgroundColor: AppColors.white,
                radius: 12.sp,
                child: CircleAvatar(
                  backgroundColor: AppColors.labelColor52,
                  radius: 10.sp,
                  child: Center(
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 10.sp,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppbarTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.sp,
        vertical: 0.sp,
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
                      widget.onBackPress();
                    },
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: AppColors.white,
                      size: 3.h,
                    ),
                  ),
                  10.sp.sbw,
                  CustomText(
                    text: AppString.myProfile,
                    textAlign: TextAlign.start,
                    color: AppColors.white,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              InkWell(
                  onTap: () {
                    Get.to(() => const PersonalInfoScreen());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5.sp),
                    child: SvgPicture.asset(
                      SvgImage.editProfileIc,
                      height: 13.sp,
                      width: 13.sp,
                    ),
                  )),
            ],
          ),
          10.sp.sbh,
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

  _deleteAccount() async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title:
              "Are you sure you want to delete your account? This action is irreversible and will permanently delete all your data.",
        );
      },
    );
    if (res != null && res == true) {
      var mainController = Get.find<MainController>();
      mainController.addToStackAndNavigate(AppConstants.todayIndex);
      var sharedPrefServiceController = Get.find<ProfileSharedPrefService>();
      var authController = Get.find<AuthController>();
      var res = await authController.deleteAccount();
      if (res != null && res == true) {
        sharedPrefServiceController.clearSharedData();
        Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
      }
    }
  }

  _updateImageCover(CroppedFile? cropedFile) async {
    try {
      buildLoading(Get.context!);
      var response =
          await _profileController.uploadProfileCover(File(cropedFile!.path));
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  _pickImageForProfileCover() async {
    var file = await CommonController.pickImage();
    if (file != null) {
      var cropedFile =
          // ignore: use_build_context_synchronously
          await CommonController.cropImageForCoverImage(file, context);
      if (cropedFile != null) {
        _updateImageCover(cropedFile);
      }
    }
  }
}
