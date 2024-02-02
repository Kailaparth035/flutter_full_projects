import 'dart:math';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  const YoutubePlayerWidget({super.key, required this.url});
  final String url;
  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    var videoId = YoutubePlayer.convertUrlToId(widget.url);

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId.toString(),
      flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          showLiveFullscreenButton: true,
          disableDragSeek: true),
    );
  }

  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(random.nextInt(4294967296).toString()),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;

        if (visiblePercentage == 0.0) {
          _youtubeController.pause();
        }
      },
      child: YoutubePlayer(
        controller: _youtubeController,
        showVideoProgressIndicator: true,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
        ],
        onReady: () {},
      ),
    );
  }

  @override
  void dispose() {
    try {
      _youtubeController.dispose();
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }

    super.dispose();
  }
}
