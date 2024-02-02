import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ReportPostAlertDialog extends StatefulWidget {
  const ReportPostAlertDialog({super.key, required this.postId});
  final String postId;
  @override
  State<ReportPostAlertDialog> createState() => ReportPostAlertDialogState();
}

class ReportPostAlertDialogState extends State<ReportPostAlertDialog> {
  final _insightStreamController = Get.find<InsightStreamController>();

  // bool _isLoadingSend = false;

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _msgTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFirstSubmit = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 0.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: Stack(
        children: [
          SizedBox(
            width: 100.w,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: !_isFirstSubmit
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    10.sp.sbh,
                    _buildTitle(),
                    10.sp.sbh,
                    Divider(
                      height: 1.sp,
                      color: AppColors.labelColor,
                      thickness: 1,
                    ),
                    5.sp.sbh,
                    _buildTextTitle(AppString.topic),
                    5.sp.sbh,
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                      child: CustomTextFormFieldForMessage(
                        borderColor: AppColors.labelColor9.withOpacity(0.2),
                        inputAction: TextInputAction.done,
                        labelText: AppString.addTitle,
                        inputType: TextInputType.text,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 10.sp,
                        lineCount: 1,
                        validator: Validation().requiredFieldValidation,
                        editColor: AppColors.labelColor12,
                        textEditingController: _titleTextController,
                      ),
                    ),
                    5.sp.sbh,
                    _buildTextTitle(AppString.canyougiveusmoredetails),
                    5.sp.sbh,
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                      child: CustomTextFormFieldForMessage(
                        borderColor: AppColors.labelColor9.withOpacity(0.2),
                        inputAction: TextInputAction.done,
                        labelText: AppString.sendMessage,
                        inputType: TextInputType.text,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 10.sp,
                        lineCount: 4,
                        validator: Validation().requiredFieldValidation,
                        editColor: AppColors.labelColor12,
                        textEditingController: _msgTextController,
                      ),
                    ),
                    10.sp.sbh,
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton2(
                              buttonText: AppString.close,
                              buttonColor: AppColors.primaryColor,
                              radius: 5.sp,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.sp, horizontal: 13.sp),
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          5.sp.sbw,
                          CustomButton2(
                              buttonText: AppString.reportPost,
                              radius: 5.sp,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.sp, horizontal: 13.sp),
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              onPressed: () {
                                setState(() {
                                  _isFirstSubmit = false;
                                });
                                if (_formKey.currentState!.validate()) {
                                  _sendMessage();
                                }
                              })
                        ],
                      ),
                    ),
                    10.sp.sbh,
                  ],
                ),
              ),
            ),
          ),
          // Positioned.fill(
          //   child: _isLoadingSend
          //       ? Container(
          //           color: AppColors.black.withOpacity(0.1),
          //           child: const Center(
          //             child: CustomLoadingWidget(),
          //           ),
          //         )
          //       : 0.sbh,
          // ),
        ],
      ),
    );
  }

  Widget _buildTextTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
      child: CustomText(
        fontWeight: FontWeight.w500,
        fontSize: 10.sp,
        color: AppColors.black,
        text: title,
        textAlign: TextAlign.start,
        fontFamily: AppString.manropeFontFamily,
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: AppString.reportPost,
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.labelColor15.withOpacity(0.5)),
              child: Icon(
                Icons.close,
                weight: 3,
                size: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  _sendMessage() async {
    // setState(() {
    //   _isLoadingSend = true;
    // });
    buildLoading(Get.context!);
    try {
      Map<String, dynamic> requestPrm = {
        "post_id": widget.postId.toString(),
        "title": _titleTextController.text.toString().trim(),
        "message": _msgTextController.text.toString().trim(),
      };
      var response = await _insightStreamController.reportPost(requestPrm);

      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pop(Get.context!, true);
        });
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
      // setState(() {
      //   _isLoadingSend = false;
      // });
    }
  }
}
