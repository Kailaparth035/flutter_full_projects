import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/growth_community_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ImportContactsStepScreen extends StatefulWidget {
  const ImportContactsStepScreen({super.key, required this.onPageChage});
  final Function onPageChage;
  @override
  State<ImportContactsStepScreen> createState() =>
      _ImportContactsStepScreenState();
}

class _ImportContactsStepScreenState extends State<ImportContactsStepScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        12.h.sbh,
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 18.h,
                    height: 18.h,
                    decoration: BoxDecoration(
                      boxShadow: CommonController.getBoxShadow,
                      color: AppColors.labelColor95,
                      borderRadius: BorderRadius.circular(10.sp),
                    ),
                    child: Transform.translate(
                      offset: Offset(0, 10.sp),
                      child: Container(
                        width: 18.h,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: AppColors.labelColor96,
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            SvgImage.importContact,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                7.h.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Center(
                    child: welcomeScreenTitle("Sync Your Contacts?"),
                  ),
                ),
                2.h.sbh,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.sp),
                  child: Center(
                    child: welcomeScreenSubTitle(
                        "This one time permission is useful to easily communicate with others through the app. AspireVue will not send unsolicited messages to your contacts."),
                  ),
                ),
              ],
            ),
          ),
        ),
        2.h.sbh,
        GetBuilder<GrowthCommunityController>(
            builder: (growthCommunityController) {
          return Padding(
            padding: EdgeInsets.only(left: 3.h, right: 3.h),
            child: CustomButton2(
                buttonText: "Sync Now",
                isLoading: growthCommunityController.isLoadingContact,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                radius: Dimensions.radiusDefault,
                fontSize: 13.sp,
                onPressed: () async {
                  // widget.onPageChage();
                  if (growthCommunityController.isLoadingContact == false) {
                    var result = await growthCommunityController.syncContacts();
                    if (result != null && result == true) {
                      await Future.delayed(const Duration(milliseconds: 500));
                      widget.onPageChage();
                    }
                  }
                }),
          );
        }),
        2.h.sbh,
      ],
    );
  }
}
