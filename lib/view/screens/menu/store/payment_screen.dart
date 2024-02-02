import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/alert_dialog_for_offers.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/store_common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    super.key,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _storeController = Get.find<StoreController>();
  final _profileController = Get.find<ProfileSharedPrefService>();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _creditTextController = TextEditingController();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isFirstSubmit = true;
  int _selectedIndex = 0;
  bool _isActive = false;

  CardFieldInputDetails? _cardDetails;

  // bool _isFirstTimeValidated = false;

  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = AppConstants.stripeKey;
    _nameTextController.text =
        _profileController.profileData.value.name.toString();
    _emailTextController.text =
        _profileController.profileData.value.email.toString();
    if (_storeController.cartData != null) {
      _creditTextController.text =
          _storeController.cartData!.walletAmount.toString();

      if (_storeController.cartData!.isPrecardOffer == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return const AlertDialogForOffers(isPreCart: true);
            },
          );
        });
      }
    }
  }

  _validatingCard() {
    if (!_checkIsButtonIsDesable()) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_storeController.cartData!.isPostcardOffer == 1) {
          showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return const AlertDialogForOffers(isPreCart: false);
            },
          );
        }
      });

      // setState(() {
      //   _isFirstTimeValidated = true;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: CommonController.getAnnanotaion(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              bgColor: AppColors.white,
              appbarTitle: "Store",
              onbackPress: () {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: AppColors.white,
          body: _buildView(),
        ),
      ),
    );
  }

  // Widget _buildMainView() {
  //   return GetBuilder<StoreController>(builder: (storeController) {
  //     if (storeController.isLoadingStoreUser) {
  //       return const Center(child: CustomLoadingWidget());
  //     }
  //     if (storeController.isErrorStoreUser ||
  //         storeController.storeUserData == null) {
  //       return Center(
  //         child: CustomErrorWidget(
  //           isNoData: storeController.isErrorStoreUser == false,
  //           onRetry: () {
  //             storeController.getStoreDetails(true);
  //           },
  //           text: storeController.errorMsgStoreUser,
  //         ),
  //       );
  //     } else {
  //       return _buildView(storeController.storeUserData!);
  //     }
  //   });
  // }

  Widget _buildView() {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: GetBuilder<StoreController>(builder: (storeController) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(),
                  _buildDivider(),
                  10.sp.sbh,
                  _buildCardBox(storeController),
                  20.sp.sbh,
                  _buildPaymentDetailsBox(),
                  10.sp.sbh,
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  _buildCardBox(StoreController storeController) {
    return Column(
      children: [
        ...storeController.cartData!.mainProductList!.map(
          (e) => buildMainProductListTile(
            e,
            storeController.cartData!.mainProductList!.indexOf(e),
            onTap: (int val) {
              setState(() {
                _selectedIndex = val;
              });
            },
            selectedIndex: _selectedIndex,
            isStore: false,
          ),
        ),
        // storeController.cartData!.creditAmount! > 0
        //     ? Column(
        //         children: [
        //           buildDivider(),
        //           buildChildListTile("Total Amount",
        //               "\$${storeController.cartData!.totalAmount.toString()}",
        //               isBold: true, fontSize: 10.sp),
        //           buildDivider(),
        //           buildChildListTile(
        //             "Applied Wallet Credit",
        //             "-\$${storeController.cartData!.creditAmount.toString()}",
        //             isBold: true,
        //             fontSize: 10.sp,
        //             color: AppColors.labelColor40,
        //           ),
        //         ],
        //       )
        //     : 0.sbh,
        buildDivider(),
        buildChildListTile("Total to be paid",
            "\$${storeController.cartData!.totalToPaid.toString()}",
            isBold: true, fontSize: 10.sp),
        10.sp.sbh,
      ],
    );
  }

  Widget _buildPaymentDetailsBox() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      width: context.getWidth,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.labelColor),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: !_isFirstSubmit
            ? AutovalidateMode.always
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: CustomButton2(
                  buttonText: "Offers For You",
                  radius: 5.sp,
                  buttonColor: AppColors.labelColor7,
                  textColor: AppColors.labelColor8,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  onPressed: () {
                    if (_cardDetails?.complete == true) {
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) {
                          return const AlertDialogForOffers(isPreCart: false);
                        },
                      );
                    } else {
                      showDialog(
                        context: Get.context!,
                        builder: (BuildContext context) {
                          return const AlertDialogForOffers(isPreCart: true);
                        },
                      );
                    }
                  }),
            ),
            _buildTextboxTitle("Name"),
            CustomTextFormFieldForMessage(
              padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 7.sp),
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "Enter Name",
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              lineCount: 1,
              validator: Validation().requiredFieldValidation,
              editColor: AppColors.white,
              textEditingController: _nameTextController,
              radius: 3.sp,
            ),
            10.sp.sbh,
            _buildTextboxTitle("Email"),
            CustomTextFormFieldForMessage(
              padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 7.sp),
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "Enter Email",
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              lineCount: 1,
              validator: Validation().emailValidation,
              editColor: AppColors.white,
              textEditingController: _emailTextController,
              radius: 3.sp,
            ),
            10.sp.sbh,
            _buildTextboxTitle("Card Info."),
            _buildStripePaymentView(),
            Padding(
              padding: EdgeInsets.only(left: 11.sp, top: 3.sp),
              child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Theme.of(context).colorScheme.error,
                text: _isActive == true
                    ? _getErrorMessage() != "Your postal code is invalid."
                        ? _getErrorMessage()
                        : _cardDetails!.postalCode!.isEmpty
                            ? ""
                            : _getErrorMessage()
                    : "",
                textAlign: TextAlign.start,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
            10.sp.sbh,
            Center(
              child: CustomButton2(
                  isDisable: _checkIsButtonIsDesable(),
                  buttonText: "Pay Now",
                  radius: 3.sp,
                  padding: EdgeInsets.symmetric(
                      vertical: 5.sp,
                      horizontal: AppConstants.screenHorizontalPadding),
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  onPressed: () async {
                    setState(() {
                      _isFirstSubmit = false;
                    });
                    if (_formKey.currentState!.validate()) {
                      _generatePaymentMethod();
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  bool _checkIsButtonIsDesable() {
    return (_cardDetails == null || _cardDetails!.complete != true) ||
        _cardDetails!.postalCode!.length != 5 ||
        !isNumeric(_cardDetails!.postalCode!);
  }

  Widget _buildStripePaymentView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.sp),
      child: Material(
        shadowColor: Colors.transparent,
        elevation: 0.0,
        child: CardField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.sp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.sp)),
              borderSide: const BorderSide(color: AppColors.labelColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.sp)),
              borderSide: const BorderSide(color: AppColors.labelColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.sp)),
              borderSide: const BorderSide(color: AppColors.primaryColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3.sp)),
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 160, 39, 39)),
            ),
          ),
          enablePostalCode: true,
          postalCodeHintText: "ZIP",
          numberHintText: "Card Number",
          dangerouslyUpdateFullCardDetails: true,
          dangerouslyGetFullCardDetails: true,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppString.manropeFontFamily,
          ),
          onFocus: (ca) {
            var paddinf = MediaQuery.of(context).viewInsets.bottom;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (paddinf == 0.0) {
                _scrollController.position.animateTo(
                  _scrollController.position.maxScrollExtent +
                      MediaQuery.of(context).viewInsets.bottom,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              }
            });

            setState(() {
              if (_isActive == false) {
                _isActive = true;
              }
            });
          },
          onCardChanged: (val) {
            setState(() {
              _cardDetails = val;
            });

            // if (_isFirstTimeValidated == false) {
            _validatingCard();
            // }
          },
        ),
      ),
    );
  }

  CustomText _buildTitle() {
    return CustomText(
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
      color: AppColors.labelColor14,
      text: "Make Payment",
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Widget _buildTextboxTitle(String text) {
    return Column(
      children: [
        CustomText(
          fontWeight: FontWeight.w500,
          fontSize: 10.sp,
          color: AppColors.labelColor14,
          text: text,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        5.sp.sbh,
      ],
    );
  }

  _getErrorMessage() {
    if (_cardDetails == null) {
      return "";
    }
    if (_cardDetails!.validNumber == CardValidationState.Invalid) {
      return "Your card number is invalid.";
    } else if (_cardDetails!.validExpiryDate == CardValidationState.Invalid) {
      return "Your card's expiration year is invalid.";
    } else if (_cardDetails!.validCVC == CardValidationState.Invalid) {
      return "Your card's CVC is invalid.";
    } else if (_cardDetails!.validNumber == CardValidationState.Valid &&
        _cardDetails!.validExpiryDate == CardValidationState.Valid &&
        _cardDetails!.validCVC == CardValidationState.Valid &&
        (_cardDetails!.postalCode!.length != 5 ||
            !isNumeric(_cardDetails!.postalCode!))) {
      return "Your postal code is invalid.";
    } else {
      return "";
    }
  }

  bool isNumeric(String str) {
    try {
      var value = double.parse(str);
      if (value.isNaN) {
        return false;
      }
      return true;
    } on FormatException {
      return false;
    }
  }

  Divider _buildDivider() {
    return const Divider(
      color: AppColors.labelColor,
      thickness: 1,
    );
  }

  _generatePaymentMethod() async {
    try {
      buildLoading(context);
      await stripe.Stripe.instance.applySettings();
      await stripe.Stripe.instance
          .dangerouslyUpdateCardDetails(stripe.CardDetails(
        number: _cardDetails!.number,
        cvc: _cardDetails!.cvc,
        expirationMonth: _cardDetails!.expiryMonth,
        expirationYear: _cardDetails!.expiryYear,
      ));

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
                email: _emailTextController.text.toString(),
                name: _nameTextController.text.toString()),
          ),
        ),
      );

      debugPrint(paymentMethod.toString());

      var res = await _storeController.makePayment(
          paymentMethod: paymentMethod.id.toString(),
          isShowLoading: false,
          onReload: (isLoading) async {
            await _storeController.getStoreDetails(false);
          });

      Navigator.pop(Get.context!);
      if (res != null && res == true) {
        Navigator.pop(Get.context!, true);
      }
    } catch (e) {
      Navigator.pop(Get.context!);
      if (e is StripeException) {
        StripeException error = e;
        showCustomSnackBar(error.error.message.toString(), duration: 2);
      } else {
        showCustomSnackBar(e.toString());
      }
    }
  }
}
