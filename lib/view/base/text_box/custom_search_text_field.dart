import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomSearchTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final int? lineCount;
  final int? maxLength;
  final String fontFamily;
  final String? prefixIcon;
  final String? suffixIcon;
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

  const CustomSearchTextField(
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
      this.prefixIcon,
      this.suffixIcon,
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
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
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
            ? EdgeInsets.all(1.5.h)
            : widget.isPreFixIcon == false
                ? EdgeInsets.symmetric(horizontal: 10.sp, vertical: 0)
                : EdgeInsets.zero,
        filled: true,
        counterText: "",
        fillColor: widget.editColor,
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            widget.suffixIcon2 != null
                ? InkWell(
                    onTap: () {
                      if (widget.onSecondTap != null) {
                        widget.onSecondTap!();
                      }
                    },
                    child: Image.asset(
                      widget.suffixIcon2!,
                      height: widget.iconSize ?? 15.sp,
                      width: widget.iconSize ?? 15.sp,
                    ),
                  )
                : 0.sbh,
            widget.suffixIcon2 != null ? 5.sp.sbw : 0.sbh,
            widget.suffixIcon != null
                ? InkWell(
                    onTap: () {
                      if (widget.onTapsuffixIcon2 != null) {
                        widget.onTapsuffixIcon2!();
                      }
                    },
                    child: Image.asset(
                      widget.suffixIcon!,
                      height: widget.iconSize ?? 15.sp,
                      width: widget.iconSize ?? 15.sp,
                    ),
                  )
                : 0.sbh,
            widget.lastWidth != null
                ? widget.lastWidth!.sbw
                : widget.suffixIcon2 == null
                    ? 10.sp.sbw
                    : 5.sp.sbw
          ],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(widget.radius ?? Dimensions.radiusContainer)),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(widget.radius ?? Dimensions.radiusContainer)),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(widget.radius ?? Dimensions.radiusContainer)),
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
