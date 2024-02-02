import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/data/model/response/goal_details_development_model.dart';
import 'package:aspirevue/data/model/response/goal_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_reminder.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_view_message.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_history_chart.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_button.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_slider.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/menu/my_goals/add_goal_screen.dart';
import 'package:aspirevue/view/screens/menu/my_goals/manage_follower_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:percent_indicator/percent_indicator.dart';

class GoalsDetailsScreen extends StatefulWidget {
  const GoalsDetailsScreen(
      {super.key,
      required this.goalId,
      required this.type,
      required this.styleId,
      required this.userId});
  final String goalId;
  final String type;
  final String styleId;
  final String userId;
  @override
  State<GoalsDetailsScreen> createState() => _GoalsDetailsScreenState();
}

class _GoalsDetailsScreenState extends State<GoalsDetailsScreen> {
  final FocusNode _actionFocus = FocusNode();
  final TextEditingController _actionController = TextEditingController();
  final TextEditingController _mainTargetDateController =
      TextEditingController();

  final TextEditingController _tobeTextController = TextEditingController();
  final TextEditingController _iwillTextController = TextEditingController();
  final TextEditingController _situationTextController =
      TextEditingController();
  final TextEditingController _actionPlanTextController =
      TextEditingController();

  // development textbox

  final TextEditingController _targetScoreTextController =
      TextEditingController();
  final TextEditingController _startingScoreTextController =
      TextEditingController();
  final TextEditingController _currentScoreTextController =
      TextEditingController();

  final _myGoalController = Get.find<MyGoalController>();

  GoalDetailsModelForIndividualData? _goalDataForIndividual;
  GoalDetailsForDevelopmentData? _goalDataForDevelopment;

  final List<String> _ddHrList = [
    '0',
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
  ];

  String _ddHrValue = "0";

  List<KeyResultModelForIndividualGoal> _keyResult = [];
  bool _isLoading = false;
  bool _isLoadingUpdate = false;
  bool _isError = false;
  String _isErrorMSG = "";

  String _mainProgressBarValue = "";
  String _startDate = "";
  String _dailyIQScore = "";
  String _photo = "";
  String _title = "";
  String _subTitle = "";

  bool _canUpdate = true;
  bool _isShowDailyIQ = true;
  bool _isShowTagAsDevCheckbox = false;
  bool _isCheckTagAsDeveloperCheckBox = false;
  bool _isShowEditObjectiveButton = false;
  bool _isShowArchivebutton = false;
  bool _isShowManageFolloweBtn = false;

  bool _isConfidencial = false;

  // for development condition
  bool _isUpdateTargetScore = false;
  bool _isUpdateCurrentScore = false;
  bool _isUpdateStartingScore = false;

  bool _isChanged = false;

  bool _isShowSettingIcon = true;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    Map<String, dynamic> map = {
      "goal_id": widget.goalId.toString(),
      "type": widget.type.toString() == "Individual"
          ? "1"
          : widget.type.toString() == "Development"
              ? "2"
              : "3",
      "style_id": widget.styleId.toString(),
      "user_id": widget.userId.toString(),
    };
    try {
      setState(() {
        _isLoading = true;
      });
      var response = await _myGoalController.getGoalDetails(map);
      if (map['type'] == "1") {
        GoalDetailsModelForIndividual res =
            GoalDetailsModelForIndividual.fromJson(response.body);

        setState(() {
          _goalDataForIndividual = res.data;
        });
        _assignDataForIndividueal();
      } else {
        GoalDetailsForDevelopmentModel res =
            GoalDetailsForDevelopmentModel.fromJson(response.body);
        setState(() {
          _goalDataForDevelopment = res.data;
        });
        _assignDataForDevelopment();
      }

      setState(() {
        _isError = false;
        _isErrorMSG = "";
      });
    } catch (e) {
      setState(() {
        _isError = true;
        String error = CommonController().getValidErrorMessage(e.toString());
        _isErrorMSG = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _assignDataForIndividueal() {
    _keyResult = [];
    for (var item in _goalDataForIndividual!.keyResults!) {
      if (item.unitType.toString() == "1") {
        var data = KeyResultModelForIndividualGoal(
            id: item.id.toString(),
            unitType: int.parse(item.unitType.toString()),
            keyResultText:
                TextEditingController(text: item.keyTitle.toString()),
            targetDate: TextEditingController(
                text: item.percentageTargetDate.toString()),
            sliderValue: CommonController.getSliderValue(
                item.percentagePercent.toString()));

        _keyResult.add(data);
      } else {
        var data = KeyResultModelForIndividualGoal(
            id: item.id.toString(),
            unitType: int.parse(item.unitType.toString()),
            keyResultText:
                TextEditingController(text: item.keyTitle.toString()),
            targetDate:
                TextEditingController(text: item.rateTargetDate.toString()),
            sliderValue: CommonController.getSliderValue(item.rate.toString()));

        _keyResult.add(data);
      }
    }

    _isCheckTagAsDeveloperCheckBox =
        _goalDataForIndividual!.tagAsDp.toString() == "1";

    _mainTargetDateController.text =
        _goalDataForIndividual!.targetDate.toString();

    _mainProgressBarValue = _goalDataForIndividual!.progressBarScore.toString();

    _startDate = _goalDataForIndividual!.startDate.toString();
    _photo = _goalDataForIndividual!.photo.toString();

    _title = _goalDataForIndividual!.styleName.toString();
    _subTitle = _goalDataForIndividual!.subObjTitle.toString();

    //  Daily iQ section data
    if (_goalDataForIndividual!.dailyQ != null) {
      _tobeTextController.text =
          _goalDataForIndividual!.dailyQ!.toBe.toString();
      _iwillTextController.text =
          _goalDataForIndividual!.dailyQ!.iWill.toString();
      _situationTextController.text =
          _goalDataForIndividual!.dailyQ!.situationalCue.toString();
      _actionPlanTextController.text =
          _goalDataForIndividual!.dailyQ!.plannedAction.toString();

      _dailyIQScore =
          _goalDataForIndividual!.dailyQ!.previousLastScore.toString();

      if (_ddHrList.contains(
          _goalDataForIndividual!.dailyQ!.todayTodayScore.toString())) {
        _ddHrValue = _goalDataForIndividual!.dailyQ!.todayTodayScore.toString();
      }
    }

    _isConfidencial = _goalDataForIndividual!.isConfidential == "1";
    // checking conditions

    _canUpdate = _goalDataForIndividual!.canUpdate.toString() == "1";
    _isShowDailyIQ =
        _goalDataForIndividual!.showHideDailyqSection.toString() == "1";
    _isShowTagAsDevCheckbox =
        _goalDataForIndividual!.showHideTagAsDevPlanChkbox.toString() == "1";
    _isShowEditObjectiveButton =
        _goalDataForIndividual!.showHideEditObjectiveBtn == "1";

    _isShowArchivebutton = _goalDataForIndividual!.showHideArchiveBtn == "1";
    _isShowManageFolloweBtn =
        _goalDataForIndividual!.showHideManageFollowerBtn == "1";

    _isShowSettingIcon =
        _goalDataForIndividual!.isShowSettingIcon == "0" ? false : true;

    setState(() {});
  }

  _assignDataForDevelopment() {
    _isCheckTagAsDeveloperCheckBox =
        _goalDataForDevelopment!.tagAsDp.toString() == "1";

    _mainTargetDateController.text =
        _goalDataForDevelopment!.targetDate.toString();
    _mainProgressBarValue =
        _goalDataForDevelopment!.progressBarScore.toString();
    _startDate = _goalDataForDevelopment!.startDate.toString();
    _photo = _goalDataForDevelopment!.photo.toString();
    _title = _goalDataForDevelopment!.styleName.toString();
    _subTitle = _goalDataForDevelopment!.subObjTitle.toString();

    //  Daily iQ section data
    if (_goalDataForDevelopment!.dailyQ != null) {
      _tobeTextController.text =
          _goalDataForDevelopment!.dailyQ!.toBe.toString();
      _iwillTextController.text =
          _goalDataForDevelopment!.dailyQ!.iWill.toString();
      _situationTextController.text =
          _goalDataForDevelopment!.dailyQ!.situationalCue.toString();
      _actionPlanTextController.text =
          _goalDataForDevelopment!.dailyQ!.plannedAction.toString();
      _dailyIQScore =
          _goalDataForDevelopment!.dailyQ!.previousLastScore.toString();

      if (_ddHrList.contains(
          _goalDataForDevelopment!.dailyQ!.todayTodayScore.toString())) {
        _ddHrValue =
            _goalDataForDevelopment!.dailyQ!.todayTodayScore.toString();
      }
    }

    // checking conditions
    _canUpdate = _goalDataForDevelopment!.canUpdate.toString() == "1";
    _isShowDailyIQ =
        _goalDataForDevelopment!.showHideDailyqSection.toString() == "1";
    _isShowTagAsDevCheckbox =
        _goalDataForDevelopment!.showHideTagAsDevPlanChkbox.toString() == "1";
    _isShowEditObjectiveButton =
        _goalDataForDevelopment!.showHideEditObjectiveBtn == "1";
    _isShowArchivebutton = _goalDataForDevelopment!.showHideArchiveBtn == "1";
    _isShowManageFolloweBtn =
        _goalDataForDevelopment!.showHideManageFollowerBtn == "1";

    // for development only
    _targetScoreTextController.text =
        _goalDataForDevelopment!.targetScore.toString();
    _startingScoreTextController.text =
        _goalDataForDevelopment!.startingScore.toString();
    _currentScoreTextController.text =
        _goalDataForDevelopment!.currentScore.toString();
    _actionController.text = _goalDataForDevelopment!.keyTitle.toString();

    // conditions
    _isUpdateTargetScore = _goalDataForDevelopment!.updateTargetScore == "1";
    _isUpdateCurrentScore = _goalDataForDevelopment!.updateCurrentScore == "1";
    _isUpdateStartingScore = false;
    _isConfidencial = _goalDataForDevelopment!.isConfidential == "1";
    _isShowSettingIcon =
        _goalDataForDevelopment!.isShowSettingIcon == "0" ? false : true;
    setState(() {});
  }

  Future<void> _selectDate(BuildContext context, {int? index}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // <-- SEE HERE
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
        if (index == null) {
          _mainTargetDateController.text = formattedDate;
        } else {
          _keyResult[index].targetDate.text = formattedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvoked: (didPop) {
        if (didPop == true) {
          return;
        }
        if (_isChanged == true) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
      },
      // onWillPop: () {
      //   if (_isChanged == true) {
      //     Navigator.pop(context, true);
      //   } else {
      //     Navigator.pop(context, false);
      //   }
      //   return Future.value(false);
      // },
      child: CommonController.getAnnanotaion(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              appbarTitle: AppString.goal,
              onbackPress: () {
                if (_isChanged == true) {
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context, false);
                }
              },
            ),
          ),
          backgroundColor: AppColors.labelColor47,
          body: _buildMainView(),
        ),
      ),
    );
  }

  Container _buildMainView() {
    return Container(
      margin: EdgeInsets.all(AppConstants.screenHorizontalPadding),
      child: _isLoading
          ? const Center(
              child: CustomLoadingWidget(),
            )
          : _isError ||
                  (_goalDataForIndividual == null &&
                      _goalDataForDevelopment == null)
              ? Center(
                  child: CustomErrorWidget(
                      onRetry: () {
                        _loadData();
                      },
                      text: _isErrorMSG == ""
                          ? AppString.noDataFound
                          : _isErrorMSG),
                )
              : _buildView(),
    );
  }

  Widget _buildView() {
    return RefreshIndicator(
      onRefresh: () async {
        return await _loadData();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(),
            10.sp.sbh,
            _isShowDailyIQ ? _buildDailyIQ() : 0.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.labelColor48),
          color: AppColors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.radiusSmall),
          ),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.sp.sbh,
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenHorizontalPadding),
                child: _buidListTile()),
            _isShowTagAsDevCheckbox
                ? Column(
                    children: [
                      5.sp.sbh,
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.screenHorizontalPadding),
                        child: _buildCheckboxWithTitle(),
                      ),
                    ],
                  )
                : 0.sp.sbh,
            5.sp.sbh,
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding),
              child: CustomSlider(
                percent: CommonController.getSliderValue(_mainProgressBarValue),
                isEditable: false,
              ),
            ),
            5.sp.sbh,
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding),
              child: _buildTime(),
            ),
            5.sp.sbh,
            Divider(
              height: 1.sp,
              color: AppColors.labelColor,
              thickness: 1,
            ),
            // 10.sp.sbh,
            _goalDataForIndividual != null
                ? Column(
                    children: [
                      ..._keyResult.map(
                        (e) => _buildKeyResultList(e),
                      ),
                      10.sp.sbh,
                    ],
                  )
                : 0.sbh,
            _goalDataForIndividual == null
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.screenHorizontalPadding),
                        child: _buildDevelopmentView(),
                      ),
                      10.sp.sbh,
                    ],
                  )
                : 0.sbh,
            _canUpdate
                ? Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppConstants.screenHorizontalPadding),
                        child: CustomButton(
                            isLoading: _isLoadingUpdate,
                            buttonText: AppString.update,
                            width: MediaQuery.of(context).size.width,
                            radius: Dimensions.radiusSmall,
                            height: 5.h,
                            onPressed: () {
                              _updateGoalDetails();
                            }),
                      ),
                      10.sp.sbh,
                    ],
                  )
                : 0.sbh,
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding),
              child: _buildButtonRow(),
            ),
            15.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildKeyResultList(KeyResultModelForIndividualGoal keyResult) {
    int index = _keyResult.indexOf(keyResult);
    return Column(
      children: [
        5.sp.sbh,
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: AppString.keyResults,
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor41,
                          maxLine: 3,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        5.sp.sbh,
                        SizedBox(
                          height: 25.sp,
                          child: CustomTextFormFieldForMessage(
                            borderColor: AppColors.labelColor,
                            inputAction: TextInputAction.done,
                            labelText: "",
                            isReadOnly: !_canUpdate,
                            inputType: TextInputType.text,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 10.sp,
                            lineCount: 1,
                            editColor: AppColors.labelColor12.withOpacity(0.4),
                            textEditingController: keyResult.keyResultText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  5.sp.sbw,
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: AppString.targetDate1,
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor41,
                          maxLine: 3,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        5.sp.sbh,
                        SizedBox(
                          height: 25.sp,
                          child: CustomTextFormFieldForMessage(
                            borderColor: AppColors.labelColor,
                            inputAction: TextInputAction.done,
                            labelText: "",
                            inputType: TextInputType.text,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 10.sp,
                            isReadOnly: true,
                            onTap: () {
                              if (_canUpdate) {
                                _selectDate(context, index: index);
                              }
                            },
                            lineCount: 1,
                            editColor: AppColors.labelColor12.withOpacity(0.4),
                            textEditingController: keyResult.targetDate,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              5.sp.sbh,
              keyResult.unitType == 1
                  ? CustomText(
                      text: "Percent Complete",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor41,
                      maxLine: 3,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    )
                  : CustomText(
                      text: "Rated Outcome",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor41,
                      maxLine: 3,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
              5.sp.sbh,
              CustomSlider(
                percent: keyResult.sliderValue,
                isEditable: _canUpdate,
                onChange: (double value) {
                  _keyResult[index].sliderValue = value;
                },
              ),
            ],
          ),
        ),
        5.sp.sbh,
        Divider(
          height: 1.sp,
          color: AppColors.labelColor,
          thickness: 1,
        ),
      ],
    );
  }

  Column _buildDevelopmentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.sp.sbh,
        _buildTargetScroe(),
        10.sp.sbh,
        _buildScoreRow(),
        10.sp.sbh,
        _buildTextBoxTitle(AppString.addActionPlan),
        5.sp.sbh,
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor,
          inputAction: TextInputAction.done,
          labelText: AppString.enterKeyResulthere,
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 1,
          editColor: AppColors.labelColor12.withOpacity(0.4),
          textEditingController: _actionController,
        ),
        10.sp.sbh,
      ],
    );
  }

  Widget _buildDailyIQ() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.labelColor48),
        color: AppColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimensions.radiusSmall),
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDailyQButton(),
          10.sp.sbh,
          _buildTextBoxTitle(AppString.achievement),
          10.sp.sbh,
          _buildAchivementRow(),
          10.sp.sbh,
          _buildTextBoxTitle(AppString.toBe),
          5.sp.sbh,
          CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor,
            inputAction: TextInputAction.done,
            labelText: AppString.addToBe,
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            lineCount: 2,
            editColor: AppColors.labelColor12.withOpacity(0.4),
            textEditingController: _tobeTextController,
          ),
          10.sp.sbh,
          _buildTextBoxTitle(AppString.iWill),
          5.sp.sbh,
          CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor,
            inputAction: TextInputAction.done,
            labelText: AppString.addIWill,
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            lineCount: 3,
            editColor: AppColors.labelColor12.withOpacity(0.4),
            textEditingController: _iwillTextController,
          ),
          10.sp.sbh,
          _buildTextBoxTitle(AppString.situationalCue),
          5.sp.sbh,
          CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor,
            inputAction: TextInputAction.done,
            labelText: AppString.addCue,
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            lineCount: 3,
            editColor: AppColors.labelColor12.withOpacity(0.4),
            textEditingController: _situationTextController,
          ),
          10.sp.sbh,
          _buildTextBoxTitle("My Planned Actions"),
          5.sp.sbh,
          CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor,
            focusNode: _actionFocus,
            inputAction: TextInputAction.done,
            labelText: "Add My Planned Actions",
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            lineCount: 3,
            editColor: AppColors.labelColor12.withOpacity(0.4),
            textEditingController: _actionPlanTextController,
          ),
          20.sp.sbh,
          _canUpdate
              ? Center(
                  child: CustomButton2(
                      buttonText: AppString.save,
                      radius: 5.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 7.sp, horizontal: 30.sp),
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      onPressed: () {
                        _saveDailyIQ();
                      }),
                )
              : 0.sbh,
          20.sp.sbh,
        ],
      ),
    );
  }

  Row _buildAchivementRow() {
    return Row(
      children: [
        CircularPercentIndicator(
          radius: 25.sp,
          lineWidth: 5.sp,
          animation: true,
          percent: CommonController.getPercent(_dailyIQScore),
          center: CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
            color: AppColors.black,
            text: "$_dailyIQScore%",
            textAlign: TextAlign.center,
            fontFamily: AppString.manropeFontFamily,
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: AppColors.labelColor50,
          linearGradient:
              CommonController.getLinearGradientSecondryAndPrimary(),
        ),
        15.sbw,
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 10.sp,
            runSpacing: 10.sp,
            children: [
              _isShowSettingIcon
                  ? InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ReminderAlertDialog(
                              goalId: widget.goalId,
                              styleId: widget.styleId,
                              userId: widget.userId,
                              type: widget.type,
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
                        padding: EdgeInsets.all(3.sp),
                        height: 25.sp,
                        child: Image.asset(AppImages.settingBlueIc),
                      ),
                    )
                  : 0.sbh,
              _buildDDHr(),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return HistyoryChartDialog(
                        goalId: widget.goalId,
                        styleId: widget.styleId,
                        userId: widget.userId,
                        type: widget.type,
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
                  padding:
                      EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
                  height: 25.sp,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppImages.timeReloadIc,
                        height: 12.sp,
                      ),
                      2.sp.sbw,
                      CustomText(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: AppColors.labelColor8,
                        text: AppString.history,
                        textAlign: TextAlign.center,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildDDHr() {
    return Container(
      height: 25.sp,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primaryColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
      child: DropdownButton(
        menuMaxHeight: 300,
        underline: 0.sbh,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.black,
        ),
        isDense: true,
        value: _ddHrValue,
        icon: Icon(
          Icons.keyboard_arrow_down,
          size: 13.sp,
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

  Container _buildDailyQButton() {
    return Container(
      padding: EdgeInsets.all(5.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.labelColor49,
        borderRadius: BorderRadius.all(
          Radius.circular(2.sp),
        ),
      ),
      child: Center(
        child: CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
          color: AppColors.labelColor8,
          text: AppString.dailyQ,
          textAlign: TextAlign.center,
          fontFamily: AppString.manropeFontFamily,
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Wrap(
      spacing: 10.sp,
      runSpacing: 10.sp,
      children: [
        InkWell(
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ViewMessageAlertDialog(
                  goalId: widget.goalId,
                  styleId: widget.styleId,
                  userId: widget.userId,
                  type: widget.type,
                );
              },
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            decoration: BoxDecoration(
              boxShadow: CommonController.getBoxShadow,
              gradient: CommonController.getLinearGradientSecondryAndPrimary(),
              borderRadius: BorderRadius.circular(5),
            ),
            child: CustomText(
              text: AppString.viewMessages,
              textAlign: TextAlign.start,
              color: AppColors.white,
              maxLine: 3,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _isShowEditObjectiveButton
            ? InkWell(
                onTap: () async {
                  var result = await Get.to(() => AddGoalScreen(
                        isEdit: true,
                        goalId: widget.goalId,
                        userId: widget.userId,
                      ));

                  if (result != null && result == true) {
                    _loadData();
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  decoration: BoxDecoration(
                    boxShadow: CommonController.getBoxShadow,
                    gradient:
                        CommonController.getLinearGradientSecondryAndPrimary(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CustomText(
                    text: AppString.editObjective,
                    textAlign: TextAlign.center,
                    color: AppColors.white,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : 0.sbh,
        _isShowArchivebutton
            ? InkWell(
                onTap: () {
                  _archiveAction();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  decoration: BoxDecoration(
                    boxShadow: CommonController.getBoxShadow,
                    gradient:
                        CommonController.getLinearGradientSecondryAndPrimary(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CustomText(
                    text: AppString.archive,
                    textAlign: TextAlign.start,
                    color: AppColors.white,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : 0.sbh,
        _isShowManageFolloweBtn
            ? InkWell(
                onTap: () async {
                  if (_isConfidencial) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConfirmAlertDialLog(
                          isShowOnlyTitle: false,
                          title: AppString.thisGoalCurrently,
                        );
                      },
                    );
                  } else {
                    var result = await Get.to(() => ManageFollowerScreen(
                          areaId: _goalDataForIndividual != null
                              ? _goalDataForIndividual!.areaId.toString() ==
                                      "null"
                                  ? ""
                                  : _goalDataForIndividual!.areaId.toString()
                              : _goalDataForDevelopment!.areaId.toString() ==
                                      "null"
                                  ? ""
                                  : _goalDataForDevelopment!.areaId.toString(),
                          goalId: widget.goalId,
                          styleId: widget.styleId,
                          type: widget.type,
                          userId: widget.userId,
                        ));

                    if (result != null && result == true) {
                      _loadData();
                    }
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  decoration: BoxDecoration(
                    boxShadow: CommonController.getBoxShadow,
                    gradient:
                        CommonController.getLinearGradientSecondryAndPrimary(),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CustomText(
                    text: AppString.manageFollowers,
                    textAlign: TextAlign.center,
                    color: AppColors.white,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : 0.sbh,
      ],
    );
  }

  CustomText _buildTextBoxTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w600,
      fontSize: 11.sp,
      color: AppColors.labelColor35,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Row _buildScoreRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStartingScore(AppString.startingScore),
        ),
        10.sp.sbw,
        Expanded(
          child: _buildCurrentScore(
            AppString.currentScore,
          ),
        ),
      ],
    );
  }

  Container _buildCurrentScore(
    String title,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor47,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimensions.radiusSmall),
        ),
      ),
      child: Column(
        children: [
          CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.black,
            maxLine: 3,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          5.sp.sbh,
          SizedBox(
            height: 27.sp,
            width: 40.sp,
            child: CustomTextFormFieldForMessage(
              isReadOnly: !_isUpdateCurrentScore,
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "",
              textAlignment: TextAlign.center,
              inputType: TextInputType.number,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLength: 3,
              lineCount: 1,
              editColor: AppColors.labelColor12.withOpacity(0.4),
              textEditingController: _currentScoreTextController,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildStartingScore(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor47,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimensions.radiusSmall),
        ),
      ),
      child: Column(
        children: [
          CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.black,
            maxLine: 3,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          5.sp.sbh,
          SizedBox(
            height: 27.sp,
            width: 40.sp,
            child: CustomTextFormFieldForMessage(
              isReadOnly: !_isUpdateStartingScore,
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "",
              inputType: TextInputType.number,
              textAlignment: TextAlign.center,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLength: 3,
              lineCount: 1,
              editColor: AppColors.labelColor12.withOpacity(0.4),
              textEditingController: _startingScoreTextController,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTargetScroe() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.all(
          Radius.circular(Dimensions.radiusSmall),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: AppString.targetScore,
            textAlign: TextAlign.start,
            color: AppColors.black,
            maxLine: 3,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(
            height: 27.sp,
            width: 40.sp,
            child: CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "",
              isReadOnly: !_isUpdateTargetScore,
              inputType: TextInputType.number,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLength: 3,
              lineCount: 1,
              textAlignment: TextAlign.center,
              editColor: AppColors.labelColor12.withOpacity(0.4),
              textEditingController: _targetScoreTextController,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: AppString.startDate,
                    textAlign: TextAlign.start,
                    color: AppColors.black,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  5.sp.sbh,
                  CustomText(
                    text: _startDate,
                    textAlign: TextAlign.start,
                    color: AppColors.black,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: AppString.targetDate,
                    textAlign: TextAlign.start,
                    color: AppColors.black,
                    maxLine: 3,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  5.sp.sbh,
                  SizedBox(
                    height: 25.sp,
                    child: CustomTextFormFieldForMessage(
                      borderColor: AppColors.labelColor,
                      isReadOnly: true,
                      onTap: () {
                        if (_canUpdate) {
                          _selectDate(context);
                        }
                      },
                      inputAction: TextInputAction.done,
                      labelText: "",
                      inputType: TextInputType.text,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      lineCount: 1,
                      editColor: AppColors.labelColor12.withOpacity(0.4),
                      textEditingController: _mainTargetDateController,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
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
              if (_canUpdate) {
                _isCheckTagAsDeveloperCheckBox =
                    !_isCheckTagAsDeveloperCheckBox;
              }
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

  Padding _buidListTile() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.circleGreen,
            radius: 20.sp,
            child: CircleAvatar(
              backgroundColor: AppColors.white,
              backgroundImage: NetworkImage(
                _photo,
              ),
              radius: 20.sp,
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
                    text: _title,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 3.sp,
                  ),
                  CustomText(
                    text: _subTitle,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor15,
                    maxLine: 40,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateGoalDetails() async {
    if (_mainTargetDateController.text.isEmpty) {
      showCustomSnackBar(AppString.pleaseSelectTargetDate);
      return;
    }

    Map<String, dynamic> jsonData = {};
    if (widget.type.toString() == "Individual") {
      //  checking validation
      List keyResultList = [];
      for (var item in _keyResult) {
        if (item.targetDate.text.isEmpty) {
          showCustomSnackBar(AppString.pleaseSelectTargetDateOfKeyResult);
          return;
        }
        if (item.keyResultText.text.isEmpty) {
          showCustomSnackBar(AppString.pleaseEnterKeyResult);
          return;
        }

        if (item.unitType == 1) {
          var keyResult = {
            "id": item.id.toString(),
            "key_title": item.keyResultText.text.toString(),
            "unit_type": item.unitType.toString(),
            "percentage_desc": item.keyResultText.text.toString(),
            "percentage_target_date": item.targetDate.text.toString(),
            "percentage_percent": (item.sliderValue).round().toString(),
          };

          keyResultList.add(keyResult);
        } else {
          var keyResult = {
            "id": item.id.toString(),
            "key_title": item.keyResultText.text.toString(),
            "unit_type": item.unitType.toString(),
            "rate_target_date": item.targetDate.text.toString(),
            "rate": (item.sliderValue).round().toString()
          };

          keyResultList.add(keyResult);
        }
      }

      jsonData = {
        "id": _goalDataForIndividual!.id.toString(),
        "user_id": _goalDataForIndividual!.toUser.toString(),
        "Goal_type": _goalDataForIndividual!.goalType.toString(),
        "style_id": _goalDataForIndividual!.styleId.toString(),
        "tag_as_dp": _isCheckTagAsDeveloperCheckBox ? "1" : "0",
        "target_date": _mainTargetDateController.text.toString(),
        "keyResult": keyResultList
      };
    } else {
      jsonData = {
        "id": _goalDataForDevelopment!.id.toString(),
        "user_id": _goalDataForDevelopment!.toUser.toString(),
        "Goal_type": _goalDataForDevelopment!.goalType.toString(),
        "style_id": _goalDataForDevelopment!.styleId.toString(),
        "tag_as_dp": _isCheckTagAsDeveloperCheckBox ? "1" : "0",
        "target_date": _mainTargetDateController.text.toString(),
        "current_score": _currentScoreTextController.text,
        "target_score": _targetScoreTextController.text,
        "key_title": _actionController.text,
        "keyResult": null
      };
    }

    try {
      setState(() {
        _isLoadingUpdate = true;
      });

      var response = await _myGoalController.updateGoalDetails(jsonData);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        setState(() {
          _isChanged = true;
        });
        _loadData();
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoadingUpdate = false;
      });
    }
  }

  _archiveAction() async {
    try {
      buildLoading(Get.context!);

      Map<String, dynamic> map = {
        "id": widget.goalId.toString(),
        "user_id": widget.userId.toString(),
        "Goal_type": widget.type.toString(),
        "style_id": widget.styleId.toString(),
      };

      var response = await _myGoalController.archiveGoal(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
      Navigator.pop(Get.context!, true);
    }
  }

  _saveDailyIQ() async {
    try {
      buildLoading(Get.context!);

      Map<String, dynamic> map = {
        "id": widget.goalId.toString(),
        "user_id": widget.userId.toString(),
        "Goal_type": widget.type.toString(),
        "style_id": widget.styleId.toString(),
        "i_will": _iwillTextController.text,
        "situational_cue": _situationTextController.text,
        "goal_tobe": _tobeTextController.text,
        "planned_action": _actionPlanTextController.text,
        "score": _ddHrValue,
      };

      if (_goalDataForIndividual != null) {
        map['today_update_id'] =
            _goalDataForIndividual!.dailyQ!.todayUpdateId.toString() == "null"
                ? ""
                : _goalDataForIndividual!.dailyQ!.todayUpdateId.toString();
        map['today_today_score'] =
            _goalDataForIndividual!.dailyQ!.todayTodayScore.toString() == "null"
                ? ""
                : _goalDataForIndividual!.dailyQ!.todayTodayScore.toString();

        map['first_day'] =
            _goalDataForIndividual!.dailyQ!.firstDay.toString() == "null"
                ? ""
                : _goalDataForIndividual!.dailyQ!.firstDay.toString();
        map['previous_last_score'] =
            _goalDataForIndividual!.dailyQ!.previousLastScore.toString() ==
                    "null"
                ? ""
                : _goalDataForIndividual!.dailyQ!.previousLastScore.toString();

        map['area_id'] = _goalDataForIndividual!.areaId.toString() == "null"
            ? ""
            : _goalDataForIndividual!.areaId.toString();
      }
      if (_goalDataForDevelopment != null) {
        map['today_update_id'] =
            _goalDataForDevelopment!.dailyQ!.todayUpdateId.toString() == "null"
                ? ""
                : _goalDataForDevelopment!.dailyQ!.todayUpdateId.toString();
        map['today_today_score'] =
            _goalDataForDevelopment!.dailyQ!.todayTodayScore.toString() ==
                    "null"
                ? ""
                : _goalDataForDevelopment!.dailyQ!.todayTodayScore.toString();
        map['first_day'] =
            _goalDataForDevelopment!.dailyQ!.firstDay.toString() == "null"
                ? ""
                : _goalDataForDevelopment!.dailyQ!.firstDay.toString();
        map['previous_last_score'] =
            _goalDataForDevelopment!.dailyQ!.previousLastScore.toString() ==
                    "null"
                ? ""
                : _goalDataForDevelopment!.dailyQ!.previousLastScore.toString();

        map['area_id'] = _goalDataForDevelopment!.areaId.toString() == "null"
            ? ""
            : _goalDataForDevelopment!.areaId.toString();
      }

      var response = await _myGoalController.saveDailyQ(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _loadData();
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

class KeyResultModelForIndividualGoal {
  String? id;
  TextEditingController keyResultText;
  TextEditingController targetDate;
  int unitType;

  double sliderValue;

  KeyResultModelForIndividualGoal({
    required this.id,
    required this.keyResultText,
    required this.targetDate,
    required this.unitType,
    required this.sliderValue,
  });
}
