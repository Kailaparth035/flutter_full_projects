import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/screens/welcome_screens/welcome_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpashVideoPlayerScreen extends StatefulWidget {
  const SpashVideoPlayerScreen({super.key, required this.controller});
  final VideoPlayerController controller;
  @override
  State<SpashVideoPlayerScreen> createState() => _SpashVideoPlayerScreenState();
}

class _SpashVideoPlayerScreenState extends State<SpashVideoPlayerScreen> {
  final _profileController = Get.find<ProfileSharedPrefService>();
  @override
  void initState() {
    super.initState();

    widget.controller.play();

    var durationToAd = const Duration(seconds: 1);

    Future.delayed(widget.controller.value.duration + durationToAd, () {
      if (_profileController.isShowWelcomeScreen.value == true) {
        Get.offAll(() => const WelcomeMainScreen());
      } else {
        Get.offAllNamed(RouteHelper.getMainRoute());
      }
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Center(
          child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(
                widget.controller,
              )),
        ));
  }
}
