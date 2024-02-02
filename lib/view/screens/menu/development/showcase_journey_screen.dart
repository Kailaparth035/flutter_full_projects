import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/development/showcase_journey_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/self_reflact_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ShowCaseJourneyScreen extends StatefulWidget {
  const ShowCaseJourneyScreen({super.key});

  @override
  State<ShowCaseJourneyScreen> createState() => _ShowCaseJourneyScreenState();
}

class _ShowCaseJourneyScreenState extends State<ShowCaseJourneyScreen> {
  late Future<List<ShowcaseJourneyData>> _futureCall;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    var map = <String, dynamic>{
      "id":
          Get.find<ProfileSharedPrefService>().profileData.value.id.toString(),
    };
    setState(() {
      _futureCall =
          Get.find<DevelopmentController>().journeyCertificateDetails(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor1,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: AppbarWithBackButton(
          appbarTitle: "Showcase My Journey",
          onbackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildMainView(),
    );
  }

  FutureBuildWidget _buildMainView() {
    return FutureBuildWidget(
      onRetry: () {
        _loadData();
      },
      future: _futureCall,
      child: (List<ShowcaseJourneyData> data) {
        return _buildView(data);
      },
    );
  }

  Padding _buildView(List<ShowcaseJourneyData> data) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.sp.sbh,
            ...data.map(
              (e) => _buildListTile(
                e,
                data.indexOf(e) == data.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(ShowcaseJourneyData showcaseData, bool isLast) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.sp.sbh,
        _buildTitle(showcaseData.mainTitle.toString()),
        3.sp.sbh,
        _buildSubTitle(showcaseData.subTitle.toString()),
        10.sp.sbh,
        _buildImage(showcaseData),
        10.sp.sbh,
        _buildSubTitleDetails(showcaseData.description.toString()),
        10.sp.sbh,
        showcaseData.assessmentDetails != null
            ? buildTitleWithBGCenter(
                showcaseData.assessmentDetails!.title.toString())
            : 0.sbh,
        10.sp.sbh,
        showcaseData.assessmentDetails != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...showcaseData.assessmentDetails!.list!.map((e) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleQuestion(e.title.toString()),
                          _buildSubTitleDetails(e.description.toString()),
                          5.sp.sbh
                        ],
                      )),
                ],
              )
            : 0.sbh,
        10.sp.sbh,
        showcaseData.hours!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...showcaseData.hours!.map((e) => CustomText(
                        text: e,
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor14,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ))
                ],
              )
            : 0.sbh,
        isLast ? 20.sbh : buildDivider()
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Center(
      child: CustomText(
        text: title,
        textAlign: TextAlign.center,
        color: AppColors.secondaryColor,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTitleQuestion(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor14,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
    );
  }

  Widget _buildSubTitle(String title) {
    return Center(
      child: CustomText(
        text: title,
        textAlign: TextAlign.center,
        color: AppColors.labelColor15,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 9.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSubTitleDetails(String title) {
    // return CustomText(
    //   text: title,
    //   textAlign: TextAlign.start,
    //   color: AppColors.labelColor15,
    //   fontFamily: AppString.manropeFontFamily,
    //   fontSize: 10.sp,
    //   fontWeight: FontWeight.w500,
    // );

    return Html(
      data: title,
      style: {
        "*": Style(
          padding: HtmlPaddings.all(0.sp),
          color: AppColors.labelColor15,
          fontSize: FontSize(11.sp),
          margin: Margins.symmetric(vertical: 1.sp, horizontal: 0.sp),
        )
      },
    );
  }

  Widget _buildImage(ShowcaseJourneyData showcaseData) {
    return Stack(
      children: [
        Center(
          child: CustomImage(
            height: 110.sp,
            image: showcaseData.image.toString(),
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
            child: Align(
                alignment: Alignment.centerRight,
                child: SelfReflactViewPopUpWithChild(
                    showChild: _showCaseChild(showcaseData.infoDescription),
                    child: Image.asset(
                      AppImages.infoIc,
                      height: 16.sp,
                      width: 16.sp,
                    ))
                // SelfReflactViewPopUp(
                //     isHtml: true,
                //     title: "Description",
                //     desc:
                //         "Daily Habit Bullets enable you to list tasks that you will regularly complete as you create new habits. Use the gear to schedule a push notification or email at a set time every day .",
                //     child: Image.asset(
                //       AppImages.infoIc,
                //       height: 16.sp,
                //       width: 16.sp,
                //     )),
                ))
      ],
    );
  }

  Widget _showCaseChild(List<InfoDescription>? list) {
    return Container(
      width: context.getWidth,
      // constraints: BoxConstraints(
      //   maxHeight: context.getWidth,
      // ),
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor1,
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...list!.map(
              (e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: e.title.toString(),
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor14,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: e.description.toString(),
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor15,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  ...e.descriptionList!.map(
                    (descItem) => Padding(
                      padding: EdgeInsets.only(bottom: 1.sp),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.done_rounded,
                            color: AppColors.labelColor15,
                            size: 15.sp,
                          ),
                          5.sp.sbw,
                          Expanded(
                            child: CustomText(
                              text: descItem,
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor15,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  7.sp.sbh
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
