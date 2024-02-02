import 'package:aspirevue/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomTextFormFieldForMessage extends StatefulWidget {
  final String labelText;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final int? lineCount;
  final int? maxLength;
  final String fontFamily;
  final IconData? sufixIcon;
  final Function? onTapSufixIcon;
  final double fontSize;
  final bool isRequired;
  final bool isReadOnly;
  final bool isEnabled;
  final bool isPassword;
  final bool isPreFixIcon;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final TextCapitalization capitalization;
  final Color textColor;
  final Color borderColor;
  final Color editColor;
  final Function? onChanged;
  final Function? onTap;
  final String? Function(String?)? validator;
  final TextAlign? textAlignment;
  final double? radius;
  final Color activeBorderColor;
  final FontWeight fontWeight;
  final int? maxLine;

  final EdgeInsetsGeometry? padding;
  final Function? onEditingComplete;
  final List<TextInputFormatter>? inputFormatters;

  final Function(PointerDownEvent)? onTapOutside;
  const CustomTextFormFieldForMessage(
      {super.key,
      required this.labelText,
      this.onTapOutside,
      this.textEditingController,
      this.validator,
      this.onEditingComplete,
      this.textAlignment,
      this.focusNode,
      this.nextFocus,
      this.lineCount,
      this.maxLength,
      this.radius,
      required this.fontFamily,
      required this.fontSize,
      this.capitalization = TextCapitalization.none,
      this.isRequired = false,
      this.isReadOnly = false,
      this.isEnabled = true,
      this.isPassword = false,
      this.isPreFixIcon = false,
      this.onChanged,
      this.onTap,
      this.sufixIcon,
      this.onTapSufixIcon,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.textColor = AppColors.black,
      this.borderColor = AppColors.editBoarderColor,
      this.editColor = AppColors.editColor,
      this.activeBorderColor = AppColors.labelColor5,
      this.fontWeight = FontWeight.w500,
      this.padding,
      this.maxLine,
      this.inputFormatters});

  @override
  State<CustomTextFormFieldForMessage> createState() =>
      _CustomTextFormFieldForMessageState();
}

class _CustomTextFormFieldForMessageState
    extends State<CustomTextFormFieldForMessage> {
  final bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: widget.lineCount,
      // maxLines: widget.lineCount,
      maxLines: widget.maxLine ?? widget.lineCount,
      maxLength: widget.maxLength,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      style: TextStyle(
        color: widget.textColor,
        fontFamily: widget.fontFamily,
        fontWeight: widget.fontWeight,
        fontSize: widget.fontSize,
      ),
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },

      onTapOutside: widget.onTapOutside,

      onEditingComplete: () {
        if (widget.onEditingComplete != null) {
          widget.onEditingComplete!();
        }
      },
      validator: widget.validator,
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      readOnly: widget.isReadOnly,
      enabled: widget.isEnabled,
      autofocus: false,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlignment ?? TextAlign.left,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.labelText,
        // prefixText: "\$",
        // prefixStyle: TextStyle(
        //   fontWeight: widget.fontWeight,
        //   fontSize: widget.fontSize,
        //   fontFamily: widget.fontFamily,
        // ),
        hintStyle: TextStyle(
          color: AppColors.hintColor,
          fontFamily: widget.fontFamily,
          fontWeight: widget.fontWeight,
          fontSize: widget.fontSize,
        ),
        contentPadding: context.isTablet
            ? widget.padding ?? EdgeInsets.all(1.5.h)
            : widget.isPreFixIcon == false
                ? widget.padding ?? EdgeInsets.all(1.h)
                : EdgeInsets.zero,
        suffixIcon: widget.sufixIcon != null
            ? InkWell(
                onTap: () {
                  if (widget.onTapSufixIcon != null) {
                    widget.onTapSufixIcon!();
                  }
                },
                child: SizedBox(
                  width: 20.sp,
                  height: 20.sp,
                  child: Center(
                    child: Icon(
                      widget.sufixIcon,
                      size: 14.sp,
                    ),
                  ),
                ),
              )
            : null,
        filled: true,
        counterText: '',
        fillColor: widget.editColor,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 5.sp)),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 5.sp)),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 5.sp)),
          borderSide:
              BorderSide(color: widget.activeBorderColor, width: 0.5.sp),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 5.sp)),
          borderSide: const BorderSide(color: AppColors.redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(widget.radius ?? 5.sp)),
          borderSide: const BorderSide(color: AppColors.redColor),
        ),
      ),
      onChanged: widget.onChanged as void Function(String)?,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(widget.nextFocus);
      },
    );
  }
}
