import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AccessPermissionScreen extends StatefulWidget {
  const AccessPermissionScreen({super.key});

  @override
  State<AccessPermissionScreen> createState() => _AccessPermissionScreenState();
}

class _AccessPermissionScreenState extends State<AccessPermissionScreen> {
  final _mainController = Get.find<MainController>();

  @override
  void initState() {
    _mainController.getPermissionStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: "",
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.sp),
            child: GetBuilder<MainController>(builder: (mainController) {
              return mainController.isLoadingPermission == true
                  ? const Center(
                      child: CustomLoadingWidget(),
                    )
                  : Center(
                      child: Column(
                        children: [
                          CustomText(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: AppColors.labelColor10,
                            text: "App Need Permission",
                            textAlign: TextAlign.start,
                            maxLine: 2,
                            fontFamily: AppString.manropeFontFamily,
                          ),
                          10.sp.sbh,
                          ...mainController.permissionList.map((e) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButton2(
                                    buttonColor: e.isGranted
                                        ? AppColors.greenColor
                                        : AppColors.seekbarBlue,
                                    buttonText: "Allow ${e.name}",
                                    radius: 20.sp,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5.sp, horizontal: 13.sp),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10.sp,
                                    onPressed: () async {
                                      mainController.requestPermission(e);
                                    }),
                              ))
                        ],
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
