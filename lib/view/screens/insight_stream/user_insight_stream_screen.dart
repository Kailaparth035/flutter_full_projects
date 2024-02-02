import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/user_insight_stream_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_app_bar.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/insight_tream_shimmer_widget.dart';
import 'package:aspirevue/view/screens/create_post/create_post_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/insight_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInsightStreamScreen extends StatefulWidget {
  const UserInsightStreamScreen(
      {super.key,
      required this.userName,
      required this.userId,
      required this.streamType});
  final String userId;
  final String userName;
  final UserInsightStreamEnumType streamType;
  @override
  State<UserInsightStreamScreen> createState() =>
      _UserInsightStreamScreenState();
}

class _UserInsightStreamScreenState extends State<UserInsightStreamScreen> {
  final _userInsightStreamController = Get.find<UserInsightStreamController>();
  final _insightStreamController = Get.find<InsightStreamController>();
  // bool isFeed = false;
  final _scrollcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
    _scrollcontroller.addListener(_loadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _userInsightStreamController.checkCurrentUser(
    //     widget.userId, widget.streamType);
  }

  Future<void> loadData() async {
    _userInsightStreamController.getOtherUserInsightFeeds(true, widget.userId,
        stramType: widget.streamType);
  }

  void _loadMore() async {
    if (!_userInsightStreamController.isnotMoreDatauserFeedStream) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_userInsightStreamController.isLoadinguserStream == false &&
            _userInsightStreamController.isLoadMoreRunninguserFeedStream ==
                false &&
            _scrollcontroller.position.extentAfter < 300) {
          _userInsightStreamController.pageNumberuserFeedStream += 1;
          await _userInsightStreamController.getOtherUserInsightFeeds(
              false, widget.userId,
              stramType: widget.streamType);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (va) {
        _userInsightStreamController.onNavigateBack();
      },
      canPop: true,
      // onWillPop: () {
      //   _userInsightStreamController.onNavigateBack();
      //   return Future.value(true);
      // },
      child: CommonController.getAnnanotaion(
        child: Scaffold(
          appBar: _buildAppbar(context),
          backgroundColor: AppColors.white,
          body: _buildView(context),
        ),
      ),
    );
  }

  GestureDetector _buildView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: GetBuilder<UserInsightStreamController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildList(controller)),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildList(UserInsightStreamController controller) {
    return controller.isLoadinguserStream == true
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: const InsightFeedShimmer("hashtag"),
          )
        : controller.isErroruserStream == true
            ? Center(
                child: CustomErrorWidget(
                    onRetry: () {
                      controller.getOtherUserInsightFeeds(true, widget.userId,
                          stramType: widget.streamType);
                    },
                    text: controller.errorMsguserStream),
              )
            : controller.userTagFeedList.isEmpty
                ? Center(
                    child: CustomErrorWidget(
                        isNoData: true,
                        onRetry: () {
                          controller.getOtherUserInsightFeeds(
                              true, widget.userId,
                              stramType: widget.streamType);
                        },
                        text: controller.errorMsguserStream),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return controller.getOtherUserInsightFeeds(
                          true, widget.userId,
                          stramType: widget.streamType);
                    },
                    child: ListView.builder(
                      controller: _scrollcontroller,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: controller.userTagFeedList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isLast =
                            index + 1 == controller.userTagFeedList.length;
                        return InsightWidget(
                          streamType: widget.streamType,
                          isFrom: PostTypeEnum.user,
                          isShowCommnetSection: true,
                          controller.userTagFeedList[index],
                          isLast: isLast,
                          isLoadingLast:
                              controller.isLoadMoreRunninguserFeedStream,
                          onEditing: () {
                            _editPost(controller.userTagFeedList[index].id
                                .toString());
                          },
                          onDeleting: () {
                            _deletePost(controller.userTagFeedList[index].id
                                .toString());
                          },
                        );
                      },
                    ),
                  );
  }

  CustomAppBar _buildAppbar(BuildContext context) {
    return CustomAppBar(
      onPressed: () async {
        var result = await Get.toNamed(RouteHelper.getCreatePostRoute());

        if (result != null && result == true) {
          loadData();
        }
      },
      title: widget.streamType == UserInsightStreamEnumType.savedPost
          ? AppString.savedPost
          : widget.userName,
      onBackPressed: () {
        _userInsightStreamController.onNavigateBack();
        Get.back();
      },
      showActionIcon:
          widget.streamType == UserInsightStreamEnumType.currentUser,
      textColor: AppColors.labelColor8,
      iconButtonColor: AppColors.labelColor5,
      context: context,
    );
  }

  _editPost(String postId) async {
    var result = await Get.to(() => CreatePostScreen(
          postId: postId,
        ));

    if (result != null && result == true) {
      loadData();
    }
  }

  _deletePost(String postid) async {
    try {
      buildLoading(Get.context!);
      var response = await _insightStreamController.removePost(
        postid,
      );
      if (response.isSuccess == true) {
        _userInsightStreamController.removePostFromList(postid);
        _insightStreamController.getInsightFeed(true);
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }
}
