import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/response/comment_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/loading_and_error/comment_shimmer_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/comment_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/write_comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CommentViewWidget extends StatefulWidget {
  const CommentViewWidget(
      {super.key,
      required this.postId,
      required this.onTap,
      required this.isLoadData,
      required this.isBlockedUser,
      required this.isNewsComment});
  final String postId;
  final Function(int) onTap;
  final bool isLoadData;
  final bool isNewsComment;
  final bool isBlockedUser;

  @override
  State<CommentViewWidget> createState() => _CommentViewWidgetState();
}

class _CommentViewWidgetState extends State<CommentViewWidget> {
  final _insightStreamController = Get.find<InsightStreamController>();
  List<CommentData> _commentData = [];

  bool _isLoadingComments = false;
  @override
  void initState() {
    super.initState();
    if (widget.isLoadData) {
      _loadData(true);
    }
  }

  Future _loadData(bool isShowLoading) async {
    try {
      if (isShowLoading) {
        setState(() {
          _isLoadingComments = true;
        });
      }

      var commentData =
          await _insightStreamController.getCommentDetail(widget.postId);
      if (mounted) {
        if (commentData != null) {
          setState(() {
            _commentData = commentData.record!;
          });
          widget.onTap(commentData.commentCount!);
        }
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (isShowLoading) {
        setState(() {
          _isLoadingComments = false;
        });
      }
      // ignore: control_flow_in_finally
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildCommentBox();
  }

  Widget _buildCommentBox() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 10.sp, horizontal: AppConstants.screenHorizontalPadding),
      child: Column(
        children: [
          WriteCommentWidget(
            isOnlyTextComment: false,
            isNewsComment: widget.isNewsComment,
            postId: widget.postId,
            parentCommentId: null,
            onAddComment: () async {
              return await _loadData(false);
            },
          ),
          10.sp.sbh,
          _isLoadingComments
              ? const Center(
                  child: CommentShimmerWidget(),
                )
              : Column(
                  children: [
                    ..._commentData.map(
                      (e) => CommentWidget(
                        isBlockedUser: widget.isBlockedUser,
                        isOnlyTextComment: widget.isNewsComment,
                        isNewsComment: widget.isNewsComment,
                        data: e,
                        postId: widget.postId,
                        onAddComment: () async {
                          return await _loadData(false);
                        },
                      ),
                    )
                  ],
                ),
        ],
      ),
    );
  }
}
