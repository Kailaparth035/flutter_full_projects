import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/goals_remain_model.dart';
import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_goal_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_expandable_widget.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/goal_development_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class DevelopmentGoalExpandableCardWidget extends StatefulWidget {
  const DevelopmentGoalExpandableCardWidget({
    super.key,
    required this.data,
    required this.userId,
    required this.styleId,
    required this.onReaload,
  });
  final WorkSkillSubGoalData data;
  final String? userId;
  final String? styleId;
  final Future Function(bool) onReaload;

  @override
  State<DevelopmentGoalExpandableCardWidget> createState() =>
      _DevelopmentGoalExpandableCardWidgetState();
}

class _DevelopmentGoalExpandableCardWidgetState
    extends State<DevelopmentGoalExpandableCardWidget> {
  final _developmentController = Get.find<DevelopmentController>();

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";
  GoalSelectorDetailsData? _data;

  bool isInitialLoad = true;
  bool isOpened = false;

  _getData(bool isShowLoading) async {
    Map<String, String> map = {
      "area_id": widget.data.areaId.toString(),
      "user_id": widget.userId.toString(),
      "style_id": widget.styleId.toString(),
    };
    try {
      if (isShowLoading) {
        setState(() {
          _isLoading = true;
        });
      }

      var response = await _developmentController.geGoalSelectorDetails(
        map,
      );
      if (mounted) {
        setState(() {
          _isError = false;
          _errorMsg = "";
          _data = response;
          isInitialLoad = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          String error = CommonController().getValidErrorMessage(e.toString());
          _errorMsg = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
          _buildCardTitle(
              widget.data.title.toString(), widget.data.percentile.toString()),
          _buildCardDescription(widget.data.description.toString()),
          CustomExpandableWidget(
            isOpened: isOpened,
            mainWidget: _buildMainTitle(widget.data.score.toString()),
            childWidget: _buildChild(),
            onExpand: (bool isExpand) {
              if (isExpand == true) {
                setState(() {
                  isOpened = true;
                });
                _getData(true);
              } else {
                setState(() {
                  isOpened = false;
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildChild() {
    return _isLoading
        ? const Center(
            child: CustomLoadingWidget(),
          )
        : _isError == true || _data == null
            ? Center(
                child: CustomErrorWidget(
                  width: 90.sp,
                  onRetry: () {
                    _getData(true);
                  },
                  text: _isError == true
                      ? _errorMsg
                      : AppString.somethingWentWrong,
                ),
              )
            : Container(
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5.sp),
                    bottomLeft: Radius.circular(5.sp),
                  ),
                  color: AppColors.backgroundColor1,
                ),
                child: Column(
                  children: [
                    ..._data!.list!.map((e) => _buildView(e)),
                  ],
                ),
              );
  }

  Column _buildView(GoalDataForDevelopment e) {
    return Column(
      children: [
        5.sp.sbh,
        DevelopmentToggleWidget(
            data: e,
            styleId: widget.styleId,
            userId: widget.userId,
            onReaload: (bool isShowLoading) async {
              await _getData(isShowLoading);
            }),
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
        _buildTitleDescription(
            "BEHAVIORAL DESCRIPTION", e.behaviorDesc.toString(), false),
        _buildTitleDescription(
            "SUGGESTED OBJECTIVES", e.suggesstedObj.toString(), true),
        5.sp.sbh,
        _buildDivider(),
        5.sp.sbh,
      ],
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
        5.sp.sbh,
        CustomText(
          text: value,
          textAlign: TextAlign.start,
          color: AppColors.black,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 11.sp,
          maxLine: 10,
          fontWeight: FontWeight.w600,
        ),
        5.sp.sbh,
        isLast
            ? context.getWidth.sbw
            : Column(
                children: [
                  _buildDivider(),
                  5.sp.sbh,
                ],
              ),
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

  Container _buildMainTitle(String score) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 8.sp),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.labelColor),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(4.sp),
          bottomLeft: Radius.circular(4.sp),
        ),
        color: AppColors.backgroundColor1,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Score".toUpperCase(),
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor2,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 9.sp,
                  maxLine: 10,
                  fontWeight: FontWeight.w800,
                ),
                1.sp.sbh,
                CustomText(
                  text: score,
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  maxLine: 10,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          10.sp.sbw,
          Image.asset(
            AppImages.arrowDownIc,
            height: 25.sp,
          )
        ],
      ),
    );
  }

  Padding _buildCardDescription(String desc) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: CustomText(
        text: desc,
        textAlign: TextAlign.start,
        color: AppColors.black,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 10.sp,
        maxLine: 10,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Container _buildCardTitle(String title, String per) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.sp),
          topRight: Radius.circular(5.sp),
        ),
        color: AppColors.labelColor15.withOpacity(0.85),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              CustomText(
                text: "PERCENTILE",
                textAlign: TextAlign.start,
                color: AppColors.white,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 9.sp,
                textSpacing: 0.5.sp,
                maxLine: 10,
                fontWeight: FontWeight.w700,
              ),
              5.sp.sbw,
              CustomButton2(
                  buttonText: per,
                  radius: 5.sp,
                  buttonColor: AppColors.labelColor,
                  textColor: AppColors.labelColor40,
                  padding:
                      EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                  onPressed: () {})
            ],
          )
        ],
      ),
    );
  }
}
