import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final TextEditingController? textEditingController;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final int? lineCount;
  final int? maxLength;
  final String fontFamily;
  final String prefixIcon;
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
  final String? Function(String?)? validator;

  const CustomTextFormField(
      {super.key,
      required this.labelText,
      this.textEditingController,
      required this.focusNode,
      this.nextFocus,
      this.lineCount,
      this.maxLength,
      required this.fontFamily,
      required this.fontSize,
      this.capitalization = TextCapitalization.none,
      this.isRequired = false,
      this.isReadOnly = false,
      this.isEnabled = true,
      this.isPassword = false,
      this.isPreFixIcon = false,
      this.onChanged,
      this.validator,
      this.prefixIcon = AppImages.placeholder,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.textColor = AppColors.black,
      this.borderColor = AppColors.editBoarderColor,
      this.editColor = AppColors.editColor});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.lineCount,
      maxLength: widget.maxLength,
      controller: widget.textEditingController,
      focusNode: widget.focusNode,
      autofillHints: widget.inputType == TextInputType.emailAddress
          ? const [AutofillHints.email]
          : null,
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
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      decoration: InputDecoration(
        hintText: widget.labelText,
        hintStyle: TextStyle(
          color: AppColors.labelColor9,
          fontFamily: widget.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: widget.fontSize,
        ),
        contentPadding: context.isTablet
            ? EdgeInsets.all(1.5.h)
            : widget.isPreFixIcon == false
                ? EdgeInsets.all(1.h)
                : EdgeInsets.zero,
        filled: true,
        counterText: '',
        fillColor: widget.editColor,
        prefixIcon: widget.isPreFixIcon
            ? Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.h, vertical: 1.5.h),
                child: Image.asset(
                  widget.prefixIcon,
                  width: 2.w,
                  height: 2.h,
                ),
              )
            : null,
        suffixIcon: widget.isPassword
            ? Padding(
                padding: EdgeInsets.all(1.5.h),
                child: InkWell(
                  onTap: () {
                    if (widget.textEditingController?.text.isNotEmpty == true) {
                      _toggle();
                    }
                  },
                  child: SizedBox(
                    width: 20.sp,
                    height: 20.sp,
                    child: Icon(
                        _obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.hintColor),
                  ),
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          borderSide: BorderSide(color: widget.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          borderSide: const BorderSide(color: Color.fromARGB(255, 160, 39, 39)),
        ),
      ),
      onChanged: widget.onChanged as void Function(String)?,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(widget.nextFocus);
      },
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
