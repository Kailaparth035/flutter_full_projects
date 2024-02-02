import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PackageGridTile extends StatefulWidget {
  const PackageGridTile({super.key, required this.package});
  final Package package;
  @override
  State<PackageGridTile> createState() => _PackageGridTileState();
}

class _PackageGridTileState extends State<PackageGridTile> {
  bool _isChecked = false;

  @override
  void initState() {
    _isChecked = widget.package.isActionChecked.toString() == "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildGridTile();
  }

  Widget _buildGridTile() {
    return Container(
      decoration: BoxDecoration(
        gradient: CommonController.getLinearGradientSecondryAndPrimary(),
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.5.sp),
        child: Container(
          height: context.getWidth * 0.60,
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(11.sp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7.sp),
                    topRight: Radius.circular(7.sp),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        color: getColor(widget.package.packageType.toString()),
                        child: Center(
                          child: Image.asset(
                            AppImages.packageIc,
                            height: 30.sp,
                          ),
                        ),
                      ),
                      // Positioned(
                      //   right: 3.sp,
                      //   top: 3.sp,
                      //   child: MyTooltip(
                      //     message: widget.package.description.toString(),
                      //     child: Image.asset(
                      //       AppImages.infoIc2,
                      //       height: 13.sp,
                      //       width: 13.sp,
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        right: 3.sp,
                        top: 3.sp,
                        child: SelfReflactViewPopUpWithChild(
                            showChild: htmlChildForInfo(
                                widget.package.description.toString()),
                            child: Image.asset(
                              AppImages.infoIc2,
                              height: 13.sp,
                              width: 13.sp,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    2.sp.sbh,
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        child: CustomText(
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                          color: AppColors.black,
                          text: widget.package.productName.toString(),
                          textAlign: TextAlign.center,
                          fontFamily: AppString.manropeFontFamily,
                          maxLine: 2,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: AppColors.labelColor2,
                                text: "Price",
                                textAlign: TextAlign.start,
                                fontFamily: AppString.manropeFontFamily,
                                maxLine: 2,
                              ),
                            ),
                            Expanded(
                              child: CustomText(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: AppColors.labelColor2,
                                text: "Action",
                                textAlign: TextAlign.end,
                                fontFamily: AppString.manropeFontFamily,
                                maxLine: 2,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                fontWeight: FontWeight.w400,
                                fontSize: 9.sp,
                                color: AppColors.labelColor14,
                                text:
                                    "\$${widget.package.priceLabel.toString()}",
                                textAlign: TextAlign.start,
                                fontFamily: AppString.manropeFontFamily,
                                maxLine: 2,
                              ),
                            ),
                            widget.package.isPurchase.toString() == "1"
                                ? CustomText(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 9.sp,
                                    color: AppColors.labelColor14,
                                    text: "Purchased",
                                    textAlign: TextAlign.start,
                                    fontFamily: AppString.manropeFontFamily,
                                    maxLine: 2,
                                  )
                                : GetBuilder<StoreController>(
                                    builder: (storeController) {
                                    return Align(
                                      alignment: Alignment.bottomRight,
                                      child: ToggleButtonWidget(
                                        value: _isChecked,
                                        onChange: (val) {
                                          setState(() {
                                            _isChecked = !_isChecked;
                                          });
                                          _callAPI(
                                            storeController: storeController,
                                            productId: widget.package.productId
                                                .toString(),
                                            type:
                                                widget.package.type.toString(),
                                            price:
                                                widget.package.price.toString(),
                                            isChecked:
                                                _isChecked == true ? "1" : "0",
                                            productType: widget.package.product
                                                .toString(),
                                            session: storeController
                                                .storeData!.session
                                                .toString(),
                                            promocode: storeController
                                                .storeData!.promocode
                                                .toString(),
                                            promoVerify: storeController
                                                .storeData!.promoVerify
                                                .toString(),
                                            feedbackHours: widget
                                                .package.totalTime
                                                .toString(),
                                            coachId: storeController
                                                .storeData!.coachId
                                                .toString(),
                                          );
                                        },
                                        isShowText: false,
                                        isDisable: widget.package.isActionEnable
                                                .toString() ==
                                            "0",
                                      ),
                                    );
                                  })
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
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

  Color getColor(String color) {
    switch (color) {
      case "bronze":
        return AppColors.bronzColor;
      case "silver":
        return AppColors.silverColor;
      case "gold":
        return AppColors.goldColor;
      case "platinum":
        return AppColors.platinumColor;
      default:
        return AppColors.bronzColor;
    }
  }
}
