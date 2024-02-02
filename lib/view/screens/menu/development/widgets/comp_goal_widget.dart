import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/development/comp_goal_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/comp_goal_expandable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sizer/sizer.dart';

class CompGoalCardWidget extends StatefulWidget {
  const CompGoalCardWidget({
    super.key,
    required this.data,
    required this.styleId,
    required this.userId,
    required this.onReaload,
  });
  final String styleId;
  final String userId;

  final CompGoalTitleList data;
  final Future Function(bool) onReaload;
  @override
  State<CompGoalCardWidget> createState() => _ComptGoalCardWidgetState();
}

class _ComptGoalCardWidgetState extends State<CompGoalCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBoxListTile();
  }

  Container _buildBoxListTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
          boxShadow: CommonController.getBoxShadow,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: AppColors.labelColor),
          color: AppColors.white),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(),
          _buildChild(),
        ],
      ),
    );
  }

  Container _buildCardTitle() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.sp),
          topRight: Radius.circular(5.sp),
        ),
        color: AppColors.labelColor15.withOpacity(0.85),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
      child: CustomText(
        text: "Competency : ${widget.data.title.toString()}",
        textAlign: TextAlign.start,
        color: AppColors.white,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
        maxLine: 10,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildChild() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(5.sp),
          bottomLeft: Radius.circular(5.sp),
        ),
        color: AppColors.backgroundColor1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTileForValues(
            widget.data.supervisorScore.toString(),
            widget.data.idealScore.toString(),
          ),
          widget.data.compentecnyDescription == ""
              ? 0.sbh
              : _buildTitleDescription("COMPETENCY DESCRIPTION",
                  widget.data.compentecnyDescription.toString(), false),
          widget.data.behavopralDescription == ""
              ? 0.sbh
              : _buildTitleDescription("BEHAVIORAL DESCRIPTION",
                  widget.data.behavopralDescription.toString(), false),
          ...widget.data.subdataList!.map((e) => Padding(
                padding: EdgeInsets.only(bottom: 10.sp),
                child: CompGoalExpandableWidget(
                  data: e,
                  mainData: widget.data,
                  styleId: widget.styleId,
                  userId: widget.userId,
                  onReaload: widget.onReaload,
                ),
              ))
        ],
      ),
    );
  }

  _buildTitleDescription(String title, String value, bool isLast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          textAlign: TextAlign.start,
          color: AppColors.labelColor2,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 9.sp,
          maxLine: 10,
          fontWeight: FontWeight.w700,
        ),
        Html(
          data: value.toString(),
          style: {
            "ul": Style(
              padding: HtmlPaddings.symmetric(
                vertical: 0.sp,
                horizontal: 5.sp,
              ),
            ),
            "*": Style(fontSize: FontSize(11.sp))
          },
        ),
        _buildDivider(),
        5.sp.sbh,
      ],
    );
  }

  Widget _buildListTileForValues(String score, String idealScore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Current Score : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: score,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Target Score : ",
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w700,
                        color: AppColors.labelColor2,
                      ),
                    ),
                    TextSpan(
                      text: idealScore,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontFamily: AppString.manropeFontFamily,
                        fontWeight: FontWeight.w600,
                        color: AppColors.labelColor35,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
      ],
    );
  }

  Divider _buildDivider() {
    return const Divider(
      height: 1,
      color: AppColors.labelColor,
      thickness: 1,
    );
  }
}
