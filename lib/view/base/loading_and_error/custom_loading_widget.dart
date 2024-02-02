import 'package:aspirevue/util/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class CustomLoadingWidget extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? width;
  const CustomLoadingWidget({super.key, this.color, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    // return SizedBox(
    //   height: height ?? 70.sp,
    //   child: Padding(
    //     padding: EdgeInsets.only(left: 10.sp),
    //     child: Lottie.asset(AppAnimation.loadingAnimation3),
    //   ),
    // );

    return Container(
      padding: EdgeInsets.all(15.sp),
      // decoration: BoxDecoration(
      //   color: AppColors.editColor,
      //   borderRadius: BorderRadius.circular(5.sp),
      // ),
      child: SizedBox(
        height: height ?? 20.sp,
        width: width ?? 20.sp,
        child: Transform.scale(
          scale: 1.2.sp,
          child: const CupertinoActivityIndicator(
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
