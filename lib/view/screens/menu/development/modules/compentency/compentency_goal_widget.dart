import 'package:aspirevue/controller/development/compentencies_controller.dart';
import 'package:aspirevue/data/model/response/development/comp_goal_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/comp_goal_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CompentancyGoalWidget extends StatefulWidget {
  const CompentancyGoalWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<CompentancyGoalWidget> createState() => CompentancyGoalWidgetState();
}

class CompentancyGoalWidgetState extends State<CompentancyGoalWidget> {
  final _compentenciesController = Get.find<CompentenciesController>();

  @override
  void initState() {
    super.initState();
    _compentenciesController.getGoalData(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CompentenciesController>(
        builder: (conpentenciesController) {
      if (conpentenciesController.isLoadingGoal) {
        return const Center(child: CustomLoadingWidget());
      }
      if (conpentenciesController.isErrorGoal ||
          conpentenciesController.dataGoal == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              conpentenciesController.getGoalData(true, widget.userId);
            },
            text: conpentenciesController.isErrorGoal
                ? conpentenciesController.errorMsgGoal
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return buildView(
          conpentenciesController.dataGoal!,
        );
      }
    });
  }

  Widget buildView(CompGoalDetailsData dataGoal) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _compentenciesController.getGoalData(true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlackTitle(
                    "Prioritizing and Selecting Development Objectives"),
                5.sp.sbh,
                buildGreyTitle(
                    "Potential development objectives have been created and listed below. They are based on your targeted goals. PRIORITIZE those goals that are most important to you and PUBLISH at least one goal to create a development objective for intentional priority and action. Published items will also appear in your list of Development objectives as well as on your DailyQ."),
                20.sp.sbh,
                ...dataGoal.sliderList!.map((e) => CompGoalCardWidget(
                      data: e,
                      styleId: dataGoal.styleId ?? "",
                      userId: dataGoal.userId ?? "",
                      onReaload: (val) async {
                        _compentenciesController.getGoalData(
                            val, widget.userId);
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
