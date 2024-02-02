import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/response/feeling_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/feeling_shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class FeelingListAlertDialog extends StatefulWidget {
  const FeelingListAlertDialog({
    super.key,
    required this.positiveList,
    required this.negativeList,
  });

  final List<FeelingListDataValue> positiveList;
  final List<FeelingListDataValue> negativeList;

  @override
  State<FeelingListAlertDialog> createState() => FeelingListAlertDialogState();
}

class FeelingListAlertDialogState extends State<FeelingListAlertDialog> {
  final _insightStreamController = Get.find<InsightStreamController>();
  bool _isLoading = false;

  List<FeelingListDataValue> _positiveList = [];
  List<FeelingListDataValue> _negativeList = [];
  String msgNote = "";

  bool _isItemSelected = false;

  @override
  void initState() {
    super.initState();
    _loadApi();
  }

  _loadApi() async {
    setState(() {
      _isLoading = true;
    });
    try {
      FeelingListData data = await _insightStreamController.getFeelingList();

      if (mounted) {
        setState(() {
          msgNote = data.noteMsg.toString();
          if (data.negative != null) {
            _negativeList = data.negative!;
          }
          if (data.positive != null) {
            _positiveList = data.positive!;
          }

          if (widget.positiveList.isNotEmpty) {
            for (var item in widget.positiveList) {
              var posList = _positiveList
                  .where((element) => element.id == item.id)
                  .toList();
              if (posList.isNotEmpty) {
                _isItemSelected = true;
                var index = _positiveList.indexOf(posList.first);
                _positiveList[index].isChecked = true;
              }
            }
          }
          if (widget.negativeList.isNotEmpty) {
            for (var item in widget.negativeList) {
              var negList = _negativeList
                  .where((element) => element.id == item.id)
                  .toList();
              if (negList.isNotEmpty) {
                _isItemSelected = true;
                var index = _negativeList.indexOf(negList.first);
                _negativeList[index].isChecked = true;
              }
            }
          }
        });
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (mounted) {
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
      contentPadding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 0.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              10.sp.sbh,
              _buildTitle(),
              10.sp.sbh,
              const Divider(
                height: 1,
                color: AppColors.labelColor,
                thickness: 1,
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 50.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTitleWithBG("Positive"),
                      _isLoading
                          ? const FeelingShimmerWidget()
                          : _buildPositiveView(),
                      _buildTitleWithBG("Negative"),
                      _isLoading
                          ? const FeelingShimmerWidget()
                          : _buildNegativeView(),
                      10.sp.sbh,
                    ],
                  ),
                ),
              ),
              10.sp.sbh,
              msgNote != ""
                  ? Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: CustomText(
                        text: "Note: $msgNote",
                        fontStyle: FontStyle.italic,
                        textAlign: TextAlign.start,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 8.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : 0.sp.sbh,
              _buildButton(context),
              10.sp.sbh
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPositiveView() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: AlignedGridView.count(
        crossAxisSpacing: 5.sp,
        mainAxisSpacing: 2.sp,
        crossAxisCount: 2,
        shrinkWrap: true,
        primary: false,
        itemCount: _positiveList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              _positiveList[index].isChecked =
                  _positiveList[index].isChecked == true ? false : true;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomCheckBox(
                onTap: () {
                  setState(() {
                    _positiveList[index].isChecked =
                        _positiveList[index].isChecked == true ? false : true;
                  });
                },
                borderColor: AppColors.labelColor8,
                fillColor: AppColors.labelColor8,
                isChecked: _positiveList[index].isChecked ?? false,
              ),
              5.sp.sbw,
              Expanded(
                flex: 1,
                child: CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: AppColors.labelColor5,
                  text: _positiveList[index].name.toString(),
                  maxLine: 5,
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNegativeView() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: AlignedGridView.count(
        crossAxisSpacing: 5.sp,
        mainAxisSpacing: 2.sp,
        crossAxisCount: 2,
        shrinkWrap: true,
        primary: false,
        itemCount: _negativeList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              _negativeList[index].isChecked =
                  _negativeList[index].isChecked == true ? false : true;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomCheckBox(
                onTap: () {
                  setState(() {
                    _negativeList[index].isChecked =
                        _negativeList[index].isChecked == true ? false : true;
                  });
                },
                borderColor: AppColors.labelColor8,
                fillColor: AppColors.labelColor8,
                isChecked: _negativeList[index].isChecked ?? false,
              ),
              5.sp.sbw,
              Expanded(
                flex: 1,
                child: CustomText(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  color: AppColors.labelColor5,
                  text: _negativeList[index].name.toString(),
                  maxLine: 5,
                  textAlign: TextAlign.start,
                  fontFamily: AppString.manropeFontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTitleWithBG(String title) {
    return Padding(
      padding: EdgeInsets.all(10.sp),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.sp,
          vertical: 5.sp,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.sp),
          color: AppColors.backgroundColor1,
        ),
        child: CustomText(
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
          color: AppColors.labelColor14,
          text: title,
          textAlign: TextAlign.start,
          fontFamily: AppString.manropeFontFamily,
        ),
      ),
    );
  }

  Padding _buildButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton2(
              buttonText: AppString.close,
              buttonColor: AppColors.primaryColor,
              radius: 5.sp,
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              onPressed: () {
                Navigator.pop(context);
              }),
          5.sp.sbw,
          CustomButton2(
              buttonText: AppString.done,
              radius: 5.sp,
              isDisable: _isItemSelected == false &&
                  (_positiveList
                          .where((element) => element.isChecked == true)
                          .toList()
                          .isEmpty &&
                      _negativeList
                          .where((element) => element.isChecked == true)
                          .toList()
                          .isEmpty),
              padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 13.sp),
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
              onPressed: () {
                _sendMessage();
              })
        ],
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
            text: AppString.rightnowIm,
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
    var data = {
      "positive":
          _positiveList.where((element) => element.isChecked == true).toList(),
      "nagative":
          _negativeList.where((element) => element.isChecked == true).toList(),
    };
    Navigator.pop(context, data);
  }
}
