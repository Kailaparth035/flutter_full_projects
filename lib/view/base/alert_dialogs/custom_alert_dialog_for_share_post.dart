import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_body_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_header_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/post_media_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SharePostAlertDialog extends StatefulWidget {
  const SharePostAlertDialog({super.key, required this.record});

  final Record record;
  @override
  State<SharePostAlertDialog> createState() => ReportPostAlertDialogState();
}

class ReportPostAlertDialogState extends State<SharePostAlertDialog> {
  final _insightStreamController = Get.find<InsightStreamController>();

  // bool _isLoadingSend = false;

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
            width: context.getWidth - 30.sp,
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
                    _buildCurrentUserProfile(),
                    10.sp.sbh,
                    PostHeaderWidget(
                      record: widget.record,
                      isParent: false,
                      isFrom: PostTypeEnum.insight,
                      onEditing: () {},
                      onDeleting: () {},
                    ),
                    widget.record.description.toString() != ""
                        ? Column(
                            children: [
                              5.sp.sbh,
                              PostBodyWidget(
                                  isFrom: PostTypeEnum.insight,
                                  description:
                                      widget.record.description.toString(),
                                  isParent: false),
                            ],
                          )
                        : 0.sbh,
                    5.sp.sbh,
                    PostMediaViewWidget(
                        record: widget.record, isParent: false, height: 20.h),
                    5.sp.sbh,
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButton2(
                              buttonText: AppString.sharePost,
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
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
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

  GetBuilder<ProfileSharedPrefService> _buildCurrentUserProfile() {
    return GetBuilder<ProfileSharedPrefService>(
        builder: (sharedPrefController) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
            child: Row(
              children: [
                CustomImageForProfile(
                  image:
                      sharedPrefController.profileData.value.photo.toString(),
                  radius: 16.sp,
                  nameInitials: sharedPrefController.profileData.value.name![0]
                      .toString(),
                  borderColor: AppColors.labelColor,
                ),
                5.sp.sbw,
                CustomText(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                  color: AppColors.labelColor8,
                  text: sharedPrefController.profileData.value.name.toString(),
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
            child: CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor9.withOpacity(0.2),
              inputAction: TextInputAction.done,
              labelText:
                  '${AppString.whatOnYourMind}${sharedPrefController.profileData.value.firstName} ?',
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              lineCount: 3,
              validator: Validation().requiredFieldValidation,
              editColor: AppColors.labelColor12,
              textEditingController: _msgTextController,
            ),
          ),
        ],
      );
    });
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
            text: AppString.sharePost,
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
        "share_postId": widget.record.id.toString(),
        "share_post_text": _msgTextController.text.toString().trim(),
      };

      var response = await _insightStreamController.sharePost(requestPrm);

      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        await _insightStreamController.getInsightFeed(true);
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
