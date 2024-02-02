import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ProfileUpdateStepScreen extends StatefulWidget {
  const ProfileUpdateStepScreen({super.key});

  @override
  State<ProfileUpdateStepScreen> createState() =>
      _ProfileUpdateStepScreenState();
}

class _ProfileUpdateStepScreenState extends State<ProfileUpdateStepScreen> {
  final _profileController = Get.find<ProfileSharedPrefService>();

  // String? imageUrl = null;

  _updateImage(CroppedFile? cropedFile) async {
    try {
      buildLoading(Get.context!);
      var response =
          await _profileController.uploadProfilePicture(File(cropedFile!.path));
      if (response.isSuccess == true) {
        if (response.responseT!.body['data'] != null) {
          setState(() {
            _profileController
                .setProfileImage(response.responseT!.body['data']);
          });
        }
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

  _pickImage(ImageSource imageSource) async {
    var file = await CommonController.pickImage(imageSource: imageSource);
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          5.h.sbh,
          Padding(
            padding: EdgeInsets.all(5.h),
            child: Center(
              child: welcomeScreenTitle("Profile Picture"),
            ),
          ),
          5.h.sbh,
          _buildProfileCircle(),
          2.h.sbh,
          Center(
              child: InkWell(
            onTap: () {},
            child: CustomText(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              color: AppColors.labelColor8,
              text: "Add Your Photo",
              textAlign: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
            ),
          )),
          10.h.sbh,
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton2(
                      buttonText: "Upload Photo",
                      icon: AppImages.galleryIc,
                      radius: 3.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 13.sp),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      }),
                ),
                AppConstants.screenHorizontalPadding.sbw,
                Expanded(
                  child: CustomButton2(
                      buttonText: "Take Photo",
                      icon: AppImages.cameraWhiteIc,
                      radius: 3.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 13.sp),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      }),
                )
              ],
            ),
          )

          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 25.sp),
          //   child: Center(
          //     child: welcomeScreenSubTitle(
          //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore."),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildProfileCircle() {
    return Center(
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              // _pickImage();
            },
            borderRadius: BorderRadius.circular(300),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.secondaryColor.withOpacity(0.5),
                    width: 0.8.sp),
                shape: BoxShape.circle,
                color: AppColors.secondaryColor.withOpacity(0.24),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.sp),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.secondaryColor, width: 5.sp),
                    shape: BoxShape.circle,
                    color: AppColors.labelColor95,
                  ),
                  child: Obx(() {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: CustomImage(
                          width: 11.h,
                          height: 11.h,
                          fit: BoxFit.cover,
                          image: _profileController.profileImage.toString()),
                    );
                  }),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 2.sp,
          //   right: 2.sp,
          //   child: InkWell(
          //     onTap: () async {},
          //     child: CircleAvatar(
          //       backgroundColor: AppColors.white,
          //       radius: 12.sp,
          //       child: CircleAvatar(
          //         backgroundColor: AppColors.labelColor52,
          //         radius: 10.sp,
          //         child: Center(
          //           child: Icon(
          //             Icons.camera_alt,
          //             color: AppColors.white,
          //             size: 10.sp,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  // Center _buildProfileCard(String photo) {
  //   return Center(
  //     child: Stack(
  //       children: [
  //         CustomImageForProfile(
  //             image: photo,
  //             borderWidth: 3,
  //             radius: 31.sp,
  //             nameInitials: "",
  //             borderColor: AppColors.white),
  //       ],
  //     ),
  //   );
  // }
}
