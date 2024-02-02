import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomSearchTextFieldForTopWidget extends StatefulWidget {
  final String labelText;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final int? lineCount;
  final int? maxLength;
  final String fontFamily;
  final String prefixIcon;
  final String suffixIcon;
  final String? suffixIcon2;
  final double fontSize;
  final bool isRequired;
  final bool isReadOnly;
  final bool isEnabled;
  final bool isPreFixIcon;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final Color textColor;
  final Color borderColor;
  final Color editColor;
  final Function(String)? onChanged;
  final double? radius;

  final Function? onSecondTap;
  final double? iconPadding;
  final double? iconSize;

  final Function? onTapsuffixIcon2;
  final Function? onEditComplete;

  final double? lastWidth;
  final Function? onTap;

  const CustomSearchTextFieldForTopWidget(
      {super.key,
      required this.labelText,
      this.onSecondTap,
      this.iconPadding,
      this.textEditingController,
      this.focusNode,
      this.nextFocus,
      this.lineCount,
      this.maxLength,
      required this.fontFamily,
      required this.fontSize,
      this.capitalization = TextCapitalization.none,
      this.isRequired = false,
      this.isReadOnly = false,
      this.isEnabled = true,
      this.isPreFixIcon = false,
      this.onChanged,
      this.prefixIcon = AppImages.placeholder,
      this.suffixIcon = AppImages.placeholder,
      this.suffixIcon2,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.textColor = AppColors.black,
      this.borderColor = AppColors.editBoarderColor,
      this.radius,
      this.editColor = AppColors.editColor,
      this.iconSize,
      this.onTapsuffixIcon2,
      this.lastWidth,
      this.onEditComplete,
      this.onTap});

  @override
  State<CustomSearchTextFieldForTopWidget> createState() =>
      _CustomSearchTextFieldForTopWidgetState();
}

class _CustomSearchTextFieldForTopWidgetState
    extends State<CustomSearchTextFieldForTopWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.lineCount,
      maxLines: widget.lineCount,
      maxLength: widget.maxLength,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onEditingComplete: () {
        if (widget.onEditComplete != null) {
          widget.onEditComplete!();
        }
      },
      style: TextStyle(
        color: widget.textColor,
        fontFamily: widget.fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: widget.fontSize,
      ),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      readOnly: widget.isReadOnly,
      enabled: widget.isEnabled,
      autofocus: false,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.labelText,
        hintStyle: TextStyle(
          color: AppColors.hintColor,
          fontFamily: widget.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: widget.fontSize,
        ),
        contentPadding: context.isTablet
            ? EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0)
            : widget.isPreFixIcon == false
                ? EdgeInsets.symmetric(horizontal: 15.sp, vertical: 0)
                : EdgeInsets.zero,
        filled: true,
        counterText: "",
        fillColor: widget.editColor,
        suffixIcon: Container(
          padding: EdgeInsets.all(context.isTablet ? 3.sp : 5.sp),
          child: InkWell(
            onTap: () {},
            child: Image.asset(
              widget.suffixIcon,
              height: 18.sp,
              width: 18.sp,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 20.sp)),
          borderSide: const BorderSide(color: AppColors.editBoarderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 20.sp)),
          borderSide: const BorderSide(color: AppColors.editBoarderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 20.sp)),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
      onChanged: widget.onChanged,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(widget.nextFocus);
      },
    );
  }
}
