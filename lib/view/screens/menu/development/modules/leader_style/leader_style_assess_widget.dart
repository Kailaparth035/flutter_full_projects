import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/leader_style_controller.dart';
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

class LeaderStyleAssessWidget extends StatefulWidget {
  const LeaderStyleAssessWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<LeaderStyleAssessWidget> createState() => _LeaderStyleAssesstState();
}

class _LeaderStyleAssesstState extends State<LeaderStyleAssessWidget> {
  final _leaderStyleController = Get.find<LeaderStyleController>();
  @override
  void initState() {
    super.initState();
    _leaderStyleController.getAssessData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<LeaderStyleController>(builder: (leaderStyleController) {
      if (leaderStyleController.isLoadingAssess) {
        return const Center(child: CustomLoadingWidget());
      }
      if (leaderStyleController.isErrorAssess ||
          leaderStyleController.dataAssess == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              leaderStyleController.getAssessData(widget.userId);
            },
            text: leaderStyleController.isErrorAssess
                ? leaderStyleController.errorMsgAssess
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(leaderStyleController.dataAssess!,
            leaderStyleController.titleListAssess);
      }
    });
  }

  Widget _buildView(TraitAssesData dataAssess, List titleListAssess) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _leaderStyleController.getAssessData(widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildBlackTitle(dataAssess.title.toString()),
                10.sp.sbh,
                buildGreyTitle(dataAssess.subTitle.toString()),
                10.sp.sbh,
                ...dataAssess.assementInstruction!.map(
                  (e) => PurchaseAssessWidget(
                    data: e,
                  ),
                ),
                10.sp.sbh,
                buildDivider(),
                buildTitleLog(titleListAssess),
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
                      SliderModel(
                        title: dataAssess.type3.toString(),
                        color: AppColors.labelColor56,
                        value: CommonController.getSliderValue(
                            e.reputScale.toString()),
                        isEnable: false,
                      ),
                    ],
                    mainTitle: e.areaName.toString(),
                    title: "",
                    bottomLeftTitle: e.leftMeaning.toString(),
                    bottomRightTitle: e.rightMeaning.toString(),
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
