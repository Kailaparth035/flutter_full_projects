import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/webview_widget.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.url});
  final String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              bgColor: AppColors.white,
              appbarTitle: "",
              onbackPress: () async {
                Navigator.pop(context);
              },
            ),
          ),
          backgroundColor: AppColors.white,
          body: WebViewWidgetView(url: widget.url),
        ),
      ),
    );
  }
}
