import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/custom_wistia_player.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoAlertDialog extends StatefulWidget {
  const VideoAlertDialog({super.key, required this.url});
  final String url;
  @override
  State<VideoAlertDialog> createState() => _VideoAlertDialogState();
}

class _VideoAlertDialogState extends State<VideoAlertDialog> {
  late VideoPlayerController videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  late YoutubePlayerController _youtubeController;

  bool _isloading = false;

  late VideoType videoType;

  @override
  void initState() {
    super.initState();

    videoType = _getVideoType(widget.url);

    if (videoType == VideoType.youtube) {
      var videoId = YoutubePlayer.convertUrlToId(widget.url);

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId.toString(),
        flags: const YoutubePlayerFlags(
            autoPlay: true, mute: false, showLiveFullscreenButton: true),
      );
    } else if (videoType == VideoType.wistia) {
      // nothing to do
    } else if (videoType == VideoType.vimeo) {
      // nothing to do
    } else {
      try {
        setState(() {
          _isloading = true;
        });
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(widget.url))
              ..initialize().then(
                (value) => setState(() {
                  _isloading = false;
                }),
              );
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: videoPlayerController,
        );
      } catch (e) {
        showCustomSnackBar(e.toString());
        setState(() {
          _isloading = false;
        });
      } finally {
        setState(() {
          // _isloading = false;
        });
      }
    }
  }

  _getVideoType(String url) {
    if (widget.url.contains("www.youtube.com")) {
      return VideoType.youtube;
    } else if (widget.url.contains("vimeo")) {
      return VideoType.vimeo;
    } else if (widget.url.contains("wistia")) {
      return VideoType.wistia;
    } else {
      return VideoType.embaded;
    }
  }

  @override
  void dispose() {
    if (videoType == VideoType.youtube) {
      _youtubeController.dispose();
    }

    if (videoType == VideoType.embaded) {
      videoPlayerController.dispose();
      _customVideoPlayerController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              5.sp.sbh,
              _isloading
                  ? SizedBox(
                      height: 150.sp,
                      width: context.getWidth,
                      child: const Center(
                        child: CustomLoadingWidget(),
                      ))
                  : SizedBox(
                      height: 150.sp,
                      width: context.getWidth,
                      child: _getVideoView())
            ],
          ),
        ),
      ),
    );
  }

  Widget _getVideoView() {
    switch (videoType) {
      case VideoType.wistia:
        return SizedBox(
            height: 150.sp,
            width: context.getWidth,
            child: CustomWistiaPlayer(url: widget.url));
      case VideoType.youtube:
        return YoutubePlayer(
          controller: _youtubeController,
          showVideoProgressIndicator: true,
          bottomActions: [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
          ],
        );

      case VideoType.embaded:
        return CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController,
        );
      default:
        return CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: AppColors.black,
          text: "Video Not Found!",
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        );
    }
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: AppColors.labelColor8,
          text: " ",
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(2.sp),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.labelColor15.withOpacity(0.5)),
            child: Icon(
              Icons.close,
              weight: 3,
              size: 12.sp,
            ),
          ),
        )
      ],
    );
  }
}
