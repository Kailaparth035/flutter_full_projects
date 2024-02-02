import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_goal_controller.dart';
import 'package:aspirevue/data/model/response/goal_messages_model.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ViewMessageAlertDialog extends StatefulWidget {
  const ViewMessageAlertDialog({
    super.key,
    required this.userId,
    required this.type,
    required this.styleId,
    required this.goalId,
  });

  final String userId;
  final String type;
  final String styleId;
  final String goalId;

  @override
  State<ViewMessageAlertDialog> createState() => _ViewMessageAlertDialogState();
}

class _ViewMessageAlertDialogState extends State<ViewMessageAlertDialog> {
  final _myGoalController = Get.find<MyGoalController>();

  bool _isLoading = false;
  bool _isLoadingSave = false;
  final TextEditingController _msgController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isFirstSubmit = true;

  // goalMessages
  List<GoalMessage> _goalMessageList = [];
  @override
  void initState() {
    super.initState();
    _loadGoalMessages(true);
  }

  Future _loadGoalMessages(bool showMainLoading) async {
    if (showMainLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    Map<String, dynamic> map = {
      "id": widget.goalId.toString(),
      "Goal_type": widget.type.toString(),
      "style_id": widget.styleId.toString(),
      "user_id": widget.userId.toString(),
    };
    try {
      List<GoalMessage>? list = await _myGoalController.getGoalMessages(map);
      if (list != null) {
        setState(() {
          _goalMessageList = list;
        });
      }
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    } finally {
      if (showMainLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        child: SingleChildScrollView(
          child: _isLoading
              ? const Center(
                  child: CustomLoadingWidget(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    Divider(
                      height: 1.sp,
                      color: AppColors.labelColor,
                      thickness: 1,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.sp, horizontal: 10.sp),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: !isFirstSubmit
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  minHeight: 30.sp,
                                  maxHeight: context.getHeight / 4),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.labelColor),
                                  borderRadius: BorderRadius.circular(5.sp)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.sp, horizontal: 10.sp),
                              child: _goalMessageList.isEmpty
                                  ? const Center(
                                      child: CustomNoDataFoundWidget(
                                        topPadding: 0,
                                      ),
                                    )
                                  : Scrollbar(
                                      radius: Radius.circular(20.sp),
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ..._goalMessageList
                                                .map((e) => _buildListTile(e))
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                            10.sp.sbh,
                            CustomTextFormFieldForMessage(
                              validator: Validation().requiredFieldValidation,
                              borderColor: AppColors.labelColor,
                              inputAction: TextInputAction.done,
                              labelText: AppString.pleaseEntermessages,
                              inputType: TextInputType.text,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 12.sp,
                              lineCount: 2,
                              editColor: AppColors.labelColor12,
                              textEditingController: _msgController,
                            ),
                            10.sp.sbh,
                            _isLoadingSave
                                ? Center(
                                    child: SizedBox(
                                      child: CustomLoadingWidget(
                                        height: 40.sp,
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButton2(
                                          isLoading: false,
                                          buttonText: AppString.save,
                                          radius: 5.sp,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5.sp,
                                              horizontal: 13.sp),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp,
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _sendMessage();
                                            }
                                          })
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ),
                    10.sp.sbh,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildListTile(GoalMessage messge) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.labelColor43,
            borderRadius: BorderRadius.circular(3.sp),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CustomText(
                      text: messge.senderUserName.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.secondaryColor,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 11.sp,
                      maxLine: 2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CustomText(
                        text: messge.created.toString(),
                        textAlign: TextAlign.end,
                        color: AppColors.labelColor15,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 9.sp,
                        maxLine: 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
              5.sp.sbh,
              CustomText(
                text: messge.messagesText.toString(),
                textAlign: TextAlign.start,
                color: AppColors.black,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 10.sp,
                maxLine: 2,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
        5.sp.sbh
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: AppString.viewMessages,
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(2),
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
    try {
      setState(() {
        isFirstSubmit = false;
        _isLoadingSave = true;
      });
      Map<String, dynamic> map = {
        "id": widget.goalId.toString(),
        "user_id": widget.userId.toString(),
        "Goal_type": widget.type.toString(),
        "style_id": widget.type.toString(),
        "messages_text": _msgController.text
      };

      var response = await _myGoalController.sendGoalMessage(map);
      if (response.isSuccess == true) {
        await _loadGoalMessages(false);
        showCustomSnackBar(response.message, isError: false);
        _msgController.clear();
        setState(() {
          isFirstSubmit = true;
        });
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoadingSave = false;
      });
      FocusScope.of(Get.context!).requestFocus(FocusNode());
    }
  }
}
