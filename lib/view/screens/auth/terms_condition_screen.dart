import 'package:aspirevue/controller/common_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../util/colors.dart';
import '../../../util/dimension.dart';
import '../../../util/string.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({super.key});

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),
                  CustomText(
                    text: AppString.termsCondition,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor1,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 3.h),
                  CustomText(
                    maxLine: 100,
                    text:
                        "Lectus nulla at volutpat diam ut venenatis tellus. Donec et odio pellentesque diam volutpat commodo sed. Sit amet justo donec enim diam vulputate ut pharetra. Mi quis hendrerit dolor magna eget est.Proin libero nunc consequat interdum varius sit amet. Sit amet venenatis urna cursus eget nunc scelerisque viverra mauris. Urna condimentum mattis pellentesque id nibh tortor. Tincidunt id aliquet risus feugiat in ante metus. Mauris nunc congue nisi vitae suscipit tellus mauris.Vel risus commodo viverra maecenas accumsan lacus vel. Mauris augue neque gravida in. Nec feugiat nisl pretium fusce id velit. Id interdum velit laoreet id. Sed ullamcorper morbi tincidunt ornare massa eget. Cursus euismod quis viverra nibh cras pulvinar mattis.",
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor6,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: 6.h),
                  CustomButton(
                      buttonText: AppString.iAccept,
                      width: MediaQuery.of(context).size.width,
                      radius: Dimensions.radiusDefault,
                      height: 6.5.h,
                      onPressed: () {
                        Get.back(result: true);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
