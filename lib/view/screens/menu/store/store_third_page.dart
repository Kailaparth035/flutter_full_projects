import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/store/store_coach_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class StoreThirdPage extends StatefulWidget {
  const StoreThirdPage({super.key, required this.onNext});
  final Function(int) onNext;
  @override
  State<StoreThirdPage> createState() => _StoreThirdPageState();
}

class _StoreThirdPageState extends State<StoreThirdPage> {
  final storeController = Get.find<StoreController>();
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return await storeController.getStoreDetails(true);
      },
      child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.sp.sbh,
              buildTop2TitleText("Coaching", ""),
              10.sp.sbh,
              _buildViewOne(),
              10.sp.sbh,
              _previousNextButton(),
              60.sp.sbh,
            ],
          )),
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
            padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 7.sp),
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
            onPressed: () {
              widget.onNext(2);
            }),
        GetBuilder<StoreController>(builder: (storeController) {
          if (storeController.storeData!.isCoachRequired == "1") {
            return 0.sbh;
          } else {
            return CustomButton2(
                endIcon: AppImages.whiteForwardArrowIc,
                buttonText: "Make Payment",
                radius: 3.sp,
                padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 5.sp),
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                onPressed: () async {
                  if (storeController.storeData!.isMakePayment == "1") {
                    var controller = Get.find<StoreController>();

                    try {
                      buildLoading(Get.context!);
                      var res = await controller.getCartDetailsUri(
                          true, "make_payment");

                      if (res != null && res == true) {
                        if (controller.cartData!.mainProductList!.isNotEmpty &&
                            CommonController().getIntValueFromString(
                                  controller.cartData!.totalAmount.toString(),
                                ) >
                                0) {
                          Future.delayed(const Duration(milliseconds: 500),
                              () async {
                            var res = await Get.toNamed(
                                RouteHelper.getPaymentScreenRoute());
                            if (res != null) {
                              widget.onNext(1);
                            }
                          });
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
                  } else {
                    showCustomSnackBar("please select atleast one product.");
                  }
                });
          }
        }),
      ],
    );
  }

  Widget _buildViewOne() {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor1,
          border: Border.all(color: AppColors.primaryColor, width: 0.5.sp),
          boxShadow: CommonController.getBoxShadow,
          borderRadius: BorderRadius.circular(5.sp),
        ),
        child: Column(
          children: [
            ...storeController.storeData!.coachUsers!.map(
              (e) => _buildDirectReportListTile(
                  e,
                  storeController.storeData!.coachUsers!.indexOf(e) ==
                      storeController.storeData!.coachUsers!.length - 1,
                  storeController.storeData!.coachUsers!.indexOf(e) == 0),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDirectReportListTile(CoachUser user, bool islast, bool isFirst) {
    return GetBuilder<StoreController>(builder: (storeController) {
      return Container(
        decoration: BoxDecoration(
          color: user.coachId.toString() ==
                  storeController.storeData!.coachId.toString()
              ? AppColors.labelColor88
              : Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst ? 5.sp : 0.sp),
            topRight: Radius.circular(isFirst ? 5.sp : 0.sp),
            bottomLeft: Radius.circular(islast ? 5.sp : 0.sp),
            bottomRight: Radius.circular(islast ? 5.sp : 0.sp),
          ),
        ),
        child: InkWell(
          onTap: () async {
            var res = await Get.to(() => StorePaymentDetailScreen(
                  coachId: user.coachId.toString(),
                ));

            if (res != null) {
              widget.onNext(res);
            }
          },
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
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
                                image: user.photo.toString(),
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
                                text: user.coachName.toString(),
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
                      // Image.asset(
                      //   AppImages.optionMenu,
                      //   height: 17.sp,
                      // )
                    ],
                  ),
                ),
              ),
              islast
                  ? 0.sbh
                  : Divider(
                      height: 1.sp,
                      color: AppColors.labelColor15.withOpacity(0.4),
                      thickness: 1,
                    ),
            ],
          ),
        ),
      );
    });
  }
}
