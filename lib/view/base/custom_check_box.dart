import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox(
      {super.key,
      required this.fillColor,
      required this.borderColor,
      required this.isChecked,
      this.width,
      this.height,
      required this.onTap});
  final Color borderColor;
  final Color fillColor;
  final bool isChecked;
  final Function onTap;
  final double? width;
  final double? height;
  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        height: widget.height ?? 16.sp,
        width: widget.width ?? 16.sp,
        decoration: BoxDecoration(
          color: widget.isChecked ? widget.fillColor : Colors.transparent,
          border: Border.all(color: widget.borderColor, width: 1.sp),
          borderRadius: BorderRadius.circular(
            2.sp,
          ),
        ),
        child: widget.isChecked
            ? const FittedBox(
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
