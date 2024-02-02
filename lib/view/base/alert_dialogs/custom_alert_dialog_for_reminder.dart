import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/data/model/response/reminder_option_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ReminderAlertDialog extends StatefulWidget {
  const ReminderAlertDialog({
    super.key,
    required this.userId,
    required this.goalId,
    required this.type,
    required this.styleId,
    this.fromModule,
    this.reminderType,
    this.reminderDate,
    this.title,
    this.subTitle,
  });
  final String userId;
  final String goalId;
  final String type;
  final String styleId;
  final String? fromModule;
  final String? reminderType;
  final String? reminderDate;

  final String? title;
  final String? subTitle;

  @override
  State<ReminderAlertDialog> createState() => _ReminderAlertDialogState();
}

class _ReminderAlertDialogState extends State<ReminderAlertDialog> {
  final _myGoalController = Get.find<MyGoalController>();
  final _dashboardController = Get.find<DashboardController>();
  final _developmentController = Get.find<DevelopmentController>();
  bool _isLoading = false;

  // bool _isSaveLoading = false;
  ReminderOptionData? _reminderOptionData;

  @override
  void initState() {
    super.initState();
    _loadData(true);
  }

  final _ddHrList = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  final _ddmmList = ['00', '15', '30', '45'];

  final _ddamList = ['AM', 'PM'];

  String _ddHrValue = "1";
  String _ddmmValue = "00";
  String _ddamValue = "AM";

  Future _loadData(bool showMainLoading) async {
    if (showMainLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      ReminderOptionData? data;
      if (widget.fromModule == "dashboard") {
        Map<String, dynamic> map = {
          "reminder_type": widget.reminderType.toString(),
          "reminder_date": widget.reminderDate.toString(),
        };
        data = await _dashboardController.getdailyqhabitJournaleminder(map);
      } else if (widget.fromModule == "Emotions") {
        data = await _developmentController.getEmotionReminder({});
      } else {
        Map<String, dynamic> map = {
          "id": widget.goalId.toString(),
          "Goal_type": widget.type.toString(),
          "style_id": widget.styleId.toString(),
          "user_id": widget.userId.toString(),
        };
        data = await _myGoalController.getGoalReminder(map);
      }

      setState(() {
        _reminderOptionData = data;
      });

      if (_ddHrList.contains(_reminderOptionData!.time.toString())) {
        _ddHrValue = _reminderOptionData!.time.toString();
      }
      if (_ddmmList.contains(_reminderOptionData!.min.toString())) {
        _ddmmValue = _reminderOptionData!.min.toString();
      }
      if (_reminderOptionData!.timeType.toString() == "1") {
        _ddamValue = "AM";
      } else {
        _ddamValue = "PM";
      }
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    } finally {
      if (showMainLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _clearButtonAction() async {
    if (widget.fromModule == "Emotions") {
      bool? res = await _developmentController.clearEmotionData(
          id: _reminderOptionData!.id.toString());

      if (res != null) {
        _loadData(true);
      }
    } else {
      _checkBoxAction(0, "main");
      setState(() {
        _ddHrValue = "1";
        _ddmmValue = "00";
        _ddamValue = "AM";
      });
    }
  }

  _checkBoxAction(int valueToUpdate, String from) {
    if (from == "main") {
      setState(() {
        _reminderOptionData!.isAllDays = valueToUpdate;
        _reminderOptionData!.mon = valueToUpdate;
        _reminderOptionData!.tue = valueToUpdate;
        _reminderOptionData!.wed = valueToUpdate;
        _reminderOptionData!.thu = valueToUpdate;
        _reminderOptionData!.fri = valueToUpdate;
        _reminderOptionData!.sat = valueToUpdate;
        _reminderOptionData!.sun = valueToUpdate;
      });
    }

    if (from == "Mon") {
      setState(() {
        _reminderOptionData!.mon = valueToUpdate;
      });
    }
    if (from == "Tue") {
      setState(() {
        _reminderOptionData!.tue = valueToUpdate;
      });
    }
    if (from == "Wed") {
      setState(() {
        _reminderOptionData!.wed = valueToUpdate;
      });
    }
    if (from == "Thu") {
      setState(() {
        _reminderOptionData!.thu = valueToUpdate;
      });
    }
    if (from == "Fri") {
      setState(() {
        _reminderOptionData!.fri = valueToUpdate;
      });
    }
    if (from == "Sat") {
      setState(() {
        _reminderOptionData!.sat = valueToUpdate;
      });
    }
    if (from == "Sun") {
      setState(() {
        _reminderOptionData!.sun = valueToUpdate;
      });
    }

    if (_reminderOptionData!.mon == 1 &&
        _reminderOptionData!.tue == 1 &&
        _reminderOptionData!.wed == 1 &&
        _reminderOptionData!.thu == 1 &&
        _reminderOptionData!.fri == 1 &&
        _reminderOptionData!.sat == 1 &&
        _reminderOptionData!.sun == 1) {
      setState(() {
        _reminderOptionData!.isAllDays = 1;
      });
    } else {
      setState(() {
        _reminderOptionData!.isAllDays = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.fromModule == "Development" ? false : true,
      // onWillPop: () =>
      //     Future.value(widget.fromModule == "Development" ? false : true),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: SizedBox(
          child: SingleChildScrollView(
            child: _isLoading
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 80.sp),
                      child: const CustomLoadingWidget(),
                    ),
                  )
                : _reminderOptionData == null
                    ? const Center(
                        child: CustomNoDataFoundWidget(topPadding: 0),
                      )
                    : _buildView(),
          ),
        ),
      ),
    );
  }

  Widget _buildView() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getTitleWidgetContiditon(),
            const Divider(
              height: 1,
              color: AppColors.labelColor,
              thickness: 1,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.fromModule == "Emotions"
                      ? 0.sbh
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextBoxSubTitle(AppString.tobuildmomentum),
                            5.sp.sbh,
                          ],
                        ),
                  _buildTextBoxTitle(AppString.chooseDay),
                  5.sp.sbh,
                  _buildCheckboxWithTitleMain(),
                  7.sp.sbh,
                  _buildDayCheckbox(),
                  5.sp.sbh,
                  _buildTextBoxTitle(AppString.chooseTime),
                  5.sp.sbh,
                  _buildSendAt(),
                  10.sp.sbh,
                  _buildTitleAndValue(
                      AppString.timeZone,
                      widget.fromModule == "Emotions"
                          ? "${_reminderOptionData!.country.toString()} - ${_reminderOptionData!.timeZone.toString()}"
                          : _reminderOptionData!.timeZone.toString()),
                  5.sp.sbh,
                  _buildTitleAndValue(
                      AppString.emailTo, _reminderOptionData!.email.toString()),
                  15.sp.sbh,
                  widget.fromModule == "Development"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPreviousButton(),
                            _buildNextButton(),
                          ],
                        )
                      : _buildBottomButtonForReminder(),
                ],
              ),
            ),
            // 10.sp.sbh,
          ],
        ),
        // Positioned.fill(
        //   child: _isSaveLoading
        //       ? Container(
        //           color: AppColors.black.withOpacity(0.1),
        //           child: const Center(
        //             child: CustomLoadingWidget(),
        //           ),
        //         )
        //       : 0.sbh,
        // ),
      ],
    );
  }

  _getTitleWidgetContiditon() {
    return widget.fromModule == "Development"
        ? _buildTitleSubTitle()
        : widget.fromModule == "Emotions"
            ? _buildTitle(
                "Emotions Tracker - Schedule reminders to track your emotions for 30 days.")
            : _buildTitle(AppString.reminderOptions);
  }

  CustomButton2 _buildNextButton() {
    return CustomButton2(
        isLoading: false,
        buttonText: AppString.save,
        radius: 15.sp,
        padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
        buttonColor: AppColors.greenColor,
        onPressed: () {
          _saveAction();
        });
  }

  CustomButton2 _buildPreviousButton() {
    return CustomButton2(
      isLoading: false,
      buttonText: AppString.previous,
      radius: 15.sp,
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
      fontWeight: FontWeight.w600,
      fontSize: 10.sp,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Row _buildBottomButtonForReminder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton2(
            buttonText: AppString.clear,
            buttonColor: AppColors.primaryColor,
            radius: 5.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
            onPressed: () {
              _clearButtonAction();
            }),
        5.sp.sbw,
        CustomButton2(
            buttonText: AppString.save,
            radius: 5.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
            onPressed: () {
              _saveAction();
            })
      ],
    );
  }

  Widget _buildTitleAndValue(String title, String subTiele) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          TextSpan(
            text: subTiele,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w400,
              color: AppColors.labelColor8,
            ),
          )
        ],
      ),
    );
  }

  Row _buildSendAt() {
    return Row(
      children: [
        _buildTextBoxTitle(AppString.sendAt),
        Expanded(
          child: Row(
            children: [
              _buildDDHr(),
              5.sp.sbw,
              _buildDDmm(),
              5.sp.sbw,
              _buildDDAm()
            ],
          ),
        )
      ],
    );
  }

  Container _buildDDHr() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.sp, vertical: 3.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(3.sp),
      ),
      child: DropdownButton(
        menuMaxHeight: 300,
        underline: 0.sbh,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.labelColor39,
        ),
        isDense: true,
        value: _ddHrValue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 15.sp,
          color: AppColors.labelColor39,
        ),
        items: _ddHrList.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _ddHrValue = newValue.toString();
          });
        },
      ),
    );
  }

  Container _buildDDmm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.sp, vertical: 3.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(3.sp),
      ),
      child: DropdownButton(
        menuMaxHeight: 300,
        underline: 0.sbh,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.labelColor39,
        ),
        isDense: true,
        value: _ddmmValue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 15.sp,
          color: AppColors.labelColor39,
        ),
        items: _ddmmList.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _ddmmValue = newValue.toString();
          });
        },
      ),
    );
  }

  Container _buildDDAm() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.sp, vertical: 3.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(3.sp),
      ),
      child: DropdownButton(
        menuMaxHeight: 300,
        underline: 0.sbh,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.labelColor39,
        ),
        isDense: true,
        value: _ddamValue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 15.sp,
          color: AppColors.labelColor39,
        ),
        items: _ddamList.map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _ddamValue = newValue.toString();
          });
        },
      ),
    );
  }

  Wrap _buildDayCheckbox() {
    return Wrap(
      runSpacing: 7.sp,
      spacing: 20.sp,
      direction: Axis.horizontal,
      children: [
        _buildCheckboxWithTitle(AppString.mon, _reminderOptionData!.mon == 1,
            () {
          _checkBoxAction(_reminderOptionData!.mon == 1 ? 0 : 1, AppString.mon);
        }),
        _buildCheckboxWithTitle(AppString.tue, _reminderOptionData!.tue == 1,
            () {
          _checkBoxAction(_reminderOptionData!.tue == 1 ? 0 : 1, AppString.tue);
        }),
        _buildCheckboxWithTitle(AppString.wed, _reminderOptionData!.wed == 1,
            () {
          _checkBoxAction(_reminderOptionData!.wed == 1 ? 0 : 1, AppString.wed);
        }),
        _buildCheckboxWithTitle(AppString.thu, _reminderOptionData!.thu == 1,
            () {
          _checkBoxAction(_reminderOptionData!.thu == 1 ? 0 : 1, AppString.thu);
        }),
        _buildCheckboxWithTitle(AppString.fri, _reminderOptionData!.fri == 1,
            () {
          _checkBoxAction(_reminderOptionData!.fri == 1 ? 0 : 1, AppString.fri);
        }),
        _buildCheckboxWithTitle(AppString.sat, _reminderOptionData!.sat == 1,
            () {
          _checkBoxAction(_reminderOptionData!.sat == 1 ? 0 : 1, AppString.sat);
        }),
        _buildCheckboxWithTitle(AppString.sun, _reminderOptionData!.sun == 1,
            () {
          _checkBoxAction(_reminderOptionData!.sun == 1 ? 0 : 1, AppString.sun);
        })
      ],
    );
  }

  Row _buildCheckboxWithTitleMain() {
    return Row(
      children: [
        CustomCheckBox(
          borderColor: AppColors.labelColor8,
          fillColor: AppColors.labelColor8,
          isChecked: _reminderOptionData!.isAllDays == 1,
          onTap: () {
            _checkBoxAction(
                _reminderOptionData!.isAllDays == 1 ? 0 : 1, "main");
          },
        ),
        7.sp.sbw,
        Expanded(
          child: _buildTextBoxTitleCheckBox(_reminderOptionData!.isAllDays == 1
              ? AppString.uncheckAllDays
              : AppString.checkAllDays),
        ),
      ],
    );
  }

  Widget _buildCheckboxWithTitle(String title, bool val, Function ontap) {
    return InkWell(
      onTap: () {
        ontap();
      },
      child: SizedBox(
        width: 50.sp,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckBox(
              borderColor: AppColors.labelColor8,
              fillColor: AppColors.labelColor8,
              isChecked: val,
              onTap: () {
                ontap();
              },
            ),
            5.sp.sbw,
            Expanded(
              child: _buildTextBoxTitleCheckBox(title),
            ),
          ],
        ),
      ),
    );
  }

  CustomText _buildTextBoxTitleCheckBox(String title) {
    return CustomText(
      fontWeight: FontWeight.w500,
      fontSize: 10.sp,
      color: AppColors.black,
      text: title,
      maxLine: 3,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  CustomText _buildTextBoxTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      color: AppColors.labelColor35,
      text: title,
      maxLine: 5,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  CustomText _buildTextBoxSubTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w400,
      fontSize: 11.sp,
      color: AppColors.labelColor35,
      text: title,
      maxLine: 5,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  _buildTitleSubTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
          child: CustomText(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: "Objective: ${widget.title}",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
          child: CustomText(
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: "Action Plan: ${widget.subTitle}",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        )
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              color: AppColors.labelColor8,
              text: title,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          10.sp.sbw,
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.labelColor15.withOpacity(0.5)),
              child: Icon(
                Icons.close,
                weight: 3,
                size: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  _saveAction() async {
    _reminderOptionData!.time = _ddHrValue.toString();
    _reminderOptionData!.min = _ddmmValue.toString();
    _reminderOptionData!.timeType = _ddamValue == "AM" ? "1" : "0";
    var dataToSend = _reminderOptionData!.toJson();

    if (widget.fromModule == "dashboard") {
      dataToSend['reminder_type'] = widget.reminderType;
      dataToSend['reminder_date'] = widget.reminderDate;
    } else if (widget.fromModule == "Emotions") {
      dataToSend['id'] = _reminderOptionData!.id.toString();
    } else {
      dataToSend['style_id'] = widget.styleId;
      dataToSend['Goal_type'] = widget.type;
    }

    try {
      // setState(() {
      //   _isSaveLoading = true;
      // });
      buildLoading(Get.context!);
      ResponseModel response;
      if (widget.fromModule == "dashboard") {
        response = await _dashboardController
            .savedailyqhabitJournaleminder(dataToSend);
      } else if (widget.fromModule == "Emotions") {
        response = await _developmentController.saveEmotionReminder(dataToSend);
      } else {
        response = await _myGoalController.saveGoalReminder(dataToSend);
      }

      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pop(Get.context!, true);
        });
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      // setState(() {
      //   _isSaveLoading = false;
      // });
      // Navigator.pop(Get.context!, true);
      Navigator.pop(Get.context!);
    }
  }
}
