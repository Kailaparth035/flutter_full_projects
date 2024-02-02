import 'package:aspirevue/controller/auth_controller.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_button.dart';
import 'package:aspirevue/view/base/custom_dropdown_list.dart';
import 'package:aspirevue/view/base/custom_gradient_text.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_underline_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.referralCode});
  final String? referralCode;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _repeatPasswordFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _referalFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _referalCodeController = TextEditingController();

  List<String> genderList = ['Male', 'Female', 'Non-binary'];
  String? genderDropdownValue;

  bool _isAcceptedTandC = false;

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  bool _isReferralReadOnly = false;
  @override
  void initState() {
    super.initState();
    _checkReferralPrm();
  }

  _checkReferralPrm() {
    if (widget.referralCode != null) {
      setState(() {
        _referalCodeController.text = widget.referralCode.toString();
        if (_referalCodeController.text != "") {
          _isReferralReadOnly = true;
        }
      });
    }
    // _referalCodeController.text =
    //     Get.find<ProfileSharedPrefService>().referralCodeFromLink.value;
    if (_referalCodeController.text != "") {
      setState(() {
        _isReferralReadOnly = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: _buildView(context),
      ),
    );
  }

  Widget _buildView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GetBuilder<AuthController>(
            builder: (authController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.sp.sbh,
                  _buildBackButton(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.screenHorizontalPadding),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: !isFirstSubmit
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.sp.sbh,
                          _buildTitle(),
                          // 10.sp.sbh,
                          // _buildSubTitle(),
                          20.sp.sbh,
                          _buildFirstNameTextbox(),
                          20.sp.sbh,
                          _buildLastNameTextbox(),
                          20.sp.sbh,
                          _buildEmailTextbox(),
                          20.sp.sbh,
                          _buildPhoneTextbox(),
                          7.sp.sbh,
                          _buildGenderDD(),
                          20.sp.sbh,
                          _buildPasswordTextbox(),
                          20.sp.sbh,
                          _buildRepeatPassTextbox(),

                          20.sp.sbh,
                          _buildReferalTextbox(),
                          25.sp.sbh,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            AppConstants.screenHorizontalPadding + 5.sp),
                    child: Column(
                      children: [
                        _buildTermAndCondition(),
                        20.sp.sbh,
                        _buildSignUpButton(context, authController),
                        15.sp.sbh,
                        _buildAlreadyHaveAcc(),
                        20.sp.sbh,
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildByChecking(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "By creating this account, you agree with our ",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
            ),
          ),
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  CommonController.urlLaunch(AppConstants.termAndConditionUrl);
                },
              text: "Terms of Service ",
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontFamily: AppString.manropeFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              )),
          TextSpan(
            text: "and ",
            style: TextStyle(
              color: AppColors.black,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
            ),
          ),
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  CommonController.urlLaunch(AppConstants.privacyPolicyUrl);
                },
              text: "Privacy Policy.",
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontFamily: AppString.manropeFontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              )),
        ],
      ),
    );
  }

  Row _buildAlreadyHaveAcc() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: AppString.alreadyHaveAccount,
          textAlign: TextAlign.start,
          color: AppColors.labelColor6,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(width: 1.w),
        GestureDetector(
          onTap: () => Get.back(),
          child: CustomGradientText(
            fontWeight: FontWeight.w500,
            text: AppString.login,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  CustomButton _buildSignUpButton(
      BuildContext context, AuthController authController) {
    return CustomButton(
        buttonText: "Sign Up",
        width: MediaQuery.of(context).size.width,
        radius: Dimensions.radiusDefault,
        height: 6.5.h,
        onPressed: () {
          setState(() {
            isFirstSubmit = false;
          });
          if (_formKey.currentState!.validate()) {
            _signUpAPI(context, authController);
          }
        });
  }

  Row _buildTermAndCondition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        !_isAcceptedTandC
            ? SizedBox(
                height: 5.w,
                width: 5.w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isAcceptedTandC = !_isAcceptedTandC;
                    });
                  },
                  child: Container(
                    height: 5.w,
                    width: 5.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.labelColor2),
                      borderRadius: BorderRadius.circular(3.sp),
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 5.w,
                width: 5.w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isAcceptedTandC = !_isAcceptedTandC;
                    });
                  },
                  child:
                      Image.asset(AppImages.checkBox, height: 5.w, width: 5.w),
                ),
              ),
        SizedBox(width: 3.w),
        Expanded(child: _buildByChecking(context)),
      ],
    );
  }

  CustomUnderLineTextField _buildEmailTextbox() {
    return CustomUnderLineTextField(
      focusNode: _emailFocus,
      nextFocus: _phoneFocus,
      labelText: "Email",
      inputType: TextInputType.emailAddress,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      textEditingController: _emailController,
      validator: Validation().emailValidation,
      prefixIcon: SvgImage.email,
    );
  }

  CustomUnderLineTextField _buildReferalTextbox() {
    return CustomUnderLineTextField(
      isReadOnly: _isReferralReadOnly,
      focusNode: _referalFocus,
      labelText: "Referral Code (Optional)",
      inputType: TextInputType.text,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      textEditingController: _referalCodeController,
      prefixIcon: SvgImage.referalIc,
      inputAction: TextInputAction.done,
    );
  }

  CustomUnderLineTextField _buildPhoneTextbox() {
    return CustomUnderLineTextField(
      focusNode: _phoneFocus,
      nextFocus: _passwordFocus,
      labelText: "Phone",
      inputType: TextInputType.phone,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      textEditingController: _phoneController,
      validator: Validation().phoneNumverValidation,
      prefixIcon: SvgImage.call,
    );
  }

  CustomUnderLineTextField _buildPasswordTextbox() {
    return CustomUnderLineTextField(
      focusNode: _passwordFocus,
      nextFocus: _repeatPasswordFocus,
      isPassword: true,
      lineCount: 1,
      labelText: "Password",
      inputType: TextInputType.visiblePassword,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      textEditingController: _passwordController,
      validator: Validation().passwordValidation,
      prefixIcon: SvgImage.password,
    );
  }

  CustomUnderLineTextField _buildRepeatPassTextbox() {
    return CustomUnderLineTextField(
      focusNode: _repeatPasswordFocus,
      nextFocus: _referalFocus,
      inputAction: TextInputAction.done,
      isPassword: true,
      lineCount: 1,
      labelText: "Confirm Password",
      inputType: TextInputType.visiblePassword,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      textEditingController: _repeatPasswordController,
      prefixIcon: SvgImage.password,
      validator: (val) {
        if (val == null || val.toString().trim().isEmpty) {
          return AppString.emptyMessage + AppString.passwordfield;
        } else if (_passwordController.text != _repeatPasswordController.text) {
          return AppString.confirmpasswordmustbesame;
        } else {
          return null;
        }
      },
    );
  }

  CustomDropdownList _buildGenderDD() {
    return CustomDropdownList(
      dropdownValue: genderDropdownValue,
      dropdownList: genderList,
      onChanged: (String? value) {
        setState(() {
          genderDropdownValue = value;
        });
      },
      label: "Gender (Optional)",
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      prefixIcon: SvgImage.done,
    );
  }

  CustomUnderLineTextField _buildLastNameTextbox() {
    return CustomUnderLineTextField(
      focusNode: _lastNameFocus,
      nextFocus: _emailFocus,
      labelText: "Last Name",
      inputType: TextInputType.text,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      textEditingController: _lastNameController,
      validator: Validation().requiredFieldValidation,
      prefixIcon: SvgImage.user,
    );
  }

  CustomUnderLineTextField _buildFirstNameTextbox() {
    return CustomUnderLineTextField(
      focusNode: _firstNameFocus,
      nextFocus: _lastNameFocus,
      labelText: "First Name",
      inputType: TextInputType.text,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      textEditingController: _firstNameController,
      validator: Validation().requiredFieldValidation,
      prefixIcon: SvgImage.user,
    );
  }

  // CustomText _buildTextBoxTitle(String title) {
  //   return CustomText(
  //     fontWeight: FontWeight.w500,
  //     fontSize: 11.sp,
  //     color: AppColors.labelColor6,
  //     text: title,
  //     textAlign: TextAlign.start,
  //     fontFamily: AppString.manropeFontFamily,
  //   );
  // }

  // Center _buildSubTitle() {
  //   return Center(
  //     child: CustomText(
  //       maxLine: 3,
  //       text: "Lorem dolor sit amet consectetur \nadipisicing elit, sed do.",
  //       textAlign: TextAlign.center,
  //       color: AppColors.labelColor5,
  //       fontFamily: AppString.manropeFontFamily,
  //       fontSize: 11.sp,
  //       fontWeight: FontWeight.w400,
  //     ),
  //   );
  // }

  Center _buildTitle() {
    return Center(
      child: CustomText(
        text: AppString.createAnAccount,
        textAlign: TextAlign.start,
        color: AppColors.labelColor4,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Padding _buildBackButton() {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_outlined,
          color: AppColors.backArrowColor,
          size: 3.5.h,
        ),
      ),
    );
  }

  void _signUpAPI(BuildContext context, AuthController authController) {
    if (_firstNameController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterFirstName);
    } else if (_lastNameController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterLastName);
    } else if (_emailController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterEmail);
    } else if (!GetUtils.isEmail(_emailController.text.trim())) {
      showCustomSnackBar(AppString.pleaseEnterValidEmail);
    } else if (_phoneController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterPhoneNumber);
    } else if (_passwordController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterPassword);
    } else if (_repeatPasswordController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterRepeatPassword);
    } else if (_passwordController.text.trim() !=
        _repeatPasswordController.text.trim()) {
      showCustomSnackBar(AppString.passwordCouldNotMatch);
    } else if (genderDropdownValue == null) {
      showCustomSnackBar(AppString.pleaseSelectGender);
    } else if (_isAcceptedTandC == false) {
      showCustomSnackBar(AppString.acceptTermsandConditions);
    } else {
      buildLoading(context);
      var gender = "";
      if (genderDropdownValue == "Male") {
        gender = "1";
      } else if (genderDropdownValue == "Female") {
        gender = "2";
      } else if (genderDropdownValue == "Non-binary") {
        gender = "3";
      }
      var map = <String, dynamic>{};
      map['first_name'] = _firstNameController.text.trim().toString();
      map['last_name'] = _lastNameController.text.trim().toString();
      map['phone'] = _phoneController.text.trim().toString();
      map['email'] = _emailController.text.trim().toString();
      map['password'] = _passwordController.text.trim().toString();
      map['repeat_password'] = _repeatPasswordController.text.trim().toString();
      map['gender'] = gender;
      map['referal_code'] = _referalCodeController.text.trim().toString();
      authController.registration(map).then((status) async {
        if (status.isSuccess == true) {
          showCustomSnackBar(status.message, isError: false);
          Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.signIn));
        } else {
          Navigator.pop(context);
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
