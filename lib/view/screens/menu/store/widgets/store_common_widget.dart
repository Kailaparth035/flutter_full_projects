import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/cart_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_dropdown_for_about.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

Widget buildUserCard(String name, String photo) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.backgroundColor1,
      gradient: const LinearGradient(colors: [
        AppColors.labelColor,
        AppColors.labelColor87
      ], stops: [
        0.2,
        0.5,
      ]),
      boxShadow: CommonController.getBoxShadow,
      borderRadius: BorderRadius.circular(5.sp),
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 10.sp),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.labelColor27,
                  radius: 20.sp,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                    ),
                    padding: EdgeInsets.all(1.sp),
                    child: CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 18.sp,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: CustomImage(
                          height: 60.sp,
                          width: 60.sp,
                          image: photo,
                          // fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: name,
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor8,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

CustomText buildTitle1(String title) {
  return CustomText(
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    color: AppColors.labelColor14,
    text: title,
    textAlign: TextAlign.start,
    fontFamily: AppString.manropeFontFamily,
  );
}

CustomText buildSubTitle1(String title) {
  return CustomText(
    fontWeight: FontWeight.w400,
    fontSize: 11.sp,
    color: AppColors.labelColor15,
    text: title,
    textAlign: TextAlign.start,
    fontFamily: AppString.manropeFontFamily,
  );
}

Widget buildCoachListTile(String icon, String title, String value,
    {bool isshowTextBox = false,
    required Function(StoreController) callback,
    required Function onTapOutSide,
    TextEditingController? textController}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 0.sp),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.labelColor27,
                radius: 20.sp,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                  padding: EdgeInsets.all(1.5.sp),
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 18.sp,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: Center(
                        child: Image.asset(
                          icon,
                          height: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: title,
                        textAlign: TextAlign.start,
                        color: AppColors.hintColor,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      2.sp.sbh,
                      isshowTextBox
                          ? SizedBox(
                              height: 20.sp,
                              child: GetBuilder<StoreController>(
                                  builder: (StoreController storeController) {
                                return CustomTextFormFieldForMessage(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  radius: 0,
                                  borderColor: AppColors.labelColor83,
                                  inputAction: TextInputAction.done,
                                  labelText: "",
                                  inputType: CommonController.getIsIOS()
                                      ? const TextInputType.numberWithOptions(
                                          signed: true, decimal: true)
                                      : TextInputType.number,
                                  fontFamily: AppString.manropeFontFamily,
                                  fontSize: 10.sp,
                                  textColor: AppColors.labelColor14,
                                  textEditingController: textController,
                                  onEditingComplete: () {
                                    callback(storeController);
                                  },
                                  lineCount: 1,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.sp, vertical: 2.sp),
                                  onTapOutside: (va) {
                                    onTapOutSide();

                                    // callback(storeController);
                                  },
                                );
                              }),
                            )
                          : CustomText(
                              text: value,
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor14,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget buildMainProductListTile(MainProductList product, int index,
    {required int selectedIndex,
    required Function(int) onTap,
    required bool isStore}) {
  return Padding(
    padding: EdgeInsets.only(bottom: index == selectedIndex ? 0.sp : 10.sp),
    child: CustomDropForAbout(
      index: index,
      selected: selectedIndex,
      onTap: (selectedValue) {
        onTap(selectedValue);
      },
      isGredient: true,
      bottomBgColor: Colors.transparent,
      bottomborderColor: Colors.transparent,
      borderColor: Colors.transparent,
      headingText: product.title.toString(),
      child: InkWell(
        onTap: () {},
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.sp),
          child: Column(
            children: [
              5.sp.sbh,
              ...product.productList!.map(
                  (e) => productListTyleWithSubProducts(e, isStore: isStore)),
              buildDivider(),
              buildChildListTile("Total", "\$${product.totalToPaid.toString()}",
                  isBold: true),
            ],
          ),
        ),
      ),
    ),
  );
}

productListTyleWithSubProducts(ProductList product, {required bool isStore}) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: product.productName.toString(),
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.labelColor8,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ),
                  TextSpan(
                    text: product.text != "" ? " ${product.text} " : "",
                    style: TextStyle(
                      backgroundColor:
                          AppColors.secondaryColor.withOpacity(0.10),
                      fontSize: 9.sp,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: product.isDeleteShow == "1"
                        ? _buildDeleteIcon(ontap: () async {
                            var storeController = Get.find<StoreController>();
                            await storeController.updateDataInSession(
                              onReload: (loading) async {
                                await storeController.getCartDetailsUri(
                                    false, isStore ? "store" : "make_payment");
                              },
                              productId: product.productId.toString(),
                              type: product.offerType.toString(),
                              userId: Get.find<ProfileSharedPrefService>()
                                      .profileData
                                      .value
                                      .id
                                      ?.toString() ??
                                  "",
                              value: "0",
                            );
                          })
                        : 0.sbh,
                  )
                ],
              ),
            ),
          ),
          // 10.sp.sbw,
          Expanded(
            flex: 1,
            child: CustomText(
              fontWeight: FontWeight.w400,
              fontSize: 9.sp,
              color: AppColors.labelColor8,
              text: "\$${product.price.toString()}",
              textAlign: TextAlign.end,
              fontFamily: AppString.manropeFontFamily,
            ),
          )
        ],
      ),
      ...product.assessmentCoachingHours!.map(
        (e) => buildChildListTile(
          e.productName.toString(),
          "\$${e.price.toString()}",
          color: AppColors.labelColor8,
        ),
      ),
      ...product.discountList!.map(
        (e) => Padding(
          padding: EdgeInsets.only(left: 7.sp),
          child: buildChildListTile(
              e.productName.toString(), e.dicountPrice.toString(),
              color: AppColors.labelColor40,
              titleColor: AppColors.labelColor40,
              isShowDeleteBtn: e.isDeleteDiscShow == "1", onDelete: () async {
            var storeController = Get.find<StoreController>();
            await storeController.updateDataInSession(
                onReload: (loading) async {
                  await storeController.getCartDetailsUri(false, "store");
                },
                productId: product.productId.toString(),
                type: e.isDeleteDiscLabel.toString(),
                userId: Get.find<ProfileSharedPrefService>()
                        .profileData
                        .value
                        .id
                        ?.toString() ??
                    "",
                value: "0",
                cartID: product.cartId,
                discPrice: e.price.toString());
          }),
        ),
      ),
      5.sp.sbh,
    ],
  );
}

Widget _buildDeleteIcon({required Function ontap}) {
  return Transform.scale(
    scale: 1.3,
    child: InkWell(
      onTap: () async {
        ontap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 0.sp),
        child: Icon(
          Icons.delete_forever_rounded,
          size: 13.sp,
        ),
      ),
    ),
  );
}

Divider buildDivider() {
  return Divider(
    height: 7.sp,
    color: AppColors.labelColor,
    thickness: 1,
  );
}

buildChildListTile(String title, String amount,
    {bool isBold = false,
    double? fontSize,
    Color? color,
    String? text,
    Color? titleColor,
    bool? isShowDeleteBtn,
    Function? onDelete}) {
  return Column(
    children: [
      // 1.sp.sbh,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: fontSize ?? 9.sp,
                      color: titleColor ?? AppColors.labelColor8,
                      fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ),
                  text != null
                      ? TextSpan(
                          text: " $text ",
                          style: TextStyle(
                            backgroundColor:
                                AppColors.secondaryColor.withOpacity(0.10),
                            fontSize: fontSize ?? 9.sp,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppString.manropeFontFamily,
                          ),
                        )
                      : TextSpan(
                          text: "",
                          style: TextStyle(
                            fontSize: fontSize ?? 9.sp,
                            color: AppColors.labelColor8,
                            fontWeight:
                                isBold ? FontWeight.w600 : FontWeight.w400,
                            fontFamily: AppString.manropeFontFamily,
                          ),
                        ),
                  WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: isShowDeleteBtn != null && isShowDeleteBtn == true
                          ? _buildDeleteIcon(ontap: () async {
                              if (onDelete != null) {
                                await onDelete();
                              }
                            })
                          : 0.sbh)
                ],
              ),
            ),
          ),
          10.sp.sbw,
          Expanded(
            flex: 1,
            child: CustomText(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              fontSize: fontSize ?? 9.sp,
              color: color ?? AppColors.labelColor8,
              text: amount,
              textAlign: TextAlign.end,
              fontFamily: AppString.manropeFontFamily,
            ),
          )
        ],
      ),
    ],
  );
}
