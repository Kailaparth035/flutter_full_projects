import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/user_search_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_search_with_multiselect_dd.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TagPeopleAlertDialog extends StatefulWidget {
  const TagPeopleAlertDialog({
    super.key,
    required this.selectedUserList,
  });
  final List<Map<String, dynamic>> selectedUserList;
  @override
  State<TagPeopleAlertDialog> createState() => TagPeopleDialogState();
}

class TagPeopleDialogState extends State<TagPeopleAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isFirstSubmit = true;

  final _insightStreamController = Get.find<InsightStreamController>();

  List<OptionItemForMultiSelect> _userList = [];
  final List<OptionItemForMultiSelect> _selectedUserList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    for (var item in widget.selectedUserList) {
      _selectedUserList.add(OptionItemForMultiSelect(
          id: item['id'], title: item['title'], isChecked: item['isChecked']));
    }

    setState(() {});
  }

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
            isChecked: _selectedUserList
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
                  child: CustomSearchWithMultiSelectDD(
                    removeAllSelectedItem: () {},
                    labelText: "Select the users to tag",
                    isOneSelect: false,
                    isLoading: _isLoading,
                    _userList,
                    _selectedUserList,
                    fontSize: 12.sp,
                    borderColor: AppColors.labelColor,
                    bgColor: AppColors.labelColor12,
                    removeSelectedItem: (removedSelectedItemIndex) {
                      _checkingSelected(removedSelectedItemIndex);
                    },
                    (optionItemForMultiSelect) {
                      _checking(optionItemForMultiSelect);
                    },
                    callBack: (val) {
                      _searchUser(val);
                    },
                  ),
                ),
                10.sp.sbh,
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

  _checkingSelected(removedSelectedItemIndex) {
    var selectedItem = _selectedUserList[removedSelectedItemIndex];

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
      _selectedUserList.removeAt(removedSelectedItemIndex);
    } else {
      _selectedUserList.removeAt(removedSelectedItemIndex);
    }

    setState(() {});
  }

  _checking(List<OptionItemForMultiSelect> optionItemForMultiSelect) {
    List<OptionItemForMultiSelect> tempCheckedList =
        optionItemForMultiSelect.where((element) => element.isChecked).toList();

    for (var item in tempCheckedList) {
      bool isEmpty = _selectedUserList
          .where((e) => e.id.toString() == item.id.toString())
          .isEmpty;

      if (isEmpty) {
        _selectedUserList.add(item);
      }
    }

    var tempUnCheckedList = optionItemForMultiSelect
        .where((element) => element.isChecked == false)
        .toList();

    for (var item in tempUnCheckedList) {
      List unchecked = _selectedUserList
          .where((e) => e.id.toString() == item.id.toString())
          .toList();

      if (unchecked.isNotEmpty) {
        for (var item1 in unchecked) {
          int index = _selectedUserList.indexOf(item1);

          _selectedUserList.removeAt(index);
        }
      }
    }

    setState(() {});
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
            text: AppString.tagPeople,
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

  _sendMessage() async {
    Navigator.pop(context, _selectedUserList);
  }
}
