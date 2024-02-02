import 'package:aspirevue/controller/auth_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ConsentAlertWidget extends StatefulWidget {
  const ConsentAlertWidget({super.key, required this.isChecked});
  final bool isChecked;
  @override
  State<ConsentAlertWidget> createState() => _ConsentAlertWidgetState();
}

class _ConsentAlertWidgetState extends State<ConsentAlertWidget> {
  bool isChecked = false;
  @override
  void initState() {
    isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: Container(
          padding: EdgeInsets.all(10.sp),
          // constraints: BoxConstraints(maxHeight: context.getWidth),
          width: context.getWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buidCheckboxAndContent(),
                10.sp.sbh,
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buidCheckboxAndContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: Offset(0, 2.sp),
          child: CustomCheckBox(
            borderColor: AppColors.labelColor8,
            fillColor: AppColors.labelColor8,
            isChecked: isChecked,
            onTap: () {
              setState(() {
                isChecked = !isChecked;
              });
            },
          ),
        ),
        10.sp.sbw,
        Expanded(
          child: CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.black,
            text:
                "I agree to receive the DailyQ reminders and recurring updates SMS from +18334141253. reply STOP to Opt-out.",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        )
      ],
    );
  }

  _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton2(
            buttonText: AppString.save,
            buttonColor: AppColors.primaryColor,
            radius: 15.sp,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 15.sp),
            fontWeight: FontWeight.w600,
            fontSize: 11.sp,
            onPressed: () {
              _saveAction();
              // Navigator.pop(Get.context!, true);
            }),
      ],
    );
  }

  _saveAction() async {
    var authController = Get.find<AuthController>();
    var res = await authController.updateSmsConsent(isChecked);
    if (res != null && res == true) {
      Navigator.pop(Get.context!, true);
    }
  }
}
