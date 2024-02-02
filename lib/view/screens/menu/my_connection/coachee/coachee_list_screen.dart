import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/sub_controller/coachee_controller.dart';
import 'package:aspirevue/data/model/response/coachee_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_message.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/text_box/custom_search_text_field.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CoacheeListScreen extends StatefulWidget {
  const CoacheeListScreen({
    super.key,
  });

  @override
  State<CoacheeListScreen> createState() => _CoacheeListScreenState();
}

class _CoacheeListScreenState extends State<CoacheeListScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final _coacheeController = Get.find<CoacheeController>();
  final _scrollcontroller = ScrollController();

  bool _isActive = true;
  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollcontroller.addListener(_loadMore);
  }

  _loadData() {
    _coacheeController.getGrowthCoacheeListWithPagination(
        true, _searchController.text, _isActive ? "0" : "1");
  }

  _changeToggle(bool val) {
    setState(() {
      _isActive = val;
    });
    _loadData();
  }

  void _loadMore() async {
    if (!_coacheeController.isnotMoreData) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_coacheeController.isLoading == false &&
            _coacheeController.isLoadMoreRunning == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _coacheeController.setisLoadMoreRunning = true;

          _coacheeController.setpageNo = _coacheeController.pageNo + 1;
          await _coacheeController.getGrowthCoacheeListWithPagination(
              false, _searchController.text, _isActive ? "0" : "1");

          _coacheeController.setisLoadMoreRunning = false;
        }
      }
    }
  }

  _updataData(String id) async {
    try {
      buildLoading(Get.context!);
      var map = <String, dynamic>{
        "coachee_id": id,
        "type": !_isActive ? "0" : "1",
      };

      var response = await _coacheeController.updateCoacheeActiveArchive(map);
      if (response.isSuccess == true) {
        showCustomSnackBar(response.message, isError: false);
        _loadData();
      } else {
        showCustomSnackBar(response.message);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.myConnections,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        // bottomNavigationBar: const BottomNavBar(
        //   isFromMain: false,
        // ),
        body: _buildMainView(),
      ),
    );
  }

  Widget _buildMainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.sp.sbh,
        _buildTitle(),
        15.sp.sbh,
        _buildTopButton(),
        15.sp.sbh,
        _buildSearchBox(),
        GetBuilder<CoacheeController>(builder: (coacheeController) {
          if (coacheeController.isLoading) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20.h,
                ),
                child: const CustomLoadingWidget(),
              ),
            );
          }

          if (coacheeController.isError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: CustomErrorWidget(
                  text: coacheeController.errorMsg,
                  onRetry: () {
                    coacheeController.getGrowthCoacheeListWithPagination(
                        true, "", _isActive ? "0" : "1");
                  },
                ),
              ),
            );
          }

          if (coacheeController.dataList.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: const CustomNoDataFoundWidget(),
              ),
            );
          }
          return Expanded(
            child: Column(
              children: [
                15.sp.sbh,
                Expanded(
                  child: ListView.builder(
                    controller: _scrollcontroller,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: _coacheeController.dataList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      bool isLast =
                          _coacheeController.dataList.length == index + 1;

                      return _buildListTile(_coacheeController.dataList[index],
                          isLast, _coacheeController.isLoadMoreRunning);
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildListTile(CoacheeData data, bool isLast, bool isShowLoading) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 10.sp,
              horizontal: AppConstants.screenHorizontalPadding),
          child: Row(
            children: [
              CustomImageForProfile(
                  image: data.photo.toString(),
                  radius: 20.sp,
                  nameInitials: data.nameInitials.toString(),
                  borderColor: AppColors.circleGreen),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.name.toString(),
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor8,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        text: data.positions.toString(),
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor15,
                        maxLine: 3,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _updataData(data.id.toString());
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.white,
                          backgroundImage: AssetImage(_isActive
                              ? AppImages.fileCircleIc
                              : AppImages.reloadCircleIc),
                          radius: 10.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.sp,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MessageAlertDialog(
                                userId: data.id.toString(),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.white,
                          backgroundImage:
                              const AssetImage(AppImages.messageCircleIc),
                          radius: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: AppColors.labelColor,
          thickness: 1,
        ),
        isLast
            ? isShowLoading
                ? Column(
                    children: [
                      const Center(
                        child: CustomLoadingWidget(),
                      ),
                      20.sp.sbh,
                    ],
                  )
                : 80.sp.sbh
            : 0.sp.sbh
      ],
    );
  }

  Padding _buildSearchBox() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: SizedBox(
        height: 35.sp,
        child: CustomSearchTextField(
          iconPadding: 11.sp,
          labelText: AppString.search,
          suffixIcon: AppImages.searchBlack,
          fontFamily: AppString.manropeFontFamily,
          textEditingController: _searchController,
          fontSize: 10.sp,
          editColor: AppColors.labelColor,
          onChanged: (val) {
            _coacheeController.getGrowthCoacheeListWithPagination(
                true, val, _isActive ? "0" : "1");
          },
        ),
      ),
    );
  }

  Padding _buildTopButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 35.sp,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  if (!_isActive) _changeToggle(true);
                },
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 5.sp,
                    horizontal: 5.sp,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: CommonController.getBoxShadow,
                    gradient: LinearGradient(colors: [
                      _isActive
                          ? AppColors.secondaryColor
                          : AppColors.secondaryColor.withOpacity(0.6),
                      _isActive
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.6),
                    ]),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.sp),
                      bottomLeft: Radius.circular(5.sp),
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: _isActive
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.6),
                      text: AppString.active,
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  if (_isActive) _changeToggle(false);
                },
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 5.sp,
                    horizontal: 5.sp,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: CommonController.getBoxShadow,
                    gradient: LinearGradient(colors: [
                      !_isActive
                          ? AppColors.primaryColor
                          : AppColors.primaryColor.withOpacity(0.6),
                      !_isActive
                          ? AppColors.secondaryColor
                          : AppColors.secondaryColor.withOpacity(0.6),
                    ]),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.sp),
                      bottomRight: Radius.circular(5.sp),
                    ),
                  ),
                  child: Center(
                    child: CustomText(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: !_isActive
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.6),
                      text: AppString.archive,
                      maxLine: 2,
                      textAlign: TextAlign.center,
                      fontFamily: AppString.manropeFontFamily,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: CustomText(
        fontWeight: FontWeight.w600,
        fontSize: 15.sp,
        color: AppColors.black,
        text: AppString.coachee,
        textAlign: TextAlign.center,
        fontFamily: AppString.manropeFontFamily,
      ),
    );
  }
}
