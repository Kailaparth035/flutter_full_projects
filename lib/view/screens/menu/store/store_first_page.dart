import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/personal_growth_listtile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class StoreFirstPage extends StatefulWidget {
  const StoreFirstPage({
    super.key,
    required this.onNext,
  });
  final Function onNext;

  @override
  State<StoreFirstPage> createState() => _StoreFirstPageState();
}

class _StoreFirstPageState extends State<StoreFirstPage> {
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
            _buildActiveLicense(storeController.storeData),
            12.sp.sbh,
            _buildPrimerySubscriberTypeTitle(
              storeController.storeData!.subscriptionType.toString(),
            ),
            12.sp.sbh,
            _buildTitle(),
            4.sp.sbh,
            _buildDivider(
              AppColors.labelColor,
            ),
            10.sp.sbh,
            ...storeController.storeData!.subscriptionList!.map(
              (e) => PersonalGrowthListtile(data: e),
            ),
            _nextButton(),
            60.sp.sbh,
          ],
        )),
      );
    });
  }

  Widget _nextButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomButton2(
          endIcon: AppImages.whiteForwardArrowIc,
          buttonText: "Next",
          radius: 3.sp,
          padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 10.sp),
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
          onPressed: () {
            widget.onNext();
          }),
    );
  }

  Widget _buildActiveLicense(StoreDetailData? data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.labelColor84,
        border: Border.all(color: AppColors.labelColor85),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Column(
        children: [
          _buildActiveLicenseTitle(),
          5.sp.sbh,
          // Image.asset(
          //   AppImages.storeImage1,
          //   width: double.infinity,
          //   fit: BoxFit.fitWidth,
          // ),

          CustomImage(
            image: data!.bannerImage.toString(),
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          5.sp.sbh,
          data.activeLicenses!.isEmpty
              ? Padding(
                  padding:
                      EdgeInsets.only(bottom: 5.sp, left: 5.sp, right: 5.sp),
                  child: Center(
                    child: CustomText(
                      text: "No active licenses.",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor14,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      maxLine: 2,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : Column(
                  children: [
                    ...data.activeLicenses!.map(
                      (e) {
                        return _buildActivityLicenseListTile(
                            e,
                            data.activeLicenses!.indexOf(e) ==
                                data.activeLicenses!.length - 1);
                      },
                    ),
                  ],
                )
        ],
      ),
    );
  }

  _buildActivityLicenseListTile(ActiveLicense data, bool isLast) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Column(
        children: [
          10.sp.sbh,
          Row(
            children: [
              Container(
                height: 7.sp,
                width: 7.sp,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
              ),
              10.sp.sbw,
              Expanded(
                // flex: 5,
                child: CustomText(
                  text: data.productName.toString(),
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor14,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  maxLine: 2,
                  fontWeight: FontWeight.w400,
                ),
              ),
              // Expanded(
              //   flex: 2,
              //   child: CustomText(
              //     text: data.type.toString(),
              //     textAlign: TextAlign.end,
              //     color: AppColors.labelColor40,
              //     fontFamily: AppString.manropeFontFamily,
              //     fontSize: 10.sp,
              //     maxLine: 2,
              //     fontWeight: FontWeight.w400,
              //   ),
              // )
            ],
          ),
          10.sp.sbh,
          isLast ? 0.sbh : _buildDivider(AppColors.labelColor46),
        ],
      ),
    );
  }

  Divider _buildDivider(Color color) {
    return Divider(
      color: color,
      thickness: 1,
      height: 1,
    );
  }

  Row _buildActiveLicenseTitle() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
            child: CustomText(
              text: "Active Licenses",
              textAlign: TextAlign.start,
              color: AppColors.labelColor14,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
        //   child: Image.asset(
        //     AppImages.infoIc,
        //     height: 15.sp,
        //     width: 15.sp,
        //   ),
        // )
      ],
    );
  }

  RichText _buildPrimerySubscriberTypeTitle(String type) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Primary Subscriber Type: ",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          TextSpan(
            text: type,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.w400,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  CustomText _buildTitle() {
    return CustomText(
      fontWeight: FontWeight.w700,
      fontSize: 11.sp,
      color: AppColors.labelColor14,
      text: "Personal Growth Options",
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }
}
