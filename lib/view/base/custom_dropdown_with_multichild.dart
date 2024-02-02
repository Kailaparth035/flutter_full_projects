import 'package:aspirevue/data/model/response/objective_note_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomDropForAlert extends StatefulWidget {
  const CustomDropForAlert(
      {super.key,
      required this.headingText,
      required this.list,
      this.bgColor,
      this.borderColor,
      this.fontWeight,
      required this.onTap,
      this.fontSize});
  final String headingText;

  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final List<AlignmentObjective>? list;
  final Function onTap;

  @override
  State<CustomDropForAlert> createState() => _CustomDropForAlertState();
}

class _CustomDropForAlertState extends State<CustomDropForAlert>
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
    runExpandCheck();
  }

  void runExpandCheck() {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: widget.borderColor ?? AppColors.secondaryColor),
            borderRadius: BorderRadius.circular(3.sp),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: widget.bgColor ?? AppColors.labelColor21,
              borderRadius: BorderRadius.circular(3.sp),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
            child: InkWell(
              onTap: () {
                isShow = !isShow;
                runExpandCheck();
                setState(() {});
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 5.sp,
                  ),
                  Expanded(
                    child: CustomText(
                      fontWeight: widget.fontWeight ?? FontWeight.w600,
                      fontSize: 10.sp,
                      color: AppColors.black,
                      text: widget.headingText,
                      textAlign: TextAlign.start,
                      fontFamily: AppString.manropeFontFamily,
                    ),
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
            ),
          ),
        ),
        SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: animation,
          child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 1.h),
              padding: EdgeInsets.only(bottom: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5.sp),
                    bottomRight: Radius.circular(5.sp)),
                color: AppColors.backgroundColor1,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.list!.map(
                      (e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                            color: AppColors.black,
                            maxLine: 100,
                            text: e.title.toString(),
                            textAlign: TextAlign.start,
                            fontFamily: AppString.manropeFontFamily,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...e.child!.map(
                                (r) => InkWell(
                                  onTap: () {
                                    isShow = !isShow;
                                    runExpandCheck();
                                    setState(() {});
                                    widget.onTap(r);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.sp, top: 2.sp, bottom: 2.sp),
                                    child: CustomText(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10.sp,
                                      maxLine: 100,
                                      color: AppColors.black,
                                      text: r.title.toString(),
                                      textAlign: TextAlign.start,
                                      fontFamily: AppString.manropeFontFamily,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
