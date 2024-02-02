import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_reminder.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class GoalDetailDialog extends StatefulWidget {
  const GoalDetailDialog({
    super.key,
    required this.goalId,
    required this.styleId,
    required this.title,
    required this.userId,
  });

  final String goalId;
  final String title;
  final String styleId;
  final String userId;

  @override
  State<GoalDetailDialog> createState() => _GoalDetailDialogState();
}

class _GoalDetailDialogState extends State<GoalDetailDialog> {
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _addActionPlanDateController =
      TextEditingController();
  final TextEditingController _addCueTextController = TextEditingController();
  bool _isCheckTagAsDeveloperCheckBox = false;

  int stepNo = 1;

  String _goalType = "";

  final _formStepOne = GlobalKey<FormState>();
  final _formStepTwo = GlobalKey<FormState>();
  final _formStepThree = GlobalKey<FormState>();

  final _developmentController = Get.find<DevelopmentController>();
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100), () {
      getData();
    });
    super.initState();
  }

  getData() async {
    var res = await Get.find<DevelopmentController>().getGoalPopupDetails(
      goalId: widget.goalId,
      styleId: widget.styleId,
    );

    if (res != null) {
      setState(() {
        _targetDateController.text = res.targetDate.toString();
        _isCheckTagAsDeveloperCheckBox = res.isChecked == "1";
        _addActionPlanDateController.text = res.actionPlan.toString();
        _addCueTextController.text = res.objSituationalCue.toString();
        _goalType = res.goalType.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // onWillPop: () => Future.value(false),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: SizedBox(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _addActionPlanDateController.text.isEmpty
                  ? 0.sbh
                  : _buildActionPlanTitle(),
              Divider(
                height: 1.sp,
                color: AppColors.labelColor,
                thickness: 1,
              ),
              buildView(stepNo),
            ],
          )),
        ),
      ),
    );
  }

  Widget buildView(int val) {
    switch (val) {
      case 1:
        return _stepOne();
      case 2:
        return _stepTwo();
      case 3:
        return _stepThree();
      default:
        return 10.sp.sbh;
    }
  }

  Widget _stepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Form(
            key: _formStepOne,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  color: AppColors.labelColor8,
                  text: "What is your target date for achieving this goal?",
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor9.withOpacity(0.2),
                  inputAction: TextInputAction.done,
                  labelText: "",
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  lineCount: 1,
                  validator: Validation().requiredFieldValidation,
                  editColor: AppColors.labelColor12,
                  textEditingController: _targetDateController,
                  isReadOnly: true,
                  onTap: () {
                    _pickDateForStepOne();
                  },
                ),
                10.sp.sbh,
                _buildCheckboxWithTitle(),
                10.sp.sbh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildNextButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Form(
            key: _formStepTwo,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  color: AppColors.labelColor8,
                  text: "What planned action step will you take?",
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor9.withOpacity(0.2),
                  inputAction: TextInputAction.done,
                  labelText: "Add Action Plan",
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  lineCount: 1,
                  validator: Validation().requiredFieldValidation,
                  editColor: AppColors.labelColor12,
                  textEditingController: _addActionPlanDateController,
                ),
                10.sp.sbh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPreviousButton(),
                    _buildNextButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: Form(
            key: _formStepThree,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  color: AppColors.labelColor8,
                  text:
                      "What situational cue or previous behavior will prompt you to execute the planned action?",
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor9.withOpacity(0.2),
                  inputAction: TextInputAction.done,
                  labelText: "Add Cue",
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  lineCount: 1,
                  validator: Validation().requiredFieldValidation,
                  editColor: AppColors.labelColor12,
                  textEditingController: _addCueTextController,
                ),
                10.sp.sbh,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPreviousButton(),
                    _buildNextButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  CustomButton2 _buildNextButton() {
    return CustomButton2(
        // isLoading: false,
        buttonText: AppString.next,
        radius: 15.sp,
        padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
        onPressed: () async {
          if (stepNo == 1) {
            if (_formStepOne.currentState!.validate()) {
              setState(() {
                stepNo++;
              });
              return;
            }
          }

          if (stepNo == 2) {
            if (_formStepTwo.currentState!.validate()) {
              setState(() {
                stepNo++;
              });
              return;
            }
          }

          if (stepNo == 3) {
            if (_formStepThree.currentState!.validate()) {
              bool? result = await _developmentController.saveGoalPopupDetails(
                  styleId: widget.styleId,
                  goalId: widget.goalId,
                  actionPlan: _addActionPlanDateController.text,
                  targetDate: _targetDateController.text,
                  objSituationalCue: _addCueTextController.text,
                  isChecked:
                      _isCheckTagAsDeveloperCheckBox == true ? "1" : "0");
              if (result != null && result == true) {
                // ignore: use_build_context_synchronously
                var isSaved = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return ReminderAlertDialog(
                      fromModule: "Development",
                      goalId: widget.goalId,
                      styleId: widget.styleId,
                      userId: widget.userId,
                      type: _goalType,
                      title: widget.title,
                      subTitle: _addActionPlanDateController.text,
                    );
                  },
                );

                if (isSaved != null && isSaved == true) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, true);
                }
              }
              return;
            }
          }
        });
  }

  CustomButton2 _buildPreviousButton() {
    return CustomButton2(
        // isLoading: false,
        buttonText: AppString.previous,
        radius: 15.sp,
        padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
        fontWeight: FontWeight.w600,
        fontSize: 10.sp,
        onPressed: () {
          setState(() {
            stepNo--;
          });
          // if (_formKey.currentState!.validate()) {
          //   _sendMessage();
          // }
        });
  }

  Row _buildCheckboxWithTitle() {
    return Row(
      children: [
        CustomCheckBox(
          borderColor: AppColors.labelColor8,
          fillColor: AppColors.labelColor8,
          isChecked: _isCheckTagAsDeveloperCheckBox,
          onTap: () {
            setState(() {
              _isCheckTagAsDeveloperCheckBox = !_isCheckTagAsDeveloperCheckBox;
            });
          },
        ),
        8.sp.sbw,
        Expanded(
          child: _buildTextBoxTitleCheckBox(
              AppString.tagtoincludethisgoalinyourDevelopmentPlan),
        ),
      ],
    );
  }

  CustomText _buildTextBoxTitleCheckBox(String title) {
    return CustomText(
      fontWeight: FontWeight.w500,
      fontSize: 10.sp,
      color: AppColors.labelColor20,
      text: title,
      maxLine: 3,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
      child: CustomText(
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
        color: AppColors.labelColor8,
        text: "Objective: ${widget.title}",
        textAlign: TextAlign.start,
        fontFamily: AppString.manropeFontFamily,
      ),
    );
  }

  Widget _buildActionPlanTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
      child: CustomText(
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
        color: AppColors.labelColor8,
        text: "Action Plan: ${_addActionPlanDateController.text}",
        textAlign: TextAlign.start,
        fontFamily: AppString.manropeFontFamily,
      ),
    );
  }

  _pickDateForStepOne() async {
    var date = await CommonController().pickDate(
      context,
      initialDate: _targetDateController.text == ""
          ? DateTime.now()
          : DateFormat(
              "MM/dd/yyyy",
            ).parse(_targetDateController.text),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (date != null && date != _targetDateController.text) {
      setState(() {
        _targetDateController.text = date;
      });
    }
  }
}
