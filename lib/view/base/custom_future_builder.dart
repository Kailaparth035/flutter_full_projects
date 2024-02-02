import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FutureBuildWidget extends StatelessWidget {
  const FutureBuildWidget(
      {super.key,
      required this.child,
      this.errorchild,
      required this.future,
      required this.onRetry,
      this.errorMessage,
      this.padding,
      this.isShowBackArrowInError,
      this.isList = false});
  final Function child;
  final Function onRetry;
  final Widget? errorchild;
  final dynamic future;
  final EdgeInsetsGeometry? padding;
  final String? errorMessage;
  final bool isList;
  final bool? isShowBackArrowInError;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                if (isList) {
                  if (snapshot.data.isNotEmpty) {
                    return child(snapshot.data);
                  } else {
                    return errorchild ??
                        _buildDataNotFound1(
                            errorMessage ?? AppString.noDataFound);
                  }
                } else {
                  return child(snapshot.data);
                }
              } else {
                return errorchild ??
                    _buildDataNotFound1(errorMessage ?? AppString.noDataFound);
              }
            } else if (snapshot.hasError) {
              return errorchild ?? _buildErrorWidget(snapshot.error.toString());
            } else {
              return errorchild ??
                  _buildDataNotFound1(errorMessage ?? AppString.noDataFound);
            }
          } else {
            return _buildLoading();
          }
        });
  }

  Widget _buildLoading() {
    return Padding(
      padding: padding ?? EdgeInsets.only(bottom: 0.h),
      child: const Center(child: CustomLoadingWidget()),
    );
  }

  Widget _buildErrorWidget(
    String text,
  ) {
    return Stack(
      children: [
        isShowBackArrowInError == true
            ? Positioned(
                top: 50.sp,
                left: 20.sp,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: AppColors.black,
                    size: 3.h,
                  ),
                ),
              )
            : 0.sbh,
        Padding(
          padding: padding ?? EdgeInsets.only(bottom: 10.h),
          child: Center(
            child: CustomErrorWidget(onRetry: onRetry, text: text),
          ),
        ),
      ],
    );
  }

  Widget _buildDataNotFound1(
    String text,
  ) {
    return Padding(
      padding: padding ?? EdgeInsets.only(bottom: 10.h),
      child: const Center(child: CustomNoDataFoundWidget()),
    );
  }
}
