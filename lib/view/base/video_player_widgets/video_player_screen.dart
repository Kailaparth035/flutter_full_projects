import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/video_player_widgets/custom_video_player_widget.dart';
import 'package:flutter/material.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.url});
  final String url;
  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.black,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.black,
          ),
          backgroundColor: AppColors.black,
          body: CustomVideoPlayerWidget(url: widget.url),
        ),
      ),
    );
  }
}
