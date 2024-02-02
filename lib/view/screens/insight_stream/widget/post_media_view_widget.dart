import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/custom_wistia_player.dart';
import 'package:aspirevue/view/base/video_player_widgets/custom_video_player_widget.dart';
import 'package:aspirevue/view/base/video_player_widgets/vimeo_video_player.dart';
import 'package:aspirevue/view/base/video_player_widgets/youtube_player_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_preview_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
// import 'package:vimeo_player_flutter/vimeo_player_flutter.dart';

class PostMediaViewWidget extends StatefulWidget {
  const PostMediaViewWidget(
      {super.key,
      required this.record,
      required this.isParent,
      required this.height});
  final Record record;
  final bool isParent;
  final double height;
  @override
  State<PostMediaViewWidget> createState() => _PostMediaViewWidgetState();
}

class _PostMediaViewWidgetState extends State<PostMediaViewWidget> {
  int _activePage = 0;

  final List<VideoPlayModel> _videoList = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    for (var element in _videoList) {
      element.controller = null;
      element.customController = null;
    }
    super.dispose();
  }

  _loadData() {
    for (var element in widget.record.postFiles!) {
      if (element.postType == "video") {
        _videoList.add(
          VideoPlayModel(
              id: element.id.toString(),
              fullPath: element.fullPath.toString(),
              isLoading: true,
              isError: false,
              errorMsg: "",
              controller: null,
              customController: null),
        );
        try {
          var controller = VideoPlayerController.networkUrl(
              Uri.parse(element.fullPath.toString()))
            ..initialize().then((value) {
              var firstElement = _videoList
                  .where((a) => a.id.toString() == element.id.toString())
                  .first;

              int index = _videoList.indexOf(firstElement);

              VideoPlayModel obj = VideoPlayModel(
                  id: element.id.toString(),
                  fullPath: element.fullPath.toString(),
                  isLoading: false,
                  isError: false,
                  errorMsg: "",
                  controller: _videoList[index].controller,
                  customController: _videoList[index].customController);

              if (mounted) {
                setState(() {
                  _videoList[index] = obj;
                });
              }
            });

          var customController = CustomVideoPlayerController(
            context: context,
            videoPlayerController: controller,
            customVideoPlayerSettings: const CustomVideoPlayerSettings(
              systemUIModeInsideFullscreen: SystemUiMode.immersiveSticky,
              deviceOrientationsAfterFullscreen: [DeviceOrientation.portraitUp],
            ),
          );

          var firstElement = _videoList
              .where((a) => a.id.toString() == element.id.toString())
              .first;

          int index = _videoList.indexOf(firstElement);

          setState(() {
            _videoList[index] = VideoPlayModel(
                id: element.id.toString(),
                fullPath: element.fullPath.toString(),
                isLoading: true,
                isError: false,
                errorMsg: "",
                controller: controller,
                customController: customController);
          });
        } catch (e) {
          var firstElement = _videoList
              .where((a) => a.id.toString() == element.id.toString())
              .first;

          int index = _videoList.indexOf(firstElement);

          setState(() {
            _videoList[index] = VideoPlayModel(
                id: element.id.toString(),
                fullPath: element.fullPath.toString(),
                isLoading: false,
                isError: true,
                errorMsg: e.toString(),
                controller: null,
                customController: null);
          });

          debugPrint("====> ${e.toString()}");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMediaView(widget.record, widget.height, context,
        isParent: widget.isParent);
  }

  Widget _buildMediaView(Record record, double hheight, BuildContext context,
      {required bool isParent}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isParent ? 15.sp : 10.sp),
      child: Column(
        children: [
          record.postFiles!.isNotEmpty
              ? SizedBox(
                  width: context.getWidth,
                  height: hheight,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => PostPreviewWidget(
                                activePage: _activePage,
                                record: record,
                                videoList: _videoList,
                              ));
                        },
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            initialPage: 0,
                            height: hheight,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            reverse: false,
                            autoPlay: false,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            onPageChanged: (index, re) {
                              setState(() {
                                _activePage = index;
                              });
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          itemCount: record.postFiles!.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) {
                            if (record.postFiles![itemIndex].postType ==
                                "video") {
                              return _buildVideoView2(context,
                                  record.postFiles![itemIndex].id.toString());
                            } else if (record.postFiles![itemIndex].postType ==
                                "youtube_video") {
                              return _buildYoutubeVideoView(
                                  context,
                                  record.postFiles![itemIndex].fullPath
                                      .toString());
                            } else if (record.postFiles![itemIndex].postType ==
                                "vimeo_video") {
                              return _buildVimeoVideoView(
                                  context,
                                  record.postFiles![itemIndex].fullPath
                                      .toString());
                            } else if (record.postFiles![itemIndex].postType ==
                                "wistia_video") {
                              return _buildWistiaVideoView(
                                  context,
                                  record.postFiles![itemIndex].fullPath
                                      .toString());
                            } else {
                              return _buildPostImage(
                                  context,
                                  record.postFiles![itemIndex].fullPath
                                      .toString());
                            }
                          },
                        ),
                      ),
                      record.postFiles!.length > 1
                          ? Positioned(
                              top: 10.sp,
                              right: 10.sp,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2.sp, horizontal: 5.sp),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    color: AppColors.black.withOpacity(0.32)),
                                child: CustomText(
                                  text:
                                      "${_activePage + 1}/${record.postFiles!.length}",
                                  textAlign: TextAlign.center,
                                  color: AppColors.white,
                                  fontFamily: AppString.manropeFontFamily,
                                  fontSize: 8.sp,
                                  textSpacing: 1.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                          : 0.sbh,
                    ],
                  ),
                )
              : 0.sbh,
          record.postFiles!.isNotEmpty ? 0.h.sbh : 0.sbh
        ],
      ),
    );
  }

  Widget _buildVideoView2(BuildContext context, String id) {
    var firstElement =
        _videoList.where((a) => a.id.toString() == id.toString()).first;

    int index = _videoList.indexOf(firstElement);

    return Center(
      child: GestureDetector(
        onTap: () {
          // Get.to(VideoPlayerScreen(url: url.toString()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            border: Border.all(
              color: AppColors.labelColor,
            ),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).orientation == Orientation.portrait
                ? context.getWidth
                : context.getHeight,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.sp),
              child: VideoPlayWidget2(
                  isLoading: _videoList[index].isLoading,
                  isError: _videoList[index].isError,
                  errorMsg: _videoList[index].errorMsg,
                  onReload: () {},
                  videoPlayerController: _videoList[index].controller,
                  customVideoPlayerController:
                      _videoList[index].customController),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildVideoView(BuildContext context, String url) {
  //   return Center(
  //     child: GestureDetector(
  //       onTap: () {
  //         // Get.to(VideoPlayerScreen(url: url.toString()));
  //       },
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10.sp),
  //           border: Border.all(
  //             color: AppColors.labelColor,
  //           ),
  //         ),
  //         child: SizedBox(
  //           width: MediaQuery.of(context).orientation == Orientation.portrait
  //               ? context.getWidth
  //               : context.getHeight,
  //           height: double.infinity,
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(9.sp),
  //             child: CustomVideoPlayerWidget(
  //               url: url,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildWistiaVideoView(BuildContext context, String url) {
    return SizedBox(
      width: context.getWidth,
      height: double.infinity,
      child: CustomWistiaPlayer(url: url),
    );

    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10.sp),
    //     border: Border.all(
    //       color: AppColors.labelColor,
    //     ),
    //   ),
    //   child: SizedBox(
    //     width: context.getWidth,
    //     height: double.infinity,
    //     child: ClipRRect(
    //         borderRadius: BorderRadius.circular(9.sp),
    //         child: WebViewWidgetView(url: url)),
    //   ),
    // );
  }

  Widget _buildVimeoVideoView(BuildContext context, String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(
          color: AppColors.labelColor,
        ),
      ),
      child: SizedBox(
        width: context.getWidth,
        height: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9.sp),
          // child: VimeoPlayer(
          //   videoId: url.split("/").last,
          // ),
          child: VimeoVideoPlayer(url: url.split("/").last),
        ),
      ),
    );
  }

  Widget _buildYoutubeVideoView(BuildContext context, String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(
          color: AppColors.labelColor,
        ),
      ),
      child: SizedBox(
        width: context.getWidth,
        height: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9.sp),
          child: YoutubePlayerWidget(
            url: url,
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage(BuildContext context, String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(
          color: AppColors.labelColor,
        ),
      ),
      child: SizedBox(
        width: context.getWidth,
        height: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9.sp),
          child: CustomImage(
            width: context.getWidth,
            image: url,
            fit: BoxFit.fitHeight,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

class VideoPlayModel {
  String id;
  String fullPath;
  bool isLoading;
  bool isError;
  String errorMsg;
  VideoPlayerController? controller;
  CustomVideoPlayerController? customController;

  VideoPlayModel({
    required this.id,
    required this.fullPath,
    required this.isLoading,
    required this.isError,
    required this.errorMsg,
    required this.controller,
    required this.customController,
  });
}
