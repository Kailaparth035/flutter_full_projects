import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/assment_bundle_card_widget.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/assment_bundle_card_widget_two.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/package_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class StoreSecondPage extends StatefulWidget {
  const StoreSecondPage({super.key, required this.onNext});
  final Function(bool) onNext;

  @override
  State<StoreSecondPage> createState() => _StoreSecondPageState();
}

class _StoreSecondPageState extends State<StoreSecondPage> {
  bool _isActive = true;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return RefreshIndicator(
        onRefresh: () async {
          return await storeController.getStoreDetails(true);
        },
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.sp.sbh,
            buildTop2TitleText("Assessment", ""),
            10.sp.sbh,
            buildToggleButton(
              title1: "Packages",
              title2: "Individual Tests",
              isActive: _isActive,
              onToggle: _changeToggle,
            ),
            15.sp.sbh,
            _isActive
                ? _buildViewOne(storeController.storeData!)
                : _buildViewTwo(storeController.storeData!),
            // 5.sp.sbh,
            _previousNextButton(),
            60.sp.sbh,
          ],
        )),
      );
    });
  }

  _changeToggle(bool val) {
    setState(() {
      _isActive = val;
    });
  }

  Widget _buildViewOne(StoreDetailData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubWidgetTitle("Assessment Packages - Save by Bundling!"),
        5.sp.sbh,
        _buildSubWidgetSubTitle(
            "Gain insight and support by leveraging the value of assessment and coaching! On the next tab, you will choose a qualified coach to debrief your results. You will then be ready to establish an action plan that supports your continued growth."),
        10.sp.sbh,
        AlignedGridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          mainAxisSpacing: 10.sp,
          crossAxisSpacing: 10.sp,
          primary: false,
          itemCount: data.packages!.length,
          itemBuilder: (context, index) =>
              PackageGridTile(package: data.packages![index]),
        ),
        10.sp.sbh,
        data.batteryBuilder!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...data.batteryBuilder!.map(
                    (e) => AssesmentBundleCardTwoColumns(data: e),
                  ),
                ],
              )
            : 0.sbh
      ],
    );
  }

  CustomText _buildSubWidgetSubTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w400,
      fontSize: 10.sp,
      color: AppColors.labelColor15,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  CustomText _buildSubWidgetTitle(String title, {double? fontSize}) {
    return CustomText(
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? 11.sp,
      color: AppColors.labelColor14,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Widget _buildViewTwo(StoreDetailData? data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSubWidgetTitle("Featured Tests"),
        5.sp.sbh,
        _buildSubWidgetSubTitle(
            "Pricing includes online test administration, an assessment report, and a brief coaching feedback session with a qualified coach to understand the results."),
        10.sp.sbh,
        ...data!.individualTest!.map(
          (e) => AssesmentBundleCard(data: e),
        ),
        10.sp.sbh,
        _buildSubWidgetTitle("Stand-Alone Tests"),
        5.sp.sbh,
        _buildSubWidgetSubTitle(
            "Select from a list of popular assessments to target self-awareness. You will receive a test administration link as well as an assessment report."),
        10.sp.sbh,
        ...data.assessmentReport!.map(
          (e) => AssesmentBundleCardTwoColumns(assessReport: e),
        ),
      ],
    );
  }

  Widget _previousNextButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton2(
            icon: AppImages.whiteBackArrowIc,
            buttonText: "Previous",
            radius: 3.sp,
            padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 7.sp),
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            onPressed: () {
              widget.onNext(false);
            }),
        CustomButton2(
            endIcon: AppImages.whiteForwardArrowIc,
            buttonText: "Next",
            radius: 3.sp,
            padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 12.sp),
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            onPressed: () {
              widget.onNext(true);
            }),
      ],
    );
  }
}
