import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/alert_for_completed_steps.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_gradient_text.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/toggle_button_widget.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/alert_dialog_cart.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart';

buildLoadingForDialog() {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 20.sp),
      child: SizedBox(
        height: 20.sp,
        width: 20.sp,
        child: const CircularProgressIndicator(
          strokeWidth: 1,
          color: AppColors.black,
        ),
      ),
    ),
  );
}

Padding buildToggleButton({
  required String title1,
  required String title2,
  required bool isActive,
  required Function(bool) onToggle,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: 35.sp,
    ),
    child: IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (!isActive) onToggle(true);
              },
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 5.sp,
                  horizontal: 5.sp,
                ),
                decoration: BoxDecoration(
                  boxShadow: CommonController.getBoxShadow,
                  gradient: LinearGradient(colors: [
                    isActive
                        ? AppColors.secondaryColor
                        : AppColors.secondaryColor.withOpacity(0.6),
                    isActive
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.6),
                  ]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.sp),
                    bottomLeft: Radius.circular(5.sp),
                  ),
                ),
                child: Center(
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: isActive
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.6),
                    text: title1,
                    maxLine: 2,
                    textAlign: TextAlign.center,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (isActive) onToggle(false);
              },
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: 5.sp,
                  horizontal: 5.sp,
                ),
                decoration: BoxDecoration(
                  boxShadow: CommonController.getBoxShadow,
                  gradient: LinearGradient(colors: [
                    !isActive
                        ? AppColors.primaryColor
                        : AppColors.primaryColor.withOpacity(0.6),
                    !isActive
                        ? AppColors.secondaryColor
                        : AppColors.secondaryColor.withOpacity(0.6),
                  ]),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.sp),
                    bottomRight: Radius.circular(5.sp),
                  ),
                ),
                child: Center(
                  child: CustomText(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: !isActive
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.6),
                    text: title2,
                    maxLine: 2,
                    textAlign: TextAlign.center,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget buildTop2TitleText(
  String title1,
  String title2,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        fontWeight: FontWeight.w500,
        fontSize: 12.sp,
        color: AppColors.labelColor14,
        text: title1,
        textAlign: TextAlign.start,
        fontFamily: AppString.manropeFontFamily,
      ),
      Text(
        title2,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: AppColors.labelColor40,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          fontFamily: AppString.manropeFontFamily,
        ),
      ),
    ],
  );
}

Widget buildFloatingActionButton(
    {required bool isShowCancelPromo, required int currentIndex}) {
  return DraggableFab(
    securityBottom: 80.sp,
    child: GestureDetector(
      onTap: () async {
        var controller = Get.find<StoreController>();
        buildLoading(Get.context!);
        await controller.getCartDetailsUri(true, "store");
        Navigator.pop(Get.context!);

        if (controller.cartData != null) {
          showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return AlertDialogCart(
                isShowCancelPromo: isShowCancelPromo,
                openIndex: currentIndex,
              );
            },
          );
        }
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.50),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 0.7),
            ),
          ],
          gradient: const LinearGradient(
              colors: [
                AppColors.labelColor81,
                AppColors.labelColor81,
                AppColors.labelColor82,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                0.3,
                0.9,
              ]),
        ),
        child: Center(
          child: Image.asset(
            height: 25.sp,
            width: 25.sp,
            AppImages.cardIc,
          ),
        ),
      ),
    ),
  );
}

Widget buildAppHeaderForLogin() {
  return Stack(
    children: [
      Image.asset(
        AppImages.rectangle,
        width: Get.context!.getWidth,
        height: Get.context!.getWidth * 0.9,
        fit: BoxFit.fill,
      ),
      Positioned.fill(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: Get.context!.getWidth * 0.1),
            child: Image.asset(
              AppImages.logo,
              height: Get.context!.getWidth * 0.45,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildAppHeaderForResetPassword(Function onBackPress) {
  return Stack(
    children: [
      Image.asset(
        AppImages.rectangle,
        width: Get.context!.getWidth,
        height: Get.context!.getWidth * 0.9,
        fit: BoxFit.fill,
      ),
      Positioned.fill(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: Get.context!.getWidth * 0.15),
                child: Image.asset(
                  AppImages.logo,
                  height: Get.context!.getWidth * 0.45,
                ),
              ),
            ),
            CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: AppColors.white,
              text: AppString.forgotPasswords,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ],
        ),
      ),
      Positioned(
        top: 30.sp,
        left: 15.sp,
        child: IconButton(
          onPressed: () {
            onBackPress();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      )
    ],
  );
}

Widget buildFloatingIconForWelcome({required Function onTap}) {
  return FloatingActionButton(
    focusElevation: 15,
    elevation: 15,
    hoverElevation: 15,
    highlightElevation: 15,
    disabledElevation: 15,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    onPressed: () async {
      onTap();
    },
    backgroundColor: Colors.transparent,
    child: GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [
                AppColors.labelColor81,
                AppColors.labelColor81,
                AppColors.labelColor82,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                0.3,
                0.9,
              ]),
        ),
        child: Padding(
          padding: EdgeInsets.all(Get.context!.isTablet ? 5.sp : 11.sp),
          child: const FittedBox(
            child: Icon(
              Icons.arrow_forward_rounded,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget buildFloatingIconForDashboard() {
  return FloatingActionButton.small(
    focusElevation: 15,
    elevation: 15,
    hoverElevation: 15,
    highlightElevation: 15,
    disabledElevation: 15,
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    onPressed: () async {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return const AlertForCompletedSteps();
        },
      );
    },
    backgroundColor: Colors.transparent,
    child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
            colors: [
              AppColors.labelColor81,
              AppColors.labelColor81,
              AppColors.labelColor82,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.0,
              0.3,
              0.9,
            ]),
      ),
      child: Padding(
        padding: EdgeInsets.all(Get.context!.isTablet ? 3.sp : 7.sp),
        child: const FittedBox(
          child: Icon(
            Icons.done_rounded,
          ),
        ),
      ),
    ),
  );
}

CustomText dashboardCardTitle(String title) {
  return CustomText(
    fontWeight: FontWeight.w600,
    fontSize: 15.sp,
    color: AppColors.labelColor3,
    text: title,
    textAlign: TextAlign.start,
    fontFamily: AppString.manropeFontFamily,
  );
}

CustomText welcomeScreenTitle(String title) {
  return CustomText(
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    color: AppColors.labelColor8,
    text: title,
    textAlign: TextAlign.center,
    fontFamily: AppString.manropeFontFamily,
  );
}

Row buildTitleToggle(String title, bool value, Function onTap) {
  return Row(
    children: [
      ToggleButtonWidget(
        width: 45.sp,
        height: 18.sp,
        padding: 2.sp,
        value: value,
        onChange: (val) {
          onTap();
        },
        isShowText: true,
        activeText: AppString.on,
        inactiveText: AppString.off,
      ),
      0.sp.sbw,
      Expanded(
        child: CustomText(
          text: title,
          textAlign: TextAlign.start,
          color: AppColors.labelColor9,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          maxLine: 2,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

CustomText welcomeScreenSubTitle(String title) {
  return CustomText(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    color: AppColors.labelColor6,
    text: title,
    textAlign: TextAlign.center,
    fontFamily: AppString.manropeFontFamily,
  );
}

Row buildViewALL() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      CustomGradientText(
        fontWeight: FontWeight.w700,
        text: AppString.viewAll,
        fontFamily: AppString.manropeFontFamily,
        fontSize: 11.sp,
      ),
      SizedBox(width: 1.w),
      Image.asset(AppImages.gradientArrow, height: 9.sp)
    ],
  );
}

Widget buildSVGNetworkImage({required String image, required BoxFit? fit}) {
  return SvgPicture.network(
    image,
    fit: fit ?? BoxFit.contain,
    placeholderBuilder: (context) => Shimmer(
      duration: const Duration(seconds: 1),
      colorOpacity: 1,
      color: AppColors.labelColor,
      child: Container(
        color: AppColors.backgroundColor1,
      ),
    ),
  );
}

Widget buildQuickLinkColumn(String icon, String name) {
  return Column(
    children: [
      10.sp.sbh,
      Expanded(
        flex: 6,
        child: icon.split('.').last.toString().toLowerCase() == "svg"
            ? buildSVGNetworkImage(
                image: icon,
                fit: BoxFit.contain,
              )
            : CustomImage(
                image: icon,
                fit: BoxFit.contain,
              ),
      ),
      Expanded(
          flex: 10,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 5.sp),
              child: CustomText(
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
                color: AppColors.labelColor3,
                text: name,
                textAlign: TextAlign.center,
                maxLine: 2,
                overFlow: TextOverflow.ellipsis,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
          )),
    ],
  );
}

Column buildTitleWithBorder(String title, Widget child) {
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

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}

getFeedButton(String text, bool isFeed) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 5.h,
    padding: EdgeInsets.symmetric(horizontal: 15.sp),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          isFeed ? AppColors.secondaryColor : AppColors.white,
          isFeed ? AppColors.primaryColor : AppColors.white,
        ],
      ),
      border: Border.all(color: AppColors.labelColor),
      borderRadius: BorderRadius.all(
        Radius.circular(20.sp),
      ),
    ),
    child: Center(
      child: isFeed
          ? CustomText(
              text: text,
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            )
          : CustomGradientText(
              text: text,
              fontSize: 11.sp,
              fontFamily: AppString.manropeFontFamily,
              fontWeight: FontWeight.w600,
            ),
    ),
  );
}

Widget buildViewMoreButtonWidget({required Function onTap}) {
  return Column(
    children: [
      Center(
        child: CustomButton2(
            buttonText: "View Reputation Feedback",
            buttonColor: AppColors.backArrowColor,
            radius: 5.sp,
            width: Get.context!.getWidth,
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
            textColor: AppColors.white,
            endIcon: AppImages.arrowDownIc,
            onPressed: () {
              onTap();
            }),
      ),
      10.sp.sbh,
    ],
  );
}

Widget buildFeedAndHashTagButton(
    {required Function(int) onTap,
    required int selectedIndex,
    required ScrollController scrollController}) {
  return GetBuilder<InsightStreamController>(builder: (streamController) {
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 2.h,
              top: 1.h,
              bottom: 1.h,
              right: 2.h,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    onTap(0);
                  },
                  child: getFeedButton(AppString.feed, selectedIndex == 0),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                    onTap: () {
                      onTap(1);
                    },
                    child:
                        getFeedButton(AppString.hashTag, selectedIndex == 1)),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    onTap(2);
                  },
                  child: getFeedButton("My Posts", selectedIndex == 2),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    onTap(3);
                  },
                  child: getFeedButton("Saved Posts", selectedIndex == 3),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () {
                    onTap(4);
                  },
                  child: getFeedButton(
                      "Followers (${streamController.followerCount.toString()})",
                      selectedIndex == 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}

Widget showCaseChild(String title) {
  return Container(
    width: Get.context!.getWidth,
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
          CustomText(
            text: _getTitle(title),
            textAlign: TextAlign.start,
            color: AppColors.normalTextColor,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}

String _getTitle(String title) {
  if (title == AppString.colleagues) {
    return "Your closest group of friends (3-10 people) who know you well. Colleagues agree to be mutually responsive, available, accepting and non-judgmental, candidly honest, challenging, transparent, trustworthy, good listeners, empathic, forgiving and fun to be around.";
  } else if (title == AppString.circleOfInfluenceMyFollower) {
    return "These are your followers. They have searched for you and included you within their Growth Community.";
  } else if (title == AppString.growthCommunity) {
    return "These are people you've selected to follow from within your list of imported contacts. Their posts will appear in your Insight Stream and, from here, you can promote them to a core group of My Colleagues. ";
  } else {
    return "";
  }
}
