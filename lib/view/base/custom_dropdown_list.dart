import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../util/colors.dart';

class CustomDropdownList extends StatelessWidget {
  final bool? displayLabelOnTop;
  final String? dropdownValue;
  final List<String>? dropdownList;
  final Function(String?)? onChanged;
  final String fontFamily;
  final double fontSize;
  final String label;
  final String? prefixIcon;

  final Color fillColor;
  final Color borderColor;

  const CustomDropdownList(
      {super.key,
      this.dropdownValue,
      this.dropdownList,
      this.onChanged,
      required this.label,
      required this.fontFamily,
      required this.fontSize,
      this.displayLabelOnTop = true,
      this.prefixIcon,
      this.borderColor = AppColors.editBoarderColor,
      this.fillColor = AppColors.white});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          prefixIcon != null
              ? Padding(
                  padding: EdgeInsets.only(right: 10.sp, bottom: 8.sp),
                  child: SvgPicture.asset(
                    prefixIcon!,
                    width: fontSize + 4.sp,
                    height: fontSize + 4.sp,
                  ),
                )
              : 0.sbw,
          Expanded(
            child: DropdownButtonFormField(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: AppColors.secondaryColor,
              ),
              decoration: InputDecoration(
                fillColor: Colors.red,
                hoverColor: Colors.yellow,
                focusColor: Colors.green,
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5.sp, horizontal: 0.sp),
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
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: TextStyle(
                  color: AppColors.hintColor,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize,
                ),
                labelText: label,
                alignLabelWithHint: false,
              ),
              value: dropdownValue,
              style: TextStyle(
                color: Colors.black,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w500,
                fontSize: fontSize,
              ),
              alignment: AlignmentDirectional.centerStart,
              onChanged: (val) {
                if (val != "") {
                  if (onChanged != null) {
                    onChanged!(val);
                  }
                }
              },
              hint: Text(
                label,
                style: TextStyle(
                  color: AppColors.hintColor,
                  fontFamily: fontFamily,
                  fontWeight: FontWeight.w500,
                  fontSize: fontSize,
                ),
              ),
              items: dropdownList!
                  .map(
                    (itemName) => DropdownMenuItem(
                      value: itemName,
                      child: Text(
                        itemName,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
