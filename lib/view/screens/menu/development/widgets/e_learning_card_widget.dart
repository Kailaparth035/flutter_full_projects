import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/data/model/response/development/courses_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_for_course_description.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_for_course_description_for_enterprise.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/course_details_screen.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ELearningCardWidget extends StatefulWidget {
  const ELearningCardWidget(
      {super.key,
      required this.course,
      required this.userId,
      required this.onReload,
      required this.isEnterPrise});
  final Course course;
  final String userId;
  final Function onReload;
  final bool isEnterPrise;

  @override
  State<ELearningCardWidget> createState() => _ELearningCardWidgetState();
}

class _ELearningCardWidgetState extends State<ELearningCardWidget> {
  @override
  Widget build(BuildContext context) {
    return buildElearningListTile(widget.course);
  }

  buildElearningListTile(Course data) {
    return Container(
      margin: EdgeInsets.only(bottom: 9.sp),
      width: Get.context!.getWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.secondaryColor,
        ),
        borderRadius: BorderRadius.circular(7.sp),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 5.sp),
            child: CustomText(
              text: data.course.toString(),
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5.sp),
              topLeft: Radius.circular(5.sp),
            ),
            child: CustomImage(
              height: 140.sp,
              width: double.infinity,
              image: widget.course.photo.toString(),
            ),
          ),
          InkWell(
            onTap: () {
              if (widget.isEnterPrise) {
                showDialog(
                  context: Get.context!,
                  builder: (BuildContext context) {
                    return CustomAlertForCourseDescriptionForEnterPrise(
                      course: widget.course,
                    );
                  },
                );
              } else {
                showDialog(
                  context: Get.context!,
                  builder: (BuildContext context) {
                    return CustomAlertForCourseDescription(
                      title: widget.course.course.toString(),
                      description: widget.course.description.toString(),
                    );
                  },
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 5.sp),
              child: CustomText(
                text: "Course Description",
                textAlign: TextAlign.start,
                color: AppColors.labelColor15,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          widget.isEnterPrise
              ? _buildConditionForEnterprise(widget.course)
              : _buildConditions(widget.course),
          Column(
            children: [
              data.isShowPrice == 1
                  ? _buildPriseView(
                      "Price : ",
                      widget.course.price.toString() != ""
                          ? widget.course.price.toString()
                          : "")
                  : 0.sbh,
              data.isShowPresenter == 1
                  ? _buildPriseView(
                      "Presenter : ", widget.course.presenter.toString())
                  : 0.sbh,
            ],
          ),
          _buildBottomButton()
        ],
      ),
    );
  }

  GestureDetector _buildBottomButton() {
    return GestureDetector(
      onTap: () async {
        if (widget.course.isAddToCartShow == 1) {
          _addToCart(widget.course.courseId.toString());
        } else {
          // if (widget.course.status != "Completed" &&
          //     _getScoreValue(widget.course.score.toString()) < 75) {
          bool? result = await Get.to(() => CourseDetailsScreen(
                isEnterPriseCourse: widget.isEnterPrise,
                courseType: widget.isEnterPrise
                    ? widget.course.isGlobalCourse.toString() == "0"
                        ? "0"
                        : "1"
                    : null,
                id: widget.course.courseId.toString(),
                userId: widget.userId.toString(),
              ));

          if (result != null && result == true) {
            widget.onReload();
          }
          // }
        }
      },
      child: Container(
        padding: EdgeInsets.all(7.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: CommonController.getLinearGradientSecondryAndPrimary(),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(6.sp),
            bottomRight: Radius.circular(6.sp),
          ),
        ),
        child: widget.course.isAddToCartShow == 1
            ? Center(
                child: CustomText(
                  text: widget.course.launchBtn.toString(),
                  textAlign: TextAlign.start,
                  color: AppColors.white,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: widget.course.launchBtn.toString(),
                    textAlign: TextAlign.start,
                    color: AppColors.white,
                    fontFamily: AppString.manropeFontFamily,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  Transform.translate(
                    offset: Offset(2.sp, 0.7.sp),
                    child: Image.asset(
                      AppImages.arrowNextWhiteIc,
                      height: 7.5.sp,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPriseView(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildDivider(),
        5.sp.sbh,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7.sp),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.secondaryColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
                TextSpan(
                  text: subTitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppString.manropeFontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
        5.sp.sbh,
      ],
    );
  }

  _buildConditions(Course course) {
    if (course.status != "" &&
        course.score.toString() != "" &&
        course.score != null) {
      return Column(
        children: [
          buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                _buildRowListTile(
                    "Type", course.type.toString(), Alignment.centerLeft),
                _buildRowListTile("Status", "Completed", Alignment.center),
                _buildRowListTile(
                    "Score", course.score.toString(), Alignment.centerRight)
              ],
            ),
          ),
          5.sp.sbh,
        ],
      );
    } else if (course.status == "" &&
        (course.score.toString() != "" && course.score != "0")) {
      return Column(
        children: [
          buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                _buildRowListTile(
                    "Type", course.type.toString(), Alignment.centerLeft),
                _buildRowListTile(
                    "Score", course.score.toString(), Alignment.centerRight)
              ],
            ),
          ),
          5.sp.sbh,
        ],
      );
    } else if ((course.score.toString() == "" && course.score != "0") &&
        course.status != "") {
      return Column(
        children: [
          buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                _buildRowListTile(
                    "Type", course.type.toString(), Alignment.centerLeft),
                _buildRowListTile("Status", "Completed", Alignment.centerRight),
              ],
            ),
          ),
          5.sp.sbh,
        ],
      );
    } else {
      return Column(
        children: [
          buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                _buildRowListTile(
                    "Type", course.type.toString(), Alignment.center),
              ],
            ),
          ),
          5.sp.sbh,
        ],
      );
    }
  }

  _buildConditionForEnterprise(Course course) {
    if (course.status != "" &&
        course.score.toString() != "" &&
        course.score != null) {
      return Column(
        children: [
          buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                _buildRowListTile("Status", "Completed", Alignment.centerLeft),
                _buildRowListTile("Score", "${course.score.toString()}%",
                    Alignment.centerRight)
              ],
            ),
          ),
          5.sp.sbh,
        ],
      );
    } else if (course.status == "" &&
        (course.score.toString() != "" && course.score != "0")) {
      return Column(
        children: [
          buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                _buildRowListTile(
                    "Score", "${course.score.toString()}%", Alignment.center)
              ],
            ),
          ),
          5.sp.sbh,
        ],
      );
    } else if ((course.score.toString() == "" && course.score != "0") &&
        course.status != "") {
      return Column(
        children: [
          buildDivider(),
          5.sp.sbh,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: Row(
              children: [
                _buildRowListTile("Status", "Completed", Alignment.center),
              ],
            ),
          ),
          5.sp.sbh,
        ],
      );
    } else {
      return 0.sp.sbh;
    }
  }

  Expanded _buildRowListTile(String title, String value, Alignment alignment) {
    return Expanded(
        child: Align(
      alignment: alignment,
      child: Column(
        children: [
          CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.secondaryColor,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
          CustomText(
            text: value,
            textAlign: TextAlign.start,
            color: AppColors.labelColor14,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 9.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    ));
  }

  // int _getScoreValue(String value) {
  //   String removedValue = value.replaceAll("%", "");
  //   try {
  //     return int.parse(removedValue);
  //   } catch (r) {
  //     return 0;
  //   }
  // }

  _addToCart(String courseId) async {
    Map<String, dynamic> map = {
      "course_id": courseId,
    };

    bool? result =
        await Get.find<EnterpriseController>().addToCartCourse(map: map);

    if (result != null && result == true) {
      widget.onReload();
    }
  }
}
