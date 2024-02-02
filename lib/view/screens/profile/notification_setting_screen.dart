import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/notification_setting_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:upgrader/upgrader.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  late Future<NotificationSettingData> _futureCall;
  final _profileController = Get.find<ProfileSharedPrefService>();

  bool _isLoading = false;

  bool _isAllowNotification = false;
  @override
  void initState() {
    super.initState();
    _reFreshData();
  }

  bool _isInitial = true;
  _upldateData(bool val) {
    if (_isInitial == true) {
      _isAllowNotification = val;
      _isInitial = false;
    }
  }

  _reFreshData() async {
    setState(() {
      _futureCall = _profileController.getNotificationSettings({});
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
        upgrader: Upgrader(
          canDismissDialog: false,
          showLater: false,
          showIgnore: false,
          showReleaseNotes: false,
          debugLogging: true,
        ),
        child: CommonController.getAnnanotaion(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: AppbarWithBackButton(
                bgColor: AppColors.white,
                appbarTitle: AppString.myProfile,
                onbackPress: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: AppColors.white,
            body: FutureBuildWidget(
              onRetry: () {
                _reFreshData();
              },
              isList: false,
              future: _futureCall,
              child: (NotificationSettingData data) {
                return CustomSlideUpAndFadeWidget(child: _buildMainView(data));
              },
            ),
          ),
        ));
  }

  SingleChildScrollView _buildMainView(NotificationSettingData data) {
    _upldateData(data.appAllowNotification == 1);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainTitle(),
            10.sp.sbh,
            buildTitleToggle("Allow Notification", _isAllowNotification,
                () async {
              var result = await Get.find<MainController>()
                  .allowNotification(!_isAllowNotification);
              if (result != null && result == true) {
                setState(() {
                  _isAllowNotification = !_isAllowNotification;
                });
              }
            }),
            5.sp.sbh,
            data.messagesNotesComments != null
                ? _buildBoxTileForMessage(AppString.messagesNotesComments,
                    data.messagesNotesComments!)
                : 0.sbh,
            data.performanceInvitation != null
                ? _buildBoxTileForPerformace1(
                    AppString.performanceInvitation,
                    data.performanceInvitation!,
                  )
                : 0.sbh,
            data.developmentInvitation != null
                ? _buildBoxTileForDevelopment(
                    AppString.developmentInvitation,
                    data.developmentInvitation!,
                  )
                : 0.sbh,
            data.followersRequest != null
                ? _buildBoxTileForFollower(
                    AppString.followersRequest,
                    data.followersRequest!,
                  )
                : 0.sbh,
            data.licenseAssignNotification != null
                ? _buildBoxTileForLiecense(
                    AppString.licenseAssignNotification,
                    data.licenseAssignNotification!,
                  )
                : 0.sbh,
            data.projectArchiveNotification != null
                ? _buildBoxTileForNewProject(
                    AppString.projectArchiveNotification,
                    data.projectArchiveNotification!,
                  )
                : 0.sbh,
            data.successionPlanningNotification != null
                ? _buildBoxTileForNewSuccess(
                    AppString.successionPlanningNotification,
                    data.successionPlanningNotification!,
                  )
                : 0.sbh,
            data.successionPlanningNotification != null
                ? _buildBoxTileForDailyQReminder(
                    "DailyQ",
                    data.dailyqReminder!,
                  )
                : 0.sbh,
            20.sp.sbh,
            Center(
              child: _isLoading
                  ? SizedBox(
                      child: CustomLoadingWidget(
                        height: 50.sp,
                      ),
                    )
                  : CustomButton2(
                      buttonText: AppString.saveChanges,
                      radius: 5.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp,
                          horizontal: AppConstants.screenHorizontalPadding),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      onPressed: () {
                        _updateNotificationSetting(data.toJson());
                      }),
            ),
            20.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildBoxTileForNewSuccess(
      String title, SuccessionPlanningNotification data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApireVueText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.successionalInvitationInbox == 1,
                        onChange: (val) {
                          setState(() {
                            data.successionalInvitationInbox =
                                val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: AppString.email,
                        textAlign: TextAlign.end,
                        color: AppColors.labelColor9,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 10.sp,
                        maxLine: 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.successionalInvitationEmail == 1,
                        onChange: (val) {
                          setState(() {
                            data.successionalInvitationEmail =
                                val == true ? 1 : 0;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          data.isSlackAvailable == 1 ? 10.sp.sbh : 0.sbh,
          data.isSlackAvailable == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomText(
                              text: AppString.slack,
                              textAlign: TextAlign.end,
                              color: AppColors.labelColor9,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              maxLine: 2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          5.sp.sbw,
                          _buildSwitchButton(
                              val: data.successionalInvitationSlack == 1,
                              onChange: (val) {
                                setState(() {
                                  data.successionalInvitationSlack =
                                      val == true ? 1 : 0;
                                });
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: 0.sbh,
                    )
                  ],
                )
              : 0.sbh,
        ],
      ),
    );
  }

  Expanded _buildApireVueText() {
    return Expanded(
      child: CustomText(
        text: AppString.notifications,
        textAlign: TextAlign.end,
        color: AppColors.labelColor9,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
        maxLine: 2,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildBoxTileForNewProject(
      String title, ProjectArchiveNotification data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApireVueText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.projectArchiveNotificationInbox == 1,
                        onChange: (val) {
                          setState(() {
                            data.projectArchiveNotificationInbox =
                                val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildEmailText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.projectArchiveNotificationEmail == 1,
                        onChange: (val) {
                          setState(() {
                            data.projectArchiveNotificationEmail =
                                val == true ? 1 : 0;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          data.isSlackAvailable == 1 ? 10.sp.sbh : 0.sbh,
          data.isSlackAvailable == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildSlackText(),
                          5.sp.sbw,
                          _buildSwitchButton(
                              val: data.projectArchiveNotificationSlack == 1,
                              onChange: (val) {
                                setState(() {
                                  data.projectArchiveNotificationSlack =
                                      val == true ? 1 : 0;
                                });
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: 0.sbh,
                    )
                  ],
                )
              : 0.sbh,
        ],
      ),
    );
  }

  Expanded _buildSMSText() {
    return Expanded(
      child: CustomText(
        text: "SMS",
        textAlign: TextAlign.end,
        color: AppColors.labelColor9,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
        maxLine: 2,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Expanded _buildSlackText() {
    return Expanded(
      child: CustomText(
        text: AppString.slack,
        textAlign: TextAlign.end,
        color: AppColors.labelColor9,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
        maxLine: 2,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildBoxTileForLiecense(
      String title, LicenseAssignNotification data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApireVueText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.licenseAssignNotificationInbox == 1,
                        onChange: (val) {
                          setState(() {
                            data.licenseAssignNotificationInbox =
                                val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildEmailText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.licenseAssignNotificationMail == 1,
                        onChange: (val) {
                          setState(() {
                            data.licenseAssignNotificationMail =
                                val == true ? 1 : 0;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          data.isSlackAvailable == 1 ? 10.sp.sbh : 0.sbh,
          data.isSlackAvailable == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildSlackText(),
                          5.sp.sbw,
                          _buildSwitchButton(
                              val: data.licenseAssignNotificationSlack == 1,
                              onChange: (val) {
                                setState(() {
                                  data.licenseAssignNotificationSlack =
                                      val == true ? 1 : 0;
                                });
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: 0.sbh,
                    )
                  ],
                )
              : 0.sbh,
        ],
      ),
    );
  }

  Widget _buildBoxTileForFollower(String title, FollowersRequest data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApireVueText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.followerRequestInbox == 1,
                        onChange: (val) {
                          setState(() {
                            data.followerRequestInbox = val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildEmailText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.followerRequestMail == 1,
                        onChange: (val) {
                          setState(() {
                            data.followerRequestMail = val == true ? 1 : 0;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          data.isSlackAvailable == 1 ? 10.sp.sbh : 0.sbh,
          data.isSlackAvailable == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildSlackText(),
                          5.sp.sbw,
                          _buildSwitchButton(
                              val: data.followerRequestSlack == 1,
                              onChange: (val) {
                                setState(() {
                                  data.followerRequestSlack =
                                      val == true ? 1 : 0;
                                });
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: 0.sbh,
                    )
                  ],
                )
              : 0.sbh,
        ],
      ),
    );
  }

  Widget _buildBoxTileForDevelopment(String title, DevelopmentInvitation data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApireVueText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.developmentInvitationInbox == 1,
                        onChange: (val) {
                          setState(() {
                            data.developmentInvitationInbox =
                                val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildEmailText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.developmentInvitationMail == 1,
                        onChange: (val) {
                          setState(() {
                            data.developmentInvitationMail =
                                val == true ? 1 : 0;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          data.isSlackAvailable == 1 ? 10.sp.sbh : 0.sbh,
          data.isSlackAvailable == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildSlackText(),
                          5.sp.sbw,
                          _buildSwitchButton(
                              val: data.developmentInvitationSlack == 1,
                              onChange: (val) {
                                setState(() {
                                  data.developmentInvitationSlack =
                                      val == true ? 1 : 0;
                                });
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: 0.sbh,
                    )
                  ],
                )
              : 0.sbh,
        ],
      ),
    );
  }

  Widget _buildBoxTileForPerformace1(
      String title, PerformanceInvitation? data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApireVueText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data!.performanceInvitationInbox == 1,
                        onChange: (val) {
                          setState(() {
                            data.performanceInvitationInbox =
                                val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildEmailText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.performanceInvitationMail == 1,
                        onChange: (val) {
                          setState(() {
                            data.performanceInvitationMail =
                                val == true ? 1 : 0;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          data.isSlackAvailable == 1 ? 10.sp.sbh : 0.sbh,
          data.isSlackAvailable == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildSlackText(),
                          5.sp.sbw,
                          _buildSwitchButton(
                              val: data.performanceInvitationSlack == 1,
                              onChange: (val) {
                                setState(() {
                                  data.performanceInvitationSlack =
                                      val == true ? 1 : 0;
                                });
                              }),
                        ],
                      ),
                    ),
                    Expanded(
                      child: 0.sbh,
                    )
                  ],
                )
              : 0.sbh,
        ],
      ),
    );
  }

  ToggleButtonWidget _buildSwitchButton(
      {required bool val, required Function onChange}) {
    return ToggleButtonWidget(
      width: 45.sp,
      height: 18.sp,
      value: val,
      onChange: (val) {
        onChange(val);
      },
      isShowText: true,
      activeText: AppString.on,
      inactiveText: AppString.off,
    );
  }

  Widget _buildBoxTileForMessage(String title, MessagesNotesComments? data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildApireVueText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data!.oneNoteInbox == 1,
                        onChange: (val) {
                          setState(() {
                            data.oneNoteInbox = val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildEmailText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.oneNoteMail == 1,
                        onChange: (val) {
                          setState(() {
                            data.oneNoteMail = val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              )
            ],
          ),
          10.sp.sbh,
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildSMSText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.oneNoteSMS == 1,
                        onChange: (val) {
                          setState(() {
                            data.oneNoteSMS = val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              data.isSlackAvailable == 1
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildSlackText(),
                          5.sp.sbw,
                          _buildSwitchButton(
                              val: data.oneNoteSlack == 1,
                              onChange: (val) {
                                setState(() {
                                  data.oneNoteSlack = val == true ? 1 : 0;
                                });
                              })
                        ],
                      ),
                    )
                  : Expanded(
                      child: 0.sbh,
                    ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBoxDecoration(
    String title,
    Widget child,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: CommonController.getBoxShadow,
            color: AppColors.white,
            borderRadius: BorderRadius.circular(5.sp),
            border: Border.all(color: AppColors.labelColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: _buildTextboxTitle(title),
              ),
              Container(
                padding: EdgeInsets.all(10.0.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.sp),
                  color: AppColors.backgroundColor1,
                ),
                child: child,
              )
            ],
          ),
        ),
        12.sp.sbh,
      ],
    );
  }

  Expanded _buildEmailText() {
    return Expanded(
      child: CustomText(
        text: AppString.email,
        textAlign: TextAlign.end,
        color: AppColors.labelColor9,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
        maxLine: 2,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  CustomText _buildTextboxTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      maxLine: 2,
      fontWeight: FontWeight.w500,
    );
  }

  CustomText _buildMainTitle() {
    return CustomText(
      text: AppString.notifications,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _updateNotificationSetting(Map<String, dynamic> jsonData) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var response =
          await _profileController.updateNotificationSettings(jsonData);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _reFreshData();
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildBoxTileForDailyQReminder(String title, DailyqReminder data) {
    return _buildBoxDecoration(
      title,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildSMSText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.dailyqReminderSms == 1,
                        onChange: (val) {
                          setState(() {
                            data.dailyqReminderSms = val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildEmailText(),
                    5.sp.sbw,
                    _buildSwitchButton(
                        val: data.dailyqReminderEmail == 1,
                        onChange: (val) {
                          setState(() {
                            data.dailyqReminderEmail = val == true ? 1 : 0;
                          });
                        })
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
