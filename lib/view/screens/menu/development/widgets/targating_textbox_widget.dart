import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/slider_data_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TargatingTextboxWidget extends StatefulWidget {
  const TargatingTextboxWidget({
    super.key,
    required this.data,
    required this.userId,
    required this.isReset,
  });
  final SliderData data;
  final String userId;
  final bool isReset;

  @override
  State<TargatingTextboxWidget> createState() => _TargatingTextboxWidgetState();
}

class _TargatingTextboxWidgetState extends State<TargatingTextboxWidget> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController(text: widget.data.subObjIWill);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    if (widget.isReset == true) {
      setState(() {
        _textController = TextEditingController(text: widget.data.subObjIWill);
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return getTitleDartWithTextBox();
  }

  Widget getTitleDartWithTextBox() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.sp),
      decoration: BoxDecoration(
          boxShadow: CommonController.getBoxShadow,
          borderRadius: BorderRadius.circular(5.sp),
          border: Border.all(color: AppColors.labelColor),
          color: AppColors.white),
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.sp),
                topRight: Radius.circular(4.sp),
              ),
              color: AppColors.labelColor15.withOpacity(0.85),
            ),
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
            child: CustomText(
              text: widget.data.areaName.toString(),
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              maxLine: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: CustomTextFormFieldForMessage(
              radius: 3.sp,
              maxLine: 3,
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "I am the type of person who.",
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              editColor: Colors.transparent,
              textEditingController: _textController,
              onChanged: (val) {},
              onTapSufixIcon: () {},
              onEditingComplete: () {
                _callAPI(Get.find<DevelopmentController>(), widget.data);
              },
            ),
          ),
        ],
      ),
    );
  }

  _callAPI(DevelopmentController controller, SliderData data) async {
    var res = await controller.updateSelfReflaction(
        styleId: widget.data.styleId.toString(),
        areaId: data.areaId.toString(),
        isMarked: data.isMarked ?? "",
        markingType: data.markingType ?? "",
        stylrParentId: data.stylrParentId.toString(),
        radioType: data.radioType ?? "",
        newScore: data.selfIdealScale.toString(),
        onReaload: (val) async {},
        ratingType: widget.data.ratingType.toString(),
        userId: widget.userId.toString(),
        type: "",
        subObjIWill: _textController.text);

    if (res == null) {
      _textController.text = widget.data.subObjIWill.toString();
    }
  }
}
