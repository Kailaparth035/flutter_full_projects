import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/bottom_sheet/bottom_sheet_for_post.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post__self_popup_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/profile_view_popup_widget.dart';
import 'package:aspirevue/view/screens/profile/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget({
    super.key,
    required this.record,
    required this.isParent,
    required this.isFrom,
    this.streamType,
    required this.onDeleting,
    required this.onEditing,
  });
  final Record record;
  final bool isParent;
  final PostTypeEnum isFrom;
  final UserInsightStreamEnumType? streamType;
  final Function onEditing;
  final Function onDeleting;

  @override
  Widget build(BuildContext context) {
    return _buildImageAndName(context);
  }

  Widget _buildImageAndName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isParent ? 15.sp : 10.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (Get.find<ProfileSharedPrefService>()
                      .profileData
                      .value
                      .id
                      .toString() ==
                  record.userId.toString()) {
                Get.to(() => MyProfileScreen(
                      isFromMain: true,
                      onBackPress: () {
                        Navigator.pop(Get.context!);
                      },
                    ));
              } else {
                Get.to(() => UserProfileScreen(
                      userId: record.userId.toString(),
                    ));
              }
            },
            child: CustomImageForProfile(
              image: record.photo!,
              radius: isParent ? 18.sp : 16.sp,
              nameInitials: record.selfInitial.toString(),
              borderColor: AppColors.labelColor,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      ...record.tagLine!.map(
                        (e) => _buildTagUserListTile(e),
                      ),
                    ],
                  ),
                ),
                3.sp.sbh,
                CustomText(
                  text: record.postTime!,
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor15,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 9.sp,
                  maxLine: 2,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
          isParent ? _buildSelfThreeDot(context) : 0.sbh,
        ],
      ),
    );
  }

  Widget _buildSelfThreeDot(BuildContext context) {
    if (isFrom == PostTypeEnum.hashtag) {
      return record.loginUserId == record.userId
          ? 0.sbh
          : InkWell(
              onTap: () {
                _showBottomSheet(context);
              },
              child: Image.asset(AppImages.optionMenu, height: 3.h));
    } else if (isFrom == PostTypeEnum.user) {
      if (streamType != null &&
          streamType == UserInsightStreamEnumType.savedPost) {
        return InkWell(
          onTap: () {
            _showBottomSheet(context);
          },
          child: Image.asset(AppImages.optionMenu, height: 3.h),
        );
      } else {
        return record.loginUserId == record.userId
            ? PostSelfPopUpWidget(
                onEditing: () {
                  onEditing();
                },
                onDeleting: () {
                  onDeleting();
                },
                shareUrl: record.shareUrl.toString(),
              )
            : InkWell(
                onTap: () {
                  _showBottomSheet(context);
                },
                child: Image.asset(AppImages.optionMenu, height: 3.h));
      }
    } else {
      return record.loginUserId == record.userId
          ? PostSelfPopUpWidget(
              onEditing: () {
                onEditing();
              },
              onDeleting: () {
                onDeleting();
              },
              shareUrl: record.shareUrl.toString(),
            )
          : InkWell(
              onTap: () {
                _showBottomSheet(context);
              },
              child: Image.asset(AppImages.optionMenu, height: 3.h));
    }
  }

  _buildTagUserListTile(TagLine tagUser) {
    if (tagUser.type == "link") {
      return WidgetSpan(
        alignment: PlaceholderAlignment.bottom,
        child: Container(
            transform: Matrix4.translationValues(
                0, Get.context!.isTablet ? 3.sp : 1.5.sp, 0),
            margin: EdgeInsets.only(bottom: 0.sp),
            child: ProfileViewPopUp(
              userDetails: tagUser,
              child: CustomText(
                text: tagUser.name.toString(),
                textAlign: TextAlign.start,
                color: AppColors.labelColor14,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                maxLine: 2,
                fontWeight: FontWeight.w600,
              ),
            )),
      );
    } else if (tagUser.type == "text") {
      return TextSpan(
        text: tagUser.name.toString(),
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: AppString.manropeFontFamily,
          fontWeight: FontWeight.w600,
          color: AppColors.labelColor14,
        ),
      );
    } else if (tagUser.type == "emoji") {
      if (tagUser.name!.contains("happy")) {
        return TextSpan(
          text: " ${AppString.smilyEmoji}",
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.labelColor14,
          ),
        );
      } else if (tagUser.name!.contains("sad")) {
        return TextSpan(
          text: " ${AppString.sadEmoji}",
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.labelColor14,
          ),
        );
      } else {
        return TextSpan(
          text: " ${AppString.otherEmoji}",
          style: TextStyle(
            fontSize: 12.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w600,
            color: AppColors.labelColor14,
          ),
        );
      }
    } else {
      return TextSpan(
        text: "",
        style: TextStyle(
          fontSize: 12.sp,
          fontFamily: AppString.manropeFontFamily,
          fontWeight: FontWeight.w600,
          color: AppColors.labelColor14,
        ),
      );
    }
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.sp),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return BottomSheetForPost(
            streamType: streamType,
            isFrom: isFrom,
            userId: record.userId.toString(),
            postId: record.id.toString(),
            isPostSaved: record.isPostSaved ?? 0,
            isUserBlocked: record.isUserBlocked ?? 0,
            isUserFollowed: record.isUserFollowed ?? 0,
            userName: record.userName.toString(),
            shareUrl: record.shareUrl.toString(),
            // ===================================================
            isShowAddCollegue: _isShowAddCollegue(),
            isShowSaveUnsave: true,
            isShowHidePost: _isShowHidePost(),
            isShowHideAllPost: isShowHideAllPost(),
            isShowFollowUnFollow: _isShowFollowUnFollow(),
            isShowBlockUnblock: isShowBlockUnblock(),
            isShowReportPost: true,
          );
        });
  }

  bool _isShowFollowUnFollow() {
    if (streamType != null &&
        streamType == UserInsightStreamEnumType.savedPost) {
      return false;
    } else {
      return true;
    }
  }

  bool _isShowAddCollegue() {
    if (streamType != null &&
        streamType == UserInsightStreamEnumType.savedPost) {
      return false;
    } else {
      return record.isUseAsGlobal == 1;
    }
  }

  bool isShowBlockUnblock() {
    if (streamType != null &&
        streamType == UserInsightStreamEnumType.savedPost) {
      return false;
    } else if (isFrom == PostTypeEnum.hashtag) {
      return false;
    } else if (isFrom == PostTypeEnum.user) {
      return true;
    } else {
      return true;
    }
  }

  bool _isShowHidePost() {
    if (streamType != null &&
        streamType == UserInsightStreamEnumType.savedPost) {
      return false;
    } else if (isFrom == PostTypeEnum.hashtag) {
      return false;
    } else if (isFrom == PostTypeEnum.user) {
      return false;
    } else {
      return true;
    }
  }

  bool isShowHideAllPost() {
    if (streamType != null &&
        streamType == UserInsightStreamEnumType.savedPost) {
      return false;
    } else if (isFrom == PostTypeEnum.hashtag) {
      return false;
    } else if (isFrom == PostTypeEnum.user) {
      return false;
    } else {
      return true;
    }
  }
}
