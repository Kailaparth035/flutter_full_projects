import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_add_colleague.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_heads_up_mail.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_invitation_mail.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_image_for_user_profile.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/profile/my_connection_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

Container buildTitleWithBG(String title) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
    decoration: BoxDecoration(
      color: AppColors.labelColor19,
      boxShadow: CommonController.getBoxShadow,
    ),
    width: double.infinity,
    child: CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 13.sp,
      maxLine: 2,
      fontWeight: FontWeight.w600,
    ),
  );
}

Container buildTitleWithBGCenter(String title) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
    decoration: BoxDecoration(
      color: AppColors.labelColor19,
      boxShadow: CommonController.getBoxShadow,
    ),
    width: double.infinity,
    child: CustomText(
      text: title,
      textAlign: TextAlign.center,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    ),
  );
}

Container buildTitleWithBGAndEnd(
  String title,
  String title2,
) {
  return Container(
    // padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
    color: AppColors.labelColor34,
    width: double.infinity,
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: AppColors.white,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 13.sp,
              maxLine: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 5.sp),
          color: AppColors.labelColor79,
          child: Center(
            child: CustomText(
              text: title2,
              textAlign: TextAlign.start,
              color: AppColors.labelColor14,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 13.sp,
              maxLine: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

Container buildTitleWithBoxAndGradientBG(String title, String boxTitle,
    {Color? color}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.labelColor15),
      color: color,
      gradient: color != null
          ? null
          : CommonController.getLinearGradientSecondryAndPrimary(),
    ),
    padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
    width: double.infinity,
    child: Row(
      children: [
        Expanded(
          child: CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: color == null ? AppColors.white : AppColors.labelColor8,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 4.sp),
          color: AppColors.white,
          child: CustomText(
            text: boxTitle,
            textAlign: TextAlign.start,
            color: AppColors.labelColor8,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    ),
  );
}

Container buildTitleWithTopAndBottomBorder(String title) {
  return Container(
    decoration: const BoxDecoration(
      border: Border(
        top: BorderSide(color: AppColors.labelColor15),
        bottom: BorderSide(color: AppColors.labelColor15),
      ),
    ),
    padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
    width: double.infinity,
    child: CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor14,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
    ),
  );
}

Container buildTitleWithTopAndBottomBorderWithBox(
    String title, String boxTitle, Color color,
    {bool? isFullBorder}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      border: isFullBorder == true
          ? Border.all(color: AppColors.labelColor15)
          : const Border(
              top: BorderSide(color: AppColors.labelColor15),
              bottom: BorderSide(color: AppColors.labelColor15),
            ),
    ),
    padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
    width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CustomText(
            text: title,
            textAlign: TextAlign.start,
            color: AppColors.labelColor8,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        2.sp.sbw,
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.sp, horizontal: 4.sp),
          color: AppColors.white,
          child: CustomText(
            text: boxTitle,
            textAlign: TextAlign.start,
            color: AppColors.labelColor8,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    ),
  );
}

Center buildButtonHowdo({required String title}) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(5.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor8,
        ),
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 3.sp),
            child: SizedBox(
              height: 12.sp,
              width: 12.sp,
              child: Image.asset(AppImages.tagIc),
            ),
          ),
          5.sp.sbw,
          Flexible(
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 11.sp,
              maxLine: 500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

CustomText buildBlackTitle(title) {
  return CustomText(
    text: title,
    textAlign: TextAlign.start,
    color: AppColors.black,
    fontFamily: AppString.manropeFontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
  );
}

Divider buildDivider() {
  return Divider(
    height: 1,
    color: AppColors.labelColor15.withOpacity(0.6),
    thickness: 1,
  );
}

Container buildTitleWithUpperLowerLine(String title,
    {bool isFullBorder = false}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 7.sp),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: AppColors.labelColor15.withOpacity(0.5),
        ),
        bottom: BorderSide(
          color: AppColors.labelColor15.withOpacity(0.5),
        ),
        left: BorderSide(
          color: isFullBorder
              ? AppColors.labelColor15.withOpacity(0.5)
              : Colors.transparent,
        ),
        right: BorderSide(
          color: isFullBorder
              ? AppColors.labelColor15.withOpacity(0.5)
              : Colors.transparent,
        ),
      ),
      color: AppColors.labelColor36,
    ),
    width: double.infinity,
    child: CustomText(
      text: title,
      textAlign: TextAlign.center,
      color: AppColors.labelColor8,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 12.sp,
      maxLine: 2,
      fontWeight: FontWeight.w500,
    ),
  );
}

Container buildBorderWithText(String title) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(5.sp),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.labelColor8),
      borderRadius: BorderRadius.circular(5.sp),
    ),
    child: CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor15,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
    ),
  );
}

Container buildBackGroundWithText(String title) {
  return Container(
    padding: EdgeInsets.all(5.sp),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.labelColor36,
      borderRadius: BorderRadius.circular(5.sp),
    ),
    child: CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.black,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
    ),
  );
}

Container buildBackGroundWithTextWithHighlitedText(
  String title,
  String hightlitedText,
  String title2,
) {
  return Container(
    padding: EdgeInsets.all(5.sp),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.labelColor36,
      borderRadius: BorderRadius.circular(5.sp),
    ),
    child: RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          TextSpan(
            text: hightlitedText,
            style: TextStyle(
              backgroundColor: AppColors.redColor,
              color: AppColors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
          TextSpan(
            text: title2,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              fontFamily: AppString.manropeFontFamily,
            ),
          ),
        ],
      ),
    ),
  );
}

buildTitleWithAns(String title, String subTitle, {TextAlign? align}) {
  return RichText(
    textAlign: align ?? TextAlign.left,
    text: TextSpan(
      children: [
        TextSpan(
          text: title,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w700,
            color: AppColors.labelColor15,
          ),
        ),
        TextSpan(
          text: subTitle,
          style: TextStyle(
            fontSize: 10.sp,
            fontFamily: AppString.manropeFontFamily,
            fontWeight: FontWeight.w400,
            color: AppColors.labelColor15,
          ),
        ),
      ],
    ),
  );
}

// GestureDetector buildCheckBoxListTile(
//     {required bool isChecked, required String title}) {
//   return EmotionsCheckboxListtile(title: title, isChecked: isChecked, onChange: onChange);
// }

Center buildRates(String count) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(5.sp),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor8,
        ),
        borderRadius: BorderRadius.circular(5.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 14.sp,
            width: 14.sp,
            child: Image.asset(AppImages.userBlueIc),
          ),
          CustomText(
            text: " # of raters",
            textAlign: TextAlign.center,
            color: AppColors.labelColor15,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 11.sp,
            maxLine: 500,
            fontWeight: FontWeight.w600,
          ),
          10.sp.sbw,
          Container(
            height: 16.sp,
            width: 16.sp,
            decoration: BoxDecoration(
              color: AppColors.labelColor8,
              borderRadius: BorderRadius.circular(3.sp),
            ),
            child: Center(
              child: CustomText(
                text: count,
                textAlign: TextAlign.center,
                color: AppColors.white,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 11.sp,
                maxLine: 700,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget userListTileWithInviteAndRemindButton({
  required ReputationUserList data,
  required String styleId,
  required String userId,
  required Future Function(bool) onReaload,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10.sp),
    decoration: BoxDecoration(
      boxShadow: CommonController.getBoxShadow,
      borderRadius: BorderRadius.circular(5.sp),
      border: Border.all(color: AppColors.labelColor),
      color: AppColors.white,
    ),
    width: double.infinity,
    child: Column(
      children: [
        _buildListTop(
            data.photo.toString(),
            data.nameInitial.toString(),
            data.name.toString(),
            data.position.toString(),
            data.email.toString(),
            data.relation.toString()),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(5.sp),
              bottomLeft: Radius.circular(5.sp),
            ),
            color: AppColors.backgroundColor1,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 7.sp, bottom: 7.sp, left: 7.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "INVITED DATE",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor2,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 9.sp,
                      maxLine: 3,
                      fontWeight: FontWeight.w800,
                    ),
                    CustomText(
                      text: data.invitedDate.toString(),
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor8,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 9.sp,
                      maxLine: 3,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),
                10.sp.sbw,
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      data.isShowInviteBtn == "1"
                          ? CustomButton2(
                              isDisable:
                                  data.isEnableInviteBtn == "1" ? false : true,
                              buttonText: data.isEnableInviteBtn == "1"
                                  ? "Invite"
                                  : "Invited",
                              radius: 5.sp,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.sp, horizontal: 10.sp),
                              fontWeight: FontWeight.w700,
                              fontSize: 10.sp,
                              onPressed: () {
                                Get.find<DevelopmentController>()
                                    .inviteUserReputation(
                                  styleId: styleId,
                                  fromUser: userId,
                                  firstName: data.name.toString(),
                                  lastName: data.name.toString(),
                                  email: data.email.toString(),
                                  toUser: data.id.toString(),
                                  onReaload: (val) async {
                                    await onReaload(val);
                                  },
                                );
                              })
                          : 0.sbh,
                      data.isShowRemindBtn == "1"
                          ? Padding(
                              padding: EdgeInsets.only(left: 7.sp),
                              child: CustomButton2(
                                  isDisable: data.isEnableRemindBtn == "1"
                                      ? false
                                      : true,
                                  buttonText: "Remind",
                                  radius: 5.sp,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.sp, horizontal: 10.sp),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.sp,
                                  onPressed: () {
                                    Get.find<DevelopmentController>()
                                        .inviteUserReputation(
                                      styleId: styleId,
                                      fromUser: userId,
                                      firstName: data.name.toString(),
                                      lastName: data.name.toString(),
                                      email: data.email.toString(),
                                      toUser: data.id.toString(),
                                      onReaload: (val) async {
                                        onReaload(val);
                                      },
                                    );
                                  }),
                            )
                          : 0.sbh,
                      data.isShowMailBtn == "1"
                          ? Padding(
                              padding: EdgeInsets.only(left: 7.sp),
                              child: GestureDetector(
                                onTap: () {
                                  if (data.isInviteBtn == "1") {
                                    showDialog(
                                      context: Get.context!,
                                      builder: (BuildContext context) {
                                        return CustomAlertForHeadsUp(
                                          mailContent:
                                              data.mailContent.toString(),
                                        );
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: Get.context!,
                                      builder: (BuildContext context) {
                                        return CustomAlertForInvitationMail(
                                          name: data.mailInviteeName.toString(),
                                          date: data.invitedDate.toString(),
                                          link: data.link.toString(),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: SizedBox(
                                  height: 25.sp,
                                  width: 25.sp,
                                  child: Image.asset(AppImages.iconAccountIc),
                                ),
                              ),
                            )
                          : 0.sbh,
                      10.sp.sbw,
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ),
  );
}

Color getColorForPosition(position) {
  switch (position) {
    case "Peer":
      return AppColors.greenColor;
    case "Supervisor":
      return AppColors.labelColor76;

    case "Direct-report":
      return AppColors.secondaryColor;
    case "Favorited Community":
      return AppColors.labelColor77;
    case "Global Colleague":
      return AppColors.labelColor62;

    default:
      return AppColors.redColor;
  }
}

Padding _buildListTop(String image, String initialName, String name,
    String position, String email, String relation) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 7.sp, horizontal: 7.sp),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageForProfile(
          image: image,
          radius: 22.sp,
          nameInitials: initialName,
          borderColor: image != ""
              ? AppColors.circleGreen
              : AppColors.labelColor8.withOpacity(0.6),
        ),
        10.sp.sbw,
        Expanded(
          flex: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: name,
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor8,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        maxLine: 3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    5.sp.sbw,
                    CustomButton2(
                        buttonText: relation,
                        radius: 5.sp,
                        buttonColor:
                            getColorForPosition(relation).withOpacity(0.2),
                        textColor: getColorForPosition(relation),
                        padding: EdgeInsets.symmetric(
                            vertical: 3.sp, horizontal: 10.sp),
                        fontWeight: FontWeight.w700,
                        fontSize: 10.sp,
                        onPressed: () {})
                  ],
                ),
                position != ""
                    ? CustomText(
                        text: position,
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor15,
                        maxLine: 3,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      )
                    : 0.sbh,
                CustomText(
                  text: email,
                  textAlign: TextAlign.start,
                  color: AppColors.labelColor8,
                  maxLine: 3,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Row buildInviteOtherTile({
  required String firstText,
  required String btnTitle,
  required Function onTap,
  required List<String> list,
}) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: CustomText(
          text: firstText,
          textAlign: TextAlign.start,
          color: AppColors.black,
          fontFamily: AppString.manropeFontFamily,
          fontSize: 11.sp,
          maxLine: 3,
          fontWeight: FontWeight.w400,
        ),
      ),
      10.sp.sbw,
      PopupMenuButton<int>(
        padding: EdgeInsets.all(0.sp),
        constraints: const BoxConstraints(),
        itemBuilder: (context) => [
          ...list.map(
            (e) => PopupMenuItem(
              onTap: () async {
                if (e == "Invite My Colleague") {
                  var result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CreateColleagueAlertDialog();
                    },
                  );
                  if (result != null && result == true) {
                    onTap();
                  }
                }
                if (e == "My Workplace Community") {
                  Get.to(() => const MyConnectionSettingScreen());
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 0),
              value: 2,
              height: 20.sp,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  list.indexOf(e) + 1 == list.length ? 5.sbh : 0.sp.sbh,
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.sp,
                    ),
                    child: CustomText(
                      text: e.toString(),
                      textAlign: TextAlign.center,
                      fontSize: 10.sp,
                      color: AppColors.secondaryColor,
                      maxLine: 2,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppString.manropeFontFamily,
                      textSpacing: 0.5.sp,
                    ),
                  ),
                  list.indexOf(e) + 1 == list.length ? 0.sbh : 7.sp.sbh,
                  list.indexOf(e) + 1 == list.length
                      ? 0.sbh
                      : const Divider(
                          height: 0,
                          color: AppColors.hintColor,
                        ),
                ],
              ),
            ),
          )
        ],
        offset: Offset(0, 30.sp),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 5.sp),
          decoration: BoxDecoration(
            color: AppColors.white,
            gradient: CommonController.getLinearGradientSecondryAndPrimary(),
            borderRadius: BorderRadius.circular(5.sp),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                text: "Invite others",
                textAlign: TextAlign.center,
                fontSize: 10.sp,
                color: AppColors.white,
                maxLine: 2,
                fontWeight: FontWeight.w600,
                fontFamily: AppString.manropeFontFamily,
                textSpacing: 0.5.sp,
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.white,
                size: 13.sp,
              )
            ],
          ),
        ),
      )
    ],
  );
}

Widget getTitleAndDescriptionWithBorder() {
  return Container(
    margin: EdgeInsets.only(bottom: 10.sp),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.white,
      boxShadow: CommonController.getBoxShadow,
      border: Border.all(color: AppColors.black),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
          child: CustomText(
            text: "title",
            textAlign: TextAlign.start,
            color: AppColors.labelColor14,
            fontFamily: AppString.manropeFontFamily,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Divider(
          height: 0,
          color: AppColors.black,
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 7.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "I am the type of person who.",
                textAlign: TextAlign.start,
                color: AppColors.labelColor8,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
              2.sp.sbh,
              CustomText(
                text:
                    "Asks for what I need. Remains present during conflict. Increases the intensity of enforcing my boundaries.",
                textAlign: TextAlign.start,
                color: AppColors.labelColor15,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

CustomText buildGreyTitle(title) {
  return CustomText(
    text: title,
    textAlign: TextAlign.start,
    color: AppColors.labelColor15,
    fontFamily: AppString.manropeFontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
  );
}

Padding buildTitleLog(List reputationList) {
  return Padding(
    padding: EdgeInsets.all(10.sp),
    child: Wrap(
      runSpacing: 8.sp,
      spacing: 5.sp,
      children: [
        ...reputationList.map((e) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: e['color'] as Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.sp))),
                  height: 15.sp,
                  width: 15.sp,
                ),
                5.sp.sbw,
                CustomText(
                  text: e['title'].toString(),
                  textAlign: TextAlign.start,
                  color: AppColors.black,
                  fontFamily: AppString.manropeFontFamily,
                  fontSize: 11.sp,
                  maxLine: 10,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ))
      ],
    ),
  );
}
