import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/forum_polls_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_view_response_chart.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/question_list_tile_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/hashtag_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForumPollsListileWidget extends StatefulWidget {
  const ForumPollsListileWidget({
    super.key,
    required this.data,
    required this.isLast,
    required this.isLoadingLast,
  });
  final ForumPollsData data;
  final bool isLast;
  final bool isLoadingLast;

  @override
  State<ForumPollsListileWidget> createState() =>
      _ForumPollsListileWidgetState();
}

class _ForumPollsListileWidgetState extends State<ForumPollsListileWidget> {
  bool _isAnswered = false;
  late ForumPollsData _forumData;
  final _dashboardController = Get.find<DashboardController>();
  @override
  void initState() {
    _isAnswered = widget.data.questionEnabledisable == 1;
    _forumData = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildQuestionListTile(_forumData);
  }

  Widget _buildQuestionListTile(ForumPollsData data) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding,
              vertical: AppConstants.screenHorizontalPadding),
          margin: EdgeInsets.only(top: AppConstants.screenHorizontalPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.sp),
            border: Border.all(color: AppColors.labelColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubTitle(data.question.toString()),
              10.sp.sbh,
              ...data.options!.map(
                (e) => QuestionListTileWidget(
                  onTap: () {
                    if (!_isAnswered) {
                      addAnswer(e.id.toString());
                    }
                  },
                  isAnswered: _isAnswered,
                  lable: e.id.toString(),
                  question: e.name.toString(),
                  borderColor: AppColors.labelColor9,
                  bgColor: e.id.toString() == data.correctAnswer.toString()
                      ? AppColors.secondaryColor.withOpacity(0.40)
                      : AppColors.labelColor65.withOpacity(0.20),
                  fontSize: 12.sp,
                ),
              ),
              ...data.hashtag!.map(
                (e) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HashTagPostStreamScreen(
                          isFrom: PostTypeEnum.hashtag,
                          hashTag: e.name.toString().replaceAll("#", "").trim(),
                        ),
                      ),
                    );
                  },
                  child: CustomText(
                    text: "#${e.name}",
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              10.sp.sbh,
              _isAnswered ? _buildViewResponseButton() : 0.sbh,
            ],
          ),
        ),
        widget.isLast
            ? widget.isLoadingLast
                ? const Center(
                    child: CustomLoadingWidget(),
                  )
                : 0.sbh
            : 0.h.sbh,
      ],
    );
  }

  Align _buildViewResponseButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomButton2(
          buttonText: AppString.viewResponses,
          radius: 5.sp,
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ViewResponseChartDialog(
                  id: _forumData.id.toString(),
                  question: _forumData.question.toString(),
                );
              },
            );
          }),
    );
  }

  Widget _buildSubTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor64,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    );
  }

  addAnswer(String id) async {
    try {
      // ignore: use_build_context_synchronously
      buildLoading(context);
      Map<String, dynamic> map = {
        "forum_question_id": _forumData.id.toString(),
        "answer_id": id
      };
      var response = await _dashboardController.addAnswer(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);

        String res = response.responseT!.body['answer_id'].toString();
        setState(() {
          _isAnswered = true;
          _forumData.correctAnswer = res;
        });
        // _dashboardController.getAssignedTests({});
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }
}
