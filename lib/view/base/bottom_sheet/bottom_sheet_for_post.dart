import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/hashtag_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/user_insight_stream_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_report_post.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class BottomSheetForPost extends StatefulWidget {
  const BottomSheetForPost({
    super.key,
    required this.isPostSaved,
    required this.isUserFollowed,
    required this.isUserBlocked,
    required this.postId,
    required this.userId,
    required this.isShowAddCollegue,
    required this.userName,
    required this.isShowSaveUnsave,
    required this.isShowHidePost,
    required this.isShowHideAllPost,
    required this.isShowFollowUnFollow,
    required this.isShowBlockUnblock,
    required this.isShowReportPost,
    required this.isFrom,
    required this.shareUrl,
    this.streamType,
  });
  final int isPostSaved;
  final int isUserFollowed;
  final int isUserBlocked;
  final String userName;
  final String postId;
  final String userId;
  final String shareUrl;

  final bool isShowSaveUnsave;
  final bool isShowHidePost;
  final bool isShowHideAllPost;
  final bool isShowFollowUnFollow;
  final bool isShowBlockUnblock;
  final bool isShowReportPost;

  final bool isShowAddCollegue;

  final PostTypeEnum isFrom;
  final UserInsightStreamEnumType? streamType;

  @override
  State<BottomSheetForPost> createState() => _BottomSheetForPostState();
}

class _BottomSheetForPostState extends State<BottomSheetForPost> {
  List<PopUpModel?> _menuList = [];
  final _insightStreamController = Get.find<InsightStreamController>();
  final _hashTagController = Get.find<HashTagController>();
  final _userInsightStreamController = Get.find<UserInsightStreamController>();
  int _isPostSaved = 0;
  int _isUserFollowed = 0;
  int _isUserBlocked = 0;
  bool _isShowAddCollegue = false;

  bool _isLoading = false;
  _loadList() {
    _menuList = [];
    _menuList.addAll([
      widget.isShowSaveUnsave
          ? PopUpModel(
              title:
                  _isPostSaved == 0 ? AppString.savePost : AppString.unsavePost,
              subTitle: _isPostSaved == 0
                  ? AppString.addThisToYourSavedItems
                  : AppString.removeThisFromYour,
              image: _isPostSaved == 0
                  ? AppImages.savePost1Ic
                  : AppImages.unsaveIc,
              onTap: () {
                _savePost();
              })
          : null,
      widget.isShowHidePost
          ? PopUpModel(
              title: AppString.hidePost,
              subTitle: AppString.seeFewerPostsLikeThis,
              image: AppImages.hidePostIc,
              onTap: () {
                _hidePost();
              })
          : null,
      widget.isShowHideAllPost
          ? PopUpModel(
              title: AppString.hideAllPost,
              subTitle: AppString.stopSeeingPosts,
              image: AppImages.hidePostIc,
              onTap: () {
                _hideAllPost();
              })
          : null,
      widget.isShowFollowUnFollow
          ? PopUpModel(
              title: _isUserFollowed == 0
                  ? "${AppString.follow} ${widget.userName}"
                  : "${AppString.unfollow} ${widget.userName}",
              subTitle: _isUserFollowed == 0
                  ? "${AppString.join} ${widget.userName}${AppString.sCircleOfInfluence}"
                  : '',
              image: _isUserFollowed == 0
                  ? AppImages.followerIc
                  : AppImages.unfollowIc,
              onTap: () {
                _followUnFollowUser();
              })
          : null,
      _isShowAddCollegue == true
          ? PopUpModel(
              title: AppString.addAsAColleague,
              subTitle:
                  "${AppString.invite} ${widget.userName} ${AppString.toBecomeMutualColleague}",
              image: AppImages.addCollegueIc,
              onTap: () {
                _addAsCollegue();
              })
          : null,
      widget.isShowBlockUnblock
          ? PopUpModel(
              title: _isUserBlocked == 0 ? AppString.block : AppString.unblock,
              subTitle: _isUserBlocked == 0 ? AppString.removeThisPerson : '',
              image:
                  _isUserBlocked == 0 ? AppImages.blockIc : AppImages.unblockIc,
              onTap: () {
                _blockUnBlock();
              })
          : null,
      PopUpModel(
          title: "Share Via",
          subTitle: "share on external platform",
          image: AppImages.shareBlackIc,
          onTap: () {
            CommonController.sharePostToEveryWhere(widget.shareUrl);
          }),
      widget.isShowReportPost
          ? PopUpModel(
              title: AppString.reportPost,
              subTitle: AppString.imConcernedAboutThis,
              image: AppImages.reportPostIc,
              onTap: () {
                _reportPost();
              })
          : null,
    ]);
  }

  @override
  void initState() {
    super.initState();
    _isPostSaved = widget.isPostSaved;
    _isUserFollowed = widget.isUserFollowed;
    _isUserBlocked = widget.isUserBlocked;
    _isShowAddCollegue = widget.isShowAddCollegue;
    _loadList();
  }

  _savePost() async {
    setState(() {
      _isLoading = true;
    });
    try {
      int valueToUpdate = _isPostSaved == 0 ? 1 : 0;
      var response = await _insightStreamController.savePost(
          widget.postId.toString(), _isPostSaved, valueToUpdate);

      if (response.isSuccess == true) {
        if (widget.streamType != null &&
            widget.streamType == UserInsightStreamEnumType.savedPost) {
          _userInsightStreamController.getOtherUserInsightFeeds(true, "",
              stramType: widget.streamType!);
          _insightStreamController.setSavedPost(
              widget.postId.toString(), valueToUpdate);

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          if (widget.isFrom == PostTypeEnum.insight) {
            _insightStreamController.setSavedPost(
                widget.postId.toString(), valueToUpdate);
          } else if (widget.isFrom == PostTypeEnum.hashtag) {
            _hashTagController.setSavedPost(
                widget.postId.toString(), valueToUpdate);
          } else {
            _userInsightStreamController.setSavedPost(
                widget.postId.toString(), valueToUpdate);
          }
        }

        setState(() {
          _isPostSaved = valueToUpdate;
        });
        _loadList();
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _hidePost() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response =
          await _insightStreamController.hidePost(widget.postId.toString());

      if (response.isSuccess == true) {
        if (widget.isFrom == PostTypeEnum.insight) {
          _insightStreamController.setHidePost(widget.postId.toString());
        }

        showCustomSnackBar(response.message, isError: false);

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _hideAllPost() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response =
          await _insightStreamController.hideAllPost(widget.userId.toString());

      if (response.isSuccess == true) {
        if (widget.isFrom == PostTypeEnum.insight) {
          _insightStreamController.setHideAllPost(widget.userId.toString());
        }

        showCustomSnackBar(response.message, isError: false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _followUnFollowUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      int valueToUpdate = _isUserFollowed == 0 ? 1 : 0;
      var response = await _insightStreamController.followUnfollowUser(
          widget.userId.toString(), valueToUpdate);

      if (response.isSuccess == true) {
        if (widget.isFrom == PostTypeEnum.insight) {
          _insightStreamController.setFollowUnFollow(
              widget.userId.toString(), valueToUpdate);
        } else if (widget.isFrom == PostTypeEnum.hashtag) {
          _hashTagController.setFollowUnFollow(
              widget.userId.toString(), valueToUpdate);
        } else {
          _userInsightStreamController.setFollowUnFollow(
              widget.userId.toString(), valueToUpdate);
        }

        setState(() {
          _isUserFollowed = valueToUpdate;
        });
        _loadList();
        _insightStreamController.getFollowersCount();
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _addAsCollegue() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var response = await _insightStreamController.addAsColleague(
        widget.userId.toString(),
      );

      if (response.isSuccess == true) {
        if (widget.isFrom == PostTypeEnum.insight) {
          _insightStreamController.setAddAsCollegue(widget.userId.toString());
        } else if (widget.isFrom == PostTypeEnum.hashtag) {
          _hashTagController.setAddAsCollegue(widget.userId.toString());
        } else {
          _userInsightStreamController
              .setAddAsCollegue(widget.userId.toString());
        }
        setState(() {
          _isShowAddCollegue = false;
        });
        _loadList();
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _blockUnBlock() async {
    setState(() {
      _isLoading = true;
    });
    try {
      int valueToUpdate = _isUserBlocked == 0 ? 1 : 0;
      var response = await _insightStreamController.blockUnBlock(
          widget.userId.toString(), valueToUpdate);

      if (response.isSuccess == true) {
        if (widget.isFrom == PostTypeEnum.insight) {
          _insightStreamController.setBlockUnblock(
              widget.userId.toString(), valueToUpdate);
        }

        if (widget.isFrom == PostTypeEnum.user) {
          _userInsightStreamController.setBlockUnblock(
              widget.userId.toString(), valueToUpdate);
        }

        setState(() {
          _isUserBlocked = valueToUpdate;
        });
        _loadList();
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _reportPost() async {
    Navigator.pop(context);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ReportPostAlertDialog(
          postId: widget.postId.toString(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            5.sp.sbh,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.sp),
                  color: AppColors.labelColor6),
              height: 3.sp,
              width: 30.sp,
            ),
            5.sp.sbh,
            Flexible(
              child: SingleChildScrollView(
                child: _buildView(),
              ),
            ),
          ],
        ),
        _isLoading
            ? Positioned.fill(
                child: Container(
                color: AppColors.black.withOpacity(0.1),
                child: const Center(
                  child: CustomLoadingWidget(),
                ),
              ))
            : 0.sbh,
      ],
    );
  }

  Widget _buildView() => Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor1,
          border: Border.all(
            color: AppColors.labelColor,
          ),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ..._menuList.map(
              (e) => e == null ? 0.sbh : _buildListTile(e),
            ),
          ],
        ),
      );

  Widget _buildListTile(PopUpModel data) {
    int index = _menuList.indexOf(data);
    bool isLast = index + 1 == _menuList.length;
    return InkWell(
      onTap: () {
        data.onTap();
      },
      child: Padding(
        padding: EdgeInsets.all(5.sp),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                12.sp.sbw,
                Padding(
                  padding: EdgeInsets.only(top: 2.sp),
                  child: Image.asset(data.image, height: 14.sp),
                ),
                12.sp.sbw,
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.title,
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor14,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 11.sp,
                        maxLine: 3,
                        fontWeight: FontWeight.w600,
                      ),
                      data.subTitle == ''
                          ? 0.sp.sbh
                          : CustomText(
                              text: data.subTitle,
                              textAlign: TextAlign.start,
                              color: AppColors.labelColor5,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              maxLine: 3,
                              fontWeight: FontWeight.w400,
                            )
                    ],
                  ),
                ),
              ],
            ),
            10.sp.sbh,
            isLast
                ? 0.sbh
                : const Divider(
                    color: AppColors.labelColor,
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
