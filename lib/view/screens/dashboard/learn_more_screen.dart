import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LearnMoreScreen extends StatefulWidget {
  const LearnMoreScreen({super.key});

  @override
  State<LearnMoreScreen> createState() => _LearnMoreScreenState();
}

class _LearnMoreScreenState extends State<LearnMoreScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              bgColor: AppColors.white,
              appbarTitle: AppString.learnMore,
              onbackPress: () async {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: AppColors.white,
          body: _buildMainView(),
        ),
      ),
    );
  }

  Widget _buildMainView() {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      if (dashboardController.isLoadingQuickLinkData) {
        return const Center(child: CustomLoadingWidget());
      }
      if (dashboardController.isErrorQuickLinkData ||
          dashboardController.quickLinkData == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              dashboardController
                  .getDashboardVideoQuickLinkDetails({}, isShowLoading: true);
            },
            text: dashboardController.isErrorQuickLinkData
                ? dashboardController.errorMsgQuickLinkData
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildView(dashboardController);
      }
    });
  }

  _buildView(DashboardController dashboardController) {
    // return SizedBox(
    //   height: context.getHeight,
    //   width: context.getWidth,
    //   child: WebViewWidgetView(
    //     url: url,
    //   ),
    // );

    if (dashboardController.learnMoreWebviewController == null) {
      // return const Center(child: CustomLoadingWidget());
      return Center(
        child: CustomErrorWidget(
            isNoData: true,
            isShowRetriyButton: false,
            onRetry: () {},
            isShowCustomMessage: true,
            text: "  wrong!"),
      );
    }
    if (dashboardController.isErrorWebView == true) {
      return Center(
        child: CustomErrorWidget(
            isNoData: true,
            isShowRetriyButton: false,
            onRetry: () {},
            isShowCustomMessage: true,
            text: "Something went wrong!"),
      );
    }
    return WebViewWidget(
      controller: dashboardController.learnMoreWebviewController!,
    );
  }
}
