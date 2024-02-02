import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/hashtag_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_app_bar.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/insight_tream_shimmer_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/search_screen.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/insight_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class HashTagPostStreamScreen extends StatefulWidget {
  const HashTagPostStreamScreen({
    super.key,
    required this.hashTag,
    required this.isFrom,
  });
  final String hashTag;
  final PostTypeEnum isFrom;

  @override
  State<HashTagPostStreamScreen> createState() =>
      _HashTagPostStreamScreenState();
}

class _HashTagPostStreamScreenState extends State<HashTagPostStreamScreen> {
  final _hashTagController = Get.find<HashTagController>();
  bool isFeed = false;
  final _scrollcontroller = ScrollController();

  String _hasTag = "";

  @override
  void initState() {
    super.initState();
    _hasTag = widget.hashTag.toString().trim();
    _scrollcontroller.addListener(_loadMore);
    loadData();
  }

  Future<void> loadData() async {
    _hashTagController.getHashTagListing(true, _hasTag);
  }

  void _loadMore() async {
    if (!_hashTagController.isnotMoreDataHashTagFeedStream) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_hashTagController.isLoadingHashtagStream == false &&
            _hashTagController.isLoadMoreRunningHashTagFeedStream == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _hashTagController.pageNumberHashTagFeedStream += 1;
          await _hashTagController.getHashTagListing(false, _hasTag);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: _buildAppbar(context),
        backgroundColor: AppColors.white,
        body: _buildView(context),
      ),
    );
  }

  GestureDetector _buildView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: GetBuilder<HashTagController>(
          builder: (hashTagController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                5.sp.sbh,
                hashTagController.isLoadingHashtagStream == true
                    ? 0.sbh
                    : hashTagController.displayFollowUnfollowBtn
                        ? _buildFollowUnfollowButton()
                        : 0.sbh,
                Expanded(child: _buildList(hashTagController)),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding _buildFollowUnfollowButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                if (!_hashTagController.followUnfollowBtnDisable) {
                  _followUnfollow(_hashTagController.hashtagId,
                      _hashTagController.userFollwedHastag);
                }
              },
              child: Container(
                height: 5.h,
                width: 10.h,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: _hashTagController.followUnfollowBtnDisable
                          ? AppColors.labelColor2.withOpacity(0.5)
                          : AppColors.secondaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(2.sp),
                  ),
                ),
                child: Center(
                    child: CustomText(
                  text: _hashTagController.userFollwedHastag
                      ? AppString.unfollow
                      : AppString.follow,
                  textAlign: TextAlign.start,
                  color: _hashTagController.followUnfollowBtnDisable
                      ? AppColors.labelColor2.withOpacity(0.5)
                      : AppColors.secondaryColor,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                )),
              ),
            ),
          ),
          2.sp.sbh,
        ],
      ),
    );
  }

  _buildList(HashTagController hashTagController) {
    return hashTagController.isLoadingHashtagStream == true
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding),
            child: const InsightFeedShimmer("hashtag"),
          )
        : hashTagController.isErrorHashtagStream == true
            ? Center(
                child: CustomErrorWidget(
                    onRetry: () {
                      hashTagController.getHashTagListing(true, _hasTag);
                    },
                    text: hashTagController.errorMsgHashtagStream),
              )
            : hashTagController.hashTagFeedList.isEmpty
                ? Center(
                    child: CustomErrorWidget(
                        isNoData: true,
                        onRetry: () {
                          hashTagController.getHashTagListing(true, _hasTag);
                        },
                        text: hashTagController.errorMsgHashtagStream),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return hashTagController.getHashTagListing(true, _hasTag);
                    },
                    child: ListView.builder(
                      controller: _scrollcontroller,
                      padding: EdgeInsets.zero,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: hashTagController.hashTagFeedList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        bool isLast = index + 1 ==
                            hashTagController.hashTagFeedList.length;
                        return InsightWidget(
                          onHashtagReload: () {
                            hashTagController.getHashTagListing(true, _hasTag);
                          },
                          isFrom: PostTypeEnum.hashtag,
                          isShowCommnetSection: true,
                          hashTagController.hashTagFeedList[index],
                          isLast: isLast,
                          isLoadingLast: hashTagController
                              .isLoadMoreRunningHashTagFeedStream,
                          onEditing: () {
                            // print("On edit");
                          },
                          onDeleting: () {
                            // print("On delete");
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
      onSearch: () async {
        var result =
            await Get.to(() => const SearchScreen(isFromHashTagScreen: true));

        if (result != null) {
          setState(() {
            _hasTag = result.toString().trim();
          });
          loadData();
        }
      },
      title: "#$_hasTag",
      onBackPressed: () {
        Get.back();
      },
      showActionIcon: true,
      isShowCreatePost: false,
      isShowSearchPost: true,
      textColor: AppColors.labelColor8,
      iconButtonColor: AppColors.labelColor5,
      context: context,
    );
  }

  _followUnfollow(String hashtagID, bool isFollow) async {
    try {
      buildLoading(Get.context!);
      Map<String, dynamic> map = {
        "hashtag_id": hashtagID,
        "follow_type": isFollow ? "U" : "F"
      };
      var response = await _hashTagController.followHashtag(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _hashTagController.updateFollowFlag(!isFollow);
        _hashTagController.followedHashtagList();
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
