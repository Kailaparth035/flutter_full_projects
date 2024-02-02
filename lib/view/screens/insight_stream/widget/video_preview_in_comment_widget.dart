import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sizer/sizer.dart';

class VideoPreviewInCommentWidget extends StatefulWidget {
  const VideoPreviewInCommentWidget({super.key, required this.videoUrl});
  final String videoUrl;
  @override
  State<VideoPreviewInCommentWidget> createState() =>
      _VideoPreviewInCommentWidgetState();
}

class _VideoPreviewInCommentWidgetState
    extends State<VideoPreviewInCommentWidget> {
  bool _isloadingCache = false;

  File? thumbnailFile;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    try {
      setState(() {
        _isloadingCache = true;
      });

      var ressult = await CommonController.generateThumbnail(widget.videoUrl);

      setState(() {
        thumbnailFile = ressult;
      });
    } finally {
      setState(() {
        _isloadingCache = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.sp),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.sp),
        child: _isloadingCache
            ? Shimmer(
                child: Container(
                  width: 10.h,
                  color: AppColors.labelColor.withOpacity(0.5),
                ),
              )
            : thumbnailFile == null
                ? Image.asset(
                    AppImages.placeholder,
                    width: 10.h,
                    height: 10.h,
                    fit: BoxFit.fill,
                  )
                : Image.file(thumbnailFile!),
      ),
    );
  }
}
