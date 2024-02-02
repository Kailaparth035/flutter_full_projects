import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/integration_setting_model.dart';
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
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class IntegrationSettingScreen extends StatefulWidget {
  const IntegrationSettingScreen({super.key});

  @override
  State<IntegrationSettingScreen> createState() =>
      _IntegrationSettingScreenState();
}

class _IntegrationSettingScreenState extends State<IntegrationSettingScreen> {
  final _profileController = Get.find<ProfileSharedPrefService>();

  bool isFirstLoad = true;
  bool _isLoading = false;

  // all storing variables
  bool _isGoogleContacts = false;
  bool _isCalender = false;
  String _startupPageRadioBtn = "1";

  late Future<IntegrationSettingData> _futureCall;
  @override
  void initState() {
    super.initState();
    _reFreshData();
  }

  _reFreshData() async {
    setState(() {
      isFirstLoad = true;
      _futureCall = _profileController.getIntegrationSetting({});
    });
  }

  loadData(IntegrationSettingData data) {
    _isGoogleContacts = data.googleContact == "1";
    _isCalender = data.calendarIntegration == "1";
    _startupPageRadioBtn = data.emailIntegration.toString();
    isFirstLoad = false;
  }

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
          isList: false,
          onRetry: () {
            _reFreshData();
          },
          future: _futureCall,
          child: (IntegrationSettingData data) {
            return CustomSlideUpAndFadeWidget(
              child: _buildMainView(
                data,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainView(IntegrationSettingData data) {
    if (isFirstLoad) loadData(data);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainTitle(),
            20.sp.sbh,
            _buildgoogleContacts(AppString.googleContacts, _isGoogleContacts,
                (val) {
              setState(() {
                _isGoogleContacts = val;
              });
            }),
            10.sp.sbh,
            _buildgoogleContacts(AppString.calendar, _isCalender, (val) {
              setState(() {
                _isCalender = val;
              });
            }),
            10.sp.sbh,
            _isCalender ? _buildStartupRadio() : 0.sbh,
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
                        _updateSetting(data.slackIntegration.toString());
                      }),
            ),
            10.sp.sbh,
          ],
        ),
      ),
    );
  }

  Container _buildgoogleContacts(String title, bool val, Function onChange) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.sp),
        border: Border.all(color: AppColors.labelColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8.sp),
                  child: CustomText(
                    text: title,
                    textAlign: TextAlign.start,
                    color: AppColors.black,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    maxLine: 5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.backgroundColor1),
                      borderRadius: BorderRadius.circular(2.sp),
                      color: AppColors.backgroundColor1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: ToggleButtonWidget(
                          width: 45.sp,
                          height: 18.sp,
                          padding: 2.sp,
                          value: val,
                          isShowText: true,
                          activeText: AppString.on,
                          inactiveText: AppString.off,
                          onChange: (val) {
                            onChange(val);
                          },
                        ),
                        // FlutterSwitch(
                        //   width: 45.sp,
                        //   height: 18.sp,
                        //   padding: 2.sp,
                        //   activeText: AppString.on,
                        //   inactiveText: AppString.off,
                        //   showOnOff: true,
                        //   activeTextColor: AppColors.primaryColor,
                        //   inactiveTextColor: AppColors.redColor,
                        //   activeTextFontWeight: FontWeight.w500,
                        //   inactiveTextFontWeight: FontWeight.w500,
                        //   inactiveToggleColor: AppColors.labelColor8,
                        //   activeToggleColor: AppColors.primaryColor,
                        //   activeColor: AppColors.labelColor46,
                        //   inactiveColor: AppColors.labelColor46,
                        //   toggleSize: 14.sp,
                        //   value: val,
                        //   onToggle: (val1) {
                        //     onChange(val1);
                        //   },
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Row _buildStartupRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildRadioButton(
              title: AppString.googlecalendar,
              gpValue: _startupPageRadioBtn,
              value: "1",
              onTap: () {
                setState(() {
                  _startupPageRadioBtn = "1";
                });
              }),
        ),
        Expanded(
          child: _buildRadioButton(
              title: AppString.outlookcalendar,
              gpValue: _startupPageRadioBtn,
              value: "2",
              onTap: () {
                setState(() {
                  _startupPageRadioBtn = "2";
                });
              }),
        )
      ],
    );
  }

  Widget _buildRadioButton({
    required String title,
    required String gpValue,
    required String value,
    required Function onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.translate(
              offset: Offset(0, 2.sp),
              child: SizedBox(
                height: 15,
                width: 15,
                child: Radio(
                  value: value,
                  groupValue: gpValue,
                  activeColor: AppColors.labelColor8,
                  fillColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.labelColor8),
                  onChanged: (value) {
                    onTap();
                  },
                ),
              ),
            ),
            7.sp.sbw,
            Expanded(
              child: CustomText(
                text: title,
                textAlign: TextAlign.start,
                color: AppColors.black,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                maxLine: 5,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }

  CustomText _buildMainTitle() {
    return CustomText(
      text: AppString.integrations,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _updateSetting(String slakIntegratioj) async {
    Map<String, dynamic> jsonData = {
      "google_contact": _isGoogleContacts ? "1" : "0",
      "calendar_integration": _isCalender ? "1" : "0",
      "slack_integration": slakIntegratioj,
      "email_integration": !_isCalender ? "0" : _startupPageRadioBtn,
    };

    try {
      setState(() {
        _isLoading = true;
      });

      var response = await _profileController.updateIntegration(jsonData);
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
