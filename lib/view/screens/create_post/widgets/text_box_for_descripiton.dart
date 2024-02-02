import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TextBoxWidgetForDescription extends StatefulWidget {
  final String labelText;
  final TextEditingController? textEditingController;

  final Color textColor;
  final Color borderColor;
  final Color editColor;
  final Function? onChanged;

  const TextBoxWidgetForDescription(
      {super.key,
      required this.labelText,
      required this.onChanged,
      this.textEditingController,
      this.textColor = AppColors.black,
      this.borderColor = AppColors.editBoarderColor,
      this.editColor = AppColors.editColor});

  @override
  State<TextBoxWidgetForDescription> createState() =>
      _TextBoxWidgetForDescriptionState();
}

class _TextBoxWidgetForDescriptionState
    extends State<TextBoxWidgetForDescription> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.newline,
      maxLines: 4,
      controller: widget.textEditingController,
      style: TextStyle(
        color: widget.textColor,
        fontFamily: AppString.manropeFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
      ),
      cursorColor: Theme.of(context).primaryColor,
      autofocus: false,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        hintText: widget.labelText,
        hintStyle: TextStyle(
          color: AppColors.hintColor,
          fontFamily: AppString.manropeFontFamily,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
        contentPadding:
            context.isTablet ? EdgeInsets.all(1.5.h) : EdgeInsets.all(1.h),
        filled: true,
        counterText: '',
        fillColor: widget.editColor,
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
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          borderSide: const BorderSide(color: AppColors.redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(Dimensions.radiusSmall)),
          borderSide: const BorderSide(color: AppColors.redColor),
        ),
      ),
      onFieldSubmitted: (v) {},
      onChanged: widget.onChanged as void Function(String)?,
    );
  }
}
