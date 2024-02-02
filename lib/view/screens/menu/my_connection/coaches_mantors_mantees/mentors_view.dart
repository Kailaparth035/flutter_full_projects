import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/my_mentors_controller.dart';
import 'package:aspirevue/data/model/response/my_mentors_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/dimension.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_message.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/profile/user_profile_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/coaches_mantors_mantees/my_coach_details_screen.dart';
import 'package:aspirevue/view/screens/others/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MentorsView extends StatefulWidget {
  const MentorsView({super.key});

  @override
  State<MentorsView> createState() => _MentorsViewState();
}

class _MentorsViewState extends State<MentorsView> {
  final List _listOfBox = [
    {"image": AppImages.userIc, "text": AppString.sessions},
    {"image": AppImages.penIc, "text": AppString.agreement},
    {"image": AppImages.videoIc, "text": AppString.connect},
    {"image": AppImages.calendarIc, "text": AppString.schedule},
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyMentorsController>(builder: (controller) {
      if (controller.isLoading) {
        return Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
          child: const Center(
            child: CustomLoadingWidget(),
          ),
        );
      }

      if (controller.isError) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: CustomErrorWidget(
              text: controller.errorMsg,
              onRetry: () {
                controller.getMyMentorsList({});
              },
            ),
          ),
        );
      }

      if (controller.dataList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: const CustomNoDataFoundWidget(),
          ),
        );
      }

      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: controller.dataList.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildListTile(controller.dataList[index]);
        },
      );
    });
  }

  Column _buildListTile(MyMentorsData myMentorsData) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall + 1),
            border: Border.all(
              color: AppColors.secondaryColor,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              _buildUserTile(myMentorsData),
              _buildBoxesRow(myMentorsData),
            ],
          ),
        ),
        10.sp.sbh,
      ],
    );
  }

  Widget _buildUserTile(MyMentorsData coachData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: CustomImageForProfile(
                image: coachData.photo.toString(),
                radius: 20.sp,
                nameInitials: coachData.nameInitials.toString(),
                borderColor: AppColors.labelColor8.withOpacity(0.6)),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: coachData.name.toString(),
                    textAlign: TextAlign.start,
                    color: AppColors.labelColor8,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: coachData.email.toString(),
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
                      Get.to(() => UserProfileScreen(
                            userId: coachData.id.toString(),
                          ));
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.white,
                      backgroundImage: const AssetImage(AppImages.accountIcon),
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
                            userId: coachData.id.toString(),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: AppColors.white,
                      backgroundImage: const AssetImage(AppImages.mailIc),
                      radius: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListTileForBox(int index, MyMentorsData data) {
    if (_listOfBox[index]['text'] == "Agreement" && data.agreement == "") {
      return const SizedBox();
    }
    if (_listOfBox[index]['text'] == "Connect" && data.connect == "") {
      return const SizedBox();
    }
    if (_listOfBox[index]['text'] == "Schedule" && data.schedule == "") {
      return const SizedBox();
    }
    return InkWell(
      onTap: () {
        if (_listOfBox[index]['text'] == "Sessions") {
          // navigate to details screen

          Get.to(
            () => MyCoachDetailsScreen(
              title: "Mentor Detail -  ${data.name.toString()}",
              currentIndex: 0,
              id: data.id.toString(),
              type: "2",
            ),
          );
        }
        if (_listOfBox[index]['text'] == "Agreement") {
          // navigate to url
          if (data.agreement != "") {
            Get.to(WebViewScreen(
              url: data.agreement.toString(),
            ));
            // CommonController.urlLaunch(data.agreement.toString());
          } else {
            showCustomSnackBar(AppString.agreementurlnotfound);
          }
        }
        if (_listOfBox[index]['text'] == "Connect") {
          // navigate to url
          if (data.connect != "") {
            CommonController.urlLaunch(data.connect.toString());
          } else {
            showCustomSnackBar(AppString.connecturlnotfound);
          }
        }
        if (_listOfBox[index]['text'] == "Schedule") {
          // navigate to url

          if (data.schedule != "") {
            CommonController.urlLaunch(data.schedule.toString());
          } else {
            showCustomSnackBar(AppString.scheduleurlnotfound);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: (index % 2 == 0) ? AppColors.labelColor43 : AppColors.white,
        ),
        child: Container(
          padding: EdgeInsets.all(5.sp),
          child: Column(
            children: [
              index == 1 ? 7.sp.sbh : 10.sp.sbh,
              Image.asset(
                _listOfBox[index]['image'],
                height: index == 1 ? 18.sp : 15.sp,
                width: index == 1 ? 18.sp : 15.sp,
                fit: BoxFit.fill,
              ),
              3.sp.sbh,
              CustomText(
                text: _listOfBox[index]['text'],
                textAlign: TextAlign.center,
                color: AppColors.secondaryColor,
                maxLine: 2,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              10.sp.sbh,
            ],
          ),
        ),
      ),
    );
  }

  Container _buildBoxesRow(MyMentorsData data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            Dimensions.radiusSmall,
          ),
          bottomRight: Radius.circular(
            Dimensions.radiusSmall,
          ),
        ),
        border: Border.all(
          color: AppColors.labelColor44,
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Dimensions.radiusSmall),
          bottomRight: Radius.circular(Dimensions.radiusSmall),
        ),
        child: AlignedGridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          mainAxisSpacing: 0.sp,
          crossAxisSpacing: 0.sp,
          primary: false,
          itemCount: _listOfBox.length - 1,
          itemBuilder: (context, index) => _buildListTileForBox(index, data),
        ),
      ),
    );
  }
}
