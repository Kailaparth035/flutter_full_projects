import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/manage_follower_model.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_multi_select_dropdown.dart';
import 'package:aspirevue/view/base/custom_slider.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/radio_button_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ManageFollowerScreen extends StatefulWidget {
  const ManageFollowerScreen(
      {super.key,
      required this.goalId,
      required this.type,
      required this.styleId,
      required this.areaId,
      required this.userId});
  final String goalId;
  final String type;
  final String styleId;
  final String userId;
  final String areaId;
  @override
  State<ManageFollowerScreen> createState() => _ManageFollowerScreenState();
}

class _ManageFollowerScreenState extends State<ManageFollowerScreen> {
  final _myGoalController = Get.find<MyGoalController>();

  final TextEditingController _repeatTextController = TextEditingController();
  final TextEditingController _endOnTextController = TextEditingController();
  final TextEditingController _afterCountTextController =
      TextEditingController();

  final OptionItemForMultiSelect _selectInternalFollwerValue =
      OptionItemForMultiSelect(
          id: null, title: AppString.selectOption, isChecked: false);
  List<OptionItemForMultiSelect> _selectInternalFollwerList = [];

  final OptionItemForMultiSelect _selectExternalFollwerValue =
      OptionItemForMultiSelect(
          id: null, title: AppString.selectOption, isChecked: true);
  List<OptionItemForMultiSelect> _selectExternalFollwerList = [];

  final List<String> _ddList = [
    'Day',
    'Week',
    'Month',
    'Year',
  ];

  String _ddValue = "Week";

  // all storing variables
  String _followerTypeRB = "1";
  String _endTypeRB = "never";

  // list of first name last name
  final List<UserDetailsModel> _userDetailList = [];

  List<FollowerList> _followerList = [];
  bool _selectAllFollower = false;

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;

  ManageFollowerData? _manageFollowersData;

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  List<DropDownOptionItemMenu> repeatOnDropDownList = [];

  DropDownOptionItemMenu repeatOnDropDownValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  @override
  void initState() {
    super.initState();
    _reFreshData(true);
  }

  _reFreshData(bool isShowLoading) async {
    if (isShowLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    Map<String, dynamic> map = {
      "id": widget.goalId.toString(),
      "user_id": widget.userId.toString(),
      "Goal_type": widget.type.toString(),
      "style_id": widget.styleId.toString(),
    };
    try {
      var data = await _myGoalController.getGoalFeedback(map);

      await loadData(data);

      setState(() {
        _manageFollowersData = data;
        _isError = false;
        _errorMsg = "";
      });
    } catch (e) {
      setState(() {
        _isError = true;
        String error = CommonController().getValidErrorMessage(e.toString());
        _errorMsg = error.toString();
      });
    } finally {
      if (isShowLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _pickDate() async {
    var date = await CommonController().pickDate(context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (date != null) {
      setState(() {
        _endOnTextController.text = date;
      });
    }
  }

  _addUserDetailIntoList() {
    var data = UserDetailsModel(
        id: null,
        firstTextController: TextEditingController(),
        lastTextController: TextEditingController(),
        emailTextController: TextEditingController());
    setState(() {
      _userDetailList.add(data);
    });
  }

  loadData(ManageFollowerData data) {
    _selectInternalFollwerList = [];

    for (var item in data.internalFollowers!) {
      _selectInternalFollwerList.add(
        OptionItemForMultiSelect(
          id: item.id.toString(),
          title: item.name.toString(),
          isChecked: false,
        ),
      );
    }

    _selectExternalFollwerList = [];

    for (var item in data.externalFollowers!) {
      _selectExternalFollwerList.add(
        OptionItemForMultiSelect(
            id: item.id.toString(),
            title: item.name.toString(),
            isChecked: false),
      );
    }

    repeatOnDropDownList = [];
    for (var item in data.monthType!) {
      repeatOnDropDownList.add(
        DropDownOptionItemMenu(
          id: item.value.toString(),
          title: item.title.toString(),
        ),
      );
    }

    var selectedItem =
        data.monthType!.where((element) => element.checked == 1).toList();
    if (selectedItem.isNotEmpty) {
      repeatOnDropDownValue = DropDownOptionItemMenu(
        id: selectedItem.first.value.toString(),
        title: selectedItem.first.title.toString(),
      );
    }

    _followerList = [];

    _followerList = data.followerList!;
    _selectAllFollower =
        _followerList.every((element) => element.isCheck == true);

    _repeatTextController.text = data.repeatEvery.toString();

    _repeatTextController.text = data.repeatEvery.toString();
    if (data.repeatDuration != "") {
      _ddValue = data.repeatDuration.toString().capitalizeFirstLatter();
    }

    _endTypeRB = data.endType.toString();

    if (_endTypeRB == "date") {
      _endOnTextController.text = data.endTypeValue.toString();
    } else {
      _afterCountTextController.text = data.endTypeValue.toString();
    }

    if (data.roleId == 9) {
      _followerTypeRB = "2";
    }

    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: AppString.goal,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: GestureDetector(
          onTap: () {
            CommonController.hideKeyboard(context);
          },
          child: SizedBox(
            width: context.width,
            height: context.height,
            child: _isLoading
                ? const Center(child: CustomLoadingWidget())
                : _isError
                    ? CustomErrorWidget(
                        onRetry: () {
                          _reFreshData(true);
                        },
                        text: _errorMsg)
                    : _buildMainView(_manageFollowersData!),
          ),
        ),
      ),
    );
  }

  Widget _buildMainView(ManageFollowerData data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainTitle(),
            20.sp.sbh,
            10.sp.sbh,
            _buildAddFollwers(data.roleId),
            10.sp.sbh,
            _buildTitle(AppString.selectFollowers),
            5.sp.sbh,
            _followerTypeRB == "1"
                ? CustomMultipleDropListShowListOnTopWidget(
                    _selectInternalFollwerValue.title,
                    _selectInternalFollwerValue,
                    _selectInternalFollwerList,
                    fontSize: 12.sp,
                    borderColor: AppColors.labelColor,
                    bgColor: AppColors.labelColor12,
                    (optionItemForMultiSelect) {
                      _selectInternalFollwerList = optionItemForMultiSelect;
                      setState(() {});
                    },
                  )
                : 0.sp.sbh,
            _followerTypeRB == "2"
                ? CustomMultipleDropListShowListOnTopWidget(
                    _selectExternalFollwerValue.title,
                    _selectExternalFollwerValue,
                    _selectExternalFollwerList,
                    fontSize: 12.sp,
                    borderColor: AppColors.labelColor,
                    bgColor: AppColors.labelColor12,
                    (optionItemForMultiSelect) {
                      _selectExternalFollwerList = optionItemForMultiSelect;
                      setState(() {});
                    },
                  )
                : 0.sp.sbh,
            10.sp.sbh,
            Form(
              key: _formKey,
              // autovalidateMode: !isFirstSubmit
              //     ? AutovalidateMode.always
              //     : AutovalidateMode.disabled,
              child: Column(
                children: _userDetailList
                    .map(
                      (e) => _buildNameDetails(e),
                    )
                    .toList(),
              ),
            ),
            _buildAddAndSaveButton(),
            15.sp.sbh,
            _buildHeaderOfTable(),
            ..._followerList.map((e) => _buildListTileOfTable(e)),
            15.sp.sbh,
            data.gatherFeedbackScoreDisplay == 1
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(AppString.followerReputationPulseScore),
                      10.sp.sbh,
                      CustomSlider(
                        percent: CommonController.getSliderValue(
                            data.gatherFeedbackScore.toString()),
                        isEditable: false,
                      ),
                    ],
                  )
                : 0.sbh,
            10.sp.sbh,
            _buildTitle(AppString.reputationPulseCadence),
            const Divider(
              color: AppColors.labelColor9,
              thickness: 0.5,
            ),
            10.sp.sbh,
            _buildReapetEvery(),
            10.sp.sbh,
            _ddValue == "Week" || _ddValue == "Month"
                ? _buildDayCheckbox()
                : 0.sbh,
            CustomText(
              text: AppString.ends,
              textAlign: TextAlign.start,
              color: AppColors.labelColor14,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 14.sp,
              maxLine: 5,
              fontWeight: FontWeight.w500,
            ),
            10.sp.sbh,
            _buildEndWidget(),
            15.sp.sbh,
            _buildGatherAndDeleteBtn(),
            10.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildDayCheckbox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppString.reapetOn,
          textAlign: TextAlign.start,
          color: AppColors.labelColor14,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 14.sp,
          maxLine: 5,
          fontWeight: FontWeight.w500,
        ),
        10.sp.sbh,
        _ddValue == "Week"
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenHorizontalPadding),
                child: Wrap(
                  runSpacing: 7.sp,
                  spacing: 7.sp,
                  direction: Axis.horizontal,
                  children: [
                    ..._manageFollowersData!.weekDay!.map(
                      (e) {
                        int index = _manageFollowersData!.weekDay!.indexOf(e);
                        return _buildCheckboxWithTitle(index);
                      },
                    )
                  ],
                ),
              )
            : CustomDropListForMessageTwo(
                repeatOnDropDownValue.title,
                repeatOnDropDownValue,
                repeatOnDropDownList,
                fontSize: 12.sp,
                borderColor: AppColors.labelColor,
                bgColor: AppColors.labelColor12,
                (optionItemForMultiSelect1) {
                  setState(() {
                    repeatOnDropDownValue = optionItemForMultiSelect1;
                  });
                },
              ),
        10.sp.sbh,
      ],
    );
  }

  Widget _buildCheckboxWithTitle(int index) {
    return InkWell(
      onTap: () {
        bool valueToUpdate = _manageFollowersData!.weekDay![index].checked == 1;
        setState(() {
          _manageFollowersData!.weekDay![index].checked = valueToUpdate ? 0 : 1;
        });
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
              isChecked: _manageFollowersData!.weekDay![index].checked == 1,
              onTap: () {
                bool valueToUpdate0 =
                    _manageFollowersData!.weekDay![index].checked == 1;
                setState(() {
                  _manageFollowersData!.weekDay![index].checked =
                      valueToUpdate0 ? 0 : 1;
                });
              },
            ),
            5.sp.sbw,
            Expanded(
              child: _buildTextBoxTitleCheckBox(
                  _manageFollowersData!.weekDay![index].value.toString()),
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
      color: AppColors.labelColor20,
      text: title,
      maxLine: 3,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  IntrinsicHeight _buildEndWidget() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildRadioButton(
                    title: AppString.never,
                    gpValue: _endTypeRB,
                    value: "never",
                    onTap: () {
                      setState(() {
                        _endTypeRB = "never";
                      });
                    }),
                20.sp.sbh,
                _buildRadioButton(
                    title: AppString.on,
                    gpValue: _endTypeRB,
                    value: "date",
                    onTap: () {
                      setState(() {
                        _endTypeRB = "date";
                      });
                    }),
                20.sp.sbh,
                _buildRadioButton(
                    title: AppString.after,
                    gpValue: _endTypeRB,
                    value: "occurence",
                    onTap: () {
                      setState(() {
                        _endTypeRB = "occurence";
                      });
                    }),
                10.sp.sbh,
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomTextFormFieldForMessage(
                  borderColor: AppColors.labelColor,
                  inputAction: TextInputAction.done,
                  labelText: AppString.selectDate,
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  isReadOnly: true,
                  onTap: () {
                    _pickDate();
                  },
                  lineCount: 1,
                  editColor: AppColors.labelColor12,
                  textEditingController: _endOnTextController,
                ),
                5.sp.sbh,
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.labelColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.sp),
                      bottomLeft: Radius.circular(5.sp),
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormFieldForMessage(
                            borderColor: AppColors.labelColor,
                            inputAction: TextInputAction.done,
                            labelText: "",
                            inputType: TextInputType.number,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 12.sp,
                            lineCount: 1,
                            textAlignment: TextAlign.center,
                            editColor: AppColors.labelColor12,
                            onEditingComplete: () {
                              CommonController.hideKeyboard(context);
                            },
                            textEditingController: _afterCountTextController,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            child: Center(
                              child: CustomText(
                                text: AppString.occurrences,
                                textAlign: TextAlign.start,
                                color: AppColors.labelColor35,
                                fontFamily: AppString.manropeFontFamily,
                                fontSize: 10.sp,
                                maxLine: 1,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReapetEvery() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomText(
            text: AppString.repeatevery,
            textAlign: TextAlign.start,
            color: AppColors.labelColor14,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 14.sp,
            maxLine: 5,
            fontWeight: FontWeight.w500,
          ),
          Expanded(
            child: CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "",
              inputType: TextInputType.number,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 1,
              textAlignment: TextAlign.center,
              editColor: AppColors.labelColor12,
              textEditingController: _repeatTextController,
            ),
          ),
          5.sp.sbw,
          Expanded(
            child: _buildDD(),
          ),
        ],
      ),
    );
  }

  Container _buildDD() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor,
        ),
        color: AppColors.labelColor12,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
      child: Align(
        alignment: Alignment.centerRight,
        child: DropdownButton(
          menuMaxHeight: 300,
          underline: 0.sbh,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: 12.sp,
            color: AppColors.black,
          ),
          isDense: true,
          value: _ddValue,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 14.sp,
            color: AppColors.labelColor53,
          ),
          items: _ddList.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _ddValue = newValue.toString();
            });
          },
        ),
      ),
    );
  }

  _selectCheckbox(int index, bool valueToUpdate) {
    setState(() {
      _followerList[index].isCheck = valueToUpdate;
    });

    if (_followerList.every((element) => element.isCheck == true)) {
      setState(() {
        _selectAllFollower = true;
      });
    } else {
      setState(() {
        _selectAllFollower = false;
      });
    }
    {}
  }

  _toggleAllFollowerCheckbox(bool valueToUpdate) {
    _selectAllFollower = valueToUpdate;

    for (var item in _followerList) {
      int index = _followerList.indexOf(item);
      _followerList[index].isCheck = valueToUpdate;
    }

    setState(() {});
  }

  Widget _buildListTileOfTable(FollowerList follower) {
    int index = _followerList.indexOf(follower);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 30.sp,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.labelColor8),
                bottom: BorderSide(color: AppColors.labelColor8),
                right: BorderSide(color: AppColors.labelColor8),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                5.sp.sbh,
                CustomCheckBox(
                  borderColor: AppColors.labelColor8,
                  fillColor: AppColors.labelColor8,
                  isChecked: _followerList[index].isCheck!,
                  onTap: () {
                    _selectCheckbox(index, !_followerList[index].isCheck!);
                  },
                ),
                5.sp.sbh,
                InkWell(
                  onTap: () {
                    _removeFollower(_followerList[index].id.toString());
                  },
                  child: Image.asset(
                    AppImages.deleteRedIc,
                    height: 14.sp,
                  ),
                ),
                5.sp.sbh,
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 30.sp,
              padding: EdgeInsets.all(5.sp),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.labelColor8),
                  right: BorderSide(color: AppColors.labelColor8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTitleAndValue(AppString.firstName1,
                            _followerList[index].firstName.toString()),
                      ),
                      Expanded(
                        child: _buildTitleAndValue(AppString.lastName1,
                            _followerList[index].lastName.toString()),
                      )
                    ],
                  ),
                  3.sp.sbh,
                  _buildTitleAndValue(
                      AppString.email1, _followerList[index].email.toString()),
                ],
              ),
            ),
          )
        ],
      ),
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

  Row _buildHeaderOfTable() {
    return Row(
      children: [
        Container(
          height: 30.sp,
          width: 30.sp,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.labelColor8,
            ),
          ),
          child: Center(
            child: CustomCheckBox(
              borderColor: AppColors.labelColor8,
              fillColor: AppColors.labelColor8,
              isChecked: _selectAllFollower,
              onTap: () {
                _toggleAllFollowerCheckbox(!_selectAllFollower);
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 30.sp,
            width: 30.sp,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.labelColor8),
                bottom: BorderSide(color: AppColors.labelColor8),
                right: BorderSide(color: AppColors.labelColor8),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 5.sp),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildTitle(AppString.followersList),
              ),
            ),
          ),
        )
      ],
    );
  }

  Row _buildGatherAndDeleteBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton2(
          buttonText: AppString.gatherFeedback,
          radius: 5.sp,
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
          onPressed: () {
            _gatherFeedback();
          },
        ),
        10.sp.sbw,
        CustomButton2(
            buttonText: AppString.deleteEvent,
            radius: 5.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            onPressed: () {
              _deleteEvent();
            })
      ],
    );
  }

  Row _buildAddAndSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _followerTypeRB == "2"
            ? CustomButton2(
                icon: AppImages.plusRountedIc,
                buttonText: AppString.addMore,
                radius: 5.sp,
                padding: EdgeInsets.symmetric(
                    vertical: 5.sp,
                    horizontal: AppConstants.screenHorizontalPadding),
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                onPressed: () {
                  _addUserDetailIntoList();
                })
            : 0.sbh,
        10.sp.sbw,
        CustomButton2(
            buttonText: AppString.save,
            radius: 5.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 20.sp),
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            onPressed: () {
              _saveFollower();
            })
      ],
    );
  }

  Widget _buildNameDetails(UserDetailsModel userDetails) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.labelColor,
            borderRadius: BorderRadius.circular(5.sp),
          ),
          padding: EdgeInsets.all(10.sp),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _userDetailList.remove(userDetails);
                    });
                  },
                  child: Icon(
                    Icons.close,
                    size: 15.sp,
                  ),
                ),
              ),
              10.sp.sbh,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomTextFormFieldForMessage(
                      borderColor: AppColors.labelColor,
                      inputAction: TextInputAction.done,
                      labelText: AppString.enterFirstName,
                      validator: Validation().requiredFieldValidation,
                      inputType: TextInputType.text,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 12.sp,
                      lineCount: 1,
                      editColor: AppColors.labelColor12,
                      textEditingController: userDetails.firstTextController,
                    ),
                  ),
                  10.sp.sbw,
                  Expanded(
                    child: CustomTextFormFieldForMessage(
                        borderColor: AppColors.labelColor,
                        inputAction: TextInputAction.done,
                        labelText: AppString.enterLastName,
                        validator: Validation().requiredFieldValidation,
                        inputType: TextInputType.text,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        lineCount: 1,
                        editColor: AppColors.labelColor12,
                        textEditingController: userDetails.lastTextController),
                  ),
                ],
              ),
              10.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                validator: Validation().emailValidation,
                labelText: AppString.enterEmail,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 1,
                editColor: AppColors.labelColor12,
                textEditingController: userDetails.emailTextController,
              )
            ],
          ),
        ),
        10.sp.sbh,
      ],
    );
  }

  _buildTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor14,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      maxLine: 5,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildAddFollwers(int? roleID) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: AppString.addFollowers,
          textAlign: TextAlign.start,
          color: AppColors.labelColor14,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 14.sp,
          maxLine: 5,
          fontWeight: FontWeight.w600,
        ),
        10.sp.sbw,
        roleID == 9
            ? 0.sbh
            : Expanded(
                flex: 1,
                child: _buildRadioButton(
                    title: AppString.internal,
                    gpValue: _followerTypeRB,
                    value: "1",
                    onTap: () {
                      setState(() {
                        _followerTypeRB = "1";
                      });
                    }),
              ),
        Expanded(
          flex: 1,
          child: _buildRadioButton(
              title: AppString.external,
              gpValue: _followerTypeRB,
              value: "2",
              onTap: () {
                setState(() {
                  _followerTypeRB = "2";
                });
              }),
        )
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
      padding: EdgeInsets.only(bottom: 0.sp),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RadioButtonWidget(value: value, gpValue: gpValue, onTap: onTap),
            // SizedBox(
            //   height: 15,
            //   width: 15,
            //   child: Radio(
            //     value: value,
            //     groupValue: gpValue,
            //     activeColor: AppColors.labelColor8,
            //     fillColor: MaterialStateColor.resolveWith(
            //         (states) => AppColors.labelColor8),
            //     onChanged: (value) {
            //       onTap();
            //     },
            //   ),
            // ),
            7.sp.sbw,
            Expanded(
              child: CustomText(
                text: title,
                textAlign: TextAlign.start,
                color: AppColors.labelColor20,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                maxLine: 5,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  CustomText _buildMainTitle() {
    return CustomText(
      text: AppString.manageFollowers,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _saveFollower() async {
    String follwerListId = "";
    // validation
    if (_followerTypeRB == "1") {
      List<OptionItemForMultiSelect> internalFollwerLsit =
          _selectInternalFollwerList
              .where((element) => element.isChecked == true)
              .toList();

      if (internalFollwerLsit.isEmpty) {
        return showCustomSnackBar(AppString.pleaseSelectInternalFollower);
      } else {
        follwerListId = internalFollwerLsit.map((e) => e.id).join(",");
      }
    } else {
      if (_userDetailList.isNotEmpty) {
        if (!_formKey.currentState!.validate()) {
          setState(() {
            isFirstSubmit = false;
          });
          return;
        }
      } else {
        List<OptionItemForMultiSelect> externalFollower =
            _selectExternalFollwerList
                .where((element) => element.isChecked == true)
                .toList();

        if (externalFollower.isEmpty) {
          return showCustomSnackBar(AppString.pleaseSelectExternalFollower);
        } else {
          follwerListId = externalFollower.map((e) => e.id).join(",");
        }
      }
    }

    debugPrint("====> save details ===========================");

    List listOfNewUser = [];

    for (var item in _userDetailList) {
      var newUser = {
        "first_name": item.firstTextController.text,
        "last_name": item.lastTextController.text,
        "email": item.emailTextController.text,
      };

      listOfNewUser.add(newUser);
    }

    if (kDebugMode) {
      print(follwerListId);
    }
    Map<String, dynamic> map = {
      "id": widget.goalId,
      "user_id": widget.userId,
      "Goal_type": widget.type,
      "style_id": widget.styleId,
      "feedback_type": _followerTypeRB,
      "followers": follwerListId,
      "area_id": widget.areaId,
      "peer": listOfNewUser
    };

    try {
      buildLoading(Get.context!);

      var response = await _myGoalController.saveFollowers(map);
      if (response.isSuccess == true) {
        await _reFreshData(false);
        showCustomSnackBar(response.message, isError: false);
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

  _removeFollower(String followerId) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areyousureyouwanttoremove,
        );
      },
    );

    if (res != null) {
      Map<String, dynamic> map = {
        "id": widget.goalId.toString(),
        "user_id": widget.userId.toString(),
        "Goal_type": widget.type.toString(),
        "style_id": widget.styleId.toString(),
        "follower_id": followerId
      };

      try {
        // ignore: use_build_context_synchronously
        buildLoading(context);

        var response = await _myGoalController.deleteFollowers(map);
        if (response.isSuccess == true) {
          await _reFreshData(false);
          showCustomSnackBar(response.message, isError: false);
        } else {
          showCustomSnackBar(response.message);
        }
      } catch (e) {
        String error = CommonController().getValidErrorMessage(e.toString());
        showCustomSnackBar(error.toString());
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  _gatherFeedback() async {
    // validations

    if (!_followerList.any((element) => element.isCheck == true)) {
      showCustomSnackBar(AppString.pleaseSelectAnyFollowers);
      return;
    }
    if (_repeatTextController.text.isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterRepeateveryNumber);
      return;
    }
    if (_endTypeRB == "date") {
      if (_endOnTextController.text.isEmpty) {
        showCustomSnackBar(AppString.pleaseSelectEndDate);
        return;
      }
    } else if (_endTypeRB == "occurence") {
      if (_afterCountTextController.text.isEmpty) {
        showCustomSnackBar(AppString.pleaseEnterAfterOccurrencesNumber);
        return;
      }
    }

    // ==========================================
    var followeIds = _followerList
        .where((element) => element.isCheck == true)
        .map((e) => e.id)
        .join(",");

    var weekdays = _manageFollowersData!.weekDay!
        .where((element) => element.checked == 1)
        .map((e) => e.value)
        .join(",");
    Map<String, dynamic> map = {
      "id": widget.goalId,
      "user_id": widget.userId,
      "Goal_type": widget.type,
      "style_id": widget.styleId,
      "area_id": widget.areaId,
      "follower_id": followeIds,
      "repeat_every": _repeatTextController.text,
      "repeat_duration": _ddValue.lowercaseFirstLatter(),
      "week_day": weekdays,
      "month_type": repeatOnDropDownValue.id ?? "",
      "end_type": _endTypeRB,
      "end_date": _endOnTextController.text,
      "end_occurence": _afterCountTextController.text
    };

    try {
      buildLoading(context);

      var response = await _myGoalController.saveGatherFeedback(map);
      if (response.isSuccess == true) {
        // await _reFreshData(false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!, true);
    }
  }

  _deleteEvent() async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areyousureyouwanttodeleteEvent,
        );
      },
    );

    if (res != null) {
      Map<String, dynamic> map = {
        "id": widget.goalId.toString(),
        "user_id": widget.userId.toString(),
        "Goal_type": widget.type.toString(),
        "style_id": widget.styleId.toString(),
      };

      try {
        // ignore: use_build_context_synchronously
        buildLoading(context);
        var response = await _myGoalController.deleteEvent(map);
        if (response.isSuccess == true) {
          showCustomSnackBar(response.message, isError: false);
        } else {
          showCustomSnackBar(response.message);
        }
      } catch (e) {
        String error = CommonController().getValidErrorMessage(e.toString());
        showCustomSnackBar(error.toString());
      } finally {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      }
    }
  }
}

class UserDetailsModel {
  String? id;
  TextEditingController firstTextController;
  TextEditingController lastTextController;
  TextEditingController emailTextController;

  UserDetailsModel({
    required this.id,
    required this.firstTextController,
    required this.lastTextController,
    required this.emailTextController,
  });
}
