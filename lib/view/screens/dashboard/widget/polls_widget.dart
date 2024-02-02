import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/data/model/response/forum_poll_listing_for_dashboard_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/forum_poll_shimmer_widget.dart';
import 'package:aspirevue/view/screens/dashboard/question_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PollsWidget extends StatefulWidget {
  const PollsWidget({super.key});

  @override
  State<PollsWidget> createState() => _PollsWidgetState();
}

class _PollsWidgetState extends State<PollsWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (controller) {
      return _buildList(controller);
    });
  }

  _buildList(DashboardController controller) {
    return controller.isLoadingForumPoll == true
        ? const ForumPollShimmerWidget(count: 3)
        : controller.isErrorForumPoll == true
            ? Center(
                child: CustomErrorWidget(
                    width: 20.h,
                    onRetry: () {
                      controller.getForumPollQuestionAnswer({});
                    },
                    text: controller.errorMsgForumPoll),
              )
            : controller.forumPollButlletsList.isEmpty
                ? Center(
                    child: CustomNoDataFoundWidget(
                      topPadding: 0.h,
                      height: 5.h,
                    ),
                  )
                : _buildForumList(controller);
  }

  ListView _buildForumList(DashboardController controller) {
    return ListView.builder(
        itemCount: controller.forumPollButlletsList.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return _buildListTile(controller.forumPollButlletsList[index]);
        });
  }

  InkWell _buildListTile(ForumDataForDashboard data) {
    return InkWell(
      onTap: () {
        Get.to(() => QuestionDetailScreen(
              id: data.id.toString(),
            ));
      },
      child: Container(
        margin: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.sp),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ]),
        child: Container(
          padding: EdgeInsets.all(5.sp),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.labelColor63),
            gradient: LinearGradient(
              colors: [
                AppColors.secondaryColor.withOpacity(0.23),
                AppColors.primaryColor.withOpacity(0.23),
                AppColors.primaryColor.withOpacity(0.23),
              ],
            ),
            borderRadius: BorderRadius.circular(5.sp),
          ),
          child: CustomText(
            color: AppColors.black,
            text: data.question.toString(),
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
