import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomMultipleDropList extends StatefulWidget {
  final String headingText;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final OptionItemForMultiSelect itemSelected;
  final List<OptionItemForMultiSelect> list;
  final Function(List<OptionItemForMultiSelect> optionItem) onOptionSelected;
  final Function? onExpand;
  const CustomMultipleDropList(
      this.headingText, this.itemSelected, this.list, this.onOptionSelected,
      {super.key,
      this.bgColor,
      this.borderColor,
      this.fontSize,
      this.onExpand});

  @override
  State<CustomMultipleDropList> createState() => _CustomMultipleDropListState();
}

class _CustomMultipleDropListState extends State<CustomMultipleDropList>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

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
      if (widget.onExpand != null) {
        widget.onExpand!();
      }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.borderColor ??
                    AppColors.labelColor9.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(3.sp),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.bgColor ?? AppColors.labelColor12,
              borderRadius: BorderRadius.circular(3.sp),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: InkWell(
                  onTap: () {
                    isShow = !isShow;
                    _runExpandCheck();
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 5.sp,
                      ),
                      CustomText(
                        fontWeight: FontWeight.w500,
                        fontSize: widget.fontSize ?? 10.sp,
                        color: AppColors.black,
                        text: widget.headingText,
                        textAlign: TextAlign.start,
                        fontFamily: AppString.manropeFontFamily,
                      ),
                      const Spacer(),
                      Icon(
                        isShow
                            ? Icons.keyboard_arrow_right
                            : Icons.keyboard_arrow_down,
                        color: AppColors.hintColor,
                        size: 15.sp,
                      ),
                      SizedBox(
                        width: 5.sp,
                      ),
                    ],
                  ),
                )),
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
                child: _buildDropListOptions(widget.list, context))),
      ],
    );
  }

  Widget _buildDropListOptions(
      List<OptionItemForMultiSelect> items, BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 40.h),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: items
                .map((item) => _buildSubMenu(item, context, items))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSubMenu(OptionItemForMultiSelect item, BuildContext context,
      List<OptionItemForMultiSelect> items) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.sp),
      child: GestureDetector(
        child: Row(
          children: <Widget>[
            8.sp.sbw,
            CustomCheckBox(
                onTap: () {
                  var index = items.indexOf(item);

                  var itemToStore = OptionItemForMultiSelect(
                      id: item.id,
                      title: item.title,
                      isChecked: !item.isChecked);
                  items[index] = itemToStore;
                  widget.onOptionSelected(items);
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
        onTap: () {
          var index = items.indexOf(item);
          var itemToStore = OptionItemForMultiSelect(
              id: item.id, title: item.title, isChecked: !item.isChecked);
          items[index] = itemToStore;
          widget.onOptionSelected(items);
        },
      ),
    );
  }
}

class CustomMultipleDropListShowListOnTopWidget extends StatefulWidget {
  final String headingText;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final OptionItemForMultiSelect itemSelected;
  final List<OptionItemForMultiSelect> list;
  final Function(List<OptionItemForMultiSelect> optionItem) onOptionSelected;
  final Function? onExpand;
  const CustomMultipleDropListShowListOnTopWidget(
      this.headingText, this.itemSelected, this.list, this.onOptionSelected,
      {super.key,
      this.bgColor,
      this.borderColor,
      this.fontSize,
      this.onExpand});

  @override
  // ignore: library_private_types_in_public_api
  _CustomMultipleDropListShowListOnTopWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _CustomMultipleDropListShowListOnTopWidgetState(itemSelected, list);
}

class _CustomMultipleDropListShowListOnTopWidgetState
    extends State<CustomMultipleDropListShowListOnTopWidget>
    with SingleTickerProviderStateMixin {
  late OptionItemForMultiSelect optionItemSelected;
  final List<OptionItemForMultiSelect> list;

  late AnimationController expandController;
  late Animation<double> animation;

  bool isShow = false;

  _CustomMultipleDropListShowListOnTopWidgetState(
      this.optionItemSelected, this.list);

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
      if (widget.onExpand != null) {
        widget.onExpand!();
      }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.borderColor ??
                    AppColors.labelColor9.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(3.sp),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.bgColor ?? AppColors.labelColor12,
              borderRadius: BorderRadius.circular(3.sp),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child:
                      widget.list.where((element) => element.isChecked).isEmpty
                          ? InkWell(
                              onTap: () {
                                isShow = !isShow;
                                _runExpandCheck();
                                setState(() {});
                              },
                              child: CustomText(
                                text: AppString.selectOption,
                                textAlign: TextAlign.start,
                                color: AppColors.labelColor9,
                                fontFamily: AppString.manropeFontFamily,
                                fontSize: 12.sp,
                                maxLine: 5,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Wrap(
                              spacing: 2.sp,
                              runSpacing: 2.sp,
                              children: [
                                ...widget.list.map((e) {
                                  if (e.isChecked) {
                                    return _buildDeleteUserTile(e);
                                  } else {
                                    return 0.sbh;
                                  }
                                }),
                              ],
                            ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      isShow = !isShow;
                      _runExpandCheck();
                      setState(() {});
                    },
                    child: Icon(
                      isShow
                          ? Icons.keyboard_arrow_right
                          : Icons.keyboard_arrow_down,
                      color: AppColors.hintColor,
                      size: 15.sp,
                    ),
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
                child: _buildDropListOptions(list, context))),
      ],
    );
  }

  Container _buildDeleteUserTile(OptionItemForMultiSelect data) {
    return Container(
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
              var index = widget.list.indexOf(data);

              var itemToStore = OptionItemForMultiSelect(
                  id: data.id, title: data.title, isChecked: !data.isChecked);
              list[index] = itemToStore;
              widget.onOptionSelected(list);
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
          children:
              items.map((item) => _buildSubMenu(item, context, items)).toList(),
        ),
      ),
    );
  }

  Widget _buildSubMenu(OptionItemForMultiSelect item, BuildContext context,
      List<OptionItemForMultiSelect> items) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.sp),
      child: Container(
        constraints: BoxConstraints(maxHeight: 40.h),
        child: GestureDetector(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: <Widget>[
                  8.sp.sbw,
                  CustomCheckBox(
                      onTap: () {
                        var index = items.indexOf(item);

                        var itemToStore = OptionItemForMultiSelect(
                            id: item.id,
                            title: item.title,
                            isChecked: !item.isChecked);
                        items[index] = itemToStore;
                        widget.onOptionSelected(items);
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
              Divider(
                color: AppColors.labelColor,
                height: 1.sp,
              )
            ],
          ),
          onTap: () {
            var index = items.indexOf(item);
            var itemToStore = OptionItemForMultiSelect(
                id: item.id, title: item.title, isChecked: !item.isChecked);
            items[index] = itemToStore;

            widget.onOptionSelected(items);
          },
        ),
      ),
    );
  }
}
