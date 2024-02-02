import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/privacy_setting_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class PrivacySettingScreen extends StatefulWidget {
  const PrivacySettingScreen({super.key});

  @override
  State<PrivacySettingScreen> createState() => _PrivacySettingScreenState();
}

class _PrivacySettingScreenState extends State<PrivacySettingScreen> {
  final _profileController = Get.find<ProfileSharedPrefService>();

  bool _isLoading = false;

  List<DropDownOptionItemMenu> insignstremList = [];
  DropDownOptionItemMenu insignstremValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  List<DropDownOptionItemMenu> personalList = [];
  DropDownOptionItemMenu personalValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  List<DropDownOptionItemMenu> signatureList = [];
  DropDownOptionItemMenu signatureValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  List<DropDownOptionItemMenu> favQuoteList = [];
  DropDownOptionItemMenu favQuoteValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  bool _isProfileLock = false;
  bool isFirstLoad = true;
  late Future<PrivacySettingData> _futureCall;
  @override
  void initState() {
    super.initState();
    _reFreshData();
  }

  _reFreshData() async {
    setState(() {
      isFirstLoad = true;
      _futureCall = _profileController.getPrivacySettings({});
    });
  }

  loadData(PrivacySettingData data) {
    _isProfileLock = data.lockProfile == 1 ? true : false;

    insignstremList = data.questionOneValue!
        .map(
          (e) => DropDownOptionItemMenu(
            id: e.id,
            title: e.title.toString(),
          ),
        )
        .toList();

    if (data.questionOne != 0 && data.questionOne != null) {
      var item = data.questionOneValue!
          .where(
              (element) => element.id.toString() == data.questionOne.toString())
          .toList();

      if (item.isNotEmpty) {
        insignstremValue = DropDownOptionItemMenu(
            id: item.first.id, title: item.first.title.toString());
      }
    }

    personalList = data.showPersonalInfoValue!
        .map(
          (e) => DropDownOptionItemMenu(
            id: e.id,
            title: e.title.toString(),
          ),
        )
        .toList();

    if (data.showPersonalInfo != 0 && data.showPersonalInfo != null) {
      var item = data.showPersonalInfoValue!
          .where((element) =>
              element.id.toString() == data.showPersonalInfo.toString())
          .toList();

      if (item.isNotEmpty) {
        personalValue = DropDownOptionItemMenu(
            id: item.first.id, title: item.first.title.toString());
      }
    }

    signatureList = data.showAboutMeValue!
        .map(
          (e) => DropDownOptionItemMenu(
            id: e.id,
            title: e.title.toString(),
          ),
        )
        .toList();

    if (data.showAboutMe != 0 && data.showAboutMe != null) {
      var item = data.showAboutMeValue!
          .where(
              (element) => element.id.toString() == data.showAboutMe.toString())
          .toList();

      if (item.isNotEmpty) {
        signatureValue = DropDownOptionItemMenu(
            id: item.first.id, title: item.first.title.toString());
      }
    }

    favQuoteList = data.showFavouriteQuoteValue!
        .map(
          (e) => DropDownOptionItemMenu(
            id: e.id,
            title: e.title.toString(),
          ),
        )
        .toList();

    if (data.showFavouriteQuote != 0 && data.showFavouriteQuote != null) {
      var item = data.showFavouriteQuoteValue!
          .where((element) =>
              element.id.toString() == data.showFavouriteQuote.toString())
          .toList();

      if (item.isNotEmpty) {
        favQuoteValue = DropDownOptionItemMenu(
            id: item.first.id, title: item.first.title.toString());
      }
    }
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
          onRetry: () {
            _reFreshData();
          },
          isList: false,
          future: _futureCall,
          child: (PrivacySettingData data) {
            return CustomSlideUpAndFadeWidget(child: _buildMainView(data));
          },
        ),
      ),
    );
  }

  SingleChildScrollView _buildMainView(PrivacySettingData datas) {
    if (isFirstLoad) loadData(datas);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainTitle(),
            10.sp.sbh,
            _buildTextboxTitle(AppString.whocanseeyourInsightStream),
            5.sp.sbh,
            CustomDropListForMessageTwo(
              insignstremValue.title,
              insignstremValue,
              insignstremList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (selectedValue) {
                insignstremValue = selectedValue;
                setState(() {});
              },
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.whocanseeyourPersonalInformation),
            5.sp.sbh,
            CustomDropListForMessageTwo(
              personalValue.title,
              personalValue,
              personalList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (selectedValue) {
                personalValue = selectedValue;
                setState(() {});
              },
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.whocanseeyourSignature),
            5.sp.sbh,
            CustomDropListForMessageTwo(
              signatureValue.title,
              signatureValue,
              signatureList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (selectedValue) {
                signatureValue = selectedValue;
                setState(() {});
              },
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.whocanseeyourFavoriteQuote),
            5.sp.sbh,
            CustomDropListForMessageTwo(
              favQuoteValue.title,
              favQuoteValue,
              favQuoteList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (selectedValue) {
                favQuoteValue = selectedValue;
                setState(() {});
              },
            ),
            15.sp.sbh,
            _buildTitleToggle(),
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
                        _updateSetting();
                      }),
            ),
            20.sp.sbh,
          ],
        ),
      ),
    );
  }

  Row _buildTitleToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTextboxTitle(AppString.myProfileLock),

        ToggleButtonWidget(
          value: _isProfileLock,
          onChange: (val) {
            setState(() {
              _isProfileLock = val;
            });
          },
          isShowText: true,
        )
        // FlutterSwitch(
        //   width: 45.sp,
        //   height: 20.sp,
        //   padding: 2.sp,
        //   activeText: AppString.yes,
        //   inactiveText: AppString.no,
        //   showOnOff: true,
        //   activeTextColor: AppColors.primaryColor,
        //   inactiveTextColor: AppColors.redColor,
        //   activeTextFontWeight: FontWeight.w500,
        //   inactiveTextFontWeight: FontWeight.w500,
        //   inactiveToggleColor: AppColors.labelColor8,
        //   activeToggleColor: AppColors.primaryColor,
        //   activeColor: AppColors.labelColor46,
        //   inactiveColor: AppColors.labelColor46,
        //   valueFontSize: 12.sp,
        //   toggleSize: 15.sp,
        //   value: _isProfileLock,
        //   onToggle: (val) {
        //     setState(() {
        //       _isProfileLock = val;
        //     });
        //   },
        // ),
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
      text: AppString.privacySetting,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _updateSetting() async {
    Map<String, dynamic> jsonData = {
      "question_one": insignstremValue.id.toString(),
      "show_personal_info": personalValue.id.toString(),
      "show_about_me": signatureValue.id.toString(),
      "show_favourite_quote": favQuoteValue.id.toString(),
      "lock_profile": _isProfileLock ? "1" : "0",
    };
    try {
      setState(() {
        _isLoading = true;
      });

      var response = await _profileController.updatePrivacySettings(jsonData);
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
