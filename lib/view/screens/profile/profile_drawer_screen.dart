import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/profile_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/profile/change_password_screen.dart';
import 'package:aspirevue/view/screens/profile/integration_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/my_connection_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/my_profile_screen.dart';
import 'package:aspirevue/view/screens/profile/my_signature_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/notification_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/personal_info_screen.dart';
import 'package:aspirevue/view/screens/profile/privacy_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sizer/sizer.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key, required this.isFromAboutScreen});
  final bool isFromAboutScreen;
  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  final _profileController = Get.find<ProfileSharedPrefService>();

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

  _pickImageForProfile() async {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.getWidth * 0.8,
      child: Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileMainView(context),
            _buildTitle(),
            _buildDivider(3.sp),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTitleWithIcon(
                        AppString.personalinfo, AppImages.exlamation1Ic, () {
                      Get.to(() => const PersonalInfoScreen());
                    }),
                    _buildTitleWithIcon(AppString.about, AppImages.aboutIc, () {
                      if (widget.isFromAboutScreen == true) {
                        Navigator.pop(Get.context!);
                      } else {
                        Get.to(() => MyProfileScreen(
                              isFromMain: true,
                              onBackPress: () {
                                Navigator.pop(Get.context!);
                              },
                            ));
                      }
                    }),
                    _buildTitleWithIcon(
                        AppString.account, AppImages.userAccountIc1, () {
                      Get.to(() => const ChangePasswordScreen());
                    }),
                    _buildTitleWithIcon(AppString.privacy, AppImages.lockIc1,
                        () {
                      Get.to(() => const PrivacySettingScreen());
                    }),
                    _buildTitleWithIcon(
                        AppString.notifications, AppImages.notification1Ic, () {
                      Get.to(() => const NotificationSettingScreen());
                    }),
                    _buildTitleWithIcon(
                        AppString.myConnections, AppImages.contactsIc, () {
                      Get.to(() => const MyConnectionSettingScreen());
                    }),
                    _buildTitleWithIcon(AppString.integrations, AppImages.triIc,
                        () {
                      Get.to(() => const IntegrationSettingScreen());
                    }),
                    _buildTitleWithIcon(
                        AppString.signature, AppImages.signatureIc, () {
                      Get.to(() => const SignatureSettingScreen());
                    }),
                    _buildTitleWithIcon(AppString.logOut, AppImages.logoutIc,
                        () {
                      CommonController().logout();
                    })
                  ],
                ),
              ),
            ),
            50.sp.sbh,
          ],
        ),
      ),
    );
  }

  Container _buildDivider(double hie) {
    return Container(
      height: hie,
      width: double.infinity,
      color: AppColors.labelColor,
    );
  }

  Widget _buildTitleWithIcon(String title, String icon, Function ontap) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: Column(
        children: [
          7.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: 12.sp,
                  width: 12.sp,
                ),
                10.sp.sbw,
                CustomText(
                  text: title,
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor8,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          7.sp.sbh,
          _buildDivider(1.sp),
        ],
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
      child: CustomText(
        text: AppString.preferences,
        textAlign: TextAlign.start,
        color: AppColors.labelColor8,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildProfileMainView(BuildContext context) {
    return GetBuilder<ProfileSharedPrefService>(
        builder: (sharedPrefController) {
      return SizedBox(
        child: Column(
          children: [
            _buildCoverImage(sharedPrefController),
            // 9.h.sbh,
          ],
        ),
      );
    });
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
                // height: 13.h,
                height: context.getWidth * 0.8 * 0.35,
                width: double.infinity,
                image: sharedPrefController.profileData.value.coverPhoto
                    .toString(),
                fit: BoxFit.fitWidth,
              ),
              Positioned.fill(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    _pickImageForProfileCover();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(1.1.h),
                    child: Container(
                      padding: EdgeInsets.all(0.4.h),
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
          offset: Offset(0, -5.h),
          child: Column(
            children: [
              _buildProfileCard(
                sharedPrefController.profileData.value.photo.toString(),
              ),
              5.sp.sbh,
              _buildBoxContainer(sharedPrefController.profileData.value)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBoxContainer(ProfileData profiledata) {
    return Column(
      children: [
        CustomText(
          text: profiledata.name.toString(),
          textAlign: TextAlign.start,
          color: AppColors.black,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        CustomText(
          text: profiledata.roleName.toString(),
          textAlign: TextAlign.start,
          color: AppColors.black,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }

  Center _buildProfileCard(String photo) {
    return Center(
      child: Stack(
        children: [
          CustomImageForProfile(
              image: photo,
              borderWidth: 3,
              radius: 31.sp,
              nameInitials: "",
              borderColor: AppColors.white),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                _pickImageForProfile();
              },
              child: CircleAvatar(
                backgroundColor: AppColors.white,
                radius: 10.sp,
                child: CircleAvatar(
                  backgroundColor: AppColors.labelColor52,
                  radius: 8.sp,
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
}
