import 'package:aspirevue/controller/development/behaviors_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/behaviors_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/emotions_checkbox_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BehaviorsSelfReflectionWidget extends StatefulWidget {
  const BehaviorsSelfReflectionWidget({
    super.key,
    required this.userId,
  });
  final String userId;
  @override
  State<BehaviorsSelfReflectionWidget> createState() =>
      _BehaviorsSelfReflectionWidgetState();
}

class _BehaviorsSelfReflectionWidgetState
    extends State<BehaviorsSelfReflectionWidget> {
  final _behaviorsController = Get.find<BehaviorsController>();

  @override
  void initState() {
    super.initState();
    _behaviorsController.getSelfReflactData(true, widget.userId);
  }

  bool _isViewMore = true;

  changeTabType(type) {
    setState(() {
      _isViewMore = !type;
    });
  }

  _callAPICheckbox(
      DevelopmentController controller, SliderData data, String checkboxValue,
      {String type = ""}) async {
    controller.updateSelfReflaction(
      styleId: data.styleId.toString(),
      areaId: data.areaId.toString(),
      isMarked: checkboxValue,
      markingType: data.markingType.toString(),
      stylrParentId: data.stylrParentId.toString(),
      radioType: data.radioType.toString(),
      newScore: data.idealScale.toString(),
      onReaload: (isloading) async {
        // await widget.onReaload(isloading, _isViewMore ? "2" : "1");
        _behaviorsController.getSelfReflactData(true, widget.userId,
            tabType: _isViewMore ? "2" : "1");
      },
      ratingType: _behaviorsController.dataSelfReflact!.ratingType.toString(),
      userId: _behaviorsController.dataSelfReflact!.userId.toString(),
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<BehaviorsController>(builder: (behaviorsController) {
      if (behaviorsController.isLoadingSelfReflact) {
        return const Center(child: CustomLoadingWidget());
      }
      if (behaviorsController.isErrorSelfReflact ||
          behaviorsController.dataSelfReflact == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              behaviorsController.getSelfReflactData(true, widget.userId);
            },
            text: behaviorsController.isErrorSelfReflact
                ? behaviorsController.errorMsgSelfReflact
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(behaviorsController.dataSelfReflact!);
      }
    });
  }

  CustomSlideUpAndFadeWidget _buildView(
      BehaviorSelfReflectDetailsData dataSelfReflact) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          changeTabType(false);
          return _behaviorsController.getSelfReflactData(true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: GetBuilder<DevelopmentController>(builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitleWithAns(
                      "ASPIRATIONAL IDENTITY: WHAT ARE YOU CAPABLE OF?  ",
                      "An individual’s personal and professional identity is both expressed and established by the actions they choose. From the list below, select between 5 and 10 potential identities that most resonate with the better or ideal version of your Self, representing how you also would like to be known by others:",
                      align: TextAlign.center),
                  10.sp.sbh,
                  buildButtonHowdo(
                      title: "Defining Identity Through My Top 10 Behaviors"),
                  10.sp.sbh,
                  buildTitleWithBG("Check frequent behaviors:"),
                  10.sp.sbh,
                  _buildNegativeView(controller, dataSelfReflact),
                  10.sp.sbh,
                  CustomButton2(
                      buttonText: _isViewMore ? "View More" : "View Less",
                      radius: 5.sp,
                      width: context.getWidth,
                      padding: EdgeInsets.symmetric(
                          vertical: 7.sp, horizontal: 10.sp),
                      fontWeight: FontWeight.w600,
                      fontSize: 11.sp,
                      onPressed: () {
                        changeTabType(_isViewMore);
                        // widget.onReaload(true, _isViewMore ? "2" : "1");
                        _behaviorsController.getSelfReflactData(
                            true, widget.userId,
                            tabType: _isViewMore ? "2" : "1");
                      })
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildNegativeView(DevelopmentController controller,
      BehaviorSelfReflectDetailsData dataSelfReflact) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.sp),
      child: AlignedGridView.count(
          crossAxisSpacing: 5.sp,
          mainAxisSpacing: 5.sp,
          crossAxisCount: 3,
          shrinkWrap: true,
          primary: false,
          itemCount: dataSelfReflact.checkboxList!.length,
          itemBuilder: (context, index) => EmotionsCheckboxListtile(
              feelingCount: "",
              isReset: controller.isReset,
              title: dataSelfReflact.checkboxList![index].areaName.toString(),
              isChecked: dataSelfReflact.checkboxList![index].isMarked == "1",
              onChange: (val) {
                _callAPICheckbox(
                  controller,
                  dataSelfReflact.checkboxList![index],
                  val == true ? "1" : "0".toString(),
                  type: "",
                );
              })),
    );
  }
}
