import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/refer_and_earn_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ReferalScreen extends StatefulWidget {
  const ReferalScreen({super.key});

  @override
  State<ReferalScreen> createState() => _ReferalScreenState();
}

class _ReferalScreenState extends State<ReferalScreen> {
  final _storeController = Get.find<StoreController>();

  @override
  void initState() {
    if (_storeController.referAndEarnData == null) {
      _storeController.referAndEarn(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: "Refer And Earn",
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: _buildMainView(),
      ),
    );
  }

  Widget _buildMainView() {
    return GetBuilder<StoreController>(builder: (storeController) {
      if (storeController.isLoadingReferAndEarn) {
        return const Center(child: CustomLoadingWidget());
      }
      if (storeController.isErrorReferAndEarn ||
          storeController.referAndEarnData == null) {
        return Center(
          child: CustomErrorWidget(
            isNoData: storeController.isErrorReferAndEarn == false,
            onRetry: () {
              storeController.referAndEarn(true);
            },
            text: storeController.errorMsgReferAndEarn,
          ),
        );
      } else {
        return _buildView(storeController.referAndEarnData!);
      }
    });
  }

  Widget _buildView(ReferAndEarnData data) {
    int index = 0;
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.sp.sbh,
              _buildTitle(data.earnAmount.toString()),
              30.sp.sbh,
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.sp,
                ),
                child: Image.asset(AppImages.referalVector),
              ),
              30.sp.sbh,
              ...data.stepList!.map((e) {
                index++;
                return _buildRowListTile(index.toString(), e);
              }),
              30.sp.sbh,
              _buildCopycode(data),
              10.sp.sbh,
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.sp),
                  child: CustomButton2(
                      height: 32.sp,
                      width: context.getWidth,
                      topIconPadding: 0,
                      icon: AppImages.whatsappIc,
                      buttonText: "Invite friends now",
                      radius: 5.sp,
                      fontWeight: FontWeight.w700,
                      fontSize: 12.sp,
                      iconHeight: 15.sp,
                      onPressed: () async {
                        CommonController().shareInWhatsapp();

                        // CommonController.urlLaunch(
                        //     "https://wa.me/?text=YourTextHere");
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCopycode(ReferAndEarnData data) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.sp),
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor88,
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
            color: AppColors.labelColor14,
            text: data.referalCode.toString(),
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(
                      ClipboardData(text: data.referalCode.toString()))
                  .then((value) {
                showCustomSnackBar("Clipboard Copied.",
                    color: Colors.black,
                    statusMessage: data.referalCode.toString());
              });
            },
            child: CustomText(
              fontWeight: FontWeight.w700,
              fontSize: 11.sp,
              color: AppColors.labelColor8,
              text: "Copy",
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowListTile(String number, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 30.sp, bottom: 15.sp, right: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 25.sp,
            width: 25.sp,
            decoration: BoxDecoration(
              color: AppColors.labelColor87,
              borderRadius: BorderRadius.circular(5.sp),
            ),
            child: Center(
              child: CustomText(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: AppColors.labelColor14,
                text: number,
                textAlign: TextAlign.start,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
          ),
          10.sp.sbw,
          Expanded(
            child: CustomText(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
              color: AppColors.labelColor14,
              text: title,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Center _buildTitle(String amount) {
    return Center(
      child: CustomText(
        fontWeight: FontWeight.w700,
        fontSize: 14.sp,
        color: AppColors.labelColor14,
        text: "Invite & Earn $amount",
        textAlign: TextAlign.center,
        fontFamily: AppString.manropeFontFamily,
      ),
    );
  }
}
