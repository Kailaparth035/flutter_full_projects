import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/behaviors_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/targating_textbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BehaviorsAspirevueTrainingWidget extends StatefulWidget {
  const BehaviorsAspirevueTrainingWidget({
    super.key,
    required this.userId,
  });
  final String userId;
  @override
  State<BehaviorsAspirevueTrainingWidget> createState() =>
      BbehaviorsAspirevueTrainingtState();
}

class BbehaviorsAspirevueTrainingtState
    extends State<BehaviorsAspirevueTrainingWidget> {
  final _behaviorsController = Get.find<BehaviorsController>();

  @override
  void initState() {
    super.initState();
    _behaviorsController.getTargetingDetails(widget.userId);
  }

  final List<Map<String, String>> _itentiList = [
    {
      "title": "Asserter",
      "sub_title":
          "Asks for what I need. Remains present during conflict. Increases the intensity of enforcing my boundaries.",
    },
    {
      "title": "Responder",
      "sub_title":
          "Delays before reacting, identifies and describes emotions. Makes a plan, then delivers on that plan.",
    },
    {
      "title": "Exerciser",
      "sub_title":
          "Takes the stairs instead of the elevator. Sets out my shoes and workout clothes the night before.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<BehaviorsController>(builder: (behaviorsController) {
      if (behaviorsController.isLoadingTarget) {
        return const Center(child: CustomLoadingWidget());
      }
      if (behaviorsController.isErrorTarget ||
          behaviorsController.dataTarget == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              _behaviorsController.getTargetingDetails(widget.userId);
            },
            text: behaviorsController.isErrorTarget
                ? behaviorsController.errorMsgTarget
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return Stack(
          children: [
            _buildView(behaviorsController.dataTarget!,
                behaviorsController.titleListTarget, behaviorsController),
            behaviorsController.dataTarget!.isJourneyLicensePurchased == 0
                ? PurchasePopupWidget(
                    text: behaviorsController
                        .dataTarget!.journeyLicensePurchaseText
                        .toString(),
                  )
                : 0.sbh
          ],
        );
      }
    });
  }

  Widget _buildView(TraitAssesData dataTarget, List titleListTarget,
      BehaviorsController behaviorsController) {
    return GestureDetector(
      onTap: () => CommonController.hideKeyboard(context),
      child: CustomSlideUpAndFadeWidget(
        child: RefreshIndicator(
          onRefresh: () {
            return _behaviorsController.getTargetingDetails(widget.userId);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
              child: GetBuilder<DevelopmentController>(builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.sp.sbh,
                    buildBlackTitle("Targeting My Ideal Self at My Best"),
                    5.sp.sbh,
                    buildGreyTitle(
                        "When we intend to do something different, we mentally create a different story that moves us toward our ideal self. For each of Aspirational Identities below, imagine a clear picture of “Me at my Best” and complete the statement, describing specific actions that express that identity."),
                    5.sp.sbh,
                    buildGreyTitle("Here are some examples:"),
                    10.sp.sbh,
                    _buildHeader(),
                    3.sp.sbh,
                    ..._itentiList.map((e) => _buildListtile(
                        e["title"].toString(), e["sub_title"].toString())),
                    10.sp.sbh,
                    ...dataTarget.sliderList!.map((e) => TargatingTextboxWidget(
                        data: e,
                        userId: dataTarget.userId.toString(),
                        isReset: controller.isReset))
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildHeader() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
        decoration: BoxDecoration(
          color: AppColors.labelColor19,
          boxShadow: CommonController.getBoxShadow,
        ),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: CustomText(
                text: "Aspirational Identity",
                textAlign: TextAlign.start,
                color: AppColors.labelColor14,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 10.sp,
                maxLine: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomText(
                text: "I am the type of person who.",
                textAlign: TextAlign.start,
                color: AppColors.labelColor14,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 10.sp,
                maxLine: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ));
  }

  Container _buildListtile(String title, String subTitle) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: CustomText(
                text: title,
                textAlign: TextAlign.start,
                color: AppColors.labelColor14,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              flex: 2,
              child: CustomText(
                text: subTitle,
                textAlign: TextAlign.start,
                color: AppColors.labelColor15,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ));
  }
}
