import 'dart:math';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/insight_tream_shimmer_widget.dart';
import 'package:aspirevue/view/screens/create_post/create_post_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'insight_widget.dart';

class InsightView extends StatefulWidget {
  final InsightStreamController streamController;
  final String type;
  final bool isShowCommnetSection;

  const InsightView(this.streamController, this.type,
      {super.key, required this.isShowCommnetSection});

  @override
  State<InsightView> createState() => _InsightViewState();
}

class _InsightViewState extends State<InsightView> {
  final _scrollcontroller = ScrollController();

  final _insightStreamController = Get.find<InsightStreamController>();

  @override
  void initState() {
    super.initState();
    _scrollcontroller.addListener(_loadMore);
  }

  Future<void> loadData() async {
    _insightStreamController.getInsightFeed(true);
  }

  void _loadMore() async {
    if (!widget.streamController.isnotMoreData) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (widget.streamController.isLoadingInsightStream == false &&
            widget.streamController.isLoadMoreRunning == false &&
            _scrollcontroller.position.extentAfter < 300) {
          widget.streamController.pageNumber += 1;
          await widget.streamController.getInsightFeed(
            false,
          );
        }
      }
    }
  }

  _buildInsightConditionView() {
    return widget.streamController.isLoadingInsightStream == true
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: InsightFeedShimmer(widget.type),
          )
        : widget.streamController.isErrorInsightStream == true
            ? Center(
                child: CustomErrorWidget(
                    onRetry: () {
                      widget.streamController.getInsightFeed(true);
                    },
                    text: widget.streamController.errorMsgInsightStream),
              )
            : _buildView();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        return await widget.streamController.getInsightFeed(
          true,
        );
      },
      child: _buildInsightConditionView(),
    );
  }

  _buildView() {
    int length = 0;
    length = widget.streamController.insightFeedList.length;
    return GetBuilder<InsightStreamController>(builder: (streamController1) {
      return ListView.builder(
        controller: _scrollcontroller,
        padding: EdgeInsets.zero,
        physics: const SlowScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: widget.type == "" ? min(length, 2) : length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          bool isLast = index + 1 == length;
          return InsightWidget(
            streamController1.insightFeedList[index],
            isFrom: PostTypeEnum.insight,
            isLoadingLast: streamController1.isLoadMoreRunning,
            isShowCommnetSection: widget.isShowCommnetSection,
            isLast: isLast,
            onEditing: () {
              _editPost(streamController1.insightFeedList[index].id.toString());
            },
            onDeleting: () {
              _deletePost(
                  streamController1.insightFeedList[index].id.toString());
            },
          );

          // return Container(
          //   margin: EdgeInsets.all(5),
          //   height: 200,
          //   width: double.infinity,
          //   color: Colors.redAccent,
          // );
        },
      );
    });
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
        _insightStreamController.removePostFromList(postid);
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

class SlowScrollPhysics extends ScrollPhysics {
  const SlowScrollPhysics({super.parent});

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Adjust the speed of scrolling by multiplying the offset
    // You can experiment with different values to achieve the desired slow scrolling effect
    return offset * 0.1;
  }
}
