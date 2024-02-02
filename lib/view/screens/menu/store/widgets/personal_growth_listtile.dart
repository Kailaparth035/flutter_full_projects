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

class PersonalGrowthListtile extends StatefulWidget {
  const PersonalGrowthListtile({super.key, required this.data});
  final SubscriptionList data;
  @override
  State<PersonalGrowthListtile> createState() => _PersonalGrowthListtileState();
}

class _PersonalGrowthListtileState extends State<PersonalGrowthListtile> {
  bool _isChecked = false;

  bool _isAutoRenewChecked = false;

  @override
  void initState() {
    _isChecked = widget.data.isChecked == "1";
    _isAutoRenewChecked = widget.data.autoRenewChecked == "1";

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
          _buildChild2(),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCardText("Available To :"),
              _buildCardText("Purchase"),
            ],
          ),
          3.sp.sbh,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomButton2(
                      buttonText: widget.data.availableTo.toString(),
                      radius: 5.sp,
                      buttonColor: AppColors.secondaryColor.withOpacity(0.1),
                      textColor: AppColors.secondaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 3.sp, horizontal: 5.sp),
                      fontWeight: FontWeight.w700,
                      fontSize: 9.sp,
                      onPressed: () {}),
                ),
              ),
              5.sp.sbw,
              widget.data.isPurchase == "0"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          text: "\$${widget.data.priceLabel}/ mo",
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor14,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 10.sp,
                          maxLine: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        3.sp.sbh,
                        GetBuilder<StoreController>(builder: (storeController) {
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
                                productId: widget.data.productId.toString(),
                                type: widget.data.type.toString(),
                                price: widget.data.price.toString(),
                                isChecked: _isChecked == true ? "1" : "0",
                                productType: widget.data.product.toString(),
                                session: storeController.storeData!.session
                                    .toString(),
                                promocode: storeController.storeData!.promocode
                                    .toString(),
                                promoVerify: storeController
                                    .storeData!.promoVerify
                                    .toString(),
                                feedbackHours: storeController
                                    .storeData!.feedbackHours
                                    .toString(),
                                coachId: storeController.storeData!.coachId
                                    .toString(),
                              );
                            },
                            isShowText: false,
                            isDisable: false,
                          );
                        }),

                        // 5.sp.sbw,
                      ],
                    )
                  : widget.data.isPurchase == ""
                      ? CustomText(
                          text: "-          ",
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor14,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 10.sp,
                          maxLine: 10,
                          fontWeight: FontWeight.w500,
                        )
                      : CustomButton2(
                          icon: AppImages.doneGreenIc,
                          buttonText: widget.data.text.toString(),
                          radius: 5.sp,
                          buttonColor: AppColors.labelColor86.withOpacity(0.2),
                          textColor: AppColors.labelColor40,
                          padding: EdgeInsets.symmetric(
                              vertical: 3.sp, horizontal: 5.sp),
                          fontWeight: FontWeight.w700,
                          fontSize: 9.sp,
                          onPressed: () {}),
            ],
          ),
          3.sp.sbh,
        ],
      ),
    );
  }

  Widget _buildChild2() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(5.sp),
          bottomLeft: Radius.circular(5.sp),
        ),
        color: AppColors.grayColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCardText("Renewal Date"),
              _buildCardText("Auto-Renew"),
            ],
          ),
          3.sp.sbh,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.data.renewalDate == "Expired"
                  ? CustomButton2(
                      icon: AppImages.warningIc,
                      buttonText: "Expired",
                      radius: 5.sp,
                      buttonColor: AppColors.redColor.withOpacity(0.1),
                      textColor: AppColors.redColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 3.sp, horizontal: 5.sp),
                      fontWeight: FontWeight.w700,
                      fontSize: 9.sp,
                      onPressed: () {})
                  : CustomText(
                      text: widget.data.renewalDate.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor10,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 9.sp,
                      maxLine: 10,
                      fontWeight: FontWeight.w600,
                    ),
              widget.data.autoRenewShow == "0"
                  ? CustomText(
                      text: "-          ",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor14,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      maxLine: 10,
                      fontWeight: FontWeight.w500,
                    )
                  : GetBuilder<StoreController>(builder: (storeController) {
                      return ToggleButtonWidget(
                        height: 16.sp,
                        width: 40.sp,
                        padding: 2.sp,
                        value: _isAutoRenewChecked,
                        onChange: (val) {
                          setState(() {
                            _isAutoRenewChecked = !_isAutoRenewChecked;
                          });
                          _renewProduct(
                              storeController: storeController,
                              productId: widget.data.productId.toString(),
                              autoRenewChecked:
                                  _isAutoRenewChecked == true ? "1" : "0");
                        },
                        isShowText: false,
                        isDisable: false,
                      );
                    }),
            ],
          )
        ],
      ),
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
              text: widget.data.growthOption.toString(),
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 2.0.sp),
          //   child: MyTooltip(
          //     message: widget.data.tooltipDesc.toString(),
          //     child: Image.asset(
          //       AppImages.infoIc2,
          //       height: 15.sp,
          //       width: 15.sp,
          //     ),
          //   ),
          // )

          Align(
            alignment: Alignment.centerRight,
            child: SelfReflactViewPopUpWithChild(
                showChild: htmlChildForInfo(widget.data.tooltipDesc.toString()),
                child: Image.asset(
                  AppImages.infoIc2,
                  height: 15.sp,
                  width: 15.sp,
                )),
          )
          // Align(
          //   alignment: Alignment.centerRight,
          //   child: SelfReflactViewPopUp(
          //       isHtml: false,
          //       title: "Description",
          //       desc: parseHtmlString(widget.data.tooltipDesc.toString()),
          //       child: Image.asset(
          //         AppImages.infoIc2,
          //         height: 15.sp,
          //         width: 15.sp,
          //       )),
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

  _renewProduct({
    required StoreController storeController,
    required String productId,
    required String autoRenewChecked,
  }) async {
    var res = await storeController.renewProduct(
      onReaload: (loading) async {},
      productId: productId,
      autoRenewChecked: autoRenewChecked,
    );

    if (res == null) {
      setState(() {
        _isAutoRenewChecked = !_isAutoRenewChecked;
      });
    }
  }
}
