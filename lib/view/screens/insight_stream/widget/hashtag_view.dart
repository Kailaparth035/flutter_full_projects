import 'package:aspirevue/controller/hashtag_controller.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/hashtag_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'hashtag_widget.dart';

class FollowedHashTagView extends StatefulWidget {
  const FollowedHashTagView({
    super.key,
    required this.onTap,
    required this.isAll,
  });
  final Function(String) onTap;
  final bool isAll;
  @override
  State<FollowedHashTagView> createState() => _FollowedHashTagViewState();
}

class _FollowedHashTagViewState extends State<FollowedHashTagView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HashTagController>(builder: (hastagController) {
      if (hastagController.isLoadingHashTag) {
        return ListView.builder(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: 20,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return const HashTagShimmerWidget();
          },
        );
      }

      if (hastagController.isErrorHashTag) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: CustomErrorWidget(
                width: 20.h,
                onRetry: () {
                  hastagController.followedHashtagList();
                },
                text: hastagController.errorMsgHashTag),
          ),
        );
      }

      if (widget.isAll == true && hastagController.hashtagListAll.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: CustomNoDataFoundWidget(
              height: 20.h,
            ),
          ),
        );
      }
      if (widget.isAll == false && hastagController.hashtagList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 15.h),
            child: CustomNoDataFoundWidget(
              height: 20.h,
            ),
          ),
        );
      }

      if (widget.isAll == false) {
        return RefreshIndicator(
          onRefresh: () {
            return hastagController.followedHashtagList();
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: hastagController.hashtagList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    widget.onTap(
                      hastagController.hashtagList[index].name.toString(),
                    );
                  },
                  child:
                      HashTagWidget(data: hastagController.hashtagList[index]));
            },
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () {
          return hastagController.getHashtags();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: hastagController.hashtagListAll.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                widget.onTap(
                  hastagController.hashtagListAll[index].name ??
                      hastagController.hashtagListAll[index].title.toString(),
                );
              },
              child: HashTagWidget(
                data: hastagController.hashtagListAll[index],
              ),
            );
          },
        ),
      );
    });
  }
}
