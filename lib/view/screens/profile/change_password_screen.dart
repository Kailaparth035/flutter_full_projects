import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _profileDataController = Get.find<ProfileSharedPrefService>();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _cNewController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: AppString.myProfile,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: CustomSlideUpAndFadeWidget(child: _buildMainView()),
      ),
    );
  }

  SingleChildScrollView _buildMainView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Form(
          key: _formKey,
          autovalidateMode: !isFirstSubmit
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainTitle(),
              10.sp.sbh,
              _buildTextboxTitle(AppString.currentPassword),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: AppString.enterCurrentPassword,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 1,
                editColor: AppColors.labelColor12,
                textEditingController: _currentController,
                validator: Validation().passwordValidation,
              ),
              10.sp.sbh,
              _buildTextboxTitle(AppString.newPassword),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: AppString.enterNewPassword,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 1,
                editColor: AppColors.labelColor12,
                textEditingController: _newController,
                validator: Validation().passwordValidation,
              ),
              10.sp.sbh,
              _buildTextboxTitle(AppString.confirmPassword),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: AppString.enterConfirmPassword,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 1,
                editColor: AppColors.labelColor12,
                textEditingController: _cNewController,
                validator: (val) {
                  if (_newController.text != _cNewController.text) {
                    return AppString.confirmpasswordmustbesame;
                  } else if (val!.isEmpty) {
                    return AppString.emptyMessage + AppString.passwordfield;
                  } else {
                    return null;
                  }
                },
              ),
              40.sp.sbh,
              Center(
                child: _isLoading
                    ? SizedBox(
                        child: CustomLoadingWidget(
                          height: 50.sp,
                        ),
                      )
                    : CustomButton2(
                        buttonText: AppString.saveChanges,
                        radius: 5.sp,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.sp,
                            horizontal: AppConstants.screenHorizontalPadding),
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        onPressed: () {
                          setState(() {
                            isFirstSubmit = false;
                          });
                          if (_formKey.currentState!.validate()) {
                            _changePassowrd();
                          }
                        }),
              ),
              20.sp.sbh,
            ],
          ),
        ),
      ),
    );
  }

  CustomText _buildTextboxTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    );
  }

  CustomText _buildMainTitle() {
    return CustomText(
      text: AppString.accountSettings,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _changePassowrd() async {
    Map<String, String> requestPrm = {
      "old_password": _currentController.text.toString(),
      "password1": _newController.text.toString(),
      "password2": _cNewController.text.toString(),
    };

    try {
      setState(() {
        _isLoading = true;
      });
      var response = await _profileDataController.changePassword(requestPrm);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
