import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:flutter/material.dart';

class DevelopmentSelfReflectImageWidget extends StatelessWidget {
  const DevelopmentSelfReflectImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.selfReflactionImage,
      width: context.getWidth,
    );
  }
}
