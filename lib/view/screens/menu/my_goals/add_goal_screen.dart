import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/edit_objective_model.dart';
import 'package:aspirevue/data/model/response/followes_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_video.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_multi_select_dropdown.dart';
import 'package:aspirevue/view/base/custom_slider.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen(
      {super.key, required this.isEdit, this.goalId, this.userId});
  final bool isEdit;
  final String? goalId;
  final String? userId;

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final _myGoalController = Get.find<MyGoalController>();
  int _currentIndex = 1;

  final FocusNode _objectiveFocus = FocusNode();
  final FocusNode _desiredOutFocus = FocusNode();
  final FocusNode _startDateFocus = FocusNode();
  final FocusNode _endDateFocus = FocusNode();
  final FocusNode _supportRequiredFocus = FocusNode();
  final FocusNode _potentialObstaclesFocus = FocusNode();

  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _desiredOutcomesController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _targetDateController = TextEditingController();
  final TextEditingController _supportRequiredController =
      TextEditingController();
  final TextEditingController _potentialObstaclesController =
      TextEditingController();

  String _areaOfFocusRadioGp = "1";
  String _isConfidentialRadioGP = "0";

  bool _isCheckTagAsDeveloperCheckBox = false;
  bool _isCheckSolicitedFeedbackCheckBox = false;
  bool _isCheckUnsolicitedFeedbackCheckBox = false;
  bool _isCheckDocumentReviewCheckBox = false;
  bool _isCheckDirectObservationsCheckBox = false;

  List<OptionItemForMultiSelect> _ddSelectUserList = [];
  final OptionItemForMultiSelect _ddValueUserList = OptionItemForMultiSelect(
      id: null, title: AppString.selectOption, isChecked: false);

  final List<DropDownOptionItemMenu> _ddList = [
    DropDownOptionItemMenu(id: "1", title: AppString.percentComplete),
    DropDownOptionItemMenu(id: "2", title: AppString.ratedOutcome),
  ];

  final List<KeyResultModel> _keyResult = [];
  final _scrollController = ScrollController();
  List<String> _licences = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    //  check condition for edit

    if (widget.isEdit) {
      //  edit goal
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> map = {
        "id": widget.goalId,
        "user_id": widget.userId,
      };
      var data = await _myGoalController.getGoalFollowers({
        "user_id": widget.userId,
      });
      var editData = await _myGoalController.getGoalObjectiveDetail(map);

      if (editData != null) {
        await _fillData(data, editData);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      var userData = Get.find<ProfileSharedPrefService>().loginData;
      if (userData.value.licenseList != null) {
        _licences = userData.value.licenseList!;
      }

      var data = await _myGoalController.getGoalFollowers({
        "user_id": userData.value.id.toString(),
      });
      setState(() {
        for (var element in data) {
          _ddSelectUserList.add(
            OptionItemForMultiSelect(
                id: element.id.toString(),
                title: element.name.toString(),
                isChecked: false),
          );
        }
      });
    }
  }

  _fillData(List<GoalFollowersData> data, EditObjectiveData goalData) {
    _objectiveController.text = goalData.subObjTitle.toString();
    _desiredOutcomesController.text = goalData.objDesiredOutcomes.toString();
    _startDateController.text = goalData.beginningDate.toString();
    _targetDateController.text = goalData.targetDate.toString();
    _supportRequiredController.text = goalData.objSupport.toString();
    _potentialObstaclesController.text = goalData.objPotential.toString();

    _areaOfFocusRadioGp = goalData.areaOfFocus.toString();
    _isConfidentialRadioGP = goalData.isConfidential.toString();

    _isCheckTagAsDeveloperCheckBox = goalData.tagAsDp == 1;

    _isCheckSolicitedFeedbackCheckBox =
        goalData.feedbackSolicited.toString() == "1";
    _isCheckUnsolicitedFeedbackCheckBox =
        goalData.feedbackUnsolicited.toString() == "1";
    _isCheckDocumentReviewCheckBox =
        goalData.feedbackDocument.toString() == "1";
    _isCheckDirectObservationsCheckBox =
        goalData.feedbackDirect.toString() == "1";

    // loop for follower data check or not checked

    for (var element in data) {
      _ddSelectUserList.add(
        OptionItemForMultiSelect(
            id: element.id.toString(),
            title: element.name.toString(),
            isChecked: goalData.follower!.contains(element.id.toString())),
      );
    }

    // loop for key results value data

    for (var item in goalData.keyResult!) {
      if (item.unitType.toString() == "1") {
        KeyResultModel keyData = KeyResultModel(
          id: item.id.toString(),
          selectedItem: _ddList.first,
          asAvidenceTextController: TextEditingController(text: item.keyTitle),
          percentCompleteTextController:
              TextEditingController(text: item.percentageDesc),
          targetDate: item.percentageTargetDate.toString(),
          sliderValue: CommonController.getSliderValue(
              item.percentagePercent.toString()),
        );
        _keyResult.add(keyData);
      } else {
        KeyResultModel keyData = KeyResultModel(
          id: item.id.toString(),
          selectedItem: _ddList.last,
          asAvidenceTextController: TextEditingController(text: item.keyTitle),
          percentCompleteTextController: TextEditingController(text: ""),
          targetDate: item.rateTargetDate.toString(),
          sliderValue: CommonController.getSliderValue(item.rate.toString()),
        );
        _keyResult.add(keyData);
      }
    }

    _licences = goalData.licenseList!;
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isStartDate ? DateTime(2000) : DateTime.now(),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
        if (isStartDate) {
          _startDateController.text = formattedDate;
        } else {
          _targetDateController.text = formattedDate;
        }
      });
    }
  }

  Future<void> _selectDateForKeyResult(BuildContext context, int index) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
      setState(() {
        _keyResult[index].targetDate = formattedDate;
      });
    }
  }

  bool _isSaveButtonLoading = false;

  _saveButton() async {
    setState(() {
      _isSaveButtonLoading = true;
    });
    var selectedList = _ddSelectUserList
        .where((element) => element.isChecked == true)
        .toList();

    List<Map<String, dynamic>> keysList = [];

    var currentUserId =
        Get.find<ProfileSharedPrefService>().profileData.value.id ?? "";

    for (var item in _keyResult) {
      Map<String, dynamic> data = {
        "id": item.id,
        "key_title": item.asAvidenceTextController.text,
        "unit_type": item.selectedItem!.id,
      };

      if (item.selectedItem!.id == "1") {
        data['percentage_desc'] = item.percentCompleteTextController.text;
        data['percentage_target_date'] = item.targetDate.toString();
        data['percentage_percent'] = (item.sliderValue).round().toString();
      } else {
        data['rate_target_date'] = item.targetDate.toString();
        data['rate'] = (item.sliderValue).round().toString();
      }
      keysList.add(data);
    }

    var followerList = selectedList.map((e) => e.id).toList();
    String followerListString =
        followerList.map((e) => e.toString()).toString();
    Map<String, dynamic> requestPrm = {
      "sub_obj_title": _objectiveController.text,
      "obj_desired_outcomes": _desiredOutcomesController.text,
      "area_of_focus": _areaOfFocusRadioGp.toString(),
      "is_confidential": _isConfidentialRadioGP.toString(),
      "tag_as_dp": _isCheckTagAsDeveloperCheckBox ? 1 : 0,
      "beginning_date": _startDateController.text,
      "target_date": _targetDateController.text,
      "keyResult": keysList,
      "obj_support": _supportRequiredController.text,
      "obj_potential": _potentialObstaclesController.text,
      "feedback_solicited": _isCheckSolicitedFeedbackCheckBox ? 1 : 0,
      "feedback_unsolicited": _isCheckUnsolicitedFeedbackCheckBox ? 1 : 0,
      "feedback_document": _isCheckDocumentReviewCheckBox ? 1 : 0,
      "feedback_direct": _isCheckDirectObservationsCheckBox ? 1 : 0,
      "follower": followerListString
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll(" ", ""),
    };

    if (widget.isEdit) {
      requestPrm['id'] = widget.goalId;
      requestPrm['user_id'] = widget.userId.toString();
    } else {
      requestPrm['user_id'] = currentUserId.toString();
    }

    try {
      var response = await _myGoalController.addEditMyGoal(requestPrm);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);

        await _myGoalController.getMyGoal(
          true,
        );
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isSaveButtonLoading = false;
      });

      Navigator.pop(Get.context!, true);
    }
  }

  _addMoreKeyResult() {
    var data = KeyResultModel(
      id: null,
      selectedItem: _ddList.first,
      asAvidenceTextController: TextEditingController(),
      percentCompleteTextController: TextEditingController(),
      targetDate: _targetDateController.text,
      sliderValue: 0,
    );
    setState(() {
      _keyResult.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: PopScope(
        canPop: _currentIndex == 1,
        onPopInvoked: (va) {
          if (_currentIndex == 1) {
          } else {
            setState(() {
              _currentIndex -= 1;
            });
          }
        },
        child: CommonController.getAnnanotaion(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: GetBuilder<DashboardController>(
                  builder: (dashboardController) {
                String url = "";
                bool isShowHelp = dashboardController.quickLinkData != null
                    ? dashboardController.quickLinkData!.helpVideos!.isNotEmpty
                        ? dashboardController.quickLinkData!.helpVideos!
                            .where((element) {
                              if (element.navKey == "create_manual_goal") {
                                url = element.videoLink.toString();
                                return true;
                              } else {
                                return false;
                              }
                            })
                            .toList()
                            .isNotEmpty
                        : false
                    : false;

                if (isShowHelp) {}
                return AppbarWithBackButton(
                  fontSize: 15.sp,
                  isShowHelpIcon: isShowHelp,
                  onHelpTap: () {
                    _openVideoPopup(url);
                  },
                  appbarTitle: widget.isEdit
                      ? AppString.editDevelopement
                      : AppString.addDevelopement,
                  onbackPress: () {
                    Navigator.pop(context);
                  },
                );
              }),
            ),
            backgroundColor: AppColors.labelColor47,
            body: SafeArea(
              child: _isLoading
                  ? const Center(
                      child: CustomLoadingWidget(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: AppConstants.screenHorizontalPadding,
                                left: AppConstants.screenHorizontalPadding,
                                right: AppConstants.screenHorizontalPadding),
                            width: double.infinity,
                            color: AppColors.labelColor47,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildTopTimeLine(),
                                  15.sp.sbh,
                                  _currentIndex == 1
                                      ? _buildFirstPage()
                                      : _currentIndex == 2
                                          ? _buildSecondPage()
                                          : _buildThirdPage()
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _openVideoPopup(String url) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return VideoAlertDialog(
          url: url,
        );
      },
    );
  }

  Widget _buildThirdPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithBlackBorderBox(AppString.objective),
        15.sp.sbh,
        _buildTitleWithWhiteLineBox(
          AppString.resourcing,
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextBoxTitle(AppString.supportRequired),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor,
                  focusNode: _supportRequiredFocus,
                  inputAction: TextInputAction.done,
                  labelText: AppString.whatSupportDoYouRequire,
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  lineCount: 2,
                  editColor: AppColors.labelColor12,
                  textEditingController: _supportRequiredController,
                ),
                5.sp.sbh,
                _buildTextBoxTitle(AppString.potentialObstacles),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor,
                  focusNode: _potentialObstaclesFocus,
                  inputAction: TextInputAction.done,
                  labelText: AppString.whatAreThePotential,
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  lineCount: 2,
                  editColor: AppColors.labelColor12,
                  textEditingController: _potentialObstaclesController,
                ),
                5.sp.sbh,
                _isConfidentialRadioGP == "0"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextBoxTitle(AppString.feedbackType),
                          5.sp.sbh,
                          _buildBorderBoxWithText(AppString.indicateHow),
                          10.sp.sbh,
                          _buildFeedBackTypeCheckboxList(),
                          10.sp.sbh,
                          _buildTextBoxTitle(AppString.followers),
                          5.sp.sbh,
                          _buildBorderBoxWithText(AppString.whoWould),
                          10.sp.sbh,
                          CustomMultipleDropListShowListOnTopWidget(
                            _ddValueUserList.title,
                            _ddValueUserList,
                            _ddSelectUserList,
                            fontSize: 12.sp,
                            borderColor: AppColors.labelColor,
                            bgColor: AppColors.labelColor12,
                            (value) {
                              _ddSelectUserList = value;
                              setState(() {});
                            },
                          ),
                          5.sp.sbh,
                        ],
                      )
                    : 0.sbh,
              ],
            ),
          ),
        ),
        10.sp.sbh,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // _buildPreviousButton(),
            0.sbh,
            _buildSaveButton(),
          ],
        ),
        10.sp.sbh,
      ],
    );
  }

  Padding _buildFeedBackTypeCheckboxList() {
    return Padding(
      padding: EdgeInsets.only(left: 2.sp),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isCheckSolicitedFeedbackCheckBox =
                    !_isCheckSolicitedFeedbackCheckBox;
              });
            },
            child: Row(
              children: [
                CustomCheckBox(
                  borderColor: AppColors.labelColor8,
                  fillColor: AppColors.labelColor8,
                  isChecked: _isCheckSolicitedFeedbackCheckBox,
                  onTap: () {
                    setState(() {
                      _isCheckSolicitedFeedbackCheckBox =
                          !_isCheckSolicitedFeedbackCheckBox;
                    });
                  },
                ),
                8.sp.sbw,
                _buildTextBoxTitleCheckBox(AppString.solicitedFeedback),
              ],
            ),
          ),
          5.sp.sbh,
          InkWell(
            onTap: () {
              setState(() {
                _isCheckUnsolicitedFeedbackCheckBox =
                    !_isCheckUnsolicitedFeedbackCheckBox;
              });
            },
            child: Row(
              children: [
                CustomCheckBox(
                  borderColor: AppColors.labelColor8,
                  fillColor: AppColors.labelColor8,
                  isChecked: _isCheckUnsolicitedFeedbackCheckBox,
                  onTap: () {
                    setState(() {
                      _isCheckUnsolicitedFeedbackCheckBox =
                          !_isCheckUnsolicitedFeedbackCheckBox;
                    });
                  },
                ),
                8.sp.sbw,
                _buildTextBoxTitleCheckBox(AppString.unsolicitedFeedback),
              ],
            ),
          ),
          5.sp.sbh,
          InkWell(
            onTap: () {
              setState(() {
                _isCheckDocumentReviewCheckBox =
                    !_isCheckDocumentReviewCheckBox;
              });
            },
            child: Row(
              children: [
                CustomCheckBox(
                  borderColor: AppColors.labelColor8,
                  fillColor: AppColors.labelColor8,
                  isChecked: _isCheckDocumentReviewCheckBox,
                  onTap: () {
                    setState(() {
                      _isCheckDocumentReviewCheckBox =
                          !_isCheckDocumentReviewCheckBox;
                    });
                  },
                ),
                8.sp.sbw,
                _buildTextBoxTitleCheckBox(AppString.documentReview),
              ],
            ),
          ),
          5.sp.sbh,
          InkWell(
            onTap: () {
              setState(() {
                _isCheckDirectObservationsCheckBox =
                    !_isCheckDirectObservationsCheckBox;
              });
            },
            child: Row(
              children: [
                CustomCheckBox(
                  borderColor: AppColors.labelColor8,
                  fillColor: AppColors.labelColor8,
                  isChecked: _isCheckDirectObservationsCheckBox,
                  onTap: () {
                    setState(() {
                      _isCheckDirectObservationsCheckBox =
                          !_isCheckDirectObservationsCheckBox;
                    });
                  },
                ),
                8.sp.sbw,
                _buildTextBoxTitleCheckBox(AppString.directObservations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithBlackBorderBox(AppString.objective),
        15.sp.sbh,
        _buildTitleWithWhiteLineBox(
          AppString.keyResults,
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._keyResult.map((e) => _buildKeyResultBox(e)),
                _buildAddmoreKeyButton(),
                5.sp.sbh,
              ],
            ),
          ),
        ),
        15.sp.sbh,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // _buildPreviousButton(),
            0.sbh,
            _buildNextButton(),
          ],
        ),
        15.sp.sbh,
      ],
    );
  }

  Widget _buildKeyResultBox(KeyResultModel data) {
    int index = _keyResult.indexOf(data);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.labelColor),
            color: AppColors.labelColor78.withOpacity(0.05),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextBoxTitle(AppString.asevidenced),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                textEditingController: data.asAvidenceTextController,
                inputAction: TextInputAction.done,
                labelText: AppString.whatActionStepWillYouTake,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.labelColor12,
                onEditingComplete: () {
                  CommonController.hideKeyboard(context);
                },
              ),
              10.sp.sbh,
              _buildTextBoxTitle(AppString.selectedSuccessMeasure),
              5.sp.sbh,
              CustomDropListForMessageTwo(
                data.selectedItem!.title,
                data.selectedItem!,
                _ddList,
                fontSize: 12.sp,
                borderColor: AppColors.labelColor,
                bgColor: AppColors.labelColor12,
                (optionItemForMultiSelect) {
                  _keyResult[index].selectedItem = optionItemForMultiSelect;
                  setState(() {});
                },
              ),
              10.sp.sbh,
              data.selectedItem!.title != "Rated Outcome"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextBoxTitle(AppString.percentComplete),
                        5.sp.sbh,
                        CustomTextFormFieldForMessage(
                          borderColor: AppColors.labelColor,
                          inputAction: TextInputAction.done,
                          labelText: AppString.howwwillyoumeasure,
                          inputType: TextInputType.text,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 12.sp,
                          lineCount: 2,
                          editColor: AppColors.labelColor12,
                          textEditingController:
                              data.percentCompleteTextController,
                          onEditingComplete: () {
                            CommonController.hideKeyboard(context);
                          },
                        ),
                        10.sp.sbh,
                      ],
                    )
                  : 0.sbh,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextBoxTitle(AppString.targetDate),
                  InkWell(
                    onTap: () {
                      _selectDateForKeyResult(context, index);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                          color: AppColors.labelColor12.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(3.sp),
                          border: Border.all(
                            color: AppColors.backgroundColor1,
                          )),
                      child: CustomText(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: AppColors.labelColor34,
                        text: data.targetDate == ""
                            ? "Select Date"
                            : data.targetDate,
                        textAlign: TextAlign.start,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                    ),
                  ),
                ],
              ),
              5.sp.sbh,
              _buildTextBoxTitle(AppString.completePer),
              5.sp.sbh,
              CustomSlider(
                percent: data.sliderValue,
                isEditable: true,
                onChange: (double value) {
                  _keyResult[index].sliderValue = value;
                },
              ),
              10.sp.sbh,
              _buildDeleteButton(data),
            ],
          ),
        ),
        15.sp.sbh,
      ],
    );
  }

  Widget _buildFirstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleWithWhiteLineBox(
          AppString.individualObjective,
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: AppColors.labelColor34,
                  text: AppString.whatwouldaccomplish,
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                5.sp.sbh,
                _buildTextBoxTitle(AppString.objective1),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor,
                  focusNode: _objectiveFocus,
                  inputAction: TextInputAction.done,
                  labelText: AppString.enterObjective,
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  lineCount: 2,
                  editColor: AppColors.labelColor12,
                  textEditingController: _objectiveController,
                  nextFocus: _desiredOutFocus,
                ),
                5.sp.sbh,
                _buildTextBoxTitle(AppString.desiredOutcomes),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor,
                  focusNode: _desiredOutFocus,
                  inputAction: TextInputAction.done,
                  labelText: AppString.describeInBehavioralTerms,
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  lineCount: 2,
                  editColor: AppColors.labelColor12,
                  textEditingController: _desiredOutcomesController,
                  onEditingComplete: () {
                    CommonController.hideKeyboard(context);
                  },
                ),
              ],
            ),
          ),
        ),
        15.sp.sbh,
        _buildTitleWithWhiteLineBox(
          AppString.areaofFocus,
          child: Padding(
            padding: EdgeInsets.all(10.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRadioButton(
                    title: AppString.personalGrowth,
                    gpValue: _areaOfFocusRadioGp,
                    value: "1",
                    onTap: () {
                      setState(() {
                        _areaOfFocusRadioGp = "1";
                      });
                    }),
                _buildRadioButton(
                    title: AppString.operationalRelated,
                    gpValue: _areaOfFocusRadioGp,
                    value: "0",
                    onTap: () {
                      setState(() {
                        _areaOfFocusRadioGp = "0";
                      });
                    }),
                _buildBorderBoxWithText(_isConfidentialRadioGP == "0"
                    ? AppString.chooseTheAre
                    : AppString.aConfidentGoal),
                10.sp.sbh,
                _buildRadioButton(
                    title: AppString.sharableGoal,
                    gpValue: _isConfidentialRadioGP,
                    value: "0",
                    onTap: () {
                      setState(() {
                        _isConfidentialRadioGP = "0";
                      });
                    }),
                _buildRadioButton(
                    title: AppString.confidentialGoal,
                    gpValue: _isConfidentialRadioGP,
                    value: "1",
                    onTap: () {
                      setState(() {
                        _isConfidentialRadioGP = "1";
                      });
                    }),
                _licences.contains("47") || _licences.contains("63")
                    ? _areaOfFocusRadioGp == "1" &&
                            _isConfidentialRadioGP == "0"
                        ? _buildCheckboxWithTitle()
                        : 0.sbh
                    : 0.sbh,
                10.sp.sbh,
                _buildTextBoxTitle(AppString.startDate1),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  onTap: () {
                    _selectDate(context, true);
                  },
                  borderColor: AppColors.labelColor,
                  focusNode: _startDateFocus,
                  inputAction: TextInputAction.done,
                  labelText: AppString.selectDate,
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  isReadOnly: true,
                  editColor: AppColors.labelColor12,
                  textEditingController: _startDateController,
                ),
                5.sp.sbh,
                _buildTextBoxTitle(AppString.targetDate1),
                5.sp.sbh,
                CustomTextFormFieldForMessage(
                  onTap: () {
                    _selectDate(context, false);
                  },
                  isReadOnly: true,
                  borderColor: AppColors.labelColor,
                  focusNode: _endDateFocus,
                  inputAction: TextInputAction.done,
                  labelText: AppString.selectDate,
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  editColor: AppColors.labelColor12,
                  textEditingController: _targetDateController,
                ),
              ],
            ),
          ),
        ),
        15.sp.sbh,
        _buildNextButton(),
        15.sp.sbh,
      ],
    );
  }

  Container _buildBorderBoxWithText(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor39,
        ),
        borderRadius: BorderRadius.circular(
          3.sp,
        ),
      ),
      child: CustomText(
        text: title,
        textAlign: TextAlign.start,
        color: AppColors.labelColor39,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
        maxLine: 10,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildSaveButton() {
    return _isSaveButtonLoading
        ? const Center(
            child: SizedBox(child: CustomLoadingWidget()),
          )
        : Align(
            alignment: Alignment.centerRight,
            child: CustomButton2(
                buttonText: AppString.save,
                radius: 5.sp,
                padding:
                    EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                onPressed: () {
                  _saveButton();
                  // _addSuggestionQuestion();
                }),
          );
  }

  // _previousButton() {
  //   setState(() {
  //     _currentIndex--;
  //   });
  // }

  _nextButton() {
    if (_currentIndex == 1) {
      if (_objectiveController.text.trim().isEmpty) {
        showCustomSnackBar(AppString.pleaseEnterObjective);
        return;
      }
      if (_desiredOutcomesController.text.trim().isEmpty) {
        showCustomSnackBar(AppString.pleaseEnterDesiredOutcomes);
        return;
      }
      if (_startDateController.text.trim().isEmpty) {
        showCustomSnackBar(AppString.pleaseSelectStartDate);
        return;
      }
      if (_targetDateController.text.trim().isEmpty) {
        showCustomSnackBar(AppString.pleaseSelectTargetDate);
        return;
      }

      setState(() {
        _currentIndex++;
      });
      return;
    }

    if (_currentIndex == 2) {
      if (_keyResult.isEmpty) {
        showCustomSnackBar(AppString.pleasecreatealeastonekeyresult);
        return;
      }
      for (var element in _keyResult) {
        if (element.asAvidenceTextController.text.trim().isEmpty) {
          showCustomSnackBar(AppString.pleaseEnterAsEvidenced);
          return;
        }

        // if (element.selectedItem!.title != "Rated Outcome" &&
        //     element.percentCompleteTextController.text.isEmpty) {
        //   showCustomSnackBar(AppString.pleaseEnterPercentComplete);
        //   return;
        // }
      }

      setState(() {
        _currentIndex++;
      });
    }
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          _nextButton();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
          decoration: BoxDecoration(
            boxShadow: CommonController.getBoxShadow,
            color: AppColors.white,
            border: Border.all(
              color: AppColors.labelColor8,
            ),
            borderRadius: BorderRadius.circular(
              5.sp,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: AppString.next,
                textAlign: TextAlign.start,
                color: AppColors.labelColor8,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
              5.sbw,
              Image.asset(
                AppImages.icBlueRightArrow,
                height: 18.sp,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddmoreKeyButton() {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          _addMoreKeyResult();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
          decoration: BoxDecoration(
            boxShadow: CommonController.getBoxShadow,
            gradient: CommonController.getLinearGradientSecondryAndPrimary(),
            borderRadius: BorderRadius.circular(
              5.sp,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.plusIc,
                height: 10.sp,
              ),
              5.sbw,
              CustomText(
                text: AppString.addMoreKeyResults,
                textAlign: TextAlign.start,
                color: AppColors.white,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(KeyResultModel data) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          setState(() {
            _keyResult.remove(data);
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.labelColor38,
            ),
            borderRadius: BorderRadius.circular(
              5.sp,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.deleteRedIc,
                height: 12.sp,
              ),
              3.sbw,
              CustomText(
                text: AppString.delete,
                textAlign: TextAlign.start,
                color: AppColors.redColor,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ),
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
              _isCheckTagAsDeveloperCheckBox = !_isCheckTagAsDeveloperCheckBox;
            });
          },
        ),
        8.sp.sbw,
        _buildTextBoxTitle(AppString.tagasaDevelopmentPlanGoal),
      ],
    );
  }

  Widget _buildRadioButton({
    required String title,
    required String gpValue,
    required String value,
    required Function onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            SizedBox(
              height: 15,
              width: 15,
              child: Radio(
                value: value,
                groupValue: gpValue,
                activeColor: AppColors.labelColor8,
                fillColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.labelColor8),
                onChanged: (value) {
                  onTap();
                },
              ),
            ),
            10.sp.sbw,
            _buildTextBoxTitle(title),
          ],
        ),
      ),
    );
  }

  CustomText _buildTextBoxTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w600,
      fontSize: 12.sp,
      color: AppColors.labelColor35,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  CustomText _buildTextBoxTitleCheckBox(String title) {
    return CustomText(
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      color: AppColors.labelColor35,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Container _buildTitleWithBlackBorderBox(
    String title,
  ) {
    return Container(
      padding: EdgeInsets.all(5.sp),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
            color: AppColors.black,
            text: title,
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: AppColors.labelColor37,
              text: _objectiveController.text,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildTitleWithWhiteLineBox(String title, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(2.sp))
          // border: Border.all(
          //   color: AppColors.labelColor,
          // ),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(5.sp),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.white,
              // border: Border.all(
              //   color: AppColors.labelColor,
              // ),
            ),
            child: CustomText(
              fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              color: AppColors.labelColor8,
              text: title,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          Divider(
            height: 1.sp,
            color: AppColors.labelColor,
            thickness: 1.sp,
          ),
          child
        ],
      ),
    );
  }

  Row _buildTopTimeLine() {
    return Row(
      children: [
        _buildBox(1, _currentIndex >= 1),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.labelColor31,
          ),
        ),
        _buildBox(2, _currentIndex >= 2),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.labelColor31,
          ),
        ),
        _buildBox(3, _currentIndex >= 3),
      ],
    );
  }

  Widget _buildBox(int title, bool isChecked) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_currentIndex == 1) {}
          if (_currentIndex == 2) {
            if (title == 1) {
              _currentIndex = title;
            }
          }
          if (_currentIndex == 3) {
            if (title == 1 || title == 2) {
              _currentIndex = title;
            }
          }
        });
      },
      child: Container(
        height: 35.sp,
        width: 35.sp,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.labelColor31,
          ),
          color: isChecked ? AppColors.labelColor8 : AppColors.labelColor33,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Center(
          child: CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: AppColors.labelColor19,
            text: title.toString(),
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
      ),
    );
  }
}
