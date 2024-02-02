import 'dart:math';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomVideoPlayerWidget extends StatefulWidget {
  const CustomVideoPlayerWidget({super.key, required this.url});
  final String url;
  @override
  State<CustomVideoPlayerWidget> createState() =>
      _CustomVideoPlayerWidgetState();
}

class _CustomVideoPlayerWidgetState extends State<CustomVideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  CustomVideoPlayerController? _customVideoPlayerController;

  bool _isloading = false;
  bool _isError = false;
  String _errorMsg = '';
  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() {
    setState(() {
      _isloading = true;
    });
    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.url))
            ..initialize().then((value) => setState(() {
                  _isloading = false;
                }));
      _customVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _videoPlayerController!,
        customVideoPlayerSettings: const CustomVideoPlayerSettings(
          systemUIModeInsideFullscreen: SystemUiMode.immersiveSticky,
          deviceOrientationsAfterFullscreen: [DeviceOrientation.portraitUp],
        ),
      );
    } catch (e) {
      setState(() {
        _isError = true;
        _isloading = false;
        String error = CommonController().getValidErrorMessage(e.toString());
        _errorMsg = error.toString();
      });
      debugPrint("====> ${e.toString()}");
    } finally {}
  }

  @override
  void dispose() {
    try {
      _customVideoPlayerController = null;
      _videoPlayerController = null;
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }

    super.dispose();
  }

  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return _isError
        ? Center(
            child: Text(_errorMsg),
          )
        : _isloading
            ? Shimmer(
                duration: const Duration(seconds: 1),
                colorOpacity: 1,
                color: AppColors.labelColor,
                child: Container(
                  color: AppColors.backgroundColor1,
                  height: double.infinity,
                  width: double.infinity,
                ),
              )
            : VisibilityDetector(
                key: Key(random.nextInt(4294967296).toString()),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;

                  if (visiblePercentage == 0.0) {
                    _videoPlayerController!.pause();
                  }
                },
                child: SafeArea(
                  child: CustomVideoPlayer(
                      customVideoPlayerController:
                          _customVideoPlayerController!),
                ),
              );
  }
}

class VideoPlayWidget2 extends StatefulWidget {
  const VideoPlayWidget2(
      {super.key,
      required this.isLoading,
      required this.isError,
      required this.errorMsg,
      required this.onReload,
      required this.videoPlayerController,
      required this.customVideoPlayerController});

  final bool isLoading;
  final bool isError;
  final String errorMsg;
  final Function onReload;
  final VideoPlayerController? videoPlayerController;
  final CustomVideoPlayerController? customVideoPlayerController;
  @override
  State<VideoPlayWidget2> createState() => _VideoPlayWidget2State();
}

class _VideoPlayWidget2State extends State<VideoPlayWidget2> {
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return widget.isError
        ? Center(
            child: Text(widget.errorMsg.toString()),
          )
        : widget.isLoading
            ? Shimmer(
                duration: const Duration(seconds: 1),
                colorOpacity: 1,
                color: AppColors.labelColor,
                child: Container(
                  color: AppColors.backgroundColor1,
                  height: double.infinity,
                  width: double.infinity,
                ),
              )
            // : Text("data");
            : VisibilityDetector(
                key: Key(random.nextInt(4294967296).toString()),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;

                  if (visiblePercentage == 0.0) {
                    widget.videoPlayerController!.pause();
                  }
                },
                child: SafeArea(
                  child: CustomVideoPlayer(
                      customVideoPlayerController:
                          widget.customVideoPlayerController!),
                ),
              );
  }
}
