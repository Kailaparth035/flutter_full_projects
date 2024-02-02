import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/dashboard_dailyq_list_model.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_daily_history.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_reminder.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class DailyIQWidget extends StatefulWidget {
  const DailyIQWidget(
      {super.key, required this.isShowBullets, required this.isShowjournal});

  final bool isShowBullets;
  final bool isShowjournal;

  @override
  State<DailyIQWidget> createState() => _DailyIQWidgetState();
}

class _DailyIQWidgetState extends State<DailyIQWidget> {
  final FocusNode _bulletFocus = FocusNode();

  final TextEditingController _bulletController = TextEditingController();

  final _dashboardController = Get.find<DashboardController>();

  final TextEditingController _msgController = TextEditingController();
  bool _isBullets = true;

  @override
  void initState() {
    super.initState();

    if (widget.isShowBullets == false && widget.isShowjournal == true) {
      _isBullets = false;
    }
  }

  _changeAction(value, DashboardController dashboardController) {
    if (_isBullets != value) {
      setState(() {
        _isBullets = value;
      });
      dashboardController.getHabitJournalBulletsDetail(true, _isBullets);
    }
  }

  _pickDate(DashboardController dashboardController) async {
    var selectedDate = DateFormat(
      "MM/dd/yyyy",
    ).parse(dashboardController.selectedDate);
    var date = await CommonController().pickDate(context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (date != null && dashboardController.selectedDate != date) {
      dashboardController.changeSelectedDate(date);
      dashboardController.getHabitJournalBulletsDetail(true, _isBullets);
    }
  }

  _changeDate(bool isNext, DashboardController dashboardController) {
    if (!dashboardController.isLoadingDailyQ) {
      var dateTime = DateFormat(
        "MM/dd/yyyy",
      ).parse(dashboardController.selectedDate);
      dateTime = dateTime.add(Duration(days: isNext ? 1 : -1));
      dashboardController
          .changeSelectedDate(DateFormat('MM/dd/yyyy').format(dateTime));

      dashboardController.getHabitJournalBulletsDetail(true, _isBullets);
    }
  }

  Future _reLoadCurrentData(DashboardController dashboardController) async {
    if (!dashboardController.isLoadingDailyQ) {
      var dateTime = DateFormat(
        "MM/dd/yyyy",
      ).parse(dashboardController.selectedDate);

      dashboardController
          .changeSelectedDate(DateFormat('MM/dd/yyyy').format(dateTime));

      await dashboardController.getHabitJournalBulletsDetail(false, _isBullets);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopButton(dashboardController),
          10.sp.sbh,
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 7.sp,
              horizontal: 10.sp,
            ),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor1,
              border: Border.all(color: AppColors.labelColor),
              borderRadius: BorderRadius.all(
                Radius.circular(5.sp),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _isBullets
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: SelfReflactViewPopUp(
                            isHtml: false,
                            title: "Description",
                            desc:
                                "Daily Habit Bullets enable you to list tasks that you will regularly complete as you create new habits. Use the gear to schedule a push notification or email at a set time every day .",
                            child: Image.asset(
                              AppImages.infoIc,
                              height: 16.sp,
                              width: 16.sp,
                            )),
                      )
                    : 0.sbh,
                // _isBullets ? _buildBulletDescritpion() : 0.sbh,
                10.sp.sbh,
                _buildButtonRowSetting(dashboardController),
                15.sp.sbh,
                _buildCheckBoxList(dashboardController),
                15.sp.sbh,
                _isBullets
                    ? dashboardController.selectedDate ==
                            dashboardController.currentDate
                        ? _buildAddBullets(dashboardController)
                        : 0.sbh
                    : _buildAddNotes(dashboardController),
                15.sp.sbh,
              ],
            ),
          )
        ],
      );
    });
  }

  // Column _buildBulletDescritpion() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       5.sp.sbh,
  //       InkWell(
  //         onTap: () {
  //           showDialog(
  //             context: Get.context!,
  //             builder: (BuildContext context) {
  //               return const CustomAlertForCourseDescription(
  //                 title: " ",
  //                 description:
  //                     "Daily Habit Bullets enable you to list tasks that you will regularly complete as you create new habits. Use the gear to schedule a push notification or email at a set time every day .",
  //               );
  //             },
  //           );
  //         },
  //         child: CustomUnderlineText(
  //           fontWeight: FontWeight.w400,
  //           fontSize: 11.sp,
  //           color: AppColors.labelColor52,
  //           maxLine: 5,
  //           text: "Description",
  //           textAlign: TextAlign.start,
  //           fontFamily: AppString.manropeFontFamily,
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _buildAddNotes(DashboardController dashboardController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor9.withOpacity(0.1),
          editColor: AppColors.labelColor9.withOpacity(0.1),
          activeBorderColor: AppColors.labelColor9,
          inputAction: TextInputAction.done,
          labelText: "Record entry",
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 2,
          fontWeight: FontWeight.w700,
          isEnabled: true,
          textEditingController: _msgController,
        ),
        5.sp.sbh,
        CustomButton2(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            buttonText: "Submit",
            fontSize: 11.sp,
            radius: Dimensions.radiusSmall,
            onPressed: () {
              if (_msgController.text.isEmpty) {
                showCustomSnackBar(AppString.pleaseEnterMessageText);
              } else {
                _addMessage(dashboardController);
              }
            }),
      ],
    );
  }

  Row _buildAddBullets(DashboardController dashboardController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            child: CustomTextFormFieldForMessage(
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 12.sp),
              borderColor: AppColors.labelColor9.withOpacity(0.1),
              editColor: AppColors.labelColor9.withOpacity(0.1),
              activeBorderColor: AppColors.labelColor9,
              focusNode: _bulletFocus,
              inputAction: TextInputAction.done,
              labelText: "Enter task",
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 1,
              // radius: Dimensions.radiusExtraLarge,
              fontWeight: FontWeight.w700,
              validator: Validation().requiredFieldValidation,
              isEnabled: true,
              textEditingController: _bulletController,
            ),
          ),
        ),
        5.sp.sbw,
        CustomButton2(
            padding: EdgeInsets.symmetric(vertical: 5.5.sp, horizontal: 10.sp),
            buttonText: "Submit",
            fontSize: 11.sp,
            radius: Dimensions.radiusSmall,
            onPressed: () {
              if (_bulletController.text.isEmpty) {
                showCustomSnackBar(AppString.pleaseEnterBulletsText);
              } else {
                _addBullets(dashboardController);
              }
            }),
      ],
    );
  }

  Container _buildCheckBoxList(DashboardController dashboardController) {
    return Container(
        padding: EdgeInsets.symmetric(
          vertical: 0.sp,
          horizontal: 10.sp,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5.sp),
          ),
        ),
        child: dashboardController.isLoadingDailyQ
            ? Shimmer(
                colorOpacity: 0.5,
                duration: const Duration(seconds: 2),
                interval: const Duration(seconds: 0),
                enabled: true,
                child: Column(
                  children: [
                    10.sp.sbh,
                    _buildCheckboxWithTitleShimmer(),
                    _buildCheckboxWithTitleShimmer(),
                    _buildCheckboxWithTitleShimmer(),
                  ],
                ),
              )
            : dashboardController.isErrorDailyQ
                ? Center(
                    child: CustomErrorWidget(
                        onRetry: () {
                          dashboardController.getHabitJournalBulletsDetail(
                              true, _isBullets);
                        },
                        width: 20.h,
                        text: dashboardController.errorMsgDailyQ),
                  )
                : dashboardController.dailyQButllets.isEmpty
                    ? CustomNoDataFoundWidget(
                        height: 30.sp,
                        topPadding: 0,
                      )
                    : Column(
                        children: [
                          10.sp.sbh,
                          ...dashboardController.dailyQButllets.map((e) =>
                              _buildCheckboxWithTitle(e, dashboardController))
                        ],
                      ));
  }

  Container _buildCheckboxWithTitleShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      padding: EdgeInsets.symmetric(
        vertical: 10.sp,
        horizontal: 10.sp,
      ),
      decoration: BoxDecoration(
        color: AppColors.labelColor36,
        borderRadius: BorderRadius.all(
          Radius.circular(5.sp),
        ),
      ),
    );
  }

  Container _buildCheckboxWithTitle(
      DailyQDataForDashboard data, DashboardController dashboardController) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      padding: EdgeInsets.symmetric(
        vertical: 5.sp,
        horizontal: 10.sp,
      ),
      decoration: BoxDecoration(
        color: AppColors.labelColor36,
        border: Border.all(color: AppColors.labelColor),
        borderRadius: BorderRadius.all(
          Radius.circular(5.sp),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !_isBullets
              ? 0.sbh
              : CustomCheckBox(
                  borderColor: AppColors.labelColor8,
                  fillColor: AppColors.labelColor8,
                  isChecked: data.isChecked == 1,
                  onTap: () {
                    _toggleCheck(
                        data.id.toString(),
                        data.isChecked == 1 ? "0" : "1",
                        data.newcheckid.toString());
                  },
                ),
          !_isBullets ? 0.sbh : 8.sp.sbw,
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
              color: AppColors.labelColor35,
              text: data.name.toString(),
              maxLine: 5,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          8.sp.sbw,
          dashboardController.currentDate == dashboardController.selectedDate
              ? InkWell(
                  onTap: () async {
                    var res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConfirmAlertDialLog(
                          title: AppString.areUSureUWantToDelete,
                        );
                      },
                    );

                    if (res != null) {
                      _deleteRecord(dashboardController, data.id.toString());
                    }
                  },
                  child: Image.asset(
                    AppImages.deleteRedIc,
                    height: 10.sp,
                  ),
                )
              : 0.sbh,
        ],
      ),
    );
  }

  Widget _buildButtonRowSetting(DashboardController dashboardController) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _changeDate(false, dashboardController);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: AppColors.primaryColor,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 4.sp),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.labelColor8,
              size: 16.sp,
            ),
          ),
        ),
        5.sp.sbw,
        Expanded(
          child: InkWell(
            onTap: () {
              _pickDate(dashboardController);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 5.5.sp, horizontal: 0.sp),
              child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
                color: AppColors.labelColor8,
                text: dashboardController.selectedDate,
                textAlign: TextAlign.center,
                maxLine: 2,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
          ),
        ),
        5.sp.sbw,
        dashboardController.selectedDate == dashboardController.currentDate
            ? InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.labelColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 4.sp),
                  height: 28.sp,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.labelColor,
                    size: 16.sp,
                  ),
                ),
              )
            : InkWell(
                onTap: () {
                  _changeDate(true, dashboardController);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 4.sp),
                  height: 28.sp,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.labelColor8,
                    size: 16.sp,
                  ),
                ),
              ),
        5.sp.sbw,
        Expanded(
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DailyQHistoryAlertDialog(isBullets: _isBullets);
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primaryColor,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 4.sp),
              height: 28.sp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.timeReloadIc,
                    height: 11.sp,
                  ),
                  CustomText(
                    fontWeight: FontWeight.w500,
                    fontSize: 11.sp,
                    color: AppColors.labelColor8,
                    text: " ${AppString.history}",
                    textAlign: TextAlign.center,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ],
              ),
            ),
          ),
        ),
        5.sp.sbw,
        InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ReminderAlertDialog(
                  goalId: "",
                  styleId: "",
                  userId: "",
                  type: "",
                  fromModule: "dashboard",
                  reminderDate: dashboardController.currentDate,
                  reminderType: _isBullets ? "1" : "2",
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primaryColor,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 4.sp),
            height: 28.sp,
            child: Image.asset(AppImages.settingBlueIc),
          ),
        ),
      ],
    );
  }

  Padding _buildTopButton(DashboardController dashboardController) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0.sp,
      ),
      child: Row(
        children: [
          widget.isShowBullets == false
              ? 0.sbh
              : Expanded(
                  child: InkWell(
                    onTap: () {
                      _changeAction(true, dashboardController);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.sp,
                        horizontal: 10.sp,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: CommonController.getBoxShadow,
                        gradient: LinearGradient(colors: [
                          _isBullets
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withOpacity(0.6),
                          _isBullets
                              ? AppColors.secondaryColor
                              : AppColors.secondaryColor.withOpacity(0.6),
                        ]),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.sp),
                          bottomLeft: Radius.circular(5.sp),
                          topRight: Radius.circular(
                              widget.isShowjournal == true ? 0 : 5.sp),
                          bottomRight: Radius.circular(
                              widget.isShowjournal == true ? 0 : 5.sp),
                        ),
                      ),
                      child: CustomText(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: _isBullets
                            ? AppColors.white
                            : AppColors.white.withOpacity(0.6),
                        text: AppString.habitBullets,
                        textAlign: TextAlign.center,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                    ),
                  ),
                ),
          widget.isShowjournal == false
              ? 0.sbh
              : Expanded(
                  child: InkWell(
                    onTap: () {
                      _changeAction(false, dashboardController);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5.sp,
                        horizontal: 1.sp,
                      ),
                      decoration: BoxDecoration(
                        boxShadow: CommonController.getBoxShadow,
                        gradient: LinearGradient(colors: [
                          !_isBullets
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withOpacity(0.6),
                          !_isBullets
                              ? AppColors.secondaryColor
                              : AppColors.secondaryColor.withOpacity(0.6),
                        ]),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.sp),
                          bottomRight: Radius.circular(5.sp),
                          bottomLeft: Radius.circular(
                              widget.isShowBullets == true ? 0 : 5.sp),
                          topLeft: Radius.circular(
                              widget.isShowBullets == true ? 0 : 5.sp),
                        ),
                      ),
                      child: CustomText(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: !_isBullets
                            ? AppColors.white
                            : AppColors.white.withOpacity(0.6),
                        text: "My Private Journal",
                        textAlign: TextAlign.center,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  _addBullets(DashboardController dashboardController) async {
    try {
      buildLoading(Get.context!);
      var response =
          await dashboardController.saveHabitBullet(_bulletController.text);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        await dashboardController.getHabitJournalBulletsDetail(
            false, _isBullets);
        _bulletController.clear();
        // ignore: use_build_context_synchronously
        FocusScope.of(context).requestFocus(FocusNode());
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

  _addMessage(DashboardController dashboardController) async {
    try {
      buildLoading(Get.context!);
      var response =
          await dashboardController.saveJournalData(_msgController.text);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        await dashboardController.getHabitJournalBulletsDetail(
            false, _isBullets);
        _msgController.clear();
        // ignore: use_build_context_synchronously
        FocusScope.of(context).requestFocus(FocusNode());
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

  _deleteRecord(DashboardController dashboardController, String id) async {
    try {
      buildLoading(Get.context!);
      var response =
          await dashboardController.deleteHabitJournalReminder(_isBullets, id);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        await dashboardController.getHabitJournalBulletsDetail(
            false, _isBullets);

        // ignore: use_build_context_synchronously
        FocusScope.of(context).requestFocus(FocusNode());
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

  _toggleCheck(
    String id,
    String isChecked,
    String newcheckid,
  ) async {
    _dashboardController.addRemoveReminderTag(
        id: id,
        isChecked: isChecked,
        newcheckid: newcheckid,
        onReload: () async {
          await _reLoadCurrentData(_dashboardController);
        });
  }
}
