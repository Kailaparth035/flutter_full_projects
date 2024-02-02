import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/cognitive_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_table_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_assess_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/title_3_slider_2_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CognitiveAssessWidget extends StatefulWidget {
  const CognitiveAssessWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<CognitiveAssessWidget> createState() => _CognitiveAssesstState();
}

class _CognitiveAssesstState extends State<CognitiveAssessWidget> {
  final _cognitiveController = Get.find<CognitiveController>();

  @override
  void initState() {
    super.initState();
    _cognitiveController.getAssessData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CognitiveController>(builder: (cognitiveController) {
      if (cognitiveController.isLoadingAssess) {
        return const Center(child: CustomLoadingWidget());
      }
      if (cognitiveController.isErrorAssess ||
          cognitiveController.dataAssess == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              cognitiveController.getAssessData(widget.userId);
            },
            text: cognitiveController.isErrorAssess
                ? cognitiveController.errorMsgAssess
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(cognitiveController.dataAssess!, cognitiveController);
      }
    });
  }

  Widget _buildView(
      TraitAssesData dataAssess, CognitiveController cognitiveController) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return cognitiveController.getAssessData(widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dataAssess.title.toString() != ""
                    ? buildBlackTitle(dataAssess.title.toString())
                    : 0.sbh,
                dataAssess.title.toString() != "" ? 10.sp.sbh : 0.sbh,
                dataAssess.subTitle.toString() != ""
                    ? buildGreyTitle(dataAssess.subTitle.toString())
                    : 0.sbh,
                dataAssess.subTitle.toString() != "" ? 10.sp.sbh : 0.sbh,
                ...dataAssess.assementInstruction!
                    .map((e) => PurchaseAssessWidget(
                          data: e,
                        )),
                dataAssess.assementInstruction!.isNotEmpty ? 10.sp.sbh : 0.sbh,
                buildDivider(),
                buildTitleLog(cognitiveController.titleListAsssess),
                buildDivider(),
                15.sp.sbh,
                ...dataAssess.sliderList!.map(
                  (e) => TitleSliderAndBottom2Title(
                    list: [
                      SliderModel(
                        interval: 0.01,
                        title: dataAssess.type1.toString(),
                        color: AppColors.labelColor62,
                        value: CommonController.getSliderValue(
                            e.assessScale.toString()),
                        isEnable: false,
                      ),
                      SliderModel(
                        title: dataAssess.type2.toString(),
                        color: AppColors.labelColor57,
                        value: CommonController.getSliderValue(
                            e.reaslScale.toString()),
                        isEnable: false,
                      ),
                    ],
                    mainTitle: e.areaName.toString(),
                    title: e.leftMeaning.toString(),
                    bottomLeftTitle: "",
                    bottomRightTitle: "",
                    isReset: false,
                  ),
                ),
                dataAssess.assessmentPdf!.isNotEmpty
                    ? DevelopmentTableWidget(
                        title1: "Product Name",
                        title2: "Created Date",
                        title3: "PDF",
                        list: [
                          ...dataAssess.assessmentPdf!.map(
                            (e) => {
                              "donwload_url": e.pdf,
                              "title1": e.productName.toString(),
                              "title2": e.createdDate.toString(),
                              "title3": e.pdf!.split("/").last,
                            },
                          )
                        ],
                      )
                    : 0.sbh,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
