import 'dart:math';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development/emotions_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/data/model/response/development/emotions_assess_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_table_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_title_3_box_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_assess_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/title_3_slider_2_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EmotionsAssessWidget extends StatefulWidget {
  const EmotionsAssessWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<EmotionsAssessWidget> createState() => _EmotionsAssesstState();
}

class _EmotionsAssesstState extends State<EmotionsAssessWidget> {
  final _emotionsController = Get.find<EmotionsController>();
  @override
  void initState() {
    super.initState();
    _emotionsController.getAssessData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<EmotionsController>(builder: (emotionsController) {
      if (emotionsController.isLoadingAssess) {
        return const Center(child: CustomLoadingWidget());
      }
      if (emotionsController.isErrorAssess ||
          emotionsController.dataAssess == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              emotionsController.getAssessData(widget.userId);
            },
            text: emotionsController.isErrorAssess
                ? emotionsController.errorMsgAssess
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(
            emotionsController.dataAssess!, emotionsController.titleListAssess);
      }
    });
  }

  Widget _buildView(EmotionsAssesData dataAssess, List titleListAssess) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _emotionsController.getAssessData(widget.userId);
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
                ...dataAssess.assementInstruction!
                    .map((e) => PurchaseAssessWidget(
                          data: e,
                        )),
                buildDivider(),
                buildTitleLog(titleListAssess),
                buildDivider(),
                10.sp.sbh,
                ...dataAssess.sliderList!.map((e) {
                  return Column(
                    children: [
                      DevelopmentTitle3BoxWidget(
                        type: 3,
                        title: e.title.toString(),
                        fontColor: _getRamdomColor(
                                    dataAssess.sliderList!.indexOf(e)) ==
                                null
                            ? AppColors.white
                            : AppColors.labelColor8,
                        bgColor:
                            _getRamdomColor(dataAssess.sliderList!.indexOf(e)),
                        reputationValue: e.repurationCount ?? "",
                        selfReflactionValue: e.reflactionCount ?? "",
                        assessValue: e.assessCount ?? "",
                        myTargetValue: "",
                      ),
                      10.sp.sbh,
                      ...e.value!.map((e) => TitleSliderAndBottom2Title(
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
                            title: e.leftMeaning.toString(),
                            bottomLeftTitle: "",
                            bottomRightTitle: "",
                            isReset: false,
                          ))
                    ],
                  );
                }),
                5.sp.sbh,
                AlignedGridView.count(
                  crossAxisSpacing: 5.sp,
                  mainAxisSpacing: 2.sp,
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  primary: false,
                  itemCount: dataAssess.checkboxListForAssess!.length,
                  itemBuilder: (context, index) => Text(
                    dataAssess.checkboxListForAssess![index].areaName
                        .toString(),
                  ),
                ),
                5.sp.sbh,
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

                // DevelopmentSliderWithTitle(
                //   onChange: (val) {},
                //   sliderValue: 50,
                //   title: "Loss of enthusiasm, passion and a sense of urgency",
                //   middleTitle: "Loss of enthusiasm, passio",
                //   topBgColor: AppColors.labelColor15.withOpacity(0.85),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CustomText _buildTitle() {
  //   return CustomText(
  //     text: "Emotions Profile: How do I compare to others?",
  //     textAlign: TextAlign.start,
  //     color: AppColors.black,
  //     fontFamily: AppString.manropeFontFamily,
  //     fontSize: 11.sp,
  //     maxLine: 500,
  //     fontWeight: FontWeight.w600,
  //   );
  // }

  // CustomText _buildTextDescription(String title) {
  //   return CustomText(
  //     text: title,
  //     textAlign: TextAlign.start,
  //     color: AppColors.labelColor15,
  //     fontFamily: AppString.manropeFontFamily,
  //     fontSize: 10.sp,
  //     maxLine: 500,
  //     fontWeight: FontWeight.w600,
  //   );
  // }

  Color? _getRamdomColor(int index) {
    switch (index) {
      case 0:
        return null;

      default:
        return _colorArray[random(0, 8)];
    }
  }

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  final List _colorArray = [
    AppColors.labelColor71,
    AppColors.labelColor72,
    AppColors.labelColor73,
    AppColors.labelColor71,
    AppColors.labelColor72,
    AppColors.labelColor73,
    AppColors.labelColor71,
    AppColors.labelColor72,
    AppColors.labelColor73
  ];
}
