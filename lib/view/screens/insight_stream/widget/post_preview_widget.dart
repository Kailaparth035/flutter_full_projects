import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_wistia_player.dart';
import 'package:aspirevue/view/base/video_player_widgets/custom_video_player_widget.dart';
import 'package:aspirevue/view/base/video_player_widgets/vimeo_video_player.dart';
import 'package:aspirevue/view/base/video_player_widgets/youtube_player_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_media_view_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

class PostPreviewWidget extends StatefulWidget {
  const PostPreviewWidget(
      {super.key,
      required this.record,
      required this.videoList,
      required this.activePage});
  final Record record;
  final List<VideoPlayModel> videoList;
  final int activePage;
  @override
  State<PostPreviewWidget> createState() => _PostPreviewWidgetState();
}

class _PostPreviewWidgetState extends State<PostPreviewWidget> {
  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.activePage);
    super.initState();
  }

  bool _lock = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: "",

            elevation: 2,
            onbackPress: () {
              Navigator.pop(context);
            },
            // bgColor: AppColors.black,
          ),
        ),
        backgroundColor: AppColors.black,
        body: _buildImagePageView(),
      ),
    );
  }

  Widget _buildImagePageView() {
    return PageView(
      physics: _lock ? const NeverScrollableScrollPhysics() : null,
      onPageChanged: (index) {
        setState(() {
          _lock = false;
        });
      },
      controller: _pageController,
      children: widget.record.postFiles!.map((image) {
        return _getView(image);
      }).toList(),
    );
  }

  // Swiper _buildView() {
  //   return Swiper(
  //     loop: false,
  //     physics: _lock ? const NeverScrollableScrollPhysics() : null,
  //     onIndexChanged: (index) {
  //       setState(() {
  //         _activePage = index;
  //         _lock = false;
  //       });
  //     },
  //     itemBuilder: (BuildContext context, int index) {},
  //     itemCount: widget.record.postFiles!.length,
  //     viewportFraction: 1,
  //     scale: 0.9,
  //   );
  // }

  Widget _getView(PostFile post) {
    if (post.postType == "video") {
      return _buildVideoView2(context, post.id.toString());
    } else if (post.postType == "youtube_video") {
      return _buildYoutubeVideoView(context, post.fullPath.toString());
    } else if (post.postType == "vimeo_video") {
      return _buildVimeoVideoView(context, post.fullPath.toString());
    } else if (post.postType == "wistia_video") {
      return _buildWistiaVideoView(context, post.fullPath.toString());
    } else {
      return _buildPostImage(context, post.fullPath.toString());
    }
  }

  // CarouselSlider _buildSlider(BuildContext context) {
  //   return CarouselSlider.builder(
  //     options: CarouselOptions(
  //       enableInfiniteScroll: false,
  //       initialPage: 0,
  //       height: context.getHeight,
  //       enlargeCenterPage: true,
  //       viewportFraction: 1,
  //       reverse: false,
  //       autoPlay: false,
  //       autoPlayCurve: Curves.fastOutSlowIn,
  //       onPageChanged: (index, re) {
  //         setState(() {
  //           _activePage = index;
  //         });
  //       },
  //       scrollDirection: Axis.horizontal,
  //     ),
  //     itemCount: widget.record.postFiles!.length,
  //     itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
  //       if (widget.record.postFiles![itemIndex].postType == "video") {
  //         return _buildVideoView2(
  //             context, widget.record.postFiles![itemIndex].id.toString());
  //       } else if (widget.record.postFiles![itemIndex].postType ==
  //           "youtube_video") {
  //         return _buildYoutubeVideoView(
  //             context, widget.record.postFiles![itemIndex].fullPath.toString());
  //       } else if (widget.record.postFiles![itemIndex].postType ==
  //           "vimeo_video") {
  //         return _buildVimeoVideoView(
  //             context, widget.record.postFiles![itemIndex].fullPath.toString());
  //       } else if (widget.record.postFiles![itemIndex].postType ==
  //           "wistia_video") {
  //         return _buildWistiaVideoView(
  //             context, widget.record.postFiles![itemIndex].fullPath.toString());
  //       } else {
  //         return _buildPostImage(
  //             context, widget.record.postFiles![itemIndex].fullPath.toString());
  //       }
  //     },
  //   );
  // }

  Widget _buildWistiaVideoView(BuildContext context, String url) {
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

    return Padding(
      padding: const EdgeInsets.all(0),
      // padding: EdgeInsets.only(left: 10.sp, right: 10.sp, bottom: 10.sp),
      child: CustomWistiaPlayer(url: url),
    );
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

  Widget _buildVideoView2(BuildContext context, String id) {
    var firstElement =
        widget.videoList.where((a) => a.id.toString() == id.toString()).first;

    int index = widget.videoList.indexOf(firstElement);

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
                  isLoading: widget.videoList[index].isLoading,
                  isError: widget.videoList[index].isError,
                  errorMsg: widget.videoList[index].errorMsg,
                  onReload: () {},
                  videoPlayerController: widget.videoList[index].controller,
                  customVideoPlayerController:
                      widget.videoList[index].customController),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage(BuildContext context, String url) {
    // return Center(
    //     child: PhotoView(
    //   imageProvider: CachedNetworkImageProvider(url),
    // ));

    return PhotoView(
      // backgroundDecoration:
      //     const BoxDecoration(color: AppColors.backgroundColor1),
      imageProvider: CachedNetworkImageProvider(url),
      minScale: PhotoViewComputedScale.contained,
      scaleStateChangedCallback: (PhotoViewScaleState state) {
        setState(() {
          _lock = state != PhotoViewScaleState.initial;
        });
      },
    );

    // return Center(
    //   child: CustomImage(
    //     width: context.getWidth,
    //     image: url,
    //     fit: BoxFit.contain,
    //     height: double.infinity,
    //   ),
    // );
  }
}
