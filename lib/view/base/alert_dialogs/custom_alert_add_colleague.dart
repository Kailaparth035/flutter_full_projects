import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CreateColleagueAlertDialog extends StatefulWidget {
  const CreateColleagueAlertDialog({
    super.key,
  });

  @override
  State<CreateColleagueAlertDialog> createState() =>
      _CreateColleagueAlertDialogState();
}

class _CreateColleagueAlertDialogState
    extends State<CreateColleagueAlertDialog> {
  final _myConnectionController = Get.find<MyConnectionController>();

  // bool _isLoadingSend = false;

  final FocusNode _fnameFocus = FocusNode();
  final TextEditingController _fnameController = TextEditingController();

  final FocusNode _lnameFocus = FocusNode();
  final TextEditingController _lnameController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        width: 100.w,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: !isFirstSubmit
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitle(),
                15.sp.sbh,
                _buildTextBoxTitle(AppString.firstName),
                5.sp.sbh,
                SizedBox(
                  child: CustomTextFormFieldForMessage(
                    borderColor: AppColors.labelColor9.withOpacity(0.2),
                    focusNode: _fnameFocus,
                    inputAction: TextInputAction.done,
                    labelText: AppString.firstName,
                    validator: Validation().requiredFieldValidation,
                    inputType: TextInputType.text,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    lineCount: 1,
                    editColor: AppColors.labelColor12,
                    textEditingController: _fnameController,
                  ),
                ),
                10.sp.sbh,
                _buildTextBoxTitle(AppString.lastName),
                5.sp.sbh,
                SizedBox(
                  child: CustomTextFormFieldForMessage(
                    borderColor: AppColors.labelColor9.withOpacity(0.2),
                    focusNode: _lnameFocus,
                    validator: Validation().requiredFieldValidation,
                    inputAction: TextInputAction.done,
                    labelText: AppString.lastName,
                    inputType: TextInputType.text,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    lineCount: 1,
                    editColor: AppColors.labelColor12,
                    textEditingController: _lnameController,
                  ),
                ),
                10.sp.sbh,
                _buildTextBoxTitle(AppString.email),
                5.sp.sbh,
                SizedBox(
                  child: CustomTextFormFieldForMessage(
                    borderColor: AppColors.labelColor9.withOpacity(0.2),
                    focusNode: _emailFocus,
                    validator: Validation().emailValidation,
                    inputAction: TextInputAction.done,
                    labelText: AppString.email,
                    inputType: TextInputType.text,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    lineCount: 1,
                    editColor: AppColors.labelColor12,
                    textEditingController: _emailController,
                  ),
                ),
                15.sp.sbh,
                Center(
                  child: CustomButton2(
                      // isLoading: _isLoadingSend,
                      buttonText: AppString.save,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp, horizontal: 20.sp),
                      radius: Dimensions.radiusSmall,
                      onPressed: () {
                        setState(() {
                          isFirstSubmit = false;
                        });
                        if (_formKey.currentState!.validate()) {
                          _createCollegue();
                        }
                      }),
                ),
                10.sp.sbh,
              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomText _buildTextBoxTitle(String title) {
    return CustomText(
      fontWeight: FontWeight.w600,
      fontSize: 10.sp,
      color: AppColors.labelColor8,
      text: title,
      textAlign: TextAlign.start,
      fontFamily: AppString.manropeFontFamily,
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: AppColors.labelColor8,
          text: AppString.createColleague,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(2.sp),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.labelColor15.withOpacity(0.5)),
            child: Icon(
              Icons.close,
              weight: 3,
              size: 12.sp,
            ),
          ),
        )
      ],
    );
  }

  _createCollegue() async {
    CommonController.hideKeyboard(context);
    // setState(() {
    //   _isLoadingSend = true;
    // });

    buildLoading(Get.context!);
    try {
      var map = <String, dynamic>{};

      map['first_name'] = _fnameController.text;
      map['last_name'] = _lnameController.text;
      map['email'] = _emailController.text;

      var status = await _myConnectionController.createColleague(map);
      if (status.isSuccess == true) {
        showCustomSnackBar(status.message, isError: false);
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pop(Get.context!, true);
        });
      } else {
        showCustomSnackBar(status.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
      // setState(() {
      //   _isLoadingSend = false;
      // });
    }
  }
}
