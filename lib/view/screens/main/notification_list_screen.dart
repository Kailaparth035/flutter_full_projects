import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/data/model/response/action_item_model.dart';
import 'package:aspirevue/data/model/response/notification_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/notification_options_widget.dart';
import 'package:aspirevue/view/screens/menu/my_goals/goals_details_screen.dart';
import 'package:aspirevue/view/screens/others/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final _scrollcontroller = ScrollController();
  final _mainController = Get.find<MainController>();
  // final _profileSharedPrefService = Get.find<ProfileSharedPrefService>();
  @override
  void initState() {
    super.initState();

    _readAllNotification();

    _loadData();
    _scrollcontroller.addListener(_loadMore);
  }

  _readAllNotification() async {
    var res = await _mainController.readAllNotification();
    if (res != null && res == true) {
      _mainController.notificationCount.value = 0;
    }
  }

  Future<void> _loadData() async {
    _mainController.notificationCount.value = 0;
    _mainController.getNotificationList(true);
  }

  void _loadMore() async {
    if (!_mainController.isnotMoreDataNotificationList) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_mainController.isLoadingNotificationList == false &&
            _mainController.isLoadMoreRunningNotificationList == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _mainController
              .setPageNumber(_mainController.pageNumberNotificationList + 1);
          await _mainController.getNotificationList(
            false,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: "Notifications",
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: _buildMainView(),
      ),
    );
  }

  _buildMainView() {
    return GetBuilder<MainController>(builder: (mainController) {
      return mainController.isLoadingNotificationList == true
          ? const Center(child: CustomLoadingWidget())
          : mainController.isErrorNotificationList == true ||
                  mainController.notificationList.isEmpty
              ? Center(
                  child: CustomErrorWidget(
                      isNoData: mainController.isErrorNotificationList == false,
                      isShowCustomMessage: true,
                      onRetry: () {
                        mainController.getNotificationList(true);
                      },
                      text: mainController.errorMsgNotificationList != ""
                          ? mainController.errorMsgNotificationList
                          : "Notifications not found!"),
                )
              : _buildView(mainController);
    });
  }

  _buildView(MainController mainController) {
    return RefreshIndicator(
      onRefresh: () {
        return mainController.getNotificationList(true);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollcontroller,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        _clearAllNotification();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.sp),
                        child: CustomUnderlineText(
                          text: "Clear All",
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor8,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ...mainController.notificationList.map(
                (e) => _buildDirectReportListTile(e),
              ),
              mainController.isLoadMoreRunningNotificationList
                  ? const Center(
                      child: CustomLoadingWidget(),
                    )
                  : 0.sbh
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDirectReportListTile(NotificationListData data) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (data.openType == OpenType.external) {
              if (data.link != "") {
                Get.to(WebViewScreen(url: data.link.toString()));
              }
            }

            if (data.openType == OpenType.internal) {
              // go to goal details screen
              if (data.tabName == "goal_details") {
                if (data.styleId.toString() != "0" &&
                    data.goalId.toString() != "0") {
                  Get.to(() => GoalsDetailsScreen(
                        goalId: data.goalId.toString(),
                        styleId: data.styleId.toString(),
                        type: data.goalType.toString(),
                        userId: data.userId.toString(),
                      ));
                }
              }

              // go to development
              if (data.tabName == "reputation" || data.tabName == "reflect") {
                DevelopmentType? developmentType =
                    getStyleNameFromStyleId(data.styleId.toString());

                String? tabName = getTabName(data.tabName.toString());

                bool isSuperVisor =
                    data.userType.toString() == AppConstants.userRoleSupervisor;

                if (developmentType != null && tabName != "") {
                  // open development
                  navigateTODevelopmentScreen(
                      developmentType: developmentType,
                      userRole: isSuperVisor == true
                          ? UserRole.supervisor
                          : UserRole.self,
                      userId: data.userId.toString(),
                      tabTypeRow: tabName,
                      isShowElarning: data.isShowElarning.toString() == "1");
                }
              }
              //
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageForProfile(
                  image: data.photo.toString(),
                  radius: 18.sp,
                  nameInitials: data.nameInitials.toString(),
                  borderColor: AppColors.circleGreen,
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: data.name.toString(),
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor8,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        data.title.toString() != ""
                            ? CustomText(
                                text: data.title.toString(),
                                textAlign: TextAlign.start,
                                color: AppColors.labelColor15,
                                fontFamily: AppString.manropeFontFamily,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              )
                            : 0.sbh,
                        data.description.toString() != ""
                            ? CustomText(
                                text: data.description.toString(),
                                textAlign: TextAlign.start,
                                color: AppColors.labelColor15,
                                maxLine: 3,
                                fontFamily: AppString.manropeFontFamily,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w400,
                              )
                            : 0.sbh,
                        data.isAcceptDeclineOption == 1
                            ? Row(
                                children: [
                                  _buildBorderButton(
                                    title: "Accept",
                                    onTap: () {
                                      _mainController
                                          .acceptDeclineGlobalInvitation(
                                              indexId: data.id!,
                                              isAccept: true,
                                              inviterId:
                                                  data.inviterId.toString());
                                    },
                                    color: AppColors.greenColor,
                                  ),
                                  5.sp.sbw,
                                  _buildBorderButton(
                                    title: "Decline",
                                    onTap: () {
                                      _mainController
                                          .acceptDeclineGlobalInvitation(
                                              indexId: data.id!,
                                              isAccept: false,
                                              inviterId:
                                                  data.inviterId.toString());
                                    },
                                    color: AppColors.redColor,
                                  )
                                ],
                              )
                            : 0.sbh,
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: data.time.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor15,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    Transform.translate(
                        offset: Offset(7.sp, 0),
                        child: NotificationOptionWidget(data: data)),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 5.sp,
          color: AppColors.labelColor,
          thickness: 1,
        ),
        // islast ? 80.sp.sbh : 0.sp.sbh
      ],
    );
  }

  _buildBorderButton(
      {required String title,
      required void Function()? onTap,
      required Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 4.sp,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50.sp),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 5.sp,
            horizontal: 10.sp,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                color: color,
              ),
              borderRadius: BorderRadius.circular(50.sp)),
          child: CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: color,
            maxLine: 1,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  _clearAllNotification() async {
    var res = await _mainController.clearAllNotification();
    if (res != null && res) {
      _mainController.notificationCount.value = 0;
      _mainController.getNotificationList(true);
    }
  }

  @override
  void dispose() {
    _mainController.readAllNotification();
    super.dispose();
  }
}
