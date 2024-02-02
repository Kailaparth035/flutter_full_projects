import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_connection_controller.dart';
import 'package:aspirevue/data/model/response/role_responsibility_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RolesAndResponsibilityAlertDialog extends StatefulWidget {
  const RolesAndResponsibilityAlertDialog({super.key, required this.userId});
  final String userId;
  @override
  State<RolesAndResponsibilityAlertDialog> createState() =>
      _RolesAndResponsibilityAlertDialogState();
}

class _RolesAndResponsibilityAlertDialogState
    extends State<RolesAndResponsibilityAlertDialog> {
  bool _isLoading = false;
  final _myConnectionController = Get.find<MyConnectionController>();
  List<RolesAndResponsibilityData> _roles = [];

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
      _roles = await _myConnectionController
          .getMenteeRoleResponsibility(widget.userId);
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
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
        width: context.getWidth,
        child: SingleChildScrollView(
          child: _isLoading
              ? const Center(
                  child: CustomLoadingWidget(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitle(),
                    15.sp.sbh,
                    _buildHeader(),
                    ..._roles.map((e) => _buildListTile(e)),
                    5.sp.sbh,
                    10.sp.sbh,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildListTile(RolesAndResponsibilityData data) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(5.sp),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.black, width: 0.5),
                  right: BorderSide(color: Colors.black, width: 0.5),
                  bottom: BorderSide(color: Colors.black, width: 0.5),
                ),
              ),
              child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: AppColors.black,
                text: data.reviewTitle.toString(),
                textAlign: TextAlign.start,
                maxLine: 50,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              padding: EdgeInsets.all(5.sp),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 0.5),
                ),
              ),
              child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: AppColors.black,
                text: data.reviewDesc.toString(),
                maxLine: 50,
                textAlign: TextAlign.start,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(5.sp),
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.black, width: 0.5),
                  right: BorderSide(color: Colors.black, width: 0.5),
                  bottom: BorderSide(color: Colors.black, width: 0.5),
                ),
              ),
              child: CustomText(
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                maxLine: 50,
                color: AppColors.black,
                text: data.score.toString(),
                textAlign: TextAlign.start,
                fontFamily: AppString.manropeFontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(5.sp),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              color: AppColors.black,
              text: AppString.title,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            padding: EdgeInsets.all(5.sp),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black, width: 0.5),
                bottom: BorderSide(color: Colors.black, width: 0.5),
              ),
            ),
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              color: AppColors.black,
              text: AppString.description,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(5.sp),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: CustomText(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
              color: AppColors.black,
              text: AppString.score,
              textAlign: TextAlign.start,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ),
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
          text: AppString.roleResponsibilities,
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
}
