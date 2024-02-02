import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/hashtag_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/user_insight_stream_controller.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_share_post.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/comment_view_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_body_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_header_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_media_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class InsightWidget extends StatefulWidget {
  final Record record;
  final bool isShowCommnetSection;
  final bool isLast;
  final bool isLoadingLast;
  final Function? onHashtagReload;
  final PostTypeEnum isFrom; // insight , hashtag , user
  final UserInsightStreamEnumType? streamType;
  final Function onEditing;
  final Function onDeleting;

  const InsightWidget(
    this.record, {
    super.key,
    required this.isShowCommnetSection,
    required this.isLast,
    required this.isFrom,
    this.onHashtagReload,
    this.streamType,
    required this.isLoadingLast,
    required this.onDeleting,
    required this.onEditing,
  });

  @override
  State<InsightWidget> createState() => _InsightWidgetState();
}

class _InsightWidgetState extends State<InsightWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  bool _isShowComment = false;
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    initData();
    expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  void _runExpandCheck() {
    if (_isShowComment) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  initData() {
    setState(() {
      commentCount = int.parse(widget.record.postCommentCount!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        2.h.sbh,
        PostHeaderWidget(
          streamType: widget.streamType,
          record: widget.record,
          isParent: true,
          isFrom: widget.isFrom,
          onEditing: () {
            widget.onEditing();
          },
          onDeleting: () {
            widget.onDeleting();
          },
        ),
        2.h.sbh,
        widget.record.description.toString() != ""
            ? PostBodyWidget(
                onHashtagReload: widget.onHashtagReload,
                isFrom: widget.isFrom,
                description: widget.record.description.toString(),
                isParent: true)
            : 0.sbh,
        _buildSharedPostView(widget.record),
        PostMediaViewWidget(
            record: widget.record, isParent: true, height: 25.h),
        widget.isShowCommnetSection
            ? Column(
                children: [
                  CommonController.getDoubleValue(
                                  widget.record.postStarRatingAvg!.toString()) >
                              0 ||
                          commentCount > 0 ||
                          CommonController.getDoubleValue(
                                  widget.record.postShareCount!.toString()) >
                              0
                      ? Column(
                          children: [
                            10.sp.sbh,
                            _buildLikeCommentShare(widget.record),
                          ],
                        )
                      : 0.sbh,
                  // _buildDivider(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.sp),
                    child: Divider(
                      height: 10.sp,
                      color: AppColors.labelColor9,
                      thickness: 0.1,
                    ),
                  ),
                  _buildLikeCommentShare2(widget.record),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _isShowComment
                        ? CommentViewWidget(
                            isBlockedUser: false,
                            isNewsComment: false,
                            postId: widget.record.id.toString(),
                            isLoadData: commentCount > 0,
                            onTap: (int count) {
                              setState(() {
                                commentCount = count;
                              });
                            },
                          )
                        : 0.sbh,
                  ),
                ],
              )
            : 0.sbh,
        Divider(
          height: 10.sp,
          color: AppColors.labelColor,
          thickness: context.isTablet ? 0.8.sp : 0.8.sp,
        ),
        widget.isLast
            ? widget.isLoadingLast
                ? const Center(
                    child: CustomLoadingWidget(),
                  )
                : 0.sbh
            : 0.5.h.sbh,
      ],
    );
  }

  Widget _buildSharedPostView(Record record) {
    return record.sharePostHtml!.isNotEmpty
        ? Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.screenHorizontalPadding,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    border: Border.all(
                      color: AppColors.labelColor11,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.sp.sbh,
                      PostHeaderWidget(
                        record: record.sharePostHtml!.first,
                        isParent: false,
                        isFrom: widget.isFrom,
                        onEditing: () {
                          widget.onEditing();
                        },
                        onDeleting: () {
                          widget.onDeleting();
                        },
                      ),
                      10.sp.sbh,
                      PostBodyWidget(
                          isFrom: widget.isFrom,
                          description: record.sharePostHtml!.first.description
                              .toString(),
                          isParent: false),
                      PostMediaViewWidget(
                        record: record.sharePostHtml!.first,
                        isParent: false,
                        height: 22.h,
                      ),
                      5.sp.sbh,
                    ],
                  ),
                ),
              ),
              5.sp.sbh,
            ],
          )
        : 0.sbh;
  }

  // Padding _buildDivider() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //         horizontal: AppConstants.screenHorizontalPadding),
  //     child: Divider(
  //       color: AppColors.labelColor,
  //       thickness: 1.sp,
  //     ),
  //   );
  // }

  Widget _buildRatingBar(String rating) {
    return RatingBar(
      initialRating: rating == "" ? 0.0 : double.parse(rating),
      direction: Axis.horizontal,
      allowHalfRating: false,
      tapOnlyMode: true,
      itemSize: 1.7.h,
      itemCount: 5,
      ratingWidget: RatingWidget(
        full: Image.asset(AppImages.startFillIc, height: 2.h),
        half: Image.asset(AppImages.startFillIc, height: 2.h),
        empty: Image.asset(AppImages.startUnFillIc, height: 2.h),
      ),
      itemPadding: EdgeInsets.symmetric(horizontal: 0.5.sp),
      onRatingUpdate: (rating1) {
        if (double.parse(rating) == rating1) {
          _updateRating(0.0);
        } else {
          _updateRating(rating1);
        }
      },
    );
  }

  Widget _buildLikeCommentShare(Record record) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    CommonController.getDoubleValue(
                                record.postStarRatingAvg!.toString()) >
                            0
                        ? AppImages.startFillIc
                        : AppImages.startUnFillIc,
                    height: 2.h),
                SizedBox(width: 2.w),
                Expanded(
                  child: CustomText(
                    text: CommonController.getDoubleValue(
                                record.postStarRatingAvg!.toString()) >
                            0
                        ? "${record.postStarRatingAvg!} (${record.postStarRatingCount!.toString()})"
                        : record.postStarRatingAvg!.toString(),
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor5,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(width: 5.w),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isShowComment = !_isShowComment;
                });
                _runExpandCheck();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.comment, height: 2.h),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: CustomText(
                      text: commentCount.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor5,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.share, height: 2.h),
                SizedBox(width: 2.w),
                Flexible(
                  child: CustomText(
                    text: record.postShareCount!,
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor5,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeCommentShare2(Record record) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              flex: 5,
              child: Transform.translate(
                  offset: Offset(0, -2.sp),
                  child: _buildRatingBar(record.postStarRating.toString()))),
          Expanded(
            flex: 5,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isShowComment = !_isShowComment;
                });
                _runExpandCheck();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.comment, height: 2.h),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: CustomText(
                      text: AppString.comment,
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor5,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return SharePostAlertDialog(
                      record: widget.record,
                    );
                  },
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.share, height: 2.h),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: CustomText(
                      text: AppString.share,
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor5,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _updateRating(double rating) async {
    final insightController = Get.find<InsightStreamController>();
    final hashTagController = Get.find<HashTagController>();
    final userStramController = Get.find<UserInsightStreamController>();
    try {
      var response = await insightController.addStarRating(
          widget.record.id.toString(), rating.toString());
      if (response.isSuccess == true) {
        if (widget.isFrom == PostTypeEnum.insight) {
          insightController.setRating(widget.record.id.toString(),
              response.responseT!, rating.toString());
        } else if (widget.isFrom == PostTypeEnum.hashtag) {
          hashTagController.setRating(widget.record.id.toString(),
              response.responseT!, rating.toString());
        } else {
          userStramController.setRating(widget.record.id.toString(),
              response.responseT!, rating.toString());
        }
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    }
  }
}
