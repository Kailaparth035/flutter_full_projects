import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';

import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AssesmentBundleCardTwoColumns extends StatefulWidget {
  const AssesmentBundleCardTwoColumns(
      {super.key, this.data, this.assessReport});
  final BatteryBuilder? data;
  final AssessmentReport? assessReport;

  @override
  State<AssesmentBundleCardTwoColumns> createState() =>
      _AssesmentBundleCardStateTwoColumns();
}

class _AssesmentBundleCardStateTwoColumns
    extends State<AssesmentBundleCardTwoColumns> {
  bool _isChecked = false;
  @override
  void initState() {
    _isChecked = widget.data != null
        ? widget.data!.isToggleChecked == "1"
        : widget.assessReport!.isChecked == "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBoxListTile();
  }

  Container _buildBoxListTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
          boxShadow: CommonController.getBoxShadow,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: AppColors.labelColor),
          color: AppColors.white),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardTitle(),
          _buildChild1(),
        ],
      ),
    );
  }

  Widget _buildChild1() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(5.sp),
          bottomLeft: Radius.circular(5.sp),
        ),
        color: AppColors.white,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardText("Price"),
                CustomText(
                  text: widget.data != null
                      ? "\$${widget.data!.priceLabel}"
                      : "\$${widget.assessReport!.priceLabel}",
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor10,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 9.sp,
                  maxLine: 1,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildCardText("Action"),
                2.sp.sbh,
                widget.data != null
                    ? _buildToggleForData1()
                    : _buildToggleForData2()
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildToggleForData1() {
    return widget.data!.isPurchase == ""
        ? 0.sbh
        : widget.data!.isPurchase == "1"
            ? CustomButton2(
                topIconPadding: 0,
                icon: AppImages.doneGreenIc,
                buttonText: widget.data!.isPurchaseTxt.toString(),
                radius: 5.sp,
                buttonColor: AppColors.labelColor86.withOpacity(0.2),
                textColor: AppColors.labelColor40,
                padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
                fontWeight: FontWeight.w700,
                fontSize: 9.sp,
                onPressed: () {})
            : Align(
                alignment: Alignment.bottomRight,
                child: GetBuilder<StoreController>(builder: (storeController) {
                  return ToggleButtonWidget(
                    height: 16.sp,
                    width: 40.sp,
                    padding: 2.sp,
                    value: _isChecked,
                    onChange: (val) {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                      _callAPI(
                        storeController: storeController,
                        productId: widget.data!.productId.toString(),
                        type: widget.data!.type.toString(),
                        price: widget.data!.price.toString(),
                        isChecked: _isChecked == true ? "1" : "0",
                        productType: widget.data!.product.toString(),
                        session: storeController.storeData!.session.toString(),
                        promocode:
                            storeController.storeData!.promocode.toString(),
                        promoVerify:
                            storeController.storeData!.promoVerify.toString(),
                        feedbackHours:
                            storeController.storeData!.feedbackHours.toString(),
                        coachId: storeController.storeData!.coachId.toString(),
                      );
                    },
                    isShowText: false,
                    isDisable: widget.data!.isToggleDisable == "1",
                  );
                }),
              );
  }

  _buildToggleForData2() {
    return widget.assessReport!.isPurchase == ""
        ? 0.sbh
        : widget.assessReport!.isPurchase == "1"
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 5.sp),
                child: CustomButton2(
                    topIconPadding: 0,
                    icon: AppImages.doneGreenIc,
                    buttonText: widget.assessReport!.isPurchaseText.toString(),
                    radius: 5.sp,
                    buttonColor: AppColors.labelColor86.withOpacity(0.2),
                    textColor: AppColors.labelColor40,
                    padding:
                        EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
                    fontWeight: FontWeight.w700,
                    fontSize: 9.sp,
                    onPressed: () {}),
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: GetBuilder<StoreController>(builder: (storeController) {
                  return ToggleButtonWidget(
                    height: 16.sp,
                    width: 40.sp,
                    padding: 2.sp,
                    value: widget.assessReport!.isChecked == "1",
                    onChange: (val) {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                      _callAPI(
                        storeController: storeController,
                        productId: widget.assessReport!.productId.toString(),
                        type: widget.assessReport!.type.toString(),
                        price: widget.assessReport!.price.toString(),
                        isChecked: _isChecked == true ? "1" : "0",
                        productType: widget.assessReport!.product.toString(),
                        session: storeController.storeData!.session.toString(),
                        promocode:
                            storeController.storeData!.promocode.toString(),
                        promoVerify:
                            storeController.storeData!.promoVerify.toString(),
                        feedbackHours:
                            storeController.storeData!.feedbackHours.toString(),
                        coachId: storeController.storeData!.coachId.toString(),
                      );
                    },
                    isShowText: false,
                    isDisable: widget.assessReport!.isDisable == "1",
                  );
                }),
              );
  }

  CustomText _buildCardText(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor2,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 10.sp,
      maxLine: 10,
      fontWeight: FontWeight.w700,
    );
  }

  Container _buildCardTitle() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.sp),
          topRight: Radius.circular(5.sp),
        ),
        color: AppColors.labelColor15.withOpacity(0.85),
      ),
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: widget.data != null
                  ? widget.data!.productName.toString()
                  : widget.assessReport!.name.toString(),
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 9.sp,
              maxLine: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0.sp),
            child: SelfReflactViewPopUpWithChild(
                showChild: htmlChildForInfo(widget.data != null
                    ? widget.data!.description.toString()
                    : widget.assessReport!.description.toString()),
                child: Image.asset(
                  AppImages.infoIc2,
                  height: 15.sp,
                  width: 15.sp,
                )),
          )
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 2.0.sp),
          //   child: MyTooltip(
          //     message: widget.data != null
          //         ? widget.data!.description.toString()
          //         : widget.assessReport!.description.toString(),
          //     child: Image.asset(
          //       AppImages.infoIc2,
          //       height: 13.sp,
          //       width: 13.sp,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  _callAPI({
    required StoreController storeController,
    required String productId,
    required String type,
    required String price,
    required String isChecked,
    required String productType,
    required String session,
    required String promocode,
    required String promoVerify,
    required String feedbackHours,
    required String coachId,
  }) async {
    var res = await storeController.addToCardDetail(
      onReload: (loading) async {},
      productId: productId,
      type: type,
      price: price,
      isChecked: isChecked,
      productType: productType,
      session: session,
      promoCode: promocode,
      promoVerify: promoVerify,
      feedbackHours: feedbackHours,
      coachId: coachId,
      isShowSucessMessage: true,
    );

    if (res == null) {
      setState(() {
        _isChecked = !_isChecked;
      });
    }
  }
}
