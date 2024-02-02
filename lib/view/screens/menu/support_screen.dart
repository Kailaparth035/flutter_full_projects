import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/helper/validation_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _maincontroller = Get.find<MainController>();

  final TextEditingController _msgController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFirstSubmit = true;

  @override
  void initState() {
    // optionValue = optionList.first;
    _loadDropDownDataIfNotGet();
    super.initState();
  }

  _loadDropDownDataIfNotGet() async {
    if (_maincontroller.commonData.value == null) {
      await _maincontroller.getCommonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: "Support",
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: _buildView(),
      ),
    );
  }

  _buildView() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: AppConstants.screenHorizontalPadding),
        child: Form(
          key: _formKey,
          autovalidateMode: !_isFirstSubmit
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.sp.sbh,
              _buildTitle("Topic"),
              5.sp.sbh,
              _buildDropDown(),
              10.sp.sbh,
              _buildTitle("Can you give us more details?"),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                editColor: AppColors.white,
                radius: 3.sp,
                inputAction: TextInputAction.done,
                labelText: "Send Message ...",
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 11.sp,
                lineCount: 5,
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                textEditingController: _msgController,
                validator: Validation().requiredFieldValidation,
                onEditingComplete: () {
                  CommonController.hideKeyboard(context);
                },
              ),
              30.sp.sbh,
              CustomButton2(
                  buttonText: "Send Message",
                  icon: AppImages.sendIc,
                  radius: 3.sp,
                  topIconPadding: 0.2.sp,
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 7.sp, horizontal: 13.sp),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
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
      ),
    );
  }

  _buildDropDown() {
    return Obx(() {
      if (_maincontroller.isLoadingCommonData.value == true) {
        return const Center(
          child: CustomLoadingWidget(),
        );
      } else {
        return CustomDropListForMessageTwo(
          _maincontroller.optionValue.value.title,
          _maincontroller.optionValue.value,
          _maincontroller.optionList,
          fontSize: 12.sp,
          borderColor: AppColors.labelColor,
          bgColor: AppColors.white,
          (selectedValue) {
            _maincontroller.optionValue.value = selectedValue;
          },
        );
      }
    });
  }

  CustomText _buildTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor35,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _sendMessage() async {
    var res = await Get.find<MainController>().saveSupportData(
        id: _maincontroller.optionValue.value.id.toString(),
        message: _msgController.text);
    if (res != null && res == true) {
      setState(() {
        _isFirstSubmit = true;
        _msgController.clear();
        CommonController.hideKeyboard(context);
      });
    }
  }
}
