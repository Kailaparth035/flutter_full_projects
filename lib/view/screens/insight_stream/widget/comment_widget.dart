import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/comment_list_model.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/video_player_widgets/video_player_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/profile_view_popup_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/video_preview_in_comment_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/write_comment_widget.dart';
import 'package:aspirevue/view/screens/others/local_image_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget(
      {super.key,
      required this.data,
      required this.postId,
      required this.onAddComment,
      this.isOnlyTextComment = false,
      required this.isNewsComment,
      required this.isBlockedUser});
  final CommentData data;
  final String postId;
  final Future Function() onAddComment;
  final bool isOnlyTextComment;
  final bool isNewsComment;
  final bool isBlockedUser;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isShowGiveComment = false;
  bool _isShowChild = false;

  @override
  Widget build(BuildContext context) {
    return _buildComment();
  }

  Widget _buildComment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageForProfile(
              image: widget.data.photo.toString(),
              radius: 14.sp,
              nameInitials: widget.data.selfInitial.toString(),
              borderColor: AppColors.labelColor,
            ),
            7.sp.sbw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                    decoration: BoxDecoration(
                      color: AppColors.labelColor,
                      borderRadius: BorderRadius.circular(3.sp),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileViewPopUp(
                          userDetails: TagLine(
                            id: widget.data.userId.toString(),
                            name: widget.data.userName.toString(),
                            companyName: widget.data.company.toString(),
                            photo: widget.data.photo.toString(),
                            position: widget.data.positions.toString(),
                            userType: widget.data.userType.toString(),
                          ),
                          child: CustomText(
                            text: widget.data.userName.toString(),
                            textAlign: TextAlign.start,
                            color: AppColors.labelColor5,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        3.sp.sbh,
                        CustomText(
                          text: widget.data.description.toString(),
                          textAlign: TextAlign.start,
                          color: AppColors.labelColor5,
                          fontFamily: AppString.manropeFontFamily,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        3.sp.sbh,
                        widget.data.commentFiles!.isNotEmpty
                            ? Wrap(
                                crossAxisAlignment: WrapCrossAlignment.start,
                                children: [
                                  ...widget.data.commentFiles!.map((e) {
                                    return _buildImageAndVideoView(e);
                                  })
                                ],
                              )
                            : 0.sbh,
                        widget.isBlockedUser == true
                            ? 0.sbh
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    _isShowGiveComment = !_isShowGiveComment;
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.asset(
                                      AppImages.backIc,
                                      height: 10.sp,
                                      width: 10.sp,
                                    ),
                                    CustomText(
                                      text:
                                          "  ${AppString.reply}  ${widget.data.commentTime}",
                                      textAlign: TextAlign.end,
                                      color: AppColors.labelColor5,
                                      fontFamily: AppString.manropeFontFamily,
                                      fontSize: 7.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _isShowGiveComment
              ? Padding(
                  padding: EdgeInsets.only(top: 2.sp),
                  child: WriteCommentWidget(
                    isNewsComment: widget.isNewsComment,
                    isOnlyTextComment: widget.isOnlyTextComment,
                    postId: widget.postId,
                    parentCommentId: widget.data.id.toString(),
                    onAddComment: () async {
                      await widget.onAddComment();
                    },
                  ),
                )
              : 0.sbh,
        ),
        widget.data.child!.isNotEmpty && _isShowChild == true
            ? Align(
                alignment: Alignment.topRight,
                child: Transform.translate(
                  offset: Offset(0, 0.sp),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isShowChild = !_isShowChild;
                      });
                    },
                    child: CustomText(
                      text: "View less...",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor5,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            : 0.sbh,
        widget.data.child!.isNotEmpty && _isShowChild == false
            ? Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isShowChild = !_isShowChild;
                    });
                  },
                  child: CustomText(
                    text:
                        "${AppString.view} ${widget.data.child!.length} ${AppString.morereply}",
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor5,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : 0.sbh,
        5.sp.sbh,
        _isShowChild
            ? Column(
                children: [
                  ...widget.data.child!.map((e) => Padding(
                        padding: EdgeInsets.only(left: 5.sp),
                        child: CommentWidget(
                            isBlockedUser: widget.isBlockedUser,
                            isOnlyTextComment: widget.isOnlyTextComment,
                            isNewsComment: widget.isNewsComment,
                            data: e,
                            postId: widget.postId,
                            onAddComment: () async {
                              await widget.onAddComment();
                            }),
                      ))
                ],
              )
            : 0.sbh,
      ],
    );
  }

  _buildImageAndVideoView(CommentFile files) {
    return SizedBox(
      height: 10.h,
      child: Stack(
        children: [
          files.postType == "image"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Get.to(
                          () => ImagePreviewScreen(url: files.name.toString()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.sp),
                      child: CustomImage(
                        image: files.name.toString(),
                      ),
                    ),
                  ),
                )
              : files.postType == "video"
                  ? InkWell(
                      onTap: () {
                        Get.to(() =>
                            VideoPlayerScreen(url: files.name.toString()));
                      },
                      child: VideoPreviewInCommentWidget(
                          videoUrl: files.name.toString()))
                  : files.postType == "docs"
                      ? files.name!.contains(".doc")
                          ? InkWell(
                              onTap: () {
                                CommonController.downloadFile(
                                    files.name!, context);
                              },
                              child: Container(
                                width: 10.h,
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  child: Image.asset(AppImages.docImageIc),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                CommonController.downloadFile(
                                    files.name!, context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                width: 10.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.sp),
                                  child: Image.asset(AppImages.excelImageIc),
                                ),
                              ),
                            )
                      : const Text(""),
          files.postType == "video"
              ? Positioned.fill(
                  child: InkWell(
                    onTap: () {
                      Get.to(
                          () => VideoPlayerScreen(url: files.name.toString()));
                    },
                    child: const Icon(
                      Icons.play_arrow,
                      color: AppColors.white,
                    ),
                  ),
                )
              : 0.sbh,
        ],
      ),
    );
  }
}
