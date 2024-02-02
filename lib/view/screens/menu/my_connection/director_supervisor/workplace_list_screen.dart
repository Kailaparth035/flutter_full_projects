import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/data/model/response/my_connection_user_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_message.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:aspirevue/view/screens/menu/development/development_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/director_supervisor/badge_detail_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/goals/goals_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WorkplaceScreen extends StatefulWidget {
  const WorkplaceScreen({super.key, required this.title});
  final String title;
  @override
  State<WorkplaceScreen> createState() => _WorkplaceScreenState();
}

class _WorkplaceScreenState extends State<WorkplaceScreen> {
  final _myConnectionController = Get.find<MyConnectionController>();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    var map = <String, dynamic>{};
    if (widget.title == AppString.supervisors) {
      map['type'] = "1";
    }
    if (widget.title == AppString.directReports) {
      map['type'] = "2";
    }
    if (widget.title == AppString.peers) {
      map['type'] = "3";
    }
    if (widget.title == AppString.community) {
      map['type'] = "4";
    }

    Get.find<MyConnectionController>().getMyConnections(map);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: Column(
        children: [
          10.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: AppColors.black,
                  text: widget.title,
                  textAlign: TextAlign.center,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<MyConnectionController>(
                builder: (myConnectionController) {
              if (myConnectionController.isLoading) {
                return const Center(
                  child: CustomLoadingWidget(),
                );
              }

              if (myConnectionController.isError) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: CustomErrorWidget(
                    text: myConnectionController.errorMsg,
                    onRetry: () {
                      loadData();
                    },
                  ),
                );
              }
              if (myConnectionController.userList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: const CustomNoDataFoundWidget(),
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: myConnectionController.userList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isLast =
                      myConnectionController.userList.length == index + 1;
                  switch (widget.title) {
                    case AppString.directReports:
                      {
                        return _buildDirectReportListTile(
                            myConnectionController.userList[index],
                            false,
                            isLast);
                      }

                    case AppString.supervisors:
                      {
                        return _buildSupervisorListTile(
                            myConnectionController.userList[index], isLast);
                      }

                    case AppString.peers:
                      {
                        return _buildSupervisorListTile(
                            myConnectionController.userList[index], isLast);
                      }

                    case AppString.community:
                      {
                        return _buildDirectReportListTile(
                            myConnectionController.userList[index],
                            true,
                            isLast);
                      }

                    default:
                      {
                        return _buildSupervisorListTile(
                            myConnectionController.userList[index], isLast);
                      }
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectReportListTile(
      MyConnectionUserListData user, bool isCommunity, bool islast) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.circleGreen,
                radius: 20.sp,
                child: CircleAvatar(
                  backgroundColor: AppColors.white,
                  backgroundImage: NetworkImage(
                    user.photo.toString(),
                  ),
                  radius: 19.sp,
                ),
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
                      SizedBox(
                        height: 3.sp,
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
              SizedBox(
                  width: 42.sp,
                  child: Wrap(
                    textDirection: TextDirection.rtl,
                    direction: Axis.horizontal,
                    spacing: 1.sp,
                    runSpacing: 1.sp,
                    children: [
                      _buildEmailIcon(user),
                      _buildGoalIcon(user),
                      _buildUserIcon(user),
                      isCommunity
                          ? _buildDeleteIcon(user)
                          : user.isShowDevelopment == "1"
                              ? _buildJourneyIcon(user.id.toString())
                              : 0.sbh,
                      user.assessbadges.toString() == "1"
                          ? InkWell(
                              onTap: () {
                                Get.to(() => BadgeDetailScreen(
                                      userId: user.id.toString(),
                                      userName: user.name.toString(),
                                    ));
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                backgroundImage:
                                    const AssetImage(AppImages.badgeRoundedIc),
                                radius: 10.sp,
                              ),
                            )
                          : 0.sbh,
                    ],
                  )),
            ],
          ),
        ),
        Divider(
          height: 5.sp,
          color: AppColors.labelColor,
          thickness: 1,
        ),
        islast ? 80.sp.sbh : 0.sp.sbh
      ],
    );
  }

  InkWell _buildJourneyIcon(String userId) {
    return InkWell(
      onTap: () {
        Get.to(DevelopmentScreen(
          userId: userId,
        ));
      },
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        backgroundImage: const AssetImage(AppImages.flowerIcon),
        radius: 10.sp,
      ),
    );
  }

  InkWell _buildDeleteIcon(MyConnectionUserListData user) {
    return InkWell(
      onTap: () {
        _deleteUser(user.id.toString(), context);
      },
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        backgroundImage: const AssetImage(AppImages.icDelete),
        radius: 10.sp,
      ),
    );
  }

  InkWell _buildUserIcon(MyConnectionUserListData user) {
    return InkWell(
      onTap: () {
        Get.to(UserProfileScreen(userId: user.id.toString()));
      },
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        backgroundImage: const AssetImage(AppImages.accountIcon),
        radius: 10.sp,
      ),
    );
  }

  InkWell _buildGoalIcon(MyConnectionUserListData user) {
    return InkWell(
      onTap: () {
        Get.to(GoalsScreen(
          userId: user.id.toString(),
        ));
      },
      child: CircleAvatar(
        backgroundColor: AppColors.white,
        backgroundImage: const AssetImage(AppImages.roundIcon),
        radius: 10.sp,
      ),
    );
  }

  InkWell _buildEmailIcon(MyConnectionUserListData user) {
    return InkWell(
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
        backgroundImage: const AssetImage(AppImages.emailIcon),
        radius: 10.sp,
      ),
    );
  }

  Widget _buildSupervisorListTile(MyConnectionUserListData user, bool isLast) {
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
                      SizedBox(
                        height: 3.sp,
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

              SizedBox(
                  width: 42.sp,
                  child: Wrap(
                    textDirection: TextDirection.rtl,
                    direction: Axis.horizontal,
                    spacing: 1.sp,
                    runSpacing: 1.sp,
                    children: [
                      _buildEmailIcon(user),
                      _buildGoalIcon(user),
                      _buildUserIcon(user),
                      user.assessbadges.toString() == "1"
                          ? InkWell(
                              onTap: () {
                                Get.to(() => BadgeDetailScreen(
                                      userId: user.id.toString(),
                                      userName: user.name.toString(),
                                    ));
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.white,
                                backgroundImage:
                                    const AssetImage(AppImages.badgeRoundedIc),
                                radius: 10.sp,
                              ),
                            )
                          : 0.sbh,
                    ],
                  )),

              // Expanded(
              //     flex: 1,
              //     child: Column(
              //       children: [
              //         Row(
              //           children: [
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Get.to(GoalsScreen(
              //                     userId: user.id.toString(),
              //                   ));
              //                 },
              //                 child: CircleAvatar(
              //                   backgroundColor: AppColors.white,
              //                   backgroundImage:
              //                       const AssetImage(AppImages.roundIcon),
              //                   radius: 10.sp,
              //                 ),
              //               ),
              //             ),
              //             SizedBox(
              //               width: 5.sp,
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   showDialog(
              //                     context: context,
              //                     builder: (BuildContext context) {
              //                       return MessageAlertDialog(
              //                         userId: user.id.toString(),
              //                       );
              //                     },
              //                   );
              //                 },
              //                 child: CircleAvatar(
              //                   backgroundColor: AppColors.white,
              //                   backgroundImage:
              //                       const AssetImage(AppImages.emailIcon),
              //                   radius: 10.sp,
              //                 ),
              //               ),
              //             ),
              //             user.assessbadges.toString() == "1"
              //                 ? Expanded(
              //                     child: InkWell(
              //                       onTap: () {
              //                         Get.to(BadgeDetailScreen(
              //                           userId: user.id.toString(),
              //                           userName: user.name.toString(),
              //                         ));
              //                       },
              //                       child: CircleAvatar(
              //                         backgroundColor: AppColors.white,
              //                         backgroundImage: const AssetImage(
              //                             AppImages.badgeRoundedIc),
              //                         radius: 10.sp,
              //                       ),
              //                     ),
              //                   )
              //                 : 0.sbh,
              //           ],
              //         ),
              //         SizedBox(
              //           height: 5.sp,
              //         ),
              //         Row(
              //           children: [
              //             SizedBox(
              //               width: 9.sp,
              //             ),
              //             Expanded(
              //               child: InkWell(
              //                 onTap: () {
              //                   Get.to(UserAboutScreen(
              //                     userId: user.id.toString(),
              //                   ));
              //                 },
              //                 child: CircleAvatar(
              //                   backgroundColor: AppColors.white,
              //                   backgroundImage:
              //                       const AssetImage(AppImages.accountIcon),
              //                   radius: 10.sp,
              //                 ),
              //               ),
              //             ),
              //             SizedBox(
              //               width: 9.sp,
              //             ),
              //           ],
              //         )
              //       ],
              //     ))
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

//  method for delete user
  _deleteUser(String uid, BuildContext cnt) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areuSureToRemovePersonMSg,
        );
      },
    );

    if (res != null) {
      try {
        // ignore: use_build_context_synchronously
        buildLoading(cnt);
        var response = await _myConnectionController.removeAsCommunityUser(uid);
        if (response.isSuccess == true) {
          showCustomSnackBar(response.message, isError: false);
          loadData();
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
