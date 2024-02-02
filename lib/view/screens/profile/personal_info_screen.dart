import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_dropdown_list_two.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';

import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_text_box_for_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _maincontroller = Get.find<MainController>();
  final _profileDataController = Get.find<ProfileSharedPrefService>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _backupEmailController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();

  final TextEditingController _streetAddressController =
      TextEditingController();

  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  List<DropDownOptionItemMenu> genderList = [
    DropDownOptionItemMenu(id: "1", title: "Male – He / Him / His"),
    DropDownOptionItemMenu(id: "2", title: "Female – She / Her"),
    DropDownOptionItemMenu(id: "3", title: "Non-binary - They / Their"),
  ];

  DropDownOptionItemMenu genderValue =
      DropDownOptionItemMenu(id: null, title: AppString.selectGender);

  List<DropDownOptionItemMenu> salutationList = [
    DropDownOptionItemMenu(id: "Dr.", title: "Dr."),
    DropDownOptionItemMenu(id: "Miss", title: "Miss"),
    DropDownOptionItemMenu(id: "Mr.", title: "Mr."),
    DropDownOptionItemMenu(id: "Mrs.", title: "Mrs."),
    DropDownOptionItemMenu(id: "Ms.", title: "Ms."),
    DropDownOptionItemMenu(id: "Mx.", title: "Mx."),
    DropDownOptionItemMenu(id: "Prof.", title: "Prof."),
  ];

  DropDownOptionItemMenu salutationValue =
      DropDownOptionItemMenu(id: null, title: AppString.selectSalutation);

  List<DropDownOptionItemMenu> countryList = [];
  DropDownOptionItemMenu countryValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  List<DropDownOptionItemMenu> stateList = [];
  DropDownOptionItemMenu stateValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  List<DropDownOptionItemMenu> timeZoneList = [];
  DropDownOptionItemMenu timeZoneValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  // for role id 10

  final TextEditingController _meetingLinkController = TextEditingController();
  final TextEditingController _yearOfExprController = TextEditingController();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _spacialitiesController = TextEditingController();

  bool _isLoadStateTime = false;

  bool _isLoading = false;
  String _roleId = "";

  @override
  void initState() {
    _loadData();
    _loadDataForEdit();
    super.initState();
  }

  _loadData() {
    for (var element in _maincontroller.countryList) {
      countryList.add(
        DropDownOptionItemMenu(
          id: element.id.toString(),
          title: element.countryName.toString(),
          sortName: element.sortname.toString(),
        ),
      );
    }

    setState(() {});
  }

  _loadDataForEdit() {
    var profileData = _profileDataController.profileData;
    _firstNameController.text = profileData.value.firstName.toString();
    _lastNameController.text = profileData.value.lastName.toString();
    _emailController.text = profileData.value.email.toString();
    _backupEmailController.text = profileData.value.backupEmail.toString();
    _dobController.text = profileData.value.dob.toString();
    _mobilePhoneController.text = profileData.value.mobileNumber.toString();
    _streetAddressController.text = profileData.value.address.toString();
    _cityController.text = profileData.value.city.toString();
    _zipCodeController.text = profileData.value.zipCode.toString();

    _meetingLinkController.text = profileData.value.meetingLink.toString();
    _yearOfExprController.text = profileData.value.experience.toString();
    _minPriceController.text = profileData.value.minPrice.toString();
    _maxPriceController.text = profileData.value.maxPrice.toString();
    _bioController.text = profileData.value.bio.toString();
    _spacialitiesController.text = profileData.value.specialties.toString();
    _roleId = profileData.value.roleId.toString();

    if (profileData.value.genderName.toString() != "null" &&
        profileData.value.genderName.toString() != "") {
      genderValue = DropDownOptionItemMenu(
          id: profileData.value.genderId.toString(),
          title: profileData.value.genderName.toString());
    }

    if (profileData.value.title.toString() != "null" &&
        profileData.value.title.toString() != "") {
      salutationValue = DropDownOptionItemMenu(
          id: profileData.value.title.toString(),
          title: profileData.value.title.toString());
    }

    if (profileData.value.countryName.toString() != "null" &&
        profileData.value.countryName.toString() != "") {
      countryValue = DropDownOptionItemMenu(
        id: profileData.value.countryId.toString(),
        title: profileData.value.countryName.toString(),
        sortName: profileData.value.sortname.toString(),
      );
    }

    if (profileData.value.stateName.toString() != "null" &&
        profileData.value.stateName.toString() != "") {
      stateValue = DropDownOptionItemMenu(
          id: profileData.value.stateId.toString(),
          title: profileData.value.stateName.toString());
    }

    if (profileData.value.zoneName.toString() != "null" &&
        profileData.value.zoneName.toString() != "") {
      timeZoneValue = DropDownOptionItemMenu(
          id: profileData.value.zoneId.toString(),
          title: profileData.value.zoneName.toString());
    }

    setState(() {});
    if (countryValue.sortName != null) {
      _getStateAndTimeZone(true);
    }
  }

  _getStateAndTimeZone(bool isPreloading) async {
    if (isPreloading == false) {
      timeZoneValue = DropDownOptionItemMenu(id: null, title: AppString.select);
      stateValue = DropDownOptionItemMenu(id: null, title: AppString.select);
    }

    stateList = [];
    timeZoneList = [];

    setState(() {
      _isLoadStateTime = true;
    });
    try {
      var data = await _maincontroller
          .getStateTimeZoneList(countryValue.sortName.toString());

      for (var element in data.states!) {
        stateList.add(
          DropDownOptionItemMenu(
            id: element.id.toString(),
            title: element.stateName.toString(),
          ),
        );
      }
      for (var element in data.timeZone!) {
        timeZoneList.add(
          DropDownOptionItemMenu(
            id: element.zoneId.toString(),
            title: element.zoneName.toString(),
          ),
        );
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoadStateTime = false;
      });
    }
  }

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
        _dobController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: AppString.myProfile,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: CustomSlideUpAndFadeWidget(child: _buildMainView()),
      ),
    );
  }

  SingleChildScrollView _buildMainView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainTitle(),
            10.sp.sbh,
            _buildTextboxTitle("${AppString.firstName}*"),
            5.sp.sbh,
            CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "${AppString.enterFirstName}* ",
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 1,
              editColor: AppColors.labelColor12,
              textEditingController: _firstNameController,
            ),
            10.sp.sbh,
            _buildTextboxTitle("${AppString.lastName}*"),
            5.sp.sbh,
            CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "${AppString.enterLastName}* ",
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 1,
              editColor: AppColors.labelColor12,
              textEditingController: _lastNameController,
            ),
            10.sp.sbh,
            _buildTextboxTitle("${AppString.email}*"),
            5.sp.sbh,
            CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: "${AppString.enterEmail}* ",
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              isReadOnly: true,
              lineCount: 1,
              editColor: AppColors.labelColor12,
              textEditingController: _emailController,
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.backupemail),
            5.sp.sbh,
            CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: AppString.enterBackupemail,
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 1,
              editColor: AppColors.labelColor12,
              textEditingController: _backupEmailController,
            ),
            10.sp.sbh,
            _buildDobAndNumber(),
            10.sp.sbh,
            _buildTextboxTitle("Salutation*"),
            5.sp.sbh,
            CustomDropListForMessageTwo(
              salutationValue.title,
              salutationValue,
              salutationList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (dropDownOptionItemMenu1) {
                setState(() {
                  salutationValue = dropDownOptionItemMenu1;
                });
              },
            ),
            10.sp.sbh,
            _buildTextboxTitle("${AppString.gender}*"),
            5.sp.sbh,
            CustomDropListForMessageTwo(
              genderValue.title,
              genderValue,
              genderList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (dropDownOptionItemMenu1) {
                genderValue = dropDownOptionItemMenu1;
                setState(() {});
              },
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.streetAddress),
            5.sp.sbh,
            CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: AppString.enterStreetAddress,
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 3,
              editColor: AppColors.labelColor12,
              textEditingController: _streetAddressController,
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.country),
            5.sp.sbh,
            CustomDropListForMessageTwo(
              countryValue.title,
              countryValue,
              countryList,
              fontSize: 12.sp,
              borderColor: AppColors.labelColor,
              bgColor: AppColors.labelColor12,
              (dropDownOptionItemMenu1) {
                countryValue = dropDownOptionItemMenu1;
                setState(() {});
                _getStateAndTimeZone(false);
              },
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.state),
            5.sp.sbh,
            _isLoadStateTime
                ? Center(
                    child: SizedBox(
                      child: CustomLoadingWidget(
                        height: 50.sp,
                      ),
                    ),
                  )
                : CustomDropListForMessageTwo(
                    stateValue.title,
                    stateValue,
                    stateList,
                    fontSize: 12.sp,
                    borderColor: AppColors.labelColor,
                    bgColor: AppColors.labelColor12,
                    (dropDownOptionItemMenu1) {
                      stateValue = dropDownOptionItemMenu1;
                      setState(() {});
                    },
                  ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.city),
            5.sp.sbh,
            CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: AppString.enterCity,
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 1,
              editColor: AppColors.labelColor12,
              textEditingController: _cityController,
            ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.timeZone1),
            5.sp.sbh,
            _isLoadStateTime
                ? Center(
                    child: SizedBox(
                    child: CustomLoadingWidget(
                      height: 50.sp,
                    ),
                  ))
                : CustomDropListForMessageTwo(
                    timeZoneValue.title,
                    timeZoneValue,
                    timeZoneList,
                    fontSize: 12.sp,
                    borderColor: AppColors.labelColor,
                    bgColor: AppColors.labelColor12,
                    (dropDownOptionItemMenu1) {
                      timeZoneValue = dropDownOptionItemMenu1;
                      setState(() {});
                    },
                  ),
            10.sp.sbh,
            _buildTextboxTitle(AppString.zipCode),
            5.sp.sbh,
            CustomTextFormFieldForMessage(
              borderColor: AppColors.labelColor,
              inputAction: TextInputAction.done,
              labelText: AppString.enterZipCode,
              inputType: TextInputType.text,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 12.sp,
              lineCount: 1,
              editColor: AppColors.labelColor12,
              textEditingController: _zipCodeController,
            ),
            _roleId == "10" ? _buildRole10View() : 0.sbh,
            20.sp.sbh,
            Center(
              child: _isLoading
                  ? SizedBox(
                      child: CustomLoadingWidget(
                        height: 50.sp,
                      ),
                    )
                  : CustomButton2(
                      buttonText: AppString.saveChanges,
                      radius: 5.sp,
                      padding: EdgeInsets.symmetric(
                          vertical: 5.sp,
                          horizontal: AppConstants.screenHorizontalPadding),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp,
                      onPressed: () {
                        _updateData();
                      }),
            ),
            20.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildRole10View() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.sp.sbh,
        _buildTextboxTitle(AppString.meetingLink),
        5.sp.sbh,
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor,
          inputAction: TextInputAction.done,
          labelText: AppString.meetingLinklable,
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 1,
          editColor: AppColors.labelColor12,
          textEditingController: _meetingLinkController,
        ),
        10.sp.sbh,
        _buildTextboxTitle(AppString.yearsOfExperience),
        5.sp.sbh,
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor,
          inputAction: TextInputAction.done,
          labelText: AppString.yearsOfExperiencelable,
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 1,
          editColor: AppColors.labelColor12,
          textEditingController: _yearOfExprController,
        ),
        10.sp.sbh,
        _buildTextboxTitle(AppString.minPrice),
        5.sp.sbh,
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor,
          inputAction: TextInputAction.done,
          labelText: AppString.minPrice,
          isReadOnly: true,
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 1,
          editColor: AppColors.labelColor,
          textEditingController: _minPriceController,
        ),
        10.sp.sbh,
        _buildTextboxTitle(AppString.maxPrice),
        5.sp.sbh,
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor,
          inputAction: TextInputAction.done,
          labelText: AppString.maxPrice,
          isReadOnly: true,
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 1,
          editColor: AppColors.labelColor,
          textEditingController: _maxPriceController,
        ),
        10.sp.sbh,
        _buildTextboxTitle(AppString.bio),
        5.sp.sbh,
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor,
          inputAction: TextInputAction.done,
          labelText: AppString.biolable,
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 4,
          editColor: AppColors.labelColor12,
          textEditingController: _bioController,
        ),
        10.sp.sbh,
        _buildTextboxTitle(AppString.specialities),
        5.sp.sbh,
        CustomTextFormFieldForMessage(
          borderColor: AppColors.labelColor,
          inputAction: TextInputAction.done,
          labelText: AppString.specialitieslable,
          inputType: TextInputType.text,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 12.sp,
          lineCount: 4,
          editColor: AppColors.labelColor12,
          textEditingController: _spacialitiesController,
        ),
      ],
    );
  }

  Row _buildDobAndNumber() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextboxTitle("${AppString.dateOfBirth}*"),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                onTap: () {
                  _selectDate(context);
                },
                borderColor: AppColors.labelColor,
                isReadOnly: true,
                inputAction: TextInputAction.done,
                labelText: "${AppString.enterDOB}*",
                inputType: TextInputType.text,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 1,
                editColor: AppColors.labelColor12,
                textEditingController: _dobController,
              ),
            ],
          ),
        ),
        10.sp.sbw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextboxTitle(AppString.mobilePhone),
              5.sp.sbh,
              CustomTextFormFieldForMessage(
                borderColor: AppColors.labelColor,
                inputAction: TextInputAction.done,
                labelText: AppString.enterMobilePhone,
                inputType: TextInputType.phone,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 12.sp,
                lineCount: 1,
                editColor: AppColors.labelColor12,
                textEditingController: _mobilePhoneController,
              ),
            ],
          ),
        )
      ],
    );
  }

  CustomText _buildTextboxTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
    );
  }

  CustomText _buildMainTitle() {
    return CustomText(
      text: AppString.personalInfo1,
      textAlign: TextAlign.start,
      color: AppColors.labelColor6,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
    );
  }

  _updateData() async {
    if (_firstNameController.text.toString().trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterFirstName);
      return;
    }
    if (_lastNameController.text.toString().trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterLastName);
      return;
    }
    if (_emailController.text.toString().trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseEnterEmail);
      return;
    }
    if (_dobController.text.toString().trim().isEmpty) {
      showCustomSnackBar(AppString.pleaseSelectDateOfBirth);
      return;
    }
    if (genderValue.id == null) {
      showCustomSnackBar(AppString.pleaseSelectGender);
      return;
    }

    Map<String, String> requestPrm = {
      "first_name": _firstNameController.text.toString(),
      "last_name": _lastNameController.text.toString(),
      "email": _emailController.text.toString(),
      "backup_email": _backupEmailController.text.toString(),
      "gender": genderValue.id == null ? "" : genderValue.id.toString(),
      "title": salutationValue.id == null ? "" : salutationValue.id.toString(),
      "dob": _dobController.text,
      "phone": _mobilePhoneController.text,
      "address": _streetAddressController.text,
      "country":
          countryValue.sortName == null ? "" : countryValue.sortName.toString(),
      "state": stateValue.id == null ? "" : stateValue.id.toString(),
      "city": _cityController.text,
      "time_zone": timeZoneValue.id == null ? "" : timeZoneValue.id.toString(),
      "zip_code": _zipCodeController.text.toString() == "null"
          ? ""
          : _zipCodeController.text.toString(),
    };

    if (_roleId.toString() == "10") {
      requestPrm['meeting_link'] = _meetingLinkController.text;
      requestPrm['experience'] = _yearOfExprController.text;
      requestPrm['bio'] = _bioController.text;
      requestPrm['specialties'] = _spacialitiesController.text;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      var response =
          await _profileDataController.updatePersonalInfo(requestPrm);
      if (response.isSuccess == true) {
        await _profileDataController.getMyProfile({});
        showCustomSnackBar(response.message, isError: false);
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
