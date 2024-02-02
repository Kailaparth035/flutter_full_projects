import 'dart:async';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomSearchWithMultiSelectDD extends StatefulWidget {
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;

  final List<OptionItemForMultiSelect> list;
  final List<OptionItemForMultiSelect> selectedUserList;
  final Function(List<OptionItemForMultiSelect> optionItem) onOptionSelected;
  final Function(String) callBack;
  final Function(int) removeSelectedItem;
  final Function removeAllSelectedItem;

  final bool isLoading;
  final String labelText;
  final bool isOneSelect;
  const CustomSearchWithMultiSelectDD(
      this.list, this.selectedUserList, this.onOptionSelected,
      {super.key,
      this.bgColor,
      this.borderColor,
      this.fontSize,
      required this.callBack,
      required this.isOneSelect,
      required this.removeSelectedItem,
      required this.removeAllSelectedItem,
      required this.isLoading,
      required this.labelText});

  @override
  // ignore: library_private_types_in_public_api
  _CustomSearchWithMultiSelectDDState createState() =>
      // ignore: no_logic_in_create_state
      _CustomSearchWithMultiSelectDDState();
}

class _CustomSearchWithMultiSelectDDState
    extends State<CustomSearchWithMultiSelectDD>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchTextController = TextEditingController();

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;
  bool isInitial = true;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (isShow) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  Timer? searchOnStoppedTyping;

  onChangeHandler(value) {
    const duration = Duration(milliseconds: 800);

    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel());
    }

    setState(() => searchOnStoppedTyping = Timer(duration, () {
          if (isShow == false) {
            setState(() {
              isShow = true;
            });
            _runExpandCheck();
          }

          widget.callBack(_searchTextController.text);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: widget.borderColor ??
                      AppColors.labelColor9.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 0.sp),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 30.sp,
                          child: CustomTextFormFieldForMessage(
                              borderColor: Colors.transparent,
                              inputAction: TextInputAction.done,
                              labelText: widget.labelText,
                              inputType: TextInputType.text,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 12.sp,
                              editColor: Colors.transparent,
                              textEditingController: _searchTextController,
                              onChanged: (val) {
                                onChangeHandler(val);
                              },
                              onTapSufixIcon: () {
                                isShow = !isShow;
                                _runExpandCheck();
                                setState(() {});
                              },
                              sufixIcon: !isShow
                                  ? Icons.keyboard_arrow_right
                                  : Icons.keyboard_arrow_down),
                        ),
                      ),
                    ],
                  ),
                  widget.selectedUserList.isEmpty ? 0.sbh : 5.sp.sbh,
                  Padding(
                    padding: EdgeInsets.all(
                        widget.selectedUserList.isEmpty ? 0.sp : 5.sp),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: widget.selectedUserList.isEmpty
                              ? 0.sbh
                              : Wrap(
                                  spacing: 2.sp,
                                  runSpacing: 5.sp,
                                  children: [
                                    ...widget.selectedUserList.map((e) {
                                      if (e.isChecked) {
                                        return _buildDeleteUserTile(e);
                                      } else {
                                        return 0.sbh;
                                      }
                                    }),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  padding: EdgeInsets.only(bottom: 1.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.sp),
                        bottomRight: Radius.circular(5.sp)),
                    color: AppColors.backgroundColor1,
                  ),
                  child: widget.isLoading
                      ? const Center(
                          child: CustomLoadingWidget(),
                        )
                      : _buildDropListOptions(widget.list, context))),
        ],
      ),
    );
  }

  Container _buildDeleteUserTile(OptionItemForMultiSelect data) {
    return Container(
      margin: EdgeInsets.only(top: 0.sp),
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 3.sp),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(3.sp),
        border: Border.all(
            color:
                widget.borderColor ?? AppColors.labelColor9.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              var index = widget.selectedUserList.indexOf(data);
              widget.removeSelectedItem(index);
            },
            child: Icon(
              Icons.close,
              size: 15.sp,
              color: AppColors.redColor,
            ),
          ),
          5.sp.sbw,
          Expanded(
            child: CustomText(
              text: data.title,
              textAlign: TextAlign.start,
              color: AppColors.labelColor9,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropListOptions(
      List<OptionItemForMultiSelect> items, BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 40.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _searchTextController.text.isNotEmpty && items.isEmpty
                ? Padding(
                    padding: EdgeInsets.all(5.sp),
                    child: const Center(child: Text("No data found!")),
                  )
                : 0.sbh,
            ...items.map((item) => _buildSubMenu(item, context, items))
          ],
        ),
      ),
    );
  }

  Widget _buildSubMenu(OptionItemForMultiSelect item, BuildContext context,
      List<OptionItemForMultiSelect> items) {
    return GestureDetector(
      onTap: () {
        _checkUncheck(items, item);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.sp),
        child: Container(
          constraints: BoxConstraints(maxHeight: 40.h),
          child: Row(
            children: <Widget>[
              8.sp.sbw,
              CustomCheckBox(
                  onTap: () {
                    _checkUncheck(items, item);
                  },
                  borderColor: AppColors.labelColor8,
                  fillColor: AppColors.labelColor8,
                  isChecked: item.isChecked),
              8.sp.sbw,
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: CustomText(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    color: AppColors.labelColor5,
                    text: item.title,
                    maxLine: 5,
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _checkUncheck(
      List<OptionItemForMultiSelect> items, OptionItemForMultiSelect item) {
    if (widget.isOneSelect) {
      int selectedItemIndex = items.indexOf(item);
      widget.removeAllSelectedItem();

      // for (var selectedUserList in widget.selectedUserList) {
      //   var index = widget.selectedUserList.indexOf(selectedUserList);
      //   widget.removeSelectedItem(index);
      // }

      for (var item1 in items) {
        var index1 = items.indexOf(item1);
        var itemToStore1 = OptionItemForMultiSelect(
            id: item1.id,
            title: item1.title,
            isChecked: index1 == selectedItemIndex ? !item.isChecked : false);
        items[index1] = itemToStore1;
      }
      widget.onOptionSelected(items);
    } else {
      var index = items.indexOf(item);
      var itemToStore = OptionItemForMultiSelect(
          id: item.id, title: item.title, isChecked: !item.isChecked);
      items[index] = itemToStore;
      widget.onOptionSelected(items);
    }
  }
}
