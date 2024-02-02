import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/growth_community_controller.dart';
import 'package:aspirevue/data/model/response/growth_community_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_message.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_search_text_field.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/contacts_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class GrowthCommunityListScreen extends StatefulWidget {
  const GrowthCommunityListScreen(
      {super.key, required this.title, required this.loadData});
  final String title;
  final Function(String) loadData;
  @override
  State<GrowthCommunityListScreen> createState() =>
      _GrowthCommunityListScreenState();
}

class _GrowthCommunityListScreenState extends State<GrowthCommunityListScreen> {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final _growthCommunityController = Get.find<GrowthCommunityController>();
  final _scrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollcontroller.addListener(_loadMore);
  }

  void _loadMore() async {
    if (!_growthCommunityController.isnotMoreData) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_growthCommunityController.isLoading1 == false &&
            _growthCommunityController.isLoadMoreRunning == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _growthCommunityController.isLoadMoreRunning = true;

          _growthCommunityController.pageNo += 1;
          await _growthCommunityController.getGrowthCommunityUserWithPagination(
              false, _searchController.text);

          _growthCommunityController.isLoadMoreRunning = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: GetBuilder<GrowthCommunityController>(
                builder: (growthCommunityController) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "${widget.title} ",
                          style: TextStyle(
                            color: AppColors.black,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        WidgetSpan(
                          child: SelfReflactViewPopUpWithChild(
                            showChild: showCaseChild(widget.title),
                            child: Image.asset(
                              AppImages.infoIc,
                              height: 16.sp,
                              width: 16.sp,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                  widget.title == AppString.growthCommunity
                      ? _buildImportContactButton()
                      : 0.sbh
                ],
              );
            }),
          ),
          //
          widget.title == AppString.growthCommunity
              ? CustomSearchTextField(
                  labelText: AppString.search,
                  focusNode: _searchFocus,
                  suffixIcon: AppImages.searchBlack,
                  fontFamily: AppString.manropeFontFamily,
                  textEditingController: _searchController,
                  fontSize: 10.sp,
                  onChanged: (val) {
                    _growthCommunityController
                        .getGrowthCommunityUserWithPagination(true, val);
                  },
                )
              : 0.sbh,

          Expanded(
            child: GetBuilder<GrowthCommunityController>(
                builder: (growthCommunityController) {
              if (growthCommunityController.isLoading1) {
                return const Center(
                  child: CustomLoadingWidget(),
                );
              }

              if (growthCommunityController.isError1) {
                return Center(
                  child: CustomErrorWidget(
                    text: growthCommunityController.errorMsg,
                    onRetry: () {
                      growthCommunityController
                          .getGrowthCommunityUserWithPagination(true, "");
                    },
                  ),
                );
              }

              if (growthCommunityController.userCommunityList!.isEmpty) {
                return const Center(
                  child: CustomNoDataFoundWidget(
                    topPadding: 0,
                  ),
                );
              }

              return Column(
                children: [
                  10.sp.sbh,
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollcontroller,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount:
                          growthCommunityController.userCommunityList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isLast = growthCommunityController
                                .userCommunityList!.length ==
                            index + 1;

                        return _buildGrowthCommunityListTile(
                            growthCommunityController.userCommunityList![index],
                            isLast,
                            growthCommunityController.isLoadMoreRunning);
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildImportContactButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () async {
            Get.to(() => const ContactListScreen());
          },
          child: Container(
            padding: EdgeInsets.all(1.sp),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.sp),
                color: AppColors.primaryColor),
            child: Container(
              padding: EdgeInsets.all(4.sp),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(4.sp),
              ),
              child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
                color: AppColors.white,
                text: "Show Contacts",
                textAlign: TextAlign.center,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
          ),
        ),
        1.sp.sbh,
        CustomText(
          text: "Total: ${_growthCommunityController.communityCount}",
          textAlign: TextAlign.end,
          color: AppColors.hintColor,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  Widget _buildGrowthCommunityListTile(
      GrowthCommunityListData user, bool isLast, bool isShowLoading) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageForProfile(
                image: user.photo.toString(),
                radius: 20.sp,
                nameInitials: user.nameInitials.toString(),
                borderColor: user.photo.toString() != ""
                    ? AppColors.circleGreen
                    : AppColors.labelColor8.withOpacity(0.6),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "${user.firstName} ${user.lastName}",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor8,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        maxLine: 3,
                        fontWeight: FontWeight.w600,
                      ),
                      2.sp.sbh,
                      user.positionName.toString() != ""
                          ? CustomText(
                              text: user.positionName.toString(),
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor15,
                              maxLine: 3,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                            )
                          : 0.sbw,
                      2.sp.sbh,
                      user.isRegistered == "false"
                          ? CustomText(
                              text: "${AppString.invited} : Pending",
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor40,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 12.sp,
                              maxLine: 3,
                              fontWeight: FontWeight.w500,
                            )
                          : 0.sbh,
                      user.isPromoteToColleague == "Pending" ||
                              user.isPromoteToColleague == "Decline"
                          ? CustomText(
                              text:
                                  "${AppString.promote} : ${user.isPromoteToColleague}",
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor40,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 12.sp,
                              maxLine: 3,
                              fontWeight: FontWeight.w500,
                            )
                          : 0.sbh,
                    ],
                  ),
                ),
              ),
              user.isRegistered != "false"
                  ? Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    _followUnfollowUser(user.isFollow == "true",
                                        user.userId.toString(), context);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.white,
                                    backgroundImage:
                                        const AssetImage(AppImages.usreAddIc),
                                    radius: 10.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 5.sp,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MessageAlertDialog(
                                          userId: user.id.toString(),
                                        );
                                      },
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.white,
                                    backgroundImage:
                                        const AssetImage(AppImages.emailIcon),
                                    radius: 10.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          user.isPromoteToColleague == "Invite"
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => UserProfileScreen(
                                              userId: user.id.toString()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          backgroundImage: const AssetImage(
                                              AppImages.accountIcon),
                                          radius: 10.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.sp,
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          _promotUser(
                                              user.id.toString(), context);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          backgroundImage: const AssetImage(
                                              AppImages.addPlusIc),
                                          radius: 10.sp,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    11.sp.sbw,
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(() => UserProfileScreen(
                                              userId: user.id.toString()));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.white,
                                          backgroundImage: const AssetImage(
                                              AppImages.accountIcon),
                                          radius: 10.sp,
                                        ),
                                      ),
                                    ),
                                    11.sp.sbw,
                                  ],
                                )
                        ],
                      ),
                    )
                  : 40.sp.sbw
            ],
          ),
        ),
        Divider(
          height: 5.sp,
          color: AppColors.labelColor,
          thickness: 1,
        ),
        isLast
            ? isShowLoading
                ? Column(
                    children: [
                      const Center(
                        child: CustomLoadingWidget(),
                      ),
                      20.sp.sbh,
                    ],
                  )
                : 80.sp.sbh
            : 0.sp.sbh
      ],
    );
  }

  _promotUser(String uid, BuildContext cnt) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areuSureToPromoteMSg,
        );
      },
    );

    if (res != null) {
      try {
        // ignore: use_build_context_synchronously
        buildLoading(cnt);
        var response =
            await _growthCommunityController.promoteToGlobalColleague(uid);
        if (response.isSuccess == true) {
          showCustomSnackBar(response.message, isError: false);
          _growthCommunityController.setPromoteToCollegue(uid);
          widget.loadData(_searchController.text);
        } else {
          showCustomSnackBar(response.message);
        }
      } catch (e) {
        String error = CommonController().getValidErrorMessage(e.toString());
        showCustomSnackBar(error.toString());
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(cnt);
      }
    }
  }

  _followUnfollowUser(bool isFollow, String uid, BuildContext cnt) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmAlertDialLog(
          title: isFollow
              ? AppString.areuwantToUnFollow
              : AppString.areuwantToFollow,
        );
      },
    );

    if (res != null) {
      try {
        // ignore: use_build_context_synchronously
        buildLoading(cnt);
        var response = await _growthCommunityController.userFollowUnfollow(
            uid, isFollow ? "0" : "1");
        if (response.isSuccess == true) {
          showCustomSnackBar(response.message, isError: false);
          _growthCommunityController.setFollowUnFollow(
              uid, isFollow ? "0" : "1");
          widget.loadData(_searchController.text);
        } else {
          showCustomSnackBar(response.message);
        }
      } catch (e) {
        String error = CommonController().getValidErrorMessage(e.toString());
        showCustomSnackBar(error.toString());
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(cnt);
      }
    }
  }
}
