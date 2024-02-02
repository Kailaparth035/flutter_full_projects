import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class CustomUnderLineTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? textEditingController;
  final FocusNode focusNode;
  final FocusNode? nextFocus;
  final int? lineCount;
  final int? maxLength;
  final String fontFamily;

  final double fontSize;
  final bool isRequired;
  final bool isReadOnly;
  final bool isEnabled;
  final bool isPassword;

  final String? prefixIcon;

  final String? sufixIcon;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final Color textColor;
  final Color borderColor;
  final Color editColor;
  final Function? onChanged;
  final String? Function(String?)? validator;

  const CustomUnderLineTextField(
      {super.key,
      required this.labelText,
      this.textEditingController,
      required this.focusNode,
      this.nextFocus,
      this.lineCount,
      this.maxLength,
      required this.fontFamily,
      required this.fontSize,
      this.isRequired = false,
      this.isReadOnly = false,
      this.isEnabled = true,
      this.isPassword = false,
      this.onChanged,
      this.validator,
      this.prefixIcon,
      this.sufixIcon,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.textColor = AppColors.black,
      this.borderColor = AppColors.editBoarderColor,
      this.editColor = AppColors.editColor});

  @override
  State<CustomUnderLineTextField> createState() =>
      _CustomUnderLineTextFieldState();
}

class _CustomUnderLineTextFieldState extends State<CustomUnderLineTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // widget.prefixIcon != null
          //     ? Padding(
          //         padding: EdgeInsets.only(right: 10.sp, top: 7.sp),
          //         child: Image.asset(
          //           widget.prefixIcon!,
          //           width: widget.fontSize + 3.sp,
          //           height: widget.fontSize + 3.sp,
          //         ),
          //       )
          //     : 0.sbw,

          widget.prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(right: 10.sp, top: 7.sp),
                  child: SvgPicture.asset(
                    widget.prefixIcon!,
                    width: widget.fontSize + 3.sp,
                    height: widget.fontSize + 3.sp,
                  ),
                )
              : 0.sbw,
          Expanded(
            child: TextFormField(
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
              readOnly: widget.isReadOnly,
              enabled: widget.isEnabled,
              textAlign: TextAlign.left,
              obscureText: widget.isPassword ? _obscureText : false,
              validator: widget.validator,
              decoration: InputDecoration(
                hintText: widget.labelText,
                isDense: true,
                suffixIconConstraints: const BoxConstraints(),
                suffixIcon:
                    widget.isPassword == true || widget.sufixIcon != null
                        ? GestureDetector(
                            onTap: () {
                              _toggle();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.sp),
                              child: SvgPicture.asset(
                                widget.sufixIcon != null
                                    ? widget.sufixIcon!
                                    : _obscureText
                                        ? SvgImage.eyeIc
                                        : SvgImage.eyeOffIc,
                                width: widget.fontSize + 3.sp,
                                height: widget.fontSize + 3.sp,
                              ),
                            ),
                          )
                        : null,
                hintStyle: TextStyle(
                  color: AppColors.hintColor,
                  fontFamily: widget.fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: widget.fontSize,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 5.sp),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.editBoarderColor1),
                ),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.editBoarderColor1),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.labelColor91),
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 160, 39, 39)),
                ),
              ),
              onChanged: widget.onChanged as void Function(String)?,
              onFieldSubmitted: (v) {
                if (widget.nextFocus != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocus);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
