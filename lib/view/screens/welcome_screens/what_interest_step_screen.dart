import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/hashtag_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WhatInterestStepsScreen extends StatefulWidget {
  const WhatInterestStepsScreen({super.key});

  @override
  State<WhatInterestStepsScreen> createState() =>
      _WhatInterestStepsScreenState();
}

class _WhatInterestStepsScreenState extends State<WhatInterestStepsScreen> {
  final _hashTagController = Get.find<HashTagController>();
  final _mainController = Get.find<MainController>();
  final yourScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        5.h.sbh,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 1.h),
          child: Center(
            child: welcomeScreenTitle(
                "Select any number of Insight Stream interests."),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 10.sp),
            child: _buildConditionView(),
          ),
        )
      ],
    );
  }

  Widget _buildConditionView() {
    return GetBuilder<MainController>(builder: (mainController) {
      if (mainController.isLoadingHashtag) {
        return const Center(child: CustomLoadingWidget());
      }
      if (mainController.isErrorHashtag || mainController.hashtagList == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              mainController.getWelcomeHashtags();
            },
            text: mainController.isErrorHashtag
                ? mainController.errorMessageHashtag
                : AppString.somethingWentWrong,
          ),
        );
      }

      return Scrollbar(
        thickness: 5.sp,
        trackVisibility: true,
        thumbVisibility: true,
        controller: yourScrollController,
        child: SingleChildScrollView(
          controller: yourScrollController, // AND Here
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding +
                    AppConstants.screenHorizontalPadding),
            child: Wrap(
              spacing: 10.sp,
              runSpacing: 10.sp,
              children: [
                ...mainController.hashtagList!
                    .where((element) => !element.isFollowed)
                    .map((e) => _buildInkwellButton(e))
              ],
            ),
          ),
        ),
      );
    });
  }

  _buildInkwellButton(HashtagData data) {
    return Container(
      decoration: BoxDecoration(
        color: data.isChecked ? AppColors.primaryColor : AppColors.white,
        borderRadius: BorderRadius.circular(200.sp),
        border: Border.all(color: AppColors.labelColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _followUnfollow(data.id.toString(), data.isChecked);
          },
          borderRadius: BorderRadius.circular(200.sp),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 12.sp),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "#",
                style: TextStyle(
                  color: data.isChecked
                      ? AppColors.white
                      : AppColors.secondaryColor,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: data.name,
                style: TextStyle(
                  color:
                      data.isChecked ? AppColors.white : AppColors.labelColor14,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ])),
          ),
        ),
      ),
    );
  }

  _followUnfollow(String hashtagID, bool isFollow) async {
    try {
      buildLoading(Get.context!);
      Map<String, dynamic> map = {
        "hashtag_id": hashtagID,
        "follow_type": isFollow ? "U" : "F"
      };
      var response = await _hashTagController.followHashtag(map);
      if (response.isSuccess == true) {
        _mainController.checkHashTagList(hashtagID, !isFollow);
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
}
