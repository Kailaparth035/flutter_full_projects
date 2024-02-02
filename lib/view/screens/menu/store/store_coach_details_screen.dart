import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_user_details.model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_table_widget.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/store_common_widget.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/time_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class StorePaymentDetailScreen extends StatefulWidget {
  const StorePaymentDetailScreen({super.key, required this.coachId});
  final String coachId;
  @override
  State<StorePaymentDetailScreen> createState() =>
      _StorePaymentDetailScreenState();
}

class _StorePaymentDetailScreenState extends State<StorePaymentDetailScreen> {
  final _storeController = Get.find<StoreController>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    await _storeController.getStoreUserDetails(widget.coachId, true);
    if (_storeController.isErrorStoreUser == false) {
      _callAddToCartMethod(false);
    }
  }

  _callAddToCartMethod(bool isShowSucessMessage) {
    _sessionValueUpdate(
      storeController: _storeController,
      productId: _storeController.storeUserData!.productId.toString(),
      type: _storeController.storeUserData!.type.toString(),
      price: _storeController.storeUserData!.price.toString(),
      isChecked: "1",
      productType: _storeController.storeUserData!.product.toString(),
      session: _storeController.storeUserData!.sessionValue.toString(),
      promocode: _storeController.storeUserData!.promocode.toString(),
      promoVerify: _storeController.storeUserData!.promoVerify.toString(),
      feedbackHours: "0",
      coachId: _storeController.storeUserData!.coachId.toString(),
      isShowLoading: false,
      isShowSucessMessage: isShowSucessMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: GestureDetector(
        onTap: () => CommonController.hideKeyboard(context),
        child: Scaffold(
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
          body: _buildMainView(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton:
              GetBuilder<StoreController>(builder: (storeController) {
            if (storeController.isLoadingStore == true ||
                storeController.isErrorStore == true) {
              return 0.sbh;
            } else {
              return buildFloatingActionButton(
                  isShowCancelPromo: true, currentIndex: 3);
            }
          }),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        ),
      ),
    );
  }

  Widget _buildMainView() {
    return GetBuilder<StoreController>(builder: (storeController) {
      if (storeController.isLoadingStoreUser) {
        return const Center(child: CustomLoadingWidget());
      }
      if (storeController.isErrorStoreUser ||
          storeController.storeUserData == null) {
        return Center(
          child: CustomErrorWidget(
            isNoData: storeController.isErrorStoreUser == false,
            onRetry: () {
              _loadData();
            },
            text: storeController.errorMsgStoreUser,
          ),
        );
      } else {
        return _buildView(storeController.storeUserData!);
      }
    });
  }

  Widget _buildView(StoreUserDetailData data) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            _buildDivider(),
            5.sp.sbh,
            TimeLineForStore(
                currentIndex: 3,
                callback: (value) {
                  Navigator.pop(context, value);
                }),
            10.sp.sbh,
            buildTop2TitleText("Coaching", ""),
            10.sp.sbh,
            _buildCard(data),
            10.sp.sbh,
            _previousNextButton(),
            60.sp.sbh,
          ],
        ),
      ),
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
            padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            onPressed: () {
              Navigator.pop(context);
            }),
        CustomButton2(
            endIcon: AppImages.whiteForwardArrowIc,
            buttonText: "Make Payment",
            radius: 3.sp,
            padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            onPressed: () async {
              var controller = Get.find<StoreController>();

              try {
                buildLoading(Get.context!);
                var res1 =
                    await controller.getCartDetailsUri(true, "make_payment");
                if (res1 != null && res1 == true) {
                  if (controller.cartData!.mainProductList!.isNotEmpty &&
                      CommonController().getIntValueFromString(
                            controller.cartData!.totalAmount.toString(),
                          ) >
                          0) {
                    var res =
                        await Get.toNamed(RouteHelper.getPaymentScreenRoute());

                    if (res != null && res == true) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pop(Get.context!, 1);
                      });
                    }
                  } else {
                    showCustomSnackBar(
                      "Your cart is Empty.",
                      statusMessage: "Opps!",
                      color: AppColors.labelColor14,
                    );
                  }
                }
              } catch (e) {
                debugPrint(e.toString());
              } finally {
                Navigator.pop(Get.context!);
              }
            }),
      ],
    );
  }

  Widget _buildCard(StoreUserDetailData data) {
    return Container(
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor1,
        border: Border.all(color: AppColors.primaryColor, width: 0.5.sp),
        boxShadow: CommonController.getBoxShadow,
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildUserCard(data.coachName.toString(), data.photo.toString()),
          10.sp.sbh,
          buildTitle1("Bio"),
          3.sp.sbh,
          buildSubTitle1(parseHtmlString(data.bio.toString())),
          // 10.sp.sbh,
          buildTitle1("Coach Details"),
          3.sp.sbh,
          buildCoachListTile(AppImages.emailIc1, "Email", data.email.toString(),
              callback: (storeController) {}, onTapOutSide: () {}),
          buildCoachListTile(
              AppImages.earthIc, "Country", data.country.toString(),
              callback: (storeController) {}, onTapOutSide: () {}),
          buildCoachListTile(AppImages.earthIc, "State", data.state.toString(),
              callback: (storeController) {}, onTapOutSide: () {}),
          10.sp.sbh,
          buildTitle1("Specialties"),
          3.sp.sbh,
          buildSubTitle1(data.specialties.toString()),
          10.sp.sbh,
          buildTitle1("Booking"),
          3.sp.sbh,
          _buildBookingList(data.hourlyRate.toString()),
          10.sp.sbh,
          data.sessionList!.isNotEmpty
              ? Column(
                  children: [
                    buildSubTitle1(
                        "Invest in your success and save \$ by purchasing additional coaching hours in advance."),
                    10.sp.sbh,
                    DevelopmentTableWidget(
                      title1: "Session",
                      title2: "Price",
                      title3: "Discount Price",
                      flax1: 3,
                      flax2: 2,
                      flax3: 3,
                      list: [
                        ...data.sessionList!.map(
                          (e) => {
                            "title1": e.title.toString(),
                            "title2": "\$${e.price.toString()}",
                            "title3": "\$${e.discountPrice.toString()}",
                          },
                        )
                      ],
                    ),
                    10.sp.sbh,
                  ],
                )
              : 0.sbh,
          buildTitle1("Coach Promo Code"),
          3.sp.sbh,
          buildSubTitle1("Insert promo code if provided by Aspire Vue Coach"),
          10.sp.sbh,
          _buildPromoCode(),
        ],
      ),
    );
  }

  Widget _buildPromoCode() {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Container(
        padding: EdgeInsets.all(7.sp),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.labelColor83, width: 1.sp),
          boxShadow: CommonController.getBoxShadow,
          borderRadius: BorderRadius.circular(5.sp),
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
                  textEditingController:
                      storeController.promoCodeTextController,
                  lineCount: 1,
                  padding: EdgeInsets.all(0.sp),
                  activeBorderColor: Colors.transparent,
                  fontWeight: FontWeight.w400,
                  isReadOnly: storeController.isVerifiedPromoCode,
                ),
              ),
            ),
            10.sp.sbw,
            GetBuilder<StoreController>(builder: (storeController) {
              return CustomButton2(
                  buttonText: storeController.isVerifiedPromoCode
                      ? "Verified"
                      : "Verify",
                  buttonColor: AppColors.labelColor8,
                  radius: 5,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                  onPressed: () {
                    if (!storeController.isVerifiedPromoCode) {
                      _verifyPromoCode(
                        storeController: storeController,
                        coachId: widget.coachId,
                        productId: "0",
                        type: storeController.storeUserData!.type.toString(),
                        isChecked: "1",
                        productType:
                            storeController.storeUserData!.product.toString(),
                        session: storeController.sessionTextController.text,
                        feedbackHours: "0",
                      );
                    }
                  });
            }),
          ],
        ),
      );
    });
  }

  Row _buildBookingList(String hourlyRate) {
    return Row(
      children: [
        Expanded(
          child: buildCoachListTile(
              AppImages.dollarIC, "Hourly Rate  ", "\$$hourlyRate",
              callback: (storeController) {}, onTapOutSide: () {}),
        ),
        Expanded(
          child: buildCoachListTile(AppImages.timeCircleIc, "Session", "",
              textController: Get.find<StoreController>().sessionTextController,
              isshowTextBox: true, callback: (storeController) {
            CommonController.unFocusKeyboard();
            CommonController.hideKeyboard(Get.context!);
            if (Get.find<StoreController>()
                .sessionTextController
                .text
                .isEmpty) {
              showCustomSnackBar("Session value can't be blank",
                  statusMessage: "Validation Error",
                  color: AppColors.labelColor14);
            } else {
              _sessionValueUpdate(
                  storeController: storeController,
                  productId: "0",
                  type: storeController.storeUserData!.type.toString(),
                  price: storeController.storeUserData!.price.toString(),
                  isChecked: "1",
                  productType:
                      storeController.storeUserData!.product.toString(),
                  session: storeController.sessionTextController.text,
                  promocode:
                      storeController.storeUserData!.promocode.toString(),
                  promoVerify:
                      storeController.storeUserData!.promoVerify.toString(),
                  feedbackHours: "0",
                  coachId: storeController.storeUserData!.coachId.toString(),
                  isShowLoading: true,
                  isShowSucessMessage: true);
            }
          }, onTapOutSide: () {
            Get.find<StoreController>().sessionTextController.text =
                Get.find<StoreController>()
                    .storeUserData!
                    .sessionValue
                    .toString();
          }),
        )
      ],
    );
  }

  CustomText _buildTitle() {
    return CustomText(
      fontWeight: FontWeight.w700,
      fontSize: 14.sp,
      color: AppColors.labelColor14,
      text: "Order Summary",
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Divider _buildDivider() {
    return const Divider(
      color: AppColors.labelColor,
      thickness: 1,
    );
  }

  _sessionValueUpdate(
      {required StoreController storeController,
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
      required bool isShowLoading,
      required bool isShowSucessMessage}) async {
    var res = await storeController.addToCardDetail(
      onReload: (loading) async {
        await storeController.getStoreUserDetails(coachId, false);
      },
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
      isShowLoading: isShowLoading,
      isShowSucessMessage: isShowSucessMessage,
    );

    if (res == null) {
      storeController.sessionTextController.clear();
    }
  }

  _verifyPromoCode({
    required StoreController storeController,
    required String coachId,
    required String productId,
    required String feedbackHours,
    required String isChecked,
    required String productType,
    required String session,
    required String type,
  }) async {
    var res = await storeController.verifyPromocode(
        onReaload: (loading) async {},
        coachId: coachId,
        promoCode: storeController.promoCodeTextController.text,
        productId: productId,
        feedbackHours: feedbackHours,
        isChecked: isChecked,
        productType: productType,
        session: session,
        type: type);
    CommonController.unFocusKeyboard();
    if (res == null) {
      // storeController.promoCodeTextController.clear();
    } else {
      setState(() {
        storeController.updateVerifyStatus(true);
      });
    }
  }
}
