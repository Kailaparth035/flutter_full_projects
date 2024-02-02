import 'package:aspirevue/util/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../util/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String placeholder;

  const CustomImage(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.cover,
      this.placeholder = AppImages.placeholder});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,
      errorListener: (obj) {
        debugPrint("====> $obj");
      },
      placeholder: (context, url) => Shimmer(
        duration: const Duration(seconds: 1),
        colorOpacity: 1,
        color: AppColors.labelColor,
        child: Container(
          color: AppColors.backgroundColor1,
          height: height,
          width: width,
        ),
      ),
      errorWidget: (context, url, error) =>
          Image.asset(placeholder, height: height, width: width, fit: fit),
    );
  }
}
