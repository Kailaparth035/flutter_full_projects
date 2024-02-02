import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectPostTypeBottomSheet extends StatelessWidget {
  const SelectPostTypeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: context.getWidth,
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.sp),
              child: ListTile(
                leading: Icon(
                  Icons.photo_library,
                  size: 14.sp,
                ),
                title: CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  color: AppColors.labelColor18,
                  text: "Photo",
                  textAlign: TextAlign.left,
                  fontFamily: AppString.manropeFontFamily,
                ),
                onTap: () {
                  Navigator.of(context).pop("image");
                },
              ),
            ),
            buildDivider(),
            Padding(
              padding: EdgeInsets.all(5.sp),
              child: ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  size: 14.sp,
                ),
                title: CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  color: AppColors.labelColor18,
                  text: "Video",
                  textAlign: TextAlign.left,
                  fontFamily: AppString.manropeFontFamily,
                ),
                onTap: () {
                  Navigator.of(context).pop("video");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
