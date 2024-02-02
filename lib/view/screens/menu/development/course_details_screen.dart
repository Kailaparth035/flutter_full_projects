import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/data/model/response/development/course_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/custom_wistia_player.dart';
import 'package:aspirevue/view/base/video_player_widgets/youtube_player_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/question_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen(
      {super.key,
      required this.id,
      required this.userId,
      required this.isEnterPriseCourse,
      this.courseType});
  final String id;
  final String userId;
  final bool isEnterPriseCourse;
  final String? courseType;

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  void initState() {
    _reFreshData();
    super.initState();
  }

  late Future<CourseDetailsData?> _futureCall;

  final _developmentController = Get.find<DevelopmentController>();
  final _enterPriseController = Get.find<EnterpriseController>();

  _reFreshData() async {
    setState(() {
      if (widget.isEnterPriseCourse == true) {
        _futureCall = _enterPriseController.enterpriseCourseDetails(
            widget.id, widget.courseType!);
      } else {
        _futureCall = _developmentController.courseDetails(
          widget.userId,
          widget.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: widget.isEnterPriseCourse
                ? "eLearning Course Details"
                : "eLearning Detail",
            bgColor: AppColors.white,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: FutureBuildWidget(
          onRetry: () {
            _reFreshData();
          },
          isList: false,
          future: _futureCall,
          isShowBackArrowInError: false,
          child: (CourseDetailsData? data) {
            return _buildMainView(data);
          },
        ),
      ),
    );
  }

  SafeArea _buildMainView(CourseDetailsData? data) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.isEnterPriseCourse
                ? _builCardForWistiaForEnterPrise(data)
                : _builCardForWistia(data),
            data!.attachments!.isNotEmpty
                ? Column(
                    children: [
                      10.sp.sbh,
                      _builCardForAttechment(data.attachments),
                      10.sp.sbh,
                    ],
                  )
                : 0.sbh,
            widget.isEnterPriseCourse
                ? data.questionDetail!.isNotEmpty
                    ? Column(
                        children: [
                          10.sp.sbh,
                          _builCardForQuestionList(data.questionDetail, data),
                          10.sp.sbh,
                        ],
                      )
                    : Container(
                        margin: EdgeInsets.only(
                            bottom: AppConstants.screenHorizontalPadding,
                            left: AppConstants.screenHorizontalPadding,
                            right: AppConstants.screenHorizontalPadding),
                        padding: EdgeInsets.symmetric(vertical: 0.sp),
                        decoration: BoxDecoration(
                          color: AppColors.labelColor75,
                          boxShadow: CommonController.getBoxShadow,
                          borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.isEnterPriseCourse
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10.sp),
                                        child: CustomText(
                                          text: "Quiz Questions",
                                          textAlign: TextAlign.start,
                                          color: AppColors.labelColor8,
                                          fontFamily:
                                              AppString.manropeFontFamily,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      _buildDivider(),
                                      10.sp.sbh,
                                      Center(
                                        child: CustomText(
                                          text: "No quiz questions available",
                                          textAlign: TextAlign.start,
                                          color: AppColors.black,
                                          fontFamily:
                                              AppString.manropeFontFamily,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : 0.sbh,
                            10.sp.sbh,
                          ],
                        ),
                      )
                : data.questionDetail!.isNotEmpty
                    ? Column(
                        children: [
                          10.sp.sbh,
                          _builCardForQuestionList(data.questionDetail, data),
                          10.sp.sbh,
                        ],
                      )
                    : 0.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: CustomText(
        text: title,
        textAlign: TextAlign.start,
        color: color,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _builCardForWistiaForEnterPrise(CourseDetailsData? data) {
    return Container(
      margin: EdgeInsets.only(
          bottom: AppConstants.screenHorizontalPadding,
          left: AppConstants.screenHorizontalPadding,
          right: AppConstants.screenHorizontalPadding),
      // padding:
      //     EdgeInsets.symmetric(vertical: AppConstants.screenHorizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.labelColor75,
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          5.sp.sbh,
          _buildTitle(data!.course.toString(), AppColors.secondaryColor),
          5.sp.sbh,
          _buildDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.sp),
            child: Html(
              data: data.shortDesc.toString(),
              style: {
                "*": Style(),
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.sp),
            child: Html(
              data: data.longDesc.toString(),
              style: {
                "*": Style(),
              },
            ),
          ),
          data.enterpriseVideoLink!.isNotEmpty
              ? Column(
                  children: [
                    5.sp.sbh,
                    ...data.enterpriseVideoLink!
                        .map((e) => _buildVideoCondition(e))
                  ],
                )
              : 0.sbh
        ],
      ),
    );
  }

  Widget _builCardForWistia(CourseDetailsData? data) {
    return Container(
      margin: EdgeInsets.only(
          bottom: AppConstants.screenHorizontalPadding,
          left: AppConstants.screenHorizontalPadding,
          right: AppConstants.screenHorizontalPadding),
      padding:
          EdgeInsets.symmetric(vertical: AppConstants.screenHorizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.labelColor75,
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(data!.course.toString(), AppColors.secondaryColor),
          5.sp.sbh,
          _buildDivider(),
          Html(
            data: data.description.toString(),
            style: {
              "*": Style(),
            },
          ),
          5.sp.sbh,
          data.videoLink.toString() == ""
              ? 0.sbh
              : _buildWistiaVideoView(data.videoLink.toString())
        ],
      ),
    );
  }

  Widget _buildVideoCondition(VideoLink enterpriseVideoLink) {
    if (enterpriseVideoLink.videoType.toString().toLowerCase() == "wistia") {
      return Padding(
        padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp),
        child: CustomWistiaPlayer(url: enterpriseVideoLink.videoUrl.toString()),
      );
    } else if (enterpriseVideoLink.videoType.toString().toLowerCase() ==
        "youtube") {
      return Padding(
        padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp),
        child:
            YoutubePlayerWidget(url: enterpriseVideoLink.videoUrl.toString()),
      );
    } else {
      return Text("not created ${enterpriseVideoLink.videoType}");
    }
  }

  Widget _buildWistiaVideoView(String url) {
    // return Container(
    //   margin: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10.sp),
    //     border: Border.all(
    //       color: AppColors.labelColor,
    //     ),
    //   ),
    //   child: SizedBox(
    //     width: context.getWidth,
    //     height: 25.h,
    //     child: ClipRRect(
    //         borderRadius: BorderRadius.circular(9.sp),
    //         child: WebViewWidgetView(url: url)),
    //   ),
    // );

    return Padding(
      padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp),
      child: CustomWistiaPlayer(url: url),
    );
  }

  Widget _builButton(CourseAttachment e) {
    return CustomButton2(
        buttonColor: AppColors.labelColor15,
        textColor: AppColors.white,
        icon: AppImages.uploadIc,
        buttonText: e.attachmentTitle.toString(),
        radius: 5.sp,
        padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
        fontWeight: FontWeight.w600,
        fontSize: 11.sp,
        onPressed: () {
          CommonController.downloadFile(e.attachmentUrl.toString(), context);
        });
  }

  Widget _builCardForAttechment(List<CourseAttachment>? attachments) {
    return Container(
      margin: EdgeInsets.only(
          bottom: AppConstants.screenHorizontalPadding,
          left: AppConstants.screenHorizontalPadding,
          right: AppConstants.screenHorizontalPadding),
      padding:
          EdgeInsets.symmetric(vertical: AppConstants.screenHorizontalPadding),
      decoration: BoxDecoration(
        color: AppColors.labelColor75,
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle("Attachment", AppColors.black),
          5.sp.sbh,
          _buildDivider(),
          10.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Wrap(
              spacing: 5.sp,
              runSpacing: 5.sp,
              children: [
                ...attachments!.map(
                  (e) => _builButton(e),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builCardForQuestionList(
      List<QuestionDetail>? questionDetail, CourseDetailsData? data) {
    return Container(
      margin: EdgeInsets.only(
          bottom: AppConstants.screenHorizontalPadding,
          left: AppConstants.screenHorizontalPadding,
          right: AppConstants.screenHorizontalPadding),
      padding: EdgeInsets.symmetric(vertical: 0.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor75,
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isEnterPriseCourse
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: CustomText(
                        text: "Quiz Questions",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor8,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _buildDivider(),
                    10.sp.sbh,
                  ],
                )
              : 10.sbh,
          ...questionDetail!.map(
            (e) {
              int index = questionDetail.indexOf(e);
              bool isLast = questionDetail.length - 1 == index;
              return _buildQuesion(e, isLast);
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: 10.sp),
              child: CustomButton2(
                  buttonText: "Submit",
                  radius: 5.sp,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  fontWeight: FontWeight.w700,
                  fontSize: 11.sp,
                  onPressed: () {
                    if (widget.isEnterPriseCourse) {
                      _submitForEnterPrise(questionDetail, data!.saveExternal);
                    } else {
                      _submit(questionDetail);
                    }
                  }),
            ),
          ),
          10.sp.sbh,
        ],
      ),
    );
  }

  Widget _buildQuesion(QuestionDetail ques, bool islast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(ques.question.toString(), AppColors.black),
        10.sp.sbh,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          child: Column(
            children: [
              ...ques.options!.map((e) => QuestionListTileWidget(
                    onTap: () {
                      for (var element in ques.options!) {
                        element.isSelected = false;
                      }
                      setState(() {
                        e.isSelected = true;
                      });
                    },
                    isAnswered: false,
                    lable: e.answerId.toString(),
                    question: e.value.toString(),
                    borderColor: AppColors.labelColor9,
                    bgColor: e.isSelected == true
                        ? AppColors.circlepink
                        : AppColors.white,
                    fontSize: 12.sp,
                    isColored: false,
                    isSelected: e.isSelected,
                  ))
            ],
          ),
        ),
        5.sp.sbh,
        !islast ? _buildDivider() : 0.sp.sbh,
        10.sp.sbh,
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

  _submit(List<QuestionDetail>? items) async {
    Map<String, dynamic> map = {
      "course_id": widget.id,
      "user_id": widget.userId,
      "answer_list": [],
    };
    for (var item in items!) {
      var opitons =
          item.options!.where((element) => element.isSelected == true).toList();
      if (opitons.isEmpty) {
        showCustomSnackBar("all question is required!");
        return;
      } else {
        Map<String, dynamic> mapQuestion = {
          "question_id": item.questionId,
          "answer_id": opitons.first.answerId,
        };

        List list = map["answer_list"] as List;
        list.add(mapQuestion);
      }
    }

    bool? result =
        await _developmentController.saveCourseQuestionAnswer(map: map);

    if (result != null && result == true) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    }
  }

  _submitForEnterPrise(List<QuestionDetail>? items, int? saveEnternal) async {
    Map<String, dynamic> map = {
      "course_type": widget.courseType,
      "save_external": saveEnternal != null ? saveEnternal.toString() : "",
      "course_id": widget.id,
      "user_id": widget.userId,
      "answer_list": [],
    };

    for (var item in items!) {
      var opitons =
          item.options!.where((element) => element.isSelected == true).toList();
      if (opitons.isEmpty) {
        showCustomSnackBar("all question is required!");
        return;
      } else {
        Map<String, dynamic> mapQuestion = {
          "question_id": item.questionId,
          "answer_id": opitons.first.answerId,
        };

        List list = map["answer_list"] as List;
        list.add(mapQuestion);
      }
    }

    bool? result = await _enterPriseController.saveQuizQuestionAnswer(map: map);

    if (result != null && result == true) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    }
  }
}
