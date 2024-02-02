import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/forum_poll_detail_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_view_response_chart.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/dashboard/widget/question_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class QuestionDetailScreen extends StatefulWidget {
  const QuestionDetailScreen({
    super.key,
    required this.id,
  });
  final String id;
  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final _dashboardController = Get.find<DashboardController>();
  bool _isAnswered = false;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";
  late ForumPollDetailData _data;

  _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var map = <String, dynamic>{"question_id": widget.id};
      ForumPollDetailData res =
          await _dashboardController.viewQuestionAnswerDetail(map);

      setState(() {
        _isAnswered = res.questionEnabledisable == 1;
        _isError = false;
        _errorMsg = "";
        _data = res;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        String error = CommonController().getValidErrorMessage(e.toString());
        _errorMsg = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor1,
      // resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: AppbarWithBackButton(
          appbarTitle: AppString.forumPolls,
          onbackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
          onTap: () {
            CommonController.hideKeyboard(context);
          },
          child: _buildMainView()),
    );
  }

  Widget _buildMainView() {
    if (_isLoading) {
      return const Center(child: CustomLoadingWidget());
    }
    if (_isError) {
      return Center(
        child: CustomErrorWidget(
          onRetry: () async {
            _loadData();
          },
          text: _isError ? _errorMsg.toString() : AppString.somethingWentWrong,
        ),
      );
    }

    return _buildView();
  }

  Widget _buildView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.sp.sbh,
        _buildTitle(
            "${AppString.forumPolls} - ${_data.hashtag!.map((e) => "#${e.name}").join(",")}"),
        10.sp.sbh,
        Expanded(
          child: Stack(
            children: [
              CustomImage(
                height: double.infinity,
                image: _data.attachment.toString(),
                fit: BoxFit.fitHeight,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    AppColors.labelColor67.withOpacity(0.60),
                    AppColors.labelColor67.withOpacity(0.60),
                    AppColors.labelColor67.withOpacity(0.60),
                  ], begin: Alignment.topLeft, end: Alignment.bottomCenter),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenHorizontalPadding,
                    vertical: 0.sp),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    child: _buildContain(),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column _buildContain() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.sp.sbh,
        _buildSubTitle(_data.question.toString()),
        10.sp.sbh,
        ..._data.options!.map(
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
            isColored: true,
            isSelected: e.id.toString() == _data.correctAnswer.toString(),
            bgColor: e.id.toString() == _data.correctAnswer.toString()
                ? AppColors.secondaryColor
                : AppColors.white,
            fontSize: 12.sp,
          ),
        ),
        _isAnswered ? _buildSecondView() : 0.sp.sbh,
        15.sp.sbh,
      ],
    );
  }

  Column _buildSecondView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppString.wouldYouLike,
          textAlign: TextAlign.end,
          color: AppColors.labelColor8,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        10.sp.sbh,
        _buildViewResponseButoon(),
        10.sp.sbh,
        CustomText(
          text: AppString.haveAnIdea,
          textAlign: TextAlign.start,
          color: AppColors.labelColor8,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        CustomText(
          text: AppString.submitItHere,
          textAlign: TextAlign.start,
          color: AppColors.labelColor35,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
        10.sp.sbh,
        SizedBox(
          height: 30.sp,
          child: CustomTextFormFieldForMessage(
            borderColor: AppColors.labelColor,
            inputAction: TextInputAction.done,
            labelText: "",
            inputType: TextInputType.text,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            lineCount: 1,
            editColor: AppColors.labelColor12,
            textEditingController: _textController,
          ),
        ),
        15.sp.sbh,
        Align(
          alignment: Alignment.centerRight,
          child: CustomButton2(
              buttonText: AppString.submit,
              radius: 5.sp,
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              onPressed: () {
                _addSuggestionQuestion();
              }),
        ),
      ],
    );
  }

  Align _buildViewResponseButoon() {
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
                    id: widget.id, question: _data.question.toString());
              },
            );
          }),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: CustomText(
        text: title,
        textAlign: TextAlign.start,
        color: AppColors.labelColor8,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSubTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor64,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    );
  }

  addAnswer(String id) async {
    try {
      // ignore: use_build_context_synchronously
      buildLoading(context);
      Map<String, dynamic> map = {
        "forum_question_id": widget.id.toString(),
        "answer_id": id
      };
      var response = await _dashboardController.addAnswer(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);

        String res = response.responseT!.body['answer_id'].toString();
        setState(() {
          _isAnswered = true;
          _data.correctAnswer = res;
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

  _addSuggestionQuestion() async {
    if (_textController.text.isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterText);
      return;
    }
    try {
      // ignore: use_build_context_synchronously
      buildLoading(context);
      Map<String, dynamic> map = {
        "suggestedQue": _textController.text,
      };
      var response = await _dashboardController.suggestQuestion(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _textController.clear();
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
