import 'dart:async';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:aspirevue/controller/auth_controller.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/alert_dialogs/consent_alert_widget.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_container.dart';
import 'package:aspirevue/view/base/custom_gradient_text.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_underline_text_field.dart';
import 'package:aspirevue/view/screens/splash/splash_video_player_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;

  const SignInScreen({super.key, required this.exitFromApp});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _profileSharedPrefServiceController =
      Get.find<ProfileSharedPrefService>();

  bool _canExit = false;
  var switchValue = true;
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  late int currYear;
  late String version = '';

  bool _isRemindMe = false;

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;

  @override
  void initState() {
    super.initState();

    DateTime nowDate = DateTime.now();
    currYear = nowDate.year;

    _checkReminder();

    _initPackageInfo();
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      await account!.authentication;
      if (account.email.isNotEmpty) {
        var map = <String, dynamic>{};
        map['first_name'] = account.displayName!.split(' ')[0];
        map['last_name'] = account.displayName!.split(' ')[1];
        map['email'] = account.email;
        map['google_identifier'] = account.id;
        map['apple_identifier'] = "";

        _socialSignIn(map);
      } else {
        showCustomSnackBar(AppString.socialMessage);
      }
    });
  }

  _socialSignIn(Map<String, dynamic> map) async {
    try {
      buildLoading(Get.context!);
      ResponseModel status = await Get.find<AuthController>()
          .socialLogin(map, _profileSharedPrefServiceController);
      if (status.isSuccess == true) {
        // _profileSharedPrefServiceController.getUserData();
        await _profileSharedPrefServiceController.getMyProfile({});

        var controller = VideoPlayerController.networkUrl(Uri.parse(
            _profileSharedPrefServiceController.loginData.value.animationVideo
                .toString()));

        controller.setLooping(false);
        controller.initialize().then((_) =>
            Get.offAll(() => SpashVideoPlayerScreen(controller: controller)));
      } else {
        showCustomSnackBar(status.message);
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  _checkReminder() {
    String? result =
        _profileSharedPrefServiceController.getUsernameAndPassword();

    if (result != null) {
      _emailController.text = result.split("&&&").first.toString();
      _passwordController.text = result.split("&&&").last.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonController.hideKeyboard(context);
      },
      child: PopScope(
        canPop: widget.exitFromApp ? _canExit : true,
        onPopInvoked: (va) {
          if (widget.exitFromApp) {
            if (_canExit) {
              SystemNavigator.pop();
            } else {
              showCustomSnackBarWithMessage(AppString.backPressAgainToExist);
              _canExit = true;
              Timer(const Duration(seconds: 2), () {
                _canExit = false;
              });
            }
          } else {}
        },
        // onWillPop: () async {
        //   if (widget.exitFromApp) {
        //     if (_canExit) {
        //       SystemNavigator.pop();
        //       return Future.value(false);
        //     } else {
        //       showCustomSnackBar(AppString.backPressAgainToExist, isError: false);
        //       _canExit = true;
        //       Timer(const Duration(seconds: 2), () {
        //         _canExit = false;
        //       });
        //       return Future.value(false);
        //     }
        //   } else {
        //     return true;
        //   }
        // },
        child: CommonController.getAnnanotaion(
          color: Colors.transparent,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              top: false,
              child: SingleChildScrollView(
                child: GetBuilder<AuthController>(
                  builder: (authController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildAppHeaderForLogin(),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 2.5.h, top: 1.5.h, right: 2.5.h),
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
                                  nextFocus: _passwordFocus,
                                  labelText: AppString.enterEmail,
                                  inputType: TextInputType.emailAddress,
                                  inputAction: TextInputAction.next,
                                  fontFamily: AppString.manropeFontFamily,
                                  fontSize: 12.sp,
                                  textEditingController: _emailController,
                                  validator: Validation().emailValidation,
                                  prefixIcon: SvgImage.email,
                                ),
                                20.sp.sbh,
                                CustomUnderLineTextField(
                                  isPassword: true,
                                  lineCount: 1,
                                  focusNode: _passwordFocus,
                                  inputAction: TextInputAction.done,
                                  labelText: AppString.enterPassword,
                                  inputType: TextInputType.visiblePassword,
                                  fontFamily: AppString.manropeFontFamily,
                                  fontSize: 12.sp,
                                  textEditingController: _passwordController,
                                  validator:
                                      Validation().requiredFieldValidation,
                                  prefixIcon: SvgImage.password,
                                ),
                                30.sp.sbh,
                                _buildRemindMeRow(),
                                20.sp.sbh,
                                CustomButton2(
                                    buttonText: AppString.logIn,
                                    width: MediaQuery.of(context).size.width,
                                    radius: Dimensions.radiusDefault,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.sp),
                                    onPressed: () {
                                      setState(() {
                                        isFirstSubmit = false;
                                      });
                                      if (_formKey.currentState!.validate()) {
                                        _loginAPI(context, authController);
                                      }
                                    }),
                                15.sp.sbh,
                                Center(
                                  child: CustomText(
                                    text: AppString.or,
                                    textAlign: TextAlign.start,
                                    color: AppColors.labelColor3,
                                    fontFamily: AppString.manropeFontFamily,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                10.sp.sbh,
                                Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                  ),
                                  child: CustomContainer(
                                    onPressed: () {
                                      googleLogin(context);
                                    },
                                    buttonColor: AppColors.white,
                                    leadingText: AppString.loginWithGoogle,
                                    imagePath: AppImages.googleImage,
                                  ),
                                ),
                                CommonController.getIsIOS()
                                    ? 15.sp.sbh
                                    : const SizedBox(),
                                CommonController.getIsIOS()
                                    ? InkWell(
                                        onTap: () async {},
                                        child: Card(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radiusDefault),
                                          ),
                                          child: CustomContainer(
                                            onPressed: () {
                                              _appleSignIn();
                                            },
                                            buttonColor: AppColors.white,
                                            leadingText:
                                                AppString.loginWithApple,
                                            imagePath: AppImages.apple,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                15.sp.sbh,
                                Center(child: doNotHaveAccountText(context)),
                                15.sp.sbh,
                                Center(
                                    child: CustomGradientText(
                                  fontWeight: FontWeight.w500,
                                  text: '© $currYear AspireVue, v$version',
                                  fontFamily: AppString.manropeFontFamily,
                                  fontSize: 9.sp,
                                )),
                                15.sp.sbh,
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
          ),
        ),
      ),
    );
  }

  bool val = false;

  Row _buildRemindMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        !_isRemindMe
            ? SizedBox(
                height: 5.w,
                width: 5.w,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isRemindMe = !_isRemindMe;
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
                      _isRemindMe = !_isRemindMe;
                    });
                  },
                  borderRadius: BorderRadius.circular(3.sp),
                  child:
                      Image.asset(AppImages.checkBox, height: 5.w, width: 5.w),
                ),
              ),
        SizedBox(width: 2.w),
        CustomText(
          text: AppString.keepMeLoggedIn,
          textAlign: TextAlign.start,
          color: AppColors.labelColor1,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Get.toNamed(RouteHelper.getForgotPasswordRoute()),
          child: CustomText(
            text: AppString.forgotPassword,
            textAlign: TextAlign.start,
            color: AppColors.secondaryColor,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget doNotHaveAccountText(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "New to AspireVue? ",
            style: TextStyle(
              color: AppColors.normalTextColor,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
            ),
          ),
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.toNamed(RouteHelper.getSignUpRoute());
                },
              text: "Create account",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: AppColors.secondaryColor,
                fontFamily: AppString.manropeFontFamily,
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              )),
        ],
      ),
    );
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      await googleSignIn.signOut();
      await googleSignIn.signIn();
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }
  }

  void _loginAPI(BuildContext context, AuthController authController) {
    if (_emailController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterEmail);
    } else if (!GetUtils.isEmail(_emailController.text.trim())) {
      showCustomSnackBar(AppString.pleaseEnterValidEmail);
    } else if (_passwordController.text.trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterPassword);
    } else {
      buildLoading(context);
      var map = <String, dynamic>{};
      map['username'] = _emailController.text.trim().toString();
      map['password'] = _passwordController.text.trim().toString();
      authController
          .login(map, _profileSharedPrefServiceController)
          .then((status) async {
        if (status.isSuccess == true) {
          // _profileSharedPrefServiceController.getUserData();
          if (_isRemindMe) {
            _profileSharedPrefServiceController.setUserNamePassword(
                username: _emailController.text.trim().toString(),
                password: _passwordController.text.trim().toString());
          }

          await _profileSharedPrefServiceController.getMyProfile({});

          // show sms content dialog
          if (_profileSharedPrefServiceController
                  .loginData.value.isSmsConsentShow ==
              1) {
            await showDialog(
                context: Get.context!,
                builder: (BuildContext context) {
                  return ConsentAlertWidget(
                      isChecked: _profileSharedPrefServiceController
                              .loginData.value.isSmsConsent ==
                          1);
                });
          }
          var controller = VideoPlayerController.networkUrl(Uri.parse(
              _profileSharedPrefServiceController.loginData.value.animationVideo
                  .toString()));

          controller.setLooping(false);

          controller.initialize().then((_) =>
              Get.offAll(() => SpashVideoPlayerScreen(controller: controller)));
        } else {
          Navigator.pop(context);
          showCustomSnackBar(status.message);
        }
      });
    }
  }

  _appleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      debugPrint("====> ${credential.toString()}");

      if (credential.email == null) {
        var authController = Get.find<ProfileSharedPrefService>();
        String? firstName = authController.getAppleUserKeyFirstName();
        String? lastName = authController.getAppleUserKeyLastName();
        String? email = authController.getAppleUserKeyEmail();
        String? appleIdentifier =
            authController.getAppleUserKeyAppleIdentifier();

        if (firstName != null &&
            lastName != null &&
            email != null &&
            appleIdentifier != null) {
          _callApiForAppleSignIn(firstName, lastName, email, appleIdentifier);
        } else {
          showCustomSnackBar(
              "unable to get the user details please remove the account from settings and try again!",
              duration: 3);
        }
      } else {
        _callApiForAppleSignIn(
          credential.givenName ?? "",
          credential.familyName ?? "",
          credential.email ?? "",
          credential.userIdentifier ?? "",
        );
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  _callApiForAppleSignIn(
      String firstName, String lastName, String email, String appleIdentifier) {
    var map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['google_identifier'] = "";
    map['apple_identifier'] = appleIdentifier;

    Get.find<ProfileSharedPrefService>()
        .setAppleUserKey(firstName, lastName, email, appleIdentifier);

    _socialSignIn(map);
  }
}
