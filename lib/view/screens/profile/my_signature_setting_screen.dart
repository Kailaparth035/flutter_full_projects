import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/signature_setting_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/others/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SignatureSettingScreen extends StatefulWidget {
  const SignatureSettingScreen({super.key});

  @override
  State<SignatureSettingScreen> createState() => _SignatureSettingScreenState();
}

class _SignatureSettingScreenState extends State<SignatureSettingScreen> {
  final _profileController = Get.find<ProfileSharedPrefService>();

  final TextEditingController _aspireSignatureTextController =
      TextEditingController();
  final TextEditingController _perposeTextController = TextEditingController();
  final TextEditingController _whatimpTextController = TextEditingController();
  final TextEditingController _teamSignatureTextController =
      TextEditingController();

// =======================================================================================

  late Future<SignatureSettingData> _futureCall;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _reFreshData();
  }

  _reFreshData() async {
    setState(() {
      isFirstLoad = true;
      _futureCall = _profileController.getSignatureSetting({});
    });
  }

  loadData(SignatureSettingData data) {
    _aspireSignatureTextController.text = data.mySignature.toString();
    _perposeTextController.text = data.purposeStatement.toString();
    _whatimpTextController.text = data.importantToMe.toString();
    _teamSignatureTextController.text = data.teamSignatureIdentity.toString();
    isFirstLoad = false;
  }

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
        body: FutureBuildWidget(
          onRetry: () {
            _reFreshData();
          },
          isList: false,
          padding: EdgeInsets.only(bottom: 10.h),
          future: _futureCall,
          child: (SignatureSettingData data) {
            return _buildMainView(context, data);
          },
        ),
      ),
    );
  }

  GestureDetector _buildMainView(
      BuildContext context, SignatureSettingData data) {
    if (isFirstLoad) loadData(data);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMainTitle(),
              10.sp.sbh,
              _buildTextboxTitleWithButton(
                AppString.aspirationalSignature1,
                AppString.signatureExercise,
                () {
                  Get.to(WebViewScreen(
                    url: data.signatureExerciseUrl.toString(),
                  ));
                  // CommonController.urlLaunch(data.signatureExerciseUrl);
                },
              ),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: "",
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.labelColor12,
                textEditingController: _aspireSignatureTextController,
              ),
              10.sp.sbh,
              _buildTextboxTitleWithButton(
                AppString.purposeStatement1,
                AppString.purposingExercise,
                () {
                  Get.to(WebViewScreen(
                    url: data.purposingExerciseUrl.toString(),
                  ));
                  // CommonController.urlLaunch(data.purposingExerciseUrl);
                },
              ),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: "",
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.labelColor12,
                textEditingController: _perposeTextController,
              ),
              10.sp.sbh,
              _buildTextboxTitle(
                AppString.whatisImportant1,
              ),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: "",
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.labelColor12,
                textEditingController: _whatimpTextController,
              ),
              10.sp.sbh,
              _buildTextboxTitle(
                AppString.teamSignature1,
              ),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: "",
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.labelColor12,
                textEditingController: _teamSignatureTextController,
              ),
              20.sp.sbh,
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
                          _updateSetting();
                        }),
              ),
              20.sp.sbh,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextboxTitleWithButton(
      String title, String buttonTitle, Function onTap) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.black,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            maxLine: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomButton2(
              buttonText: buttonTitle,
              buttonColor: AppColors.primaryColor,
              radius: 5.sp,
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              onPressed: () {
                onTap();
              }),
        ),
      ],
    );
  }

  CustomText _buildTextboxTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      maxLine: 2,
      fontWeight: FontWeight.w500,
    );
  }

  CustomText _buildMainTitle() {
    return CustomText(
      text: AppString.mySignature,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _updateSetting() async {
    Map<String, dynamic> jsonData = {
      "my_signature": _aspireSignatureTextController.text,
      "purpose_statement": _perposeTextController.text,
      "important_to_me": _whatimpTextController.text,
      "team_signature_identity": _teamSignatureTextController.text,
    };

    try {
      setState(() {
        _isLoading = true;
      });

      var response = await _profileController.updateSignature(jsonData);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _reFreshData();
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
