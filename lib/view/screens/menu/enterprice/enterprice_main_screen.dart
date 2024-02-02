import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/data/model/response/enterprise/enterprise_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/webview_widget.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_for_course_description.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/e_learning_card_widget.dart';
import 'package:aspirevue/view/screens/menu/enterprice/widget/enterprice_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EnterpriceScreen extends StatefulWidget {
  const EnterpriceScreen({super.key, required this.enterpriseId});
  final String enterpriseId;
  @override
  State<EnterpriceScreen> createState() => _EnterpriceScreenState();
}

class _EnterpriceScreenState extends State<EnterpriceScreen> {
  final _enterPriseController = Get.find<EnterpriseController>();
  @override
  void initState() {
    _reloadData(true);
    super.initState();
  }

  Future _reloadData(bool isLoading) async {
    await _enterPriseController.getEnterPriseDetails(
        isLoading, widget.enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: "My Enterprise",
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: _buildMainView(),
      ),
    );
  }

  Widget _buildMainView() {
    return GetBuilder<EnterpriseController>(builder: (storeController) {
      if (storeController.isLoadingEnterPrise) {
        return const Center(child: CustomLoadingWidget());
      }
      if (storeController.isErrorEnterPrise ||
          storeController.enterPriseData == null) {
        return Center(
          child: CustomErrorWidget(
            isNoData: storeController.isErrorEnterPrise == false,
            onRetry: () {
              storeController.getEnterPriseDetails(true, widget.enterpriseId);
            },
            text: storeController.errorMsgEnterPrise,
          ),
        );
      } else {
        return _buildView(storeController.enterPriseData!);
      }
    });
  }

  Widget _buildView(EnterPriseData data) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () => _enterPriseController.getEnterPriseDetails(
            true, widget.enterpriseId),
        child: GestureDetector(
          onTap: () {
            CommonController.hideKeyboard(context);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(data),
                  15.sp.sbh,
                  _buildTitleAndIcon(data.followerCount),
                  5.sp.sbh,
                  _buildDivider(AppColors.labelColor89),
                  10.sp.sbh,
                  _buildTextDescription(data.aboutInfo.toString()),
                  10.sp.sbh,
                  data.isShowCourseSection == 1
                      ? Column(
                          children: [
                            15.sp.sbh,
                            _buildTitleWithBorder(
                                "eLearning Courses",
                                Column(
                                  children: [
                                    ...data.courses!.map(
                                      (e) => ELearningCardWidget(
                                        isEnterPrise: true,
                                        course: e,
                                        onReload: () {
                                          _reloadData(false);
                                        },
                                        userId: data.userId.toString(),
                                      ),
                                    )
                                  ],
                                )),
                            15.sp.sbh,
                          ],
                        )
                      : 0.sbh,
                  data.isShowNewsSection == 1
                      ? EnterpriseNewsWidget(
                          isFromDetailsScreen: false,
                          enterpriseId: widget.enterpriseId)
                      : 0.sbh,
                  data.isShowFilterListSection == 1
                      ? Column(
                          children: [
                            5.sp.sbh,
                            ...data.jobBoards!.map((e) => _buildJobCard(e)),
                            // 10.sp.sbh,
                          ],
                        )
                      : 0.sbh,
                  data.wistiaEmbedCode != ""
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            data.wistiaTitle != ""
                                ? CustomText(
                                    text: data.wistiaTitle.toString(),
                                    textAlign: TextAlign.start,
                                    color: AppColors.black,
                                    fontFamily: AppString.manropeFontFamily,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  )
                                : 0.sbh,
                            data.wistiaTitle != "" ? 10.sp.sbh : 0.sp.sbh,
                            SizedBox(
                                height: context.getWidth * 1.3,
                                width: context.getWidth,
                                child: WebViewWidgetView(
                                    url: data.wistiaEmbedCode.toString())),
                            10.sp.sbh,
                          ],
                        )
                      : 0.sbh
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard(JobBoard jobBoard) {
    return SizedBox(
      width: context.getWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.getWidth,
              decoration: BoxDecoration(
                color: AppColors.labelColor15.withOpacity(0.85),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 5.sp),
                child: CustomText(
                  text: jobBoard.title.toString(),
                  textAlign: TextAlign.start,
                  color: AppColors.white,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: context.getWidth,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.labelColor),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(7.sp),
                  bottomRight: Radius.circular(7.sp),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 7.sp, vertical: 7.sp),
                    child: CustomText(
                      text: jobBoard.description.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.black,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  jobBoard.records!.isEmpty
                      ? 0.sbh
                      : _buildDivider(AppColors.labelColor),
                  ...jobBoard.records!.map((e) {
                    bool isLast = jobBoard.records!.length ==
                        jobBoard.records!.indexOf(e) + 1;
                    return Column(
                      children: [
                        _buildBoxRowWithTwoExpanded(
                          "DATE POSTED:",
                          e.datePosted.toString(),
                          "POSITION:",
                          e.position.toString(),
                        ),
                        _buildBoxRowWithTwoExpanded(
                          "DIVISION:",
                          e.division.toString(),
                          "LOCATION:",
                          e.location.toString(),
                        ),
                        _buildDivider(AppColors.labelColor),
                        10.sp.sbh,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.sp),
                          child: CustomButton2(
                              buttonText: AppString.view,
                              buttonColor: AppColors.primaryColor,
                              radius: 5.sp,
                              width: double.infinity,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              onPressed: () {
                                showDialog(
                                  context: Get.context!,
                                  builder: (BuildContext context) {
                                    return CustomAlertForCourseDescription(
                                      title: "View Description",
                                      description: e.description.toString(),
                                    );
                                  },
                                );
                              }),
                        ),
                        10.sp.sbh,
                        isLast
                            ? 0.sbh
                            : Column(
                                children: [
                                  _buildDivider(
                                      AppColors.labelColor15.withOpacity(0.54)),
                                ],
                              ),
                      ],
                    );
                  })
                ],
              ),
            ),
            15.sp.sbh
          ],
        ),
      ),
    );
  }

  _buildBoxRowWithTwoExpanded(
      String title1, String value1, String title2, String value2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child:
              _buildTitleDescription(title1, value1, CrossAxisAlignment.start),
        ),
        Expanded(
          flex: 2,
          child:
              _buildTitleDescription(title2, value2, CrossAxisAlignment.start),
        )
      ],
    );
  }

  _buildTitleDescription(
      String title, String subTitle, CrossAxisAlignment align) {
    return Container(
      constraints: BoxConstraints(maxWidth: context.getWidth / 2 - 30.sp),
      child: Padding(
        padding: EdgeInsets.all(7.sp),
        child: Column(
          crossAxisAlignment: align,
          children: [
            CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: AppColors.labelColor2,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
            ),
            CustomText(
              text: subTitle,
              textAlign: TextAlign.start,
              color: AppColors.black,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Column _buildTitleWithBorder(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(7.sp),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.labelColor,
            ),
          ),
          child: CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.labelColor8,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 9.sp, right: 9.sp, top: 9.sp),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppColors.labelColor,
              ),
              right: BorderSide(
                color: AppColors.labelColor,
              ),
              bottom: BorderSide(
                color: AppColors.labelColor,
              ),
            ),
          ),
          child: child,
        )
      ],
    );
  }

  Widget _buildTextDescription(String info) {
    return Html(
      data: info,
      style: {
        "*": Style(
          color: AppColors.labelColor15,
          fontFamily: AppString.manropeFontFamily,
          padding: HtmlPaddings.all(0),
          margin: Margins.all(0),
          fontSize: FontSize(9.sp),
        ),
      },
    );
  }

  Divider _buildDivider(Color color) {
    return Divider(
      color: color,
      height: 1.sp,
      thickness: 1,
    );
  }

  Row _buildTitleAndIcon(int? follower) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CustomText(
            text: "About",
            textAlign: TextAlign.start,
            color: AppColors.labelColor8,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Transform.translate(
                  offset: Offset(0, 0 - 2.sp),
                  child: Image.asset(
                    AppImages.userFollowedBlackIc,
                    height: 10.sp,
                  ),
                ),
              ),
              WidgetSpan(
                child: CustomText(
                  text: " $follower followers",
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(EnterPriseData data) {
    return Stack(
      children: [
        Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.labelColor9.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(10.sp),
            ),
            child: Column(
              children: [
                Container(
                  height: 80.sp,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.labelColor19,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.sp),
                      topRight: Radius.circular(9.sp),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.sp),
                      topRight: Radius.circular(9.sp),
                    ),
                    child: CustomImage(
                      height: double.infinity,
                      image: data.coverLogo.toString(),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.labelColor19,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(9.sp),
                      bottomRight: Radius.circular(9.sp),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            30.sp.sbh,
                            RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: CustomText(
                                      text: data.displayName.toString(),
                                      textAlign: TextAlign.start,
                                      color: AppColors.black,
                                      fontFamily: AppString.manropeFontFamily,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Transform.translate(
                                      offset: Offset(0, -10.sp),
                                      child: Image.asset(
                                        AppImages.verifiedIc,
                                        height: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomText(
                              text: "@${data.name}",
                              textAlign: TextAlign.start,
                              color: AppColors.hintColor,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                      CustomButton2(
                          isDisable: data.followBtnDisable == 1,
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.sp,
                            vertical: 7.sp,
                          ),
                          icon: data.followBtnText.toString() == "Following"
                              ? AppImages.userFollowedIc
                              : data.followBtnText.toString() == "Follow"
                                  ? AppImages.userPlusWhiteIc
                                  : AppImages.userUnfollowIc,
                          buttonText: data.followBtnText.toString(),
                          radius: 5.sp,
                          fontWeight: FontWeight.w700,
                          fontSize: 10.sp,
                          onPressed: () {
                            _followEnterprise(
                              data.id.toString(),
                              data.followBtnActionText.toString(),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            )),
        Positioned(
          top: 50.sp,
          left: 10.sp,
          child: Container(
            padding: EdgeInsets.all(3.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 1.5.sp,
                color: AppColors.labelColor9.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(2000),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2000),
              child: CustomImage(
                height: 55.sp,
                width: 55.sp,
                image: data.logo.toString(),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _followEnterprise(String enterPriseId, String actionType) async {
    Map<String, dynamic> map = {
      "enterprise_id": enterPriseId,
      "action_type": actionType,
    };

    try {
      buildLoading(Get.context!);
      bool? result = await _enterPriseController.followEnterprise(map: map);

      if (result != null && result == true) {
        await _reloadData(false);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
  }
}
