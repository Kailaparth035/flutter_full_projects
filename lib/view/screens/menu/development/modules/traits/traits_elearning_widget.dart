import 'package:aspirevue/controller/development/work_skill_controller.dart';
import 'package:aspirevue/data/model/response/development/courses_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/e_learning_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TraitsElearningWidget extends StatefulWidget {
  const TraitsElearningWidget({
    super.key,
    required this.styleId,
    required this.userId,
  });

  final String styleId;
  final String userId;

  @override
  State<TraitsElearningWidget> createState() => _TraitsElearningWidgetState();
}

class _TraitsElearningWidgetState extends State<TraitsElearningWidget> {
  final _workSkillController = Get.find<WorkSkillController>();
  @override
  void initState() {
    _workSkillController.getCoursesData(
        userId: widget.userId, styleId: widget.styleId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<WorkSkillController>(builder: (workSkillController) {
      if (workSkillController.isLoadingCourses) {
        return const Center(child: CustomLoadingWidget());
      }
      if (workSkillController.isErrorCourses ||
          workSkillController.dataCourses == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () async {
              await workSkillController.getCoursesData(
                  userId: widget.userId, styleId: widget.styleId);
            },
            text: workSkillController.isErrorCourses
                ? workSkillController.errorMsgCourses
                : AppString.somethingWentWrong,
          ),
        );
      } else if (workSkillController.dataCourses!.courses!.isEmpty) {
        return CustomErrorWidget(
          width: 40.w,
          onRetry: () async {
            await workSkillController.getCoursesData(
                userId: widget.userId, styleId: widget.styleId);
          },
          text: "No course available.",
          isShowCustomMessage: true,
          isNoData: true,
        );
      } else {
        return _buildView(workSkillController.dataCourses!);
      }
    });
  }

  Widget _buildView(CoursesListData dataCourses) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _workSkillController.getCoursesData(
              userId: widget.userId, styleId: widget.styleId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: Column(
              children: [
                ...dataCourses.courses!.map((e) => Column(
                      children: [
                        ELearningCardWidget(
                          isEnterPrise: false,
                          course: e,
                          onReload: () {
                            return _workSkillController.getCoursesData(
                                userId: widget.userId, styleId: widget.styleId);
                          },
                          userId: dataCourses.userId.toString(),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
