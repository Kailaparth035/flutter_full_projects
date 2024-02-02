import 'package:aspirevue/data/model/response/development/purchase_for_assess_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_video.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/store/store_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PurchaseAssessWidget extends StatelessWidget {
  const PurchaseAssessWidget({super.key, required this.data});
  final AssementInstruction data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          data.title1.toString() != ""
              ? _buildTextDescription(data.title1.toString())
              : 0.sbh,
          data.title1.toString() != "" ? 10.sp.sbh : 0.sp.sbh,
          _buildTitleWithDescription(data.title2.toString(),
              data.subTitle.toString(), data.listOfSubTitles!),
          data.title2.toString() != "" ||
                  data.subTitle.toString() != "" ||
                  data.listOfSubTitles!.isNotEmpty
              ? 10.sp.sbh
              : 0.sbh,
          ...data.buttons!.map(
            (e) => _buildImageWithDescription(
                data.isPurchase == "1" ? "" : AppImages.cameraIc, e),
          ),
          data.buttons!.isEmpty ? 0.sp.sbh : 5.sp.sbh,
          data.subTitle1.toString() != ""
              ? _buildTextDescription(data.subTitle1.toString())
              : 0.sbh,
          5.sp.sbh,
        ],
      ),
    );
  }

  Row _buildImageWithDescription(
    String image,
    Button e,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        image == "" || e.videoLink.toString() == ""
            ? 40.sp.sbw
            : InkWell(
                borderRadius: BorderRadius.circular(500),
                onTap: () {
                  showDialog(
                    context: Get.context!,
                    builder: (BuildContext context) {
                      return VideoAlertDialog(
                        url: e.videoLink.toString(),
                      );
                    },
                  );
                },
                child: Image.asset(
                  image,
                  width: 40.sp,
                ),
              ),
        10.sp.sbw,
        e.buttonTitle == ""
            ? 0.sbw
            : Expanded(
                child: CustomButton2(
                  buttonText: e.buttonTitle.toString(),
                  radius: 5.sp,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                  onPressed: () {
                    Get.to(() => const StoreMainScreen(isFromMenu: false));
                    // Get.toNamed(RouteHelper.getStoreRoute());
                  },
                ),
              ),
      ],
    );
  }

  Row _buildTitleWithDescription(
      String title, String subTitle, List<String> list) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            maxLine: 500,
            fontWeight: FontWeight.w600,
          ),
        ),
        10.sp.sbw,
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subTitle != "" ? _buildTextDescription(subTitle) : 0.sp.sbh,
              subTitle != "" ? 5.sp.sbh : 0.sp.sbh,
              list.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...list.map(
                          (e) => Column(
                            children: [
                              _buildTextDescription(e),
                              5.sp.sbh,
                            ],
                          ),
                        )
                      ],
                    )
                  : 0.sbh
            ],
          ),
        ),
      ],
    );
  }

  CustomText _buildTextDescription(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor15,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 10.sp,
      maxLine: 500,
      fontWeight: FontWeight.w600,
    );
  }
}
