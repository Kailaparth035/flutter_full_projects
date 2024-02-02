import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_coaches_controller.dart';
import 'package:aspirevue/data/model/response/coach_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/custom_tooltip_widget.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_video.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_button.dart';
import 'package:aspirevue/view/base/custom_dropdown_for_about.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_tab_bar_style.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:aspirevue/view/screens/menu/my_connection/my_connection_personal_growth_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyCoachDetailsScreen extends StatefulWidget {
  const MyCoachDetailsScreen({
    super.key,
    required this.title,
    required this.currentIndex,
    required this.id,
    required this.type,
  });
  final String title;
  final String id;
  final String type;
  final int currentIndex;
  @override
  State<MyCoachDetailsScreen> createState() => _MyCoachDetailsScreenState();
}

class _MyCoachDetailsScreenState extends State<MyCoachDetailsScreen>
    with TickerProviderStateMixin {
  final _myCoachController = Get.find<MyCoachesController>();

  final FocusNode _mySignatureIdentityFocus = FocusNode();
  final TextEditingController _mySignatureIdentityController =
      TextEditingController();

  final FocusNode _teamSignatureIdentityFocus = FocusNode();
  final TextEditingController _teamSignatureIdentityController =
      TextEditingController();

  final FocusNode _valueCommitmentsFocus = FocusNode();
  final TextEditingController _valueCommitmentsController =
      TextEditingController();

  final FocusNode _keyThemesFocus = FocusNode();
  final TextEditingController _keyThemesController = TextEditingController();

  int index = 0;

  late Future<CoachDetailsData?> _futureCall;

  bool _isFirstload = true;

  @override
  void initState() {
    super.initState();
    index = widget.currentIndex;

    _loadData();
  }

  _loadData() {
    _isFirstload = true;
    var map = <String, dynamic>{
      "user_id": widget.id,
      "type": widget.type,
    };
    setState(() {
      _futureCall =
          Get.find<MyCoachesController>().getCoachMentorMenteeDetailsUri(map);
    });
  }

  bool _isSaveLoading = false;

  _updateMysignature() async {
    try {
      setState(() {
        _isSaveLoading = true;
      });

      var map = <String, dynamic>{
        "user_id": widget.id,
        "my_signature": _mySignatureIdentityController.text,
        "team_signature_identity": _teamSignatureIdentityController.text,
        "commitments": _valueCommitmentsController.text,
        "key_themes": _keyThemesController.text,
      };

      var response = await _myCoachController.updateSignatureItem(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _loadData();
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isSaveLoading = false;
      });
    }
  }

  _updateActionItem(bool val, String id) async {
    try {
      buildLoading(Get.context!);
      var map = <String, dynamic>{
        "type": widget.type,
        "id": id,
        "status": val ? "1" : "0",
      };

      var response =
          await _myCoachController.updateCoachMentorMenteeActionItem(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _loadData();
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.myConnections,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        // bottomNavigationBar: const BottomNavBar(
        //   isFromMain: false,
        // ),
        body: DefaultTabController(
          length: 2,
          initialIndex: index,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tabSection(context),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildFutureBuilder(),
                        const MyConnectionPersonalGrowthView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFutureBuilder() {
    return FutureBuildWidget(
      onRetry: () {
        _loadData();
      },
      future: _futureCall,
      child: (CoachDetailsData? data) {
        if (_isFirstload) {
          if (data!.signatureItems!.isNotEmpty) {
            _mySignatureIdentityController.text =
                data.signatureItems!.first.mySignature ?? "";
            _teamSignatureIdentityController.text =
                data.signatureItems!.first.teamSignatureIdentity ?? "";
            _valueCommitmentsController.text =
                data.signatureItems!.first.commitments ?? "";
            _keyThemesController.text =
                data.signatureItems!.first.keyThemes ?? "";
          }
        }

        _isFirstload = false;
        return _buildDetailView(data);
      },
    );
  }

  Widget _buildDetailView(CoachDetailsData? data) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          15.sp.sbh,
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
            color: AppColors.black,
            text: widget.title,
            textAlign: TextAlign.start,
            maxLine: 20,
            fontFamily: AppString.manropeFontFamily,
          ),
          10.sp.sbh,
          _buildSignatureItems(),
          10.sp.sbh,
          _buildActionItems(data),
          10.sp.sbh,
          widget.type == "1" ? _buildAssessmentResults(data) : 0.sbh,
          widget.type == "1" ? 10.sp.sbh : 0.sbh,
          15.sp.sbh,
        ],
      ),
    );
  }

  int _selected = 1000000;

  Widget _buildAssessmentResults(CoachDetailsData? data) {
    return CustomDropForAbout(
      index: 2,
      selected: _selected,
      onTap: (selectedValue) {
        setState(() {
          _selected = selectedValue;
        });
      },
      isGredient: true,
      bottomBgColor: AppColors.labelColor51,
      bottomborderColor: AppColors.labelColor,
      borderColor: Colors.transparent,
      headingText: AppString.assessmentResults,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(5.sp),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 249, 250, 250),
          ),
          child: Column(
            children: [
              _buildAssessmentResultsHeader(),
              5.sbh,
              data!.assessment!.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 5.sp),
                      child: Center(
                        child: CustomText(
                          text: "No actions found!",
                          textAlign: TextAlign.start,
                          color: AppColors.black,
                          maxLine: 2,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        ...data.assessment!
                            .map((e) => _buildAssessmentResultsListTile1(e)),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAssessmentResultsListTile1(Assessment assement) {
    return Container(
      padding: EdgeInsets.all(7.sp),
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: assement.productName.toString(),
              textAlign: TextAlign.start,
              color: AppColors.black,
              maxLine: 2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () async {
                  CommonController.downloadFile(
                      assement.pdfFile.toString(), context);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 20.sp),
                  child: Image.asset(
                    AppImages.pdfBlueIc,
                    height: 12.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildAssessmentResultsHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor45,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: AppString.productName,
              textAlign: TextAlign.start,
              color: AppColors.white,
              maxLine: 2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: CustomText(
              text: AppString.fileName,
              textAlign: TextAlign.end,
              color: AppColors.white,
              maxLine: 2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  CustomDropForAbout _buildSignatureItems() {
    return CustomDropForAbout(
      index: 0,
      selected: _selected,
      onTap: (selectedValue) {
        setState(() {
          _selected = selectedValue;
        });
      },
      isGredient: true,
      bottomBgColor: AppColors.labelColor51,
      bottomborderColor: AppColors.labelColor,
      borderColor: Colors.transparent,
      headingText: AppString.signatureItems,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextBoxTitleWithIcon(AppString.mySignatureIdentity,
                  "Describe how you would like to be experienced by others. This is your reputation, a statement of yourself at your best. This is who you aspire to be."),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                focusNode: _mySignatureIdentityFocus,
                inputAction: TextInputAction.done,
                labelText: AppString.mySignatureIdentity,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.white,
                textEditingController: _mySignatureIdentityController,
              ),
              10.sp.sbh,
              _buildTextBoxTitleWithIcon(AppString.teamSignatureIdentity,
                  "Describe how your team would like to be known by customers and other departments in the organization. This is who your team aspires to be."),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                focusNode: _teamSignatureIdentityFocus,
                inputAction: TextInputAction.done,
                labelText: AppString.teamSignatureIdentity,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.white,
                textEditingController: _teamSignatureIdentityController,
              ),
              10.sp.sbh,
              _buildTextBoxTitleWithIcon(AppString.valueCommitments,
                  "My prioritized pursuits; things I care most about. (May be drawn from Values Inventory)"),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                focusNode: _valueCommitmentsFocus,
                inputAction: TextInputAction.done,
                labelText: AppString.valueCommitments,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.white,
                textEditingController: _valueCommitmentsController,
              ),
              10.sp.sbh,
              _buildTextBoxTitleWithIcon(AppString.keyThemes,
                  "What are key factors the Supervisor should keep in mind when working with this employee? (Score elevations, motivators)"),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                focusNode: _keyThemesFocus,
                inputAction: TextInputAction.done,
                labelText: AppString.keyThemes,
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 2,
                editColor: AppColors.white,
                textEditingController: _keyThemesController,
              ),
              10.sp.sbh,
              CustomButton(
                  isLoading: _isSaveLoading,
                  buttonText: AppString.update,
                  width: MediaQuery.of(context).size.width,
                  radius: Dimensions.radiusSmall,
                  height: 5.h,
                  onPressed: () {
                    _updateMysignature();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextBoxTitleWithIcon(String title, desc) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 17,
        ),
        children: [
          TextSpan(
            text: "$title  ",
            style: TextStyle(
              fontSize: 12.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w600,
              color: AppColors.labelColor14,
            ),
          ),
          WidgetSpan(
            child: MyTooltip(
              message: desc,
              child: Container(
                padding: EdgeInsets.only(bottom: 1.sp),
                child: Image.asset(
                  AppImages.exlamationIc,
                  width: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItems(CoachDetailsData? data) {
    return CustomDropForAbout(
      index: 1,
      selected: _selected,
      onTap: (selectedValue) {
        setState(() {
          _selected = selectedValue;
        });
      },
      isGredient: true,
      bottomBgColor: AppColors.labelColor51,
      bottomborderColor: AppColors.labelColor,
      borderColor: Colors.transparent,
      headingText: AppString.actionItems,
      child: InkWell(
        onTap: () {},
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(5.sp),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 249, 250, 250),
          ),
          child: Column(
            children: [
              _buildActionHeader(),
              5.sbh,
              data!.actionItems!.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 5.sp),
                      child: Center(
                        child: CustomText(
                          text: "No actions found!",
                          textAlign: TextAlign.start,
                          color: AppColors.black,
                          maxLine: 2,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : Column(children: [
                      ...data.actionItems!.map(
                        (e) => _buildActionListTile1(e),
                      ),
                    ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionListTile1(ActionItem data) {
    return Container(
      padding: EdgeInsets.all(7.sp),
      decoration: const BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomText(
              text: data.date.toString(),
              textAlign: TextAlign.start,
              color: AppColors.black,
              maxLine: 2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          5.sp.sbw,
          Expanded(
            child: InkWell(
              onTap: () {
                if (data.type == Type.FEEDBACK) {
                  CommonController.urlLaunch(data.feedbackUrl.toString());
                  return;
                }

                if (data.type == Type.VIDEO) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VideoAlertDialog(
                        url: data.internalUrl.toString(),
                      );
                    },
                  );
                } else {
                  CommonController.urlLaunch(data.internalUrl.toString());
                }
              },
              child: CustomText(
                text: data.actionItemName.toString(),
                textAlign: TextAlign.center,
                color: AppColors.black,
                maxLine: 2,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          5.sp.sbw,
          data.type == Type.FEEDBACK
              ? Expanded(
                  child: InkWell(
                    onTap: () {
                      CommonController.urlLaunch(data.feedbackUrl.toString());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.sp,
                        vertical: 3.sp,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.labelColor40,
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                      child: CustomText(
                        text: AppString.feedback,
                        textAlign: TextAlign.center,
                        color: AppColors.white,
                        maxLine: 2,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ToggleButtonWidget(
                        width: 50.sp,
                        height: 18.sp,
                        padding: 2.sp,
                        value: data.status == "true",
                        onChange: (val) {
                          _updateActionItem(val, data.id.toString());
                        },
                        isShowText: true,
                        activeText: AppString.yes,
                        inactiveText: AppString.no,
                      ),
                      // FlutterSwitch(
                      //   width: 50.sp,
                      //   height: 18.sp,
                      //   padding: 2.sp,
                      //   activeText: AppString.yes,
                      //   inactiveText: AppString.no,
                      //   showOnOff: true,
                      //   activeTextColor: Colors.black,
                      //   inactiveTextColor: AppColors.redColor,
                      //   activeTextFontWeight: FontWeight.w500,
                      //   inactiveTextFontWeight: FontWeight.w500,
                      //   inactiveToggleColor: AppColors.labelColor8,
                      //   activeToggleColor: AppColors.labelColor8,
                      //   activeColor: AppColors.labelColor46,
                      //   inactiveColor: AppColors.labelColor46,
                      //   toggleSize: 15.sp,
                      //   value: data.status == "true",
                      //   onToggle: (val) {
                      //     _updateActionItem(val, data.id.toString());
                      //   },
                      // ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  Container _buildActionHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: AppColors.labelColor45,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
              text: AppString.date,
              textAlign: TextAlign.start,
              color: AppColors.white,
              maxLine: 2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: CustomText(
              text: AppString.actionItem,
              textAlign: TextAlign.start,
              color: AppColors.white,
              maxLine: 2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: CustomText(
              text: AppString.completed,
              textAlign: TextAlign.end,
              color: AppColors.white,
              maxLine: 2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget tabSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedTabBar(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.labelColor,
                width: 2.0,
              ),
            ),
          ),
          tabBar: TabBar(
            isScrollable: false,
            indicatorPadding: EdgeInsets.only(top: 0.5.sp),
            indicatorWeight: 2.0,
            labelPadding: EdgeInsets.only(left: 0.sp, right: 0.sp),
            indicator: const ShapeDecoration(
                shape: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 2.0,
                        style: BorderStyle.solid)),
                gradient: LinearGradient(colors: [
                  AppColors.primaryColor,
                  AppColors.secondaryColor
                ])),
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              StatefulBuilder(builder: (context, setState) {
                DefaultTabController.of(context).addListener(() {
                  setState(() {
                    index = DefaultTabController.of(context).index;
                  });
                });
                return Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: AppColors.backgroundColor1,
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color:
                        index == 0 ? AppColors.black : AppColors.labelColor52,
                    text: AppString.workPlace,
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                );
              }),
              StatefulBuilder(builder: (context, setState) {
                DefaultTabController.of(context).addListener(() {
                  setState(() {
                    index = DefaultTabController.of(context).index;
                  });
                });
                return Container(
                  height: 40,
                  alignment: Alignment.center,
                  color: AppColors.backgroundColor1,
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color:
                        index == 1 ? AppColors.black : const Color(0xff808191),
                    text: AppString.personalGrowth,
                    textAlign: TextAlign.start,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
