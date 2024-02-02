import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/offers_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/designs/yello_custom_container_paint.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/alert_dialog_coach_list_and_coach_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OfferListTileWidget extends StatefulWidget {
  const OfferListTileWidget(
      {super.key, required this.data, required this.isPreCart});
  final OfferData data;

  final bool isPreCart;
  @override
  State<OfferListTileWidget> createState() => _OfferListTileWidgetState();
}

class _OfferListTileWidgetState extends State<OfferListTileWidget> {
  final _storeController = Get.find<StoreController>();

  bool _isShowAddTocart = true;
  @override
  Widget build(BuildContext context) {
    return _buildOfferListTile(widget.data);
  }

  Widget _buildOfferListTile(OfferData offer) {
    return Container(
      margin: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp),
      padding: EdgeInsets.all(7.sp),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondaryColor),
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFirstRow(
            offer.title.toString(),
            offer.price.toString(),
            offer.offerPrice.toString(),
          ),
          2.sp.sbh,
          CustomText(
            fontWeight: FontWeight.w400,
            fontSize: 8.sp,
            color: AppColors.labelColor15,
            text: offer.description.toString(),
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          5.sp.sbh,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.getWidth / 5,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(
                          context.getWidth / 5,
                          (context.getWidth / 7 * 0.5)
                              .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                      painter: RPSCustomPainter(),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 13.sp,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(right: 2.sp),
                            child: CustomText(
                              fontWeight: FontWeight.w400,
                              fontSize: 8.sp,
                              color: AppColors.black,
                              text: offer.offerLabel.toString(),
                              textAlign: TextAlign.start,
                              fontFamily: AppString.manropeFontFamily,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _isShowAddTocart
                  ? CustomButton2(
                      buttonText: "Add To Cart",
                      radius: 3.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 4.5.sp, horizontal: 7.sp),
                      fontWeight: FontWeight.w700,
                      fontSize: 8.sp,
                      onPressed: () {
                        if (widget.isPreCart == true) {
                          _applyOffer(
                              storeController: _storeController,
                              productId: offer.masterproductId.toString(),
                              // type: "add-precard",
                              type: offer.isShowAddToCartLabel.toString(),
                              value: offer.discountAmount.toString(),
                              cartId: offer.cartId);
                        } else {
                          if (widget.data.isCoach == "1") {
                            Navigator.pop(context);
                            showDialog(
                              context: Get.context!,
                              builder: (BuildContext context) {
                                return const AlertDialogCoachListAndCoachDetails();
                              },
                            );
                            //  show select coach screen
                          } else {
                            _applyOffer(
                              storeController: _storeController,
                              productId: offer.masterproductId.toString(),
                              type: offer.isShowAddToCartLabel.toString(),
                              value: offer.discountAmount.toString(),
                              cartId: offer.cartId,
                            );
                          }
                        }
                      })
                  : CustomButton2(
                      isDisable: true,
                      buttonText: "offer Applied",
                      radius: 3.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 4.5.sp, horizontal: 7.sp),
                      fontWeight: FontWeight.w700,
                      fontSize: 8.sp,
                      onPressed: () {},
                    ),
            ],
          )
        ],
      ),
    );
  }

  Row _buildFirstRow(
    String title,
    String price,
    String offerPrice,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 10.sp,
            color: AppColors.labelColor8,
            text: title,
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
        Expanded(
          child: RichText(
            textAlign: TextAlign.end,
            text: TextSpan(
              children: [
                TextSpan(
                  text: price != "" ? "\$$price" : "",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.labelColor15,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppString.manropeFontFamily,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                TextSpan(
                  text: "  ",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.labelColor15,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
                TextSpan(
                  text: offerPrice != "" ? "\$$offerPrice" : "",
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future _applyOffer({
    required StoreController storeController,
    required String productId,
    required String type,
    required String value,
    required int? cartId,
  }) async {
    var res = await storeController.updateDataInSession(
        onReload: (loading) async {
          await storeController.getCartDetailsUri(false, "make_payment");
        },
        productId: productId,
        type: type,
        userId: Get.find<ProfileSharedPrefService>()
                .profileData
                .value
                .id
                ?.toString() ??
            "",
        value: value,
        cartID: cartId);

    if (res != null) {
      setState(() {
        _isShowAddTocart = false;
      });
    }
  }
}
