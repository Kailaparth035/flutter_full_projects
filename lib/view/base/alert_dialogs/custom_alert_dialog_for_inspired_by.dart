import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/user_search_list_model.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_search_with_multiselect_dd.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class InspiredByAlertDialog extends StatefulWidget {
  const InspiredByAlertDialog({
    super.key,
    required this.text,
    required this.isOtherUser,
    required this.selectedUserList,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isInspiredBy,
  });
  final String text;
  final bool isOtherUser;
  final List<Map<String, dynamic>> selectedUserList;
  final String firstName;
  final String lastName;
  final String email;
  final bool isInspiredBy;
  @override
  State<InspiredByAlertDialog> createState() => InspiredByAlertDialogState();
}

class InspiredByAlertDialogState extends State<InspiredByAlertDialog> {
  final _insightStreamController = Get.find<InsightStreamController>();
  List<OptionItemForMultiSelect> _userList = [];
  List<OptionItemForMultiSelect> _selectedUserListLocal = [];

  final TextEditingController _msgTextController = TextEditingController();
  final TextEditingController _fnameTextController = TextEditingController();
  final TextEditingController _mnameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFirstSubmit = true;

  bool _isSearchView = true;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    _isSearchView = !widget.isOtherUser;
    _msgTextController.text = widget.text;

    for (var item in widget.selectedUserList) {
      _selectedUserListLocal.add(OptionItemForMultiSelect(
          id: item['id'], title: item['title'], isChecked: item['isChecked']));
    }

    if (widget.isOtherUser) {
      _fnameTextController.text = widget.firstName;
      _mnameTextController.text = widget.lastName;
      _emailTextController.text = widget.email;
    }
    setState(() {});
  }

  // @override
  // void dispose() {
  //   _selectedUserListLocal = [];
  //   super.dispose();
  // }

  bool _isLoading = false;

  _searchUser(String search) async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<PeopleUserData> searchList =
          await _insightStreamController.getPeopleUserList(search);

      _userList = [];
      final List<OptionItemForMultiSelect> tempList = [];

      for (var item in searchList) {
        tempList.add(
          OptionItemForMultiSelect(
            id: item.id.toString(),
            title: item.name.toString(),
            isChecked: _selectedUserListLocal
                .where((element) => element.id.toString() == item.id.toString())
                .isNotEmpty,
          ),
        );
      }
      if (mounted) {
        setState(() {
          _userList = tempList;
        });
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 0.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        width: 100.w,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: !_isFirstSubmit
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                10.sp.sbh,
                _buildTitle(),
                10.sp.sbh,
                Divider(
                  height: 1.sp,
                  color: AppColors.labelColor,
                  thickness: 1,
                ),
                10.sp.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                  child: CustomTextFormFieldForMessage(
                    borderColor: AppColors.labelColor9.withOpacity(0.2),
                    inputAction: TextInputAction.done,
                    labelText: widget.isInspiredBy
                        ? AppString.howDidThey
                        : AppString.describeARecent,
                    inputType: TextInputType.text,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    lineCount: 4,
                    validator: Validation().requiredFieldValidation,
                    editColor: AppColors.labelColor12,
                    textEditingController: _msgTextController,
                  ),
                ),
                10.sp.sbh,
                _isSearchView
                    ? _buildWhoinpiredBox()
                    : _buildMultiTextBoxView(),
                15.sp.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButton2(
                          buttonText: AppString.close,
                          buttonColor: AppColors.primaryColor,
                          radius: 5.sp,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.sp, horizontal: 13.sp),
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      5.sp.sbw,
                      CustomButton2(
                          buttonText: AppString.done,
                          radius: 5.sp,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.sp, horizontal: 13.sp),
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          onPressed: () {
                            setState(() {
                              _isFirstSubmit = false;
                            });
                            if (_formKey.currentState!.validate()) {
                              _sendMessage();
                            }
                          })
                    ],
                  ),
                ),
                10.sp.sbh,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildMultiTextBoxView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
          child: CustomText(
            fontWeight: FontWeight.w400,
            fontSize: 9.sp,
            color: AppColors.black,
            text: AppString.ifYouHaveNot,
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
        10.sp.sbh,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
          child: CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor9.withOpacity(0.2),
            inputAction: TextInputAction.done,
            labelText: AppString.firstName,
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            lineCount: 1,
            validator: Validation().requiredFieldValidation,
            editColor: AppColors.labelColor12,
            textEditingController: _fnameTextController,
          ),
        ),
        10.sp.sbh,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
          child: CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor9.withOpacity(0.2),
            inputAction: TextInputAction.done,
            labelText: AppString.middlename,
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            lineCount: 1,
            validator: Validation().requiredFieldValidation,
            editColor: AppColors.labelColor12,
            textEditingController: _mnameTextController,
          ),
        ),
        10.sp.sbh,
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
          child: CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor9.withOpacity(0.2),
            inputAction: TextInputAction.done,
            labelText: AppString.email,
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            lineCount: 1,
            validator: Validation().emailValidation,
            editColor: AppColors.labelColor12,
            textEditingController: _emailTextController,
          ),
        ),
        10.sp.sbh,
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 8.sp,
          color: AppColors.black,
          text: AppString.or,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        2.sp.sbh,
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isSearchView = !_isSearchView;
                    });
                  },
                  child: Text(
                    AppString.backToSearch,
                    style: TextStyle(
                      fontSize: 8.sp,
                      decoration: TextDecoration.underline,
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column _buildWhoinpiredBox() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
          child: CustomSearchWithMultiSelectDD(
              labelText: widget.isInspiredBy
                  ? "Who has inspired you?"
                  : "Tag the people for your pivotal moment",
              isOneSelect: true,
              isLoading: _isLoading,
              _userList,
              _selectedUserListLocal,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              removeSelectedItem: (removedSelectedItemIndex) {
            _checkingSelected(removedSelectedItemIndex);
          }, (optionItemForMultiSelect) {
            _listCheckUncheck(optionItemForMultiSelect);
          }, callBack: (val) {
            _searchUser(val);
          }, removeAllSelectedItem: () {
            _selectedUserListLocal = [];

            setState(() {});
          }),
        ),
        10.sp.sbh,
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 8.sp,
          color: AppColors.black,
          text: AppString.or,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        2.sp.sbh,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: AppString.ifTheUser,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ),
              TextSpan(
                text: AppString.notifyThemHere,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => setState(() {
                        _isSearchView = !_isSearchView;
                      }),
                style: TextStyle(
                  fontSize: 8.sp,
                  decoration: TextDecoration.underline,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: widget.isInspiredBy
                ? AppString.inspiredBy
                : AppString.pivotalMoments,
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
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

  _checkingSelected(removedSelectedItemIndex) {
    var selectedItem = _selectedUserListLocal[removedSelectedItemIndex];
    var list1 = _userList
        .where((element) => element.id.toString() == selectedItem.id)
        .toList();

    if (list1.isNotEmpty) {
      int index = _userList.indexOf(list1.first);
      var itemToStore = OptionItemForMultiSelect(
          id: _userList[index].id,
          title: _userList[index].title,
          isChecked: false);

      _userList[index] = itemToStore;
      _selectedUserListLocal.removeAt(removedSelectedItemIndex);
    } else {
      _selectedUserListLocal.removeAt(removedSelectedItemIndex);
    }

    setState(() {});
  }

  _listCheckUncheck(List<OptionItemForMultiSelect> optionItemForMultiSelect) {
    List<OptionItemForMultiSelect> tempCheckedList =
        optionItemForMultiSelect.where((element) => element.isChecked).toList();

    for (var item in tempCheckedList) {
      bool isEmpty = _selectedUserListLocal
          .where((e) => e.id.toString() == item.id.toString())
          .isEmpty;

      if (isEmpty) {
        _selectedUserListLocal.add(item);
      }
    }

    var tempUnCheckedList = optionItemForMultiSelect
        .where((element) => element.isChecked == false)
        .toList();

    for (var item in tempUnCheckedList) {
      List unchecked = _selectedUserListLocal
          .where((e) => e.id.toString() == item.id.toString())
          .toList();

      if (unchecked.isNotEmpty) {
        for (var item1 in unchecked) {
          int index = _selectedUserListLocal.indexOf(item1);

          _selectedUserListLocal.removeAt(index);
        }
      }
    }

    setState(() {});
  }

  _sendMessage() async {
    // if (_isSearchView) {
    //   if (_selectedUserListLocal.isEmpty) {
    //     showCustomSnackBar("Please select user.");
    //     return;
    //   }
    // }

    var data = {
      "is_current_user": _isSearchView ? true : false,
      "msg": _msgTextController.text,
      "data": _isSearchView
          ? _selectedUserListLocal
          : {
              "fname": _fnameTextController.text,
              "lname": _mnameTextController.text,
              "email": _emailTextController.text
            }
    };

    Navigator.pop(context, data);
  }
}
