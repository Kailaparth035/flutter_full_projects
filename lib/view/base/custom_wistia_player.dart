import 'dart:math';

import 'package:aspirevue/util/webview_widget.dart';
import 'package:aspirevue/wistia_player_latest/wistia_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomWistiaPlayer extends StatefulWidget {
  const CustomWistiaPlayer({super.key, required this.url});
  final String url;
  @override
  State<CustomWistiaPlayer> createState() => _CustomWistiaPlayerState();
}

class _CustomWistiaPlayerState extends State<CustomWistiaPlayer> {
  WistiaPlayerLatestController? _wistiaController;

  @override
  void initState() {
    // String? id = WistiaPlayerLatest.convertWistiaUrlToWistiaId(widget.url);

    _wistiaController =
        WistiaPlayerLatestController(videoId: widget.url.split("/").last);
    super.initState();
  }

  @override
  void dispose() {
    if (_wistiaController != null) {
      _wistiaController!.dispose();
    }
    super.dispose();
  }

  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          constraints: BoxConstraints(maxHeight: 150.sp),
          child: WebViewWidgetViewForIFrame(
              wisatiaID: widget.url.split("/").last)),
    );
  }
}
