import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/data/model/response/my_connection_user_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_add_colleague.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_message.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/goals/goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PersonalGrowthListScreen extends StatefulWidget {
  const PersonalGrowthListScreen(
      {super.key, required this.title, required this.loadData});
  final String title;
  final Function loadData;
  @override
  State<PersonalGrowthListScreen> createState() =>
      _PersonalGrowthListScreenState();
}

class _PersonalGrowthListScreenState extends State<PersonalGrowthListScreen> {
  final _myConnectionController = Get.find<MyConnectionController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: Column(
        children: [
          // 15.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Row(
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
                widget.title == AppString.colleagues
                    ? _buildCreateColleagueButton()
                    : 0.sbh
              ],
            ),
          ),

          Expanded(
            child: GetBuilder<MyConnectionController>(
                builder: (myConnectionController) {
              if (myConnectionController.isLoading) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: const CustomLoadingWidget(),
                  ),
                );
              }

              if (myConnectionController.isError) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: CustomErrorWidget(
                    text: myConnectionController.errorMsg,
                    onRetry: () {
                      myConnectionController.getColleaguesData({});
                    },
                  ),
                );
              }

              if (myConnectionController.userList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: const CustomNoDataFoundWidget(),
                );
              }

              return RefreshIndicator(
                onRefresh: () {
                  return widget.loadData();
                },
                child: ListView.builder(
                  primary: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: myConnectionController.userList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    switch (widget.title) {
                      case AppString.colleagues:
                        {
                          return _buildColleaguesListTile(
                              myConnectionController.userList[index],
                              myConnectionController.userList.length ==
                                  index + 1);
                        }

                      case AppString.circleOfInfluenceMyFollower:
                        {
                          return _buildCircularInfluence(
                              myConnectionController.userList[index],
                              myConnectionController.userList.length ==
                                  index + 1);
                        }

                      default:
                        {
                          return _buildCircularInfluence(
                              myConnectionController.userList[index],
                              myConnectionController.userList.length ==
                                  index + 1);
                        }
                    }
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateColleagueButton() {
    return InkWell(
      onTap: () async {
        var result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return const CreateColleagueAlertDialog();
          },
        );

        if (result != null && result == true) {
          widget.loadData();
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
            text: AppString.createColleague,
            textAlign: TextAlign.center,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
      ),
    );
  }

  Widget _buildCircularInfluence(MyConnectionUserListData user, bool isLast) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp),
          child: Row(
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
                        text: user.name.toString(),
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor8,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        text: user.positionName.toString(),
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor15,
                        maxLine: 3,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(() =>
                              UserProfileScreen(userId: user.id.toString()));
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.white,
                          backgroundImage:
                              const AssetImage(AppImages.accountIcon),
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
              )
            ],
          ),
        ),
        Divider(
          height: 5.sp,
          color: AppColors.labelColor,
          thickness: 1,
        ),
        isLast ? 80.sp.sbh : 0.sp.sbh
      ],
    );
  }

  Widget _buildColleaguesListTile(MyConnectionUserListData user, bool isLast) {
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: user.name.toString(),
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor8,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        user.positionName.toString() == ""
                            ? 0.sbh
                            : CustomText(
                                text: user.positionName.toString(),
                                textAlign: TextAlign.start,
                                color: AppColors.labelColor15,
                                maxLine: 3,
                                fontFamily: AppString.manropeFontFamily,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.normal,
                              ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => GoalsScreen(
                                      userId: user.id.toString(),
                                    ));
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                backgroundImage:
                                    const AssetImage(AppImages.roundIcon),
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => UserProfileScreen(
                                    userId: user.id.toString()));
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                backgroundImage:
                                    const AssetImage(AppImages.accountIcon),
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
                                _deleteUser(user.id.toString());
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                backgroundImage:
                                    const AssetImage(AppImages.icDelete),
                                radius: 10.sp,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 5.sp,
          color: AppColors.labelColor,
          thickness: 1,
        ),
        isLast ? 80.sp.sbh : 0.sp.sbh
      ],
    );
  }

  _deleteUser(String uid) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areuSureToRemovePersonFromCollegueMSg,
        );
      },
    );

    if (res != null) {
      try {
        buildLoading(Get.context!);
        var response = await _myConnectionController.removeAsColleagueUser(uid);
        if (response.isSuccess == true) {
          showCustomSnackBar(response.message, isError: false);
          widget.loadData();
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
