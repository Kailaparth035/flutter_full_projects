import 'dart:async';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/growth_community_controller.dart';
import 'package:aspirevue/data/model/response/growth_community_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({
    super.key,
  });

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen>
    with TickerProviderStateMixin {
  final _growthCommunityController = Get.find<GrowthCommunityController>();
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final _scrollcontroller = ScrollController();

  Timer? searchOnStoppedTyping;

  onDelayHandler(Function callback) {
    const duration = Duration(milliseconds: 550);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    searchOnStoppedTyping = Timer(duration, () {
      callback();
    });
  }

  @override
  void initState() {
    super.initState();

    _growthCommunityController.getContactsWithPagination(true, "");
    _scrollcontroller.addListener(_loadMore);
  }

  void _loadMore() async {
    if (!_growthCommunityController.isnotMoreDataContacts) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_growthCommunityController.isLoadingContacts == false &&
            _growthCommunityController.isLoadMoreRunningContacts == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _growthCommunityController.isLoadMoreRunningContacts = true;

          _growthCommunityController.pageNoContacts += 1;
          await _growthCommunityController.getContactsWithPagination(
              false, _searchController.text);

          _growthCommunityController.isLoadMoreRunningContacts = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: CommonController.getAnnanotaion(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              appbarTitle: AppString.myConnections,
              isShowSearchIcon: true,
              onbackPress: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: AppColors.backgroundColor1,
          // bottomNavigationBar: const BottomNavBar(
          //   isFromMain: false,
          // ),
          body: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: Column(
              children: [
                15.sp.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<GrowthCommunityController>(
                          builder: (growthCommunityController) {
                        return CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: AppColors.black,
                          text:
                              "Contacts (${_growthCommunityController.contactTotlaCount})",
                          textAlign: TextAlign.center,
                          fontFamily: AppString.manropeFontFamily,
                        );
                      }),
                      const Spacer(),
                      _buildImportContactButton()
                    ],
                  ),
                ),
                CustomSearchTextField(
                  labelText: AppString.search,
                  focusNode: _searchFocus,
                  suffixIcon: AppImages.searchBlack,
                  fontFamily: AppString.manropeFontFamily,
                  textEditingController: _searchController,
                  fontSize: 10.sp,
                  onChanged: (val) {
                    onDelayHandler(() {
                      _growthCommunityController.getContactsWithPagination(
                          true, val);
                    });
                  },
                ),
                Expanded(
                  child: GetBuilder<GrowthCommunityController>(
                      builder: (growthCommunityController) {
                    if (growthCommunityController.isLoadingContacts) {
                      return const Center(
                        child: CustomLoadingWidget(),
                      );
                    }
                    if (growthCommunityController.isLoadingContact) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              child: CustomLoadingWidget(),
                            ),
                            CustomText(
                              text: AppString.importingContacts,
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor8,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 12.sp,
                              maxLine: 3,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      );
                    }

                    if (growthCommunityController.isErrorContacts) {
                      return Center(
                        child: CustomErrorWidget(
                          text: growthCommunityController.errorMessageContacts,
                          onRetry: () {
                            growthCommunityController.getContactsWithPagination(
                                true, "");
                          },
                        ),
                      );
                    }

                    if (growthCommunityController
                        .userCommunityListContacts!.isEmpty) {
                      return const Center(
                        child: CustomNoDataFoundWidget(topPadding: 0),
                      );
                    }

                    return Column(
                      children: [
                        10.sp.sbh,
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () {
                              return growthCommunityController
                                  .getContactsWithPagination(
                                      true, _searchController.text);
                            },
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollcontroller,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: growthCommunityController
                                  .userCommunityListContacts!.length,
                              itemBuilder: (context, index) {
                                bool isLast = growthCommunityController
                                        .userCommunityListContacts!.length ==
                                    index + 1;

                                return _buildGrowthCommunityListTile(
                                    growthCommunityController
                                        .userCommunityListContacts![index],
                                    isLast,
                                    growthCommunityController
                                        .isLoadMoreRunningContacts);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrowthCommunityListTile(
      GrowthCommunityListData user, bool isLast, bool isShowLoading) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp),
          child: IntrinsicHeight(
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
                        user.emailAddress.toString() != "null" &&
                                user.emailAddress.toString() != ""
                            ? CustomText(
                                text: user.emailAddress.toString(),
                                textAlign: TextAlign.start,
                                color: AppColors.labelColor15,
                                maxLine: 3,
                                fontFamily: AppString.manropeFontFamily,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                              )
                            : 0.sbw,
                        user.phone.toString() != ""
                            ? CustomText(
                                text: user.phone.toString(),
                                textAlign: TextAlign.start,
                                color: AppColors.labelColor15,
                                maxLine: 3,
                                fontFamily: AppString.manropeFontFamily,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                              )
                            : 0.sbw,
                        2.sp.sbh,
                        user.isInvited == 1
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
                      ],
                    ),
                  ),
                ),
                user.isInvited == 0
                    ? Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton2(
                                buttonText: "Invite",
                                radius: 5.sp,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.sp, horizontal: 10.sp),
                                fontWeight: FontWeight.w700,
                                fontSize: 10.sp,
                                onPressed: () {
                                  _inviteContact(user.id.toString());
                                })
                            // Center(
                            //   child: InkWell(
                            //     onTap: () {
                            //       _inviteContact(user.id.toString());
                            //     },
                            //     child: CircleAvatar(
                            //       backgroundColor: AppColors.white,
                            //       backgroundImage:
                            //           const AssetImage(AppImages.addPlusIc),
                            //       radius: 10.sp,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    : 0.sbh
              ],
            ),
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

  Widget _buildImportContactButton() {
    return InkWell(
      onTap: () async {
        if (_growthCommunityController.isLoadingContact == false) {
          var result = await _growthCommunityController.syncContacts();

          if (result != null) {
            _growthCommunityController.getContactsWithPagination(true, "");
          }
        }
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
            text: "Import Contacts",
            textAlign: TextAlign.center,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
      ),
    );
  }

  _inviteContact(String contactId) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
            title: "Are you sure you want to Invite?");
      },
    );

    if (res != null && res == true) {
      try {
        buildLoading(Get.context!);
        var response =
            await _growthCommunityController.inviteContact(contactId);
        if (response.isSuccess == true) {
          showCustomSnackBar(response.message, isError: false);
          _growthCommunityController.updateContactList(contactId);
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
}
