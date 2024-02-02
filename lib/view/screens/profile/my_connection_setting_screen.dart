import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/my_connection_setting_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_button.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_multi_select_dropdown.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyConnectionSettingScreen extends StatefulWidget {
  const MyConnectionSettingScreen({super.key});

  @override
  State<MyConnectionSettingScreen> createState() =>
      _MyConnectionSettingScreenState();
}

class _MyConnectionSettingScreenState extends State<MyConnectionSettingScreen> {
  final _profileController = Get.find<ProfileSharedPrefService>();

  final OptionItemForMultiSelect _toWhomGiveFeedbackValue =
      OptionItemForMultiSelect(
          id: null, title: AppString.selectOption, isChecked: false);
  final OptionItemForMultiSelect _fromWhomReceiveFeedbackValue =
      OptionItemForMultiSelect(
          id: null, title: AppString.selectOption, isChecked: false);

  bool isFirstLoad = true;
  bool _isLoading = false;

  // all storing variables
  bool _isShowPersonalGrowthValue = false;
  String _startupPageRadioBtn = "1";
  bool _isShowCommunityFav = false;

  List<OptionItemForMultiSelect> _toWhomGiveFeedbackList = [];
  List<OptionItemForMultiSelect> _fromWhomReceiveFeedbackList = [];

  List<OptionItemForMultiSelect> _toWhomGiveFeedbackSelectedList = [];
  List<OptionItemForMultiSelect> _fromWhomReceiveFeedbackSelectedList = [];

  late Future<MyConnectionSettingData> _futureCall;
  @override
  void initState() {
    super.initState();
    _reFreshData();
  }

  _reFreshData() async {
    setState(() {
      isFirstLoad = true;
      _futureCall = _profileController.getConnectionSettings({});
    });
  }

  loadData(MyConnectionSettingData data) {
    _isShowPersonalGrowthValue = data.showGrowth == "1";
    _isShowCommunityFav = data.communityFavorite == "1";
    _startupPageRadioBtn = data.startPage.toString();

    _toWhomGiveFeedbackList = data.giveFeedback!
        .map(
          (e) => OptionItemForMultiSelect(
              id: e.id, title: e.name.toString(), isChecked: false),
        )
        .toList();

    _toWhomGiveFeedbackSelectedList = data.giveFeedbackValue!
        .map(
          (e) => OptionItemForMultiSelect(
              id: e.id, title: e.name.toString(), isChecked: true),
        )
        .toList();

    _fromWhomReceiveFeedbackList = data.receiveFeedback!
        .map(
          (e) => OptionItemForMultiSelect(
              id: e.id, title: e.name.toString(), isChecked: false),
        )
        .toList();

    _fromWhomReceiveFeedbackSelectedList = data.receiveFeedbackValue!
        .map(
          (e) => OptionItemForMultiSelect(
              id: e.id, title: e.name.toString(), isChecked: true),
        )
        .toList();

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
          child: (MyConnectionSettingData data) {
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

  Widget _buildMainView(MyConnectionSettingData data) {
    if (isFirstLoad) loadData(data);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainTitle(),
            10.sp.sbh,
            _buildTextboxTitle(AppString.myConnectionsPreferences),
            10.sp.sbh,
            // _buildTitleToggle(
            //     AppString.showMyPersonalGrowth, MainAxisAlignment.start),
            buildTitleToggle(
                AppString.showMyPersonalGrowth, _isShowPersonalGrowthValue, () {
              setState(() {
                _isShowPersonalGrowthValue = !_isShowPersonalGrowthValue;
              });
            }),
            10.sp.sbh,
            _buildTextboxTitle(AppString.myStartupPage),
            10.sp.sbh,
            _buildStartupRadio(),
            10.sp.sbh,
            _buildTextboxTitle(AppString.communityFavorites),
            10.sp.sbh,
            _isShowCommunityFav
                ? Column(
                    children: [
                      _buildCommunityFav(),
                      10.sp.sbh,
                      _buildFromWhom(),
                      10.sp.sbh,
                      CustomButton(
                          isLoading: _isLoading,
                          buttonText: AppString.submitRequest,
                          bgColor: AppColors.labelColor7,
                          width: MediaQuery.of(context).size.width,
                          radius: Dimensions.radiusSmall,
                          height: 5.h,
                          onPressed: () {
                            _updateSetting();
                          }),
                      10.sp.sbh,
                    ],
                  )
                : 0.sbh,
            _buildYouCanReceive(data),
            10.sp.sbh,
            _buildYouCanGiveFeedback(data),
            10.sp.sbh,
          ],
        ),
      ),
    );
  }

  Container _buildYouCanGiveFeedback(MyConnectionSettingData data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.labelColor9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(7.sp),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.labelColor9),
              ),
            ),
            child: CustomText(
              text: AppString.youCangiveFeedback,
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.sp.sbh,
                _buildListitle(
                    AppString.supervisors,
                    data.giveSupervisors!
                        .map((e) => e.name.toString())
                        .toList()),
                _buildListitle(AppString.peers,
                    data.givePeers!.map((e) => e.name.toString()).toList()),
                _buildListitle(
                    AppString.directReports,
                    data.giveDirectreport!
                        .map((e) => e.name.toString())
                        .toList()),
                5.sp.sbh,
              ],
            ),
          ),
          3.sp.sbh,
        ],
      ),
    );
  }

  Container _buildYouCanReceive(MyConnectionSettingData data) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.labelColor9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(7.sp),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.labelColor9),
              ),
            ),
            child: CustomText(
              text: AppString.youCanReceiveFeedback,
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              maxLine: 5,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.sp.sbh,
                _buildListitle(
                    AppString.supervisors,
                    data.receiveSupervisors!
                        .map((e) => e.name.toString())
                        .toList()),
                _buildListitle(AppString.peers,
                    data.receivePeers!.map((e) => e.name.toString()).toList()),
                _buildListitle(
                    AppString.directReports,
                    data.receiveDirectreport!
                        .map((e) => e.name.toString())
                        .toList()),
                5.sp.sbh,
              ],
            ),
          ),
          3.sp.sbh,
        ],
      ),
    );
  }

  Widget _buildListitle(title, List<String> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          textAlign: TextAlign.start,
          color: AppColors.labelColor6,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          maxLine: 5,
          fontWeight: FontWeight.w500,
        ),
        5.sp.sbh,
        ...list.map((e) => _buildListTile2(e)),
        5.sp.sbh,
      ],
    );
  }

  Row _buildListTile2(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        20.sp.sbw,
        Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: AppColors.secondaryColor),
          height: 5.sp,
          width: 5.sp,
        ),
        5.sp.sbw,
        Expanded(
          child: CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.labelColor35,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            maxLine: 5,
            fontWeight: FontWeight.w500,
          ),
        ),
        5.sp.sbw,
      ],
    );
  }

  Container _buildFromWhom() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(7.sp),
            decoration: BoxDecoration(
              color: AppColors.labelColor,
              borderRadius: BorderRadius.circular(4.sp),
            ),
            child: _buildTitleAndValue(
                AppString.fromWhom, AppString.whouldYouLiketoReceive),
          ),
          Padding(
            padding: EdgeInsets.all(7.sp),
            child: Column(
              children: [
                CustomMultipleDropListShowListOnTopWidget(
                  _fromWhomReceiveFeedbackValue.title,
                  _fromWhomReceiveFeedbackValue,
                  _fromWhomReceiveFeedbackList,
                  fontSize: 12.sp,
                  borderColor: AppColors.labelColor,
                  bgColor: AppColors.labelColor12.withOpacity(0.4),
                  (value) {
                    _fromWhomReceiveFeedbackList = value;
                    setState(() {});
                  },
                ),
                10.sp.sbh,
                ..._fromWhomReceiveFeedbackSelectedList.map(
                  (e) => _buildSelectedUserListTile(e, isShowDelete: true),
                ),
              ],
            ),
          ),
          3.sp.sbh,
        ],
      ),
    );
  }

  Container _buildCommunityFav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(5.sp),
        border: Border.all(color: AppColors.labelColor),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(7.sp),
            decoration: BoxDecoration(
              color: AppColors.labelColor,
              borderRadius: BorderRadius.circular(4.sp),
            ),
            child: _buildTitleAndValue(
                AppString.toWhom, AppString.whouldYouLiketoGive),
          ),
          Padding(
            padding: EdgeInsets.all(7.sp),
            child: Column(
              children: [
                CustomMultipleDropListShowListOnTopWidget(
                  _toWhomGiveFeedbackValue.title,
                  _toWhomGiveFeedbackValue,
                  _toWhomGiveFeedbackList,
                  fontSize: 12.sp,
                  borderColor: AppColors.labelColor,
                  bgColor: AppColors.labelColor12.withOpacity(0.4),
                  (value) {
                    _toWhomGiveFeedbackList = value;
                    setState(() {});
                  },
                ),
                10.sp.sbh,
                ..._toWhomGiveFeedbackSelectedList.map(
                  (e) => _buildSelectedUserListTile(e, isShowDelete: false),
                ),
              ],
            ),
          ),
          3.sp.sbh,
        ],
      ),
    );
  }

  Container _buildSelectedUserListTile(OptionItemForMultiSelect e,
      {required bool isShowDelete}) {
    return Container(
      padding: EdgeInsets.all(3.sp),
      decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.labelColor,
          ),
          borderRadius: BorderRadius.circular(0)),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: CustomText(
                  text: e.title,
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor9,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  maxLine: 5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: isShowDelete
                        ? InkWell(
                            onTap: () {
                              _removeUser(e.id.toString());
                            },
                            child: Icon(
                              Icons.delete_forever,
                              color: AppColors.redColor,
                              size: 18.sp,
                            ),
                          )
                        : 0.sbh,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitleAndValue(String title, String subTiele) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          TextSpan(
            text: subTiele,
            style: TextStyle(
              fontSize: 11.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w400,
              color: AppColors.labelColor8,
            ),
          )
        ],
      ),
    );
  }

  Row _buildStartupRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildRadioButton(
              title: AppString.myDashboard,
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
              title: AppString.myConnection,
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
            SizedBox(
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
            7.sp.sbw,
            Expanded(
              child: CustomText(
                text: title,
                textAlign: TextAlign.start,
                color: AppColors.labelColor9,
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

  // Row _buildTitleToggle(String title, MainAxisAlignment align) {
  //   return Row(
  //     children: [
  //       ToggleButtonWidget(
  //         width: 45.sp,
  //         height: 18.sp,
  //         padding: 2.sp,
  //         value: _isShowPersonalGrowthValue,
  //         onChange: (val) {
  //           setState(() {
  //             _isShowPersonalGrowthValue = !_isShowPersonalGrowthValue;
  //           });
  //         },
  //         isShowText: true,
  //         activeText: AppString.on,
  //         inactiveText: AppString.off,
  //       ),
  //       10.sp.sbw,
  //       Expanded(
  //         child: CustomText(
  //           text: title,
  //           textAlign: TextAlign.start,
  //           color: AppColors.labelColor9,
  //           fontFamily: AppString.manropeFontFamily,
  //           fontSize: 12.sp,
  //           maxLine: 2,
  //           fontWeight: FontWeight.w400,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  CustomText _buildTextboxTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      maxLine: 2,
      fontWeight: FontWeight.w600,
    );
  }

  CustomText _buildMainTitle() {
    return CustomText(
      text: AppString.myConnections,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _updateSetting() async {
    String giveFeedback = _toWhomGiveFeedbackList
        .where((element) => element.isChecked)
        .map((e) => e.id.toString())
        .join(',');
    String receiveFeedback = _fromWhomReceiveFeedbackList
        .where((element) => element.isChecked)
        .map((e) => e.id.toString())
        .join(',');

    Map<String, dynamic> jsonData = {
      "show_growth": _isShowPersonalGrowthValue ? "1" : "0",
      "start_page": _startupPageRadioBtn.toString(),
      "give_feedback": giveFeedback,
      "receive_feedback": receiveFeedback,
    };

    if (kDebugMode) {
      print(jsonData);
    }
    try {
      setState(() {
        _isLoading = true;
      });

      var response =
          await _profileController.updateConnectionSettings(jsonData);
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

  _removeUser(String userId) async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areyousureyouwanttoremove,
        );
      },
    );

    if (res != null) {
      Map<String, dynamic> jsonData = {
        "receive_user_id": userId,
      };

      try {
        // ignore: use_build_context_synchronously
        buildLoading(context);
        var response =
            await _profileController.deleteReceiveFeedbackUser(jsonData);
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
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }
}
