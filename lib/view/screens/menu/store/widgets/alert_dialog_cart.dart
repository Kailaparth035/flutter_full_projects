import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/cart_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/store_common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AlertDialogCart extends StatefulWidget {
  const AlertDialogCart(
      {super.key, required this.isShowCancelPromo, required this.openIndex});

  final bool isShowCancelPromo;
  final int openIndex;

  @override
  State<AlertDialogCart> createState() => _AlertDialogCartState();
}

class _AlertDialogCartState extends State<AlertDialogCart> {
  final TextEditingController _creditTextController = TextEditingController();
  final TextEditingController _promoCodeTextController =
      TextEditingController();

  final _storeController = Get.find<StoreController>();
  bool _isUsedCredit = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();

    if (widget.openIndex == 1) {
      _selectedIndex = 0;
    }
    if (widget.openIndex == 2) {
      _selectedIndex = 1;
    }
    if (widget.openIndex == 3) {
      _selectedIndex = 2;
    }
  }

  _loadData() {
    CartDetailData cartData = Get.find<StoreController>().cartData!;
    if (_getIntValue(cartData.creditAmount!) > 0) {
      setState(() {
        _creditTextController.text = cartData.creditAmount.toString();
        _isUsedCredit = true;
      });
    } else {
      setState(() {
        _creditTextController.text = cartData.walletAmount.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: GetBuilder<StoreController>(builder: (storeController) {
          return GestureDetector(
            onTap: () {
              CommonController.hideKeyboard(context);
            },
            child: SizedBox(
              width: context.getWidth - 30.sp,
              child: storeController.cartData!.mainProductList!.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        25.sp.sbh,
                        Center(
                          child: CustomErrorWidget(
                            onRetry: () {},
                            isNoData: true,
                            isShowRetriyButton: false,
                            isShowCustomMessage: true,
                            text: "Cart is empty!",
                          ),
                        ),
                        20.sp.sbh,
                      ],
                    )
                  : SingleChildScrollView(
                      child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTitle(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.sp),
                              child: Column(
                                children: [
                                  ...storeController.cartData!.mainProductList!
                                      .map(
                                    (e) => buildMainProductListTile(
                                      e,
                                      storeController.cartData!.mainProductList!
                                          .indexOf(e),
                                      onTap: (int val) {
                                        setState(() {
                                          _selectedIndex = val;
                                        });
                                      },
                                      selectedIndex: _selectedIndex,
                                      isStore: true,
                                    ),
                                  ),
                                  _buildCreditCardRow(
                                      storeController.cartData!.walletAmount!,
                                      storeController),
                                  storeController.cartData!.promocode != ""
                                      ? _buildPromotionCodeBox(storeController
                                          .cartData!.promocode
                                          .toString())
                                      : 0.sbh,
                                  5.sp.sbh,
                                  5.sp.sbh,
                                  _buildPromoCode(),
                                  5.sp.sbh,
                                  _getIntValue(storeController
                                              .cartData!.creditAmount!) >
                                          0
                                      ? Column(
                                          children: [
                                            buildDivider(),
                                            buildChildListTile("Total Amount",
                                                "\$${storeController.cartData!.totalAmount.toString()}",
                                                isBold: true, fontSize: 10.sp),
                                            buildDivider(),
                                            buildChildListTile(
                                              "Applied Wallet Credit",
                                              "-\$${storeController.cartData!.creditAmount.toString()}",
                                              isBold: true,
                                              fontSize: 10.sp,
                                              color: AppColors.labelColor40,
                                            ),
                                          ],
                                        )
                                      : 0.sbh,
                                  buildDivider(),
                                  buildChildListTile("Total to be paid",
                                      "\$${storeController.cartData!.totalToPaid.toString()}",
                                      isBold: true, fontSize: 10.sp),
                                  10.sp.sbh,
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomButton2(
                                        buttonText: "Empty Cart",
                                        radius: 5.sp,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.sp, horizontal: 10.sp),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10.sp,
                                        onPressed: () async {
                                          var res =
                                              await storeController.emptyCart();
                                          if (res != null && res == true) {
                                            Navigator.pop(Get.context!);
                                          }
                                        }),
                                  ),
                                  10.sp.sbh,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPromotionCodeBox(String promoCode) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 10.sp),
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.sp),
        color: AppColors.labelColor40.withOpacity(0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppImages.promoIcon,
            height: 15.sp,
            width: 15.sp,
          ),
          5.sp.sbw,
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              color: AppColors.white,
              text: promoCode,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          // widget.isShowCancelPromo == true
          //     ?

          GetBuilder<StoreController>(builder: (storeController) {
            return InkWell(
              onTap: () {
                _cancelPromoCode(
                  storeController: storeController,
                  productId: "0",
                  type: storeController.storeUserData!.type.toString(),
                  price: storeController.storeUserData!.deletePrice.toString(),
                  isChecked: "1",
                  productType:
                      storeController.storeUserData!.product.toString(),
                  session:
                      storeController.storeUserData!.sessionValue.toString(),
                  promoCode: "",
                  promoVerify: "0",
                  feedbackHours: "0",
                  coachId: storeController.storeUserData!.coachId.toString(),
                );
              },
              child: Icon(
                Icons.close_rounded,
                size: 15.sp,
                color: AppColors.white,
              ),
            );
          })
          // : 0.sbh
        ],
      ),
    );
  }

  _buildCreditCardRow(double walletAmount, StoreController storeController) {
    return Row(
      children: [
        CustomCheckBox(
          borderColor: AppColors.labelColor8,
          fillColor: AppColors.labelColor8,
          isChecked: _isUsedCredit,
          onTap: () async {
            if (_isUsedCredit == true) {
              await _applyCredit(
                storeController: storeController,
                productId: "0",
                type: "del-credit",
                value: "0",
              );
            }
            setState(() {
              _isUsedCredit = !_isUsedCredit;
            });
          },
        ),
        5.sp.sbw,
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
          color: AppColors.labelColor40,
          text: "Use Credit",
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        const Spacer(),
        !_isUsedCredit
            ? 0.sbh
            : Row(
                children: [
                  CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: AppColors.black,
                    text: "\$ ",
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                  SizedBox(
                    width: 60.sp,
                    child: CustomTextFormFieldForMessage(
                      radius: 5.sp,
                      borderColor: AppColors.labelColor83,
                      inputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      inputType: CommonController.getIsIOS()
                          ? const TextInputType.numberWithOptions(
                              signed: true, decimal: true)
                          : TextInputType.number,
                      labelText: "",
                      // inputType: TextInputType.number,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      textColor: AppColors.labelColor14,
                      textEditingController: _creditTextController,
                      onChanged: (val) {},
                      onTapSufixIcon: () {},
                      lineCount: 1,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 2.sp),
                    ),
                  ),
                  5.sp.sbw,
                  CustomButton2(
                      buttonText: "Apply",
                      radius: 5.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 10.sp),
                      fontWeight: FontWeight.w700,
                      fontSize: 10.sp,
                      onPressed: () {
                        try {
                          double count =
                              double.parse(_creditTextController.text);

                          if (count > 0 && count <= walletAmount) {
                            _applyCredit(
                                storeController: storeController,
                                productId: "0",
                                type: "credit",
                                value: _creditTextController.text);
                          } else {
                            showCustomSnackBar(
                                "Please enter credit > 0 and credit < wallet balance.");
                          }
                        } catch (e) {
                          showCustomSnackBar("Please enter valid number.");
                        }
                      }),
                ],
              ),
      ],
    );
  }

  Widget _buildPromoCode() {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Container(
        padding: EdgeInsets.all(3.sp),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.labelColor83, width: 1.sp),
          boxShadow: CommonController.getBoxShadow,
          borderRadius: BorderRadius.circular(4.sp),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 15.sp,
                child: CustomTextFormFieldForMessage(
                  radius: 0,
                  borderColor: Colors.transparent,
                  editColor: Colors.transparent,
                  inputAction: TextInputAction.next,
                  labelText: "Promo code",
                  inputType: TextInputType.text,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  textColor: AppColors.labelColor14,
                  textEditingController: _promoCodeTextController,
                  lineCount: 1,
                  padding: EdgeInsets.all(0.sp),
                  activeBorderColor: Colors.transparent,
                  fontWeight: FontWeight.w400,
                  isReadOnly: false,
                ),
              ),
            ),
            10.sp.sbw,
            GetBuilder<StoreController>(builder: (storeController) {
              return CustomButton2(
                  buttonText: "Verify",
                  buttonColor: AppColors.labelColor40,
                  radius: 5,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  onPressed: () {
                    _addPromoCode();
                  });
            }),
          ],
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: " ",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.labelColor15.withOpacity(0.5)),
              child: Icon(
                Icons.close,
                weight: 3,
                size: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  _addPromoCode() async {
    if (_promoCodeTextController.text.isEmpty) {
      showCustomSnackBar("Please enter text");
      return;
    }
    var res = await _storeController.applyCampaignPromocode(
        isShowSucessMessage: true,
        isLoadStoreDetails: true,
        onReload: (isShowLoading) async {
          await _storeController.getCartDetailsUri(false, "store");
        },
        promoVal: _promoCodeTextController.text.toString());

    if (res != null && res == true) {
      _promoCodeTextController.clear();
    }
    CommonController.hideKeyboard(Get.context!);
  }

  _cancelPromoCode({
    required StoreController storeController,
    required String productId,
    required String type,
    required String price,
    required String isChecked,
    required String productType,
    required String session,
    required String promoCode,
    required String promoVerify,
    required String feedbackHours,
    required String coachId,
  }) async {
    var res = await storeController.addToCardDetail(
      onReload: (loading) async {
        await storeController.getCartDetailsUri(false, "store");
      },
      productId: productId,
      type: type,
      price: price,
      isChecked: isChecked,
      productType: productType,
      session: session,
      promoCode: promoCode,
      promoVerify: promoVerify,
      feedbackHours: feedbackHours,
      coachId: coachId,
      isLoadStoreDetails: false,
      isShowSucessMessage: true,
    );

    if (res != null) {
      await Get.find<StoreController>().getStoreUserDetails(coachId, false);
    }
  }

  Future _applyCredit({
    required StoreController storeController,
    required String productId,
    required String type,
    required String value,
  }) async {
    await storeController.updateDataInSession(
        onReload: (loading) async {
          await storeController.getCartDetailsUri(false, "store");
        },
        productId: productId,
        type: type,
        userId: Get.find<ProfileSharedPrefService>()
                .profileData
                .value
                .id
                ?.toString() ??
            "",
        value: value);
    CommonController.hideKeyboard(Get.context!);
  }

  int _getIntValue(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }
}
