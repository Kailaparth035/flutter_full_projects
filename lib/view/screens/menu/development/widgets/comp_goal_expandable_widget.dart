import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/development/comp_goal_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_expandable_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/comp_goal_toggle_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CompGoalExpandableWidget extends StatefulWidget {
  const CompGoalExpandableWidget({
    super.key,
    required this.data,
    required this.mainData,
    required this.styleId,
    required this.userId,
    required this.onReaload,
  });
  final SubdataList data;
  final CompGoalTitleList mainData;
  final String styleId;
  final String userId;
  final Future Function(bool) onReaload;
  @override
  State<CompGoalExpandableWidget> createState() =>
      _CompGoalExpandableWidgetState();
}

class _CompGoalExpandableWidgetState extends State<CompGoalExpandableWidget> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return CustomExpandableWidget(
      isOpened: isExpanded,
      onExpand: (isEx) {
        setState(() {
          isExpanded = isEx;
        });
      },
      mainWidget: Container(
        decoration: BoxDecoration(
          gradient: CommonController.getLinearGradientSecondryAndPrimary(),
          color: AppColors.labelColor21,
          borderRadius: BorderRadius.circular(3.sp),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Row(
              children: [
                SizedBox(
                  width: 5.sp,
                ),
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  color: AppColors.white,
                  text: widget.data.title.toString(),
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
                const Spacer(),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_down,
                  color: AppColors.white,
                  size: 15.sp,
                ),
                SizedBox(
                  width: 5.sp,
                ),
              ],
            )),
          ],
        ),
      ),
      childWidget: Column(
        children: [
          5.sp.sbh,
          ...widget.data.value!.map(
            (e) => CompGoalToggleCardWidget(
              data: e,
              mainData: widget.mainData,
              userId: widget.userId,
              styleId: widget.styleId,
              onReaload: widget.onReaload,
            ),
          )
        ],
      ),
    );
  }
}
