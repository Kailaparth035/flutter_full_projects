import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/text_box/custom_underline_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/colors.dart';
import '../../../util/string.dart';
import '../../base/custom_loader.dart';
import '../../base/custom_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;
  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: GetBuilder<AuthController>(
            builder: (authController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildAppHeaderForResetPassword(() {
                    Navigator.pop(context);
                  }),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 2.5.h, top: 1.5.h, right: 2.5.h),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: !isFirstSubmit
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          20.sp.sbh,
                          CustomUnderLineTextField(
                            focusNode: _emailFocus,
                            inputAction: TextInputAction.done,
                            labelText: "Email",
                            inputType: TextInputType.emailAddress,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 12.sp,
                            textEditingController: _emailController,
                            validator: Validation().emailValidation,
                            prefixIcon: SvgImage.email,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          CustomButton2(
                              buttonText: "Send Email",
                              width: MediaQuery.of(context).size.width,
                              radius: Dimensions.radiusDefault,
                              height: 6.5.h,
                              onPressed: () {
                                setState(() {
                                  isFirstSubmit = false;
                                });
                                if (_formKey.currentState!.validate()) {
                                  _forgotPasswordAPI(context, authController);
                                }
                              }),
                          SizedBox(height: 3.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _forgotPasswordAPI(BuildContext context, AuthController authController) {
    if (_emailController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterEmail);
    } else if (!GetUtils.isEmail(_emailController.text.trim())) {
      showCustomSnackBar(AppString.pleaseEnterValidEmail);
    } else {
      buildLoading(context);
      var map = <String, dynamic>{};
      map['email'] = _emailController.text.trim().toString();
      authController.forgotPassword(map).then((status) async {
        if (status.isSuccess == true) {
          showCustomSnackBar(status.message, isError: false);
          Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
        } else {
          Navigator.pop(context);
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
