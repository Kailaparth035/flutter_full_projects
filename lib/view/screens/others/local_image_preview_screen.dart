import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatefulWidget {
  const ImagePreviewScreen({super.key, required this.url});
  final String url;
  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.black,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.black,
          ),
          backgroundColor: AppColors.black,
          body: InteractiveViewer(
            child: Center(
              child: CustomImage(
                image: widget.url,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
