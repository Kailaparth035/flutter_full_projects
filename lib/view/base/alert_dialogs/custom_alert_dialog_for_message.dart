import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/objective_note_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_button.dart';
import 'package:aspirevue/view/base/custom_dropdown_for_message.dart';
import 'package:aspirevue/view/base/custom_dropdown_with_multichild.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MessageAlertDialog extends StatefulWidget {
  const MessageAlertDialog({super.key, required this.userId});
  final String userId;
  @override
  State<MessageAlertDialog> createState() => _MessageAlertDialogState();
}

class _MessageAlertDialogState extends State<MessageAlertDialog> {
  final _myConnectionController = Get.find<MyConnectionController>();

  bool _isLoading = false;
  // bool _isLoadingSend = false;

  ObjectiveNoteListData? objectiveNote;

  DropListModel ddTypeOfNodeList = DropListModel([]);
  DropDownOptionItemMenu ddTypeOfNodeItem =
      DropDownOptionItemMenu(id: null, title: AppString.selectTypesofNotes);

  DropListModel ddDevelopmentNodeList = DropListModel([]);
  DropDownOptionItemMenu ddDevelopmentNodeItem =
      DropDownOptionItemMenu(id: null, title: AppString.selectDevelopmentNode);

  DropDownOptionItemMenu ddAlignmentNodeItem =
      DropDownOptionItemMenu(id: null, title: AppString.selectAlignmentNode);

  final FocusNode _msgFocus = FocusNode();
  final TextEditingController _msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Map<String, dynamic> map = {"user_id": widget.userId};
      var response = await _myConnectionController.getObjectiveNoteList(map);
      if (response != null) {
        if (response.generalNotes == "true") {
          ddTypeOfNodeList.listOptionItems.add(
              DropDownOptionItemMenu(id: "1", title: AppString.generalNotes));
        }
        if (response.developmentNotes == "true") {
          ddTypeOfNodeList.listOptionItems.add(DropDownOptionItemMenu(
              id: "2", title: AppString.developmentNotes));
        }
        if (response.alignmentNotes == "true") {
          ddTypeOfNodeList.listOptionItems.add(
              DropDownOptionItemMenu(id: "3", title: AppString.alignmentNotes));
        }

        for (var element in response.developmentObjectives!) {
          ddDevelopmentNodeList.listOptionItems.add(DropDownOptionItemMenu(
              id: element.id.toString(), title: element.name.toString()));
        }

        objectiveNote = response;

        setState(() {});
      }
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.sp))),
      contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        width: 100.w,
        child: SingleChildScrollView(
          child: _isLoading
              ? const Center(
                  child: CustomLoadingWidget(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    15.sp.sbh,
                    CustomDropListForMessage(
                      ddTypeOfNodeItem.title,
                      ddTypeOfNodeItem,
                      ddTypeOfNodeList,
                      (optionItem) {
                        ddTypeOfNodeItem = optionItem;

                        setState(() {});
                      },
                    ),
                    10.sp.sbh,
                    ddTypeOfNodeItem.title == AppString.developmentNotes
                        ? _buildDevelopmentDropDown()
                        : 0.sbh,
                    ddTypeOfNodeItem.title == AppString.alignmentNotes
                        ? _buildAlignmentDropDown()
                        : 0.sbh,
                    CustomTextFormFieldForMessage(
                      borderColor: AppColors.labelColor9.withOpacity(0.2),
                      focusNode: _msgFocus,
                      inputAction: TextInputAction.done,
                      labelText: AppString.pleaseEntermessages,
                      inputType: TextInputType.text,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 10.sp,
                      lineCount: 5,
                      editColor: AppColors.labelColor12,
                      textEditingController: _msgController,
                    ),
                    10.sp.sbh,
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 70,
                      ),
                      child: CustomButton(
                          // isLoading: _isLoadingSend,
                          buttonText: AppString.send,
                          width: MediaQuery.of(context).size.width,
                          radius: Dimensions.radiusSmall,
                          height: 5.h,
                          onPressed: () {
                            _sendMessage();
                          }),
                    ),
                    10.sp.sbh,
                  ],
                ),
        ),
      ),
    );
  }

  Column _buildAlignmentDropDown() {
    return Column(
      children: [
        CustomDropForAlert(
            borderColor: AppColors.labelColor9.withOpacity(0.2),
            bgColor: AppColors.labelColor12,
            fontWeight: FontWeight.w500,
            headingText: ddAlignmentNodeItem.title,
            list: objectiveNote!.alignmentObjectives!,
            onTap: (AlignmentObjectiveChildData val) {
              setState(() {
                ddAlignmentNodeItem = DropDownOptionItemMenu(
                    id: val.id, title: val.title.toString());
              });
            }),
        10.sp.sbh,
      ],
    );
  }

  Column _buildDevelopmentDropDown() {
    return Column(
      children: [
        CustomDropListForMessage(
          ddDevelopmentNodeItem.title,
          ddDevelopmentNodeItem,
          ddDevelopmentNodeList,
          (optionItem) {
            ddDevelopmentNodeItem = optionItem;

            setState(() {});
          },
        ),
        10.sp.sbh,
      ],
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: AppColors.labelColor8,
          text: AppString.messageNotes,
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
    );
  }

  _sendMessage() async {
    // if (_isLoadingSend) {
    //   return;
    // }
    if (ddTypeOfNodeItem.id == null) {
      showCustomSnackBar(AppString.pleaseSelectTypesofNotes, isError: true);
      return;
    }
    if (ddTypeOfNodeItem.title == AppString.developmentNotes) {
      if (ddDevelopmentNodeItem.id == null) {
        showCustomSnackBar(AppString.pleaseSelectDevelopmentNotes,
            isError: true);
        return;
      }
    }

    if (ddTypeOfNodeItem.title == AppString.alignmentNotes) {
      if (ddAlignmentNodeItem.id == null) {
        showCustomSnackBar(AppString.pleaseSelectAlignmentNotes, isError: true);
        return;
      }
    }

    if (_msgController.text.isEmpty) {
      showCustomSnackBar(AppString.pleaseWriteMessage, isError: true);
      return;
    }

    // setState(() {
    //   _isLoadingSend = true;
    // });

    buildLoading(Get.context!);

    try {
      var map = <String, dynamic>{};
      map['user_id'] = widget.userId.toString();
      map['type'] = ddTypeOfNodeItem.id.toString();
      map['message'] = _msgController.text.trim().toString();
      map['developvue_rating_id'] = ddDevelopmentNodeItem.id.toString();
      map['alignvue_id'] = ddAlignmentNodeItem.id.toString();

      var status = await _myConnectionController.sendMessage(map);
      if (status.isSuccess == true) {
        showCustomSnackBar(status.message, isError: false);
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pop(Get.context!, true);
        });
      } else {
        showCustomSnackBar(status.message);
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
