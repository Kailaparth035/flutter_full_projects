import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/response/quick_link_and_video_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_add_quick_links.dart';
import 'package:aspirevue/view/base/custom_check_box.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/development/development_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/behaviors/behaviors_module_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/journey/my_journy_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/personal_growth/contacts_list_screen.dart';
import 'package:aspirevue/view/screens/menu/my_goals/add_goal_screen.dart';
import 'package:aspirevue/view/screens/menu/store/store_main_screen.dart';
import 'package:aspirevue/view/screens/profile/my_profile_screen.dart';
import 'package:aspirevue/view/screens/profile/my_signature_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AlertForCompletedSteps extends StatefulWidget {
  const AlertForCompletedSteps({super.key});

  @override
  State<AlertForCompletedSteps> createState() => _AlertForCompletedStepsState();
}

class _AlertForCompletedStepsState extends State<AlertForCompletedSteps> {
  final _dashboardController = Get.find<DashboardController>();
  final _streamController = Get.find<InsightStreamController>();
  final _profileSharedPrefService = Get.find<ProfileSharedPrefService>();

  setValue(StepCheckboxModel data, bool value) async {
    if (data.navKey == "mychecklist") {
      Map<String, dynamic> jsonData = {
        "data": [
          {"nav_key": "mychecklist", "is_selected": 1}
        ],
      };
      bool? res = await _dashboardController.updateToViewQuickLinks(
          quickLinksPopup: [], defaultJsonData: jsonData);

      if (res != null && res == true) {
        Navigator.pop(Get.context!);
      }
    } else {
      await _dashboardController.updateMyChecklist(
          id: data.id.toString(), isChecked: value == true ? "1" : "0");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.circlepink2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0.sp))),
      contentPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      content: SizedBox(
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(),
              0.sp.sbh,
              CustomText(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: AppColors.black,
                text: "Complete these steps to get started",
                textAlign: TextAlign.start,
                fontFamily: AppString.manropeFontFamily,
              ),
              5.sp.sbh,
              _buildList()
            ],
          ),
        ),
      ),
    );
  }

  _buildList() {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return Column(
        children: [
          ...dashboardController.quickLinkData!.myChecklists!.map((e) =>
              _buildCheckList(
                  e, dashboardController.quickLinkData!.myChecklists!))
        ],
      );
    });
  }

  Widget _buildCheckList(StepCheckboxModel data, List<StepCheckboxModel> list) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCheckBox(
              onTap: () {
                setValue(data, data.isChecked == 1 ? false : true);
              },
              borderColor: AppColors.labelColor8,
              fillColor: AppColors.labelColor8,
              isChecked: data.isChecked == 1),
          5.sp.sbw,
          Expanded(
            child: InkWell(
              onTap: () {
                stepNavigation(data.navKey.toString());
              },
              child: Text(
                data.title.toString(),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppString.manropeFontFamily,
                  decoration: data.isChecked == 1
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.sp, horizontal: 0.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: " ",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(3.sp),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.white),
              child: Image.asset(
                AppImages.closeBoldIc,
                height: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }

  stepNavigation(String navKey) async {
    String? userId =
        Get.find<ProfileSharedPrefService>().loginData.value.id.toString();
    switch (navKey.toString().toLowerCase()) {
      case "profile_preference":
        // Navigator.pop(context);
        Get.to(MyProfileScreen(
            onBackPress: () {
              Get.back();
            },
            isFromMain: true));
        break;

      case "dashboard_open_quicklink":
        Navigator.pop(context);
        await Get.find<DashboardController>().setQuickLinksPopupMain();
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return const CustomAlertForAddQuickLink();
          },
        );
        break;
      case "import_contacts":
        // Get.to(() => const GrowthCommunityScreen(
        //       isShowUnselectedBottomSheet: true,
        //       title: AppString.growthCommunity,
        //       currentIndex: 1,
        //     ));

        Get.to(() => const ContactListScreen());

        break;
      case "start_my_journey":
        Get.to(() => MyJournyScreen(
              userRole: UserRole.self,
              userId: userId,
            ));
        break;

      case "dev_summary_page":
        Get.to(() => MyJournyScreen(
              userRole: UserRole.self,
              userId: userId,
            ));
        break;

      case "set_my_aspirations":
        Get.to(() => BehaviorsModuleScreen(
              isShowLearning: true,
              userId: userId,
              userRole: UserRole.self,
              tabName: AppConstants.selfReflection,
            ));
        break;

      case "profile_signature":
        Get.to(() => const SignatureSettingScreen());
        // Get.to(MyProfileScreen(
        //   onBackPress: () {
        //     Get.back();
        //   },
        //   isFromMain: true,
        //   isOpenedSideBar: true,
        // ));
        break;

      case "store_assessment":
        Get.to(() => const StoreMainScreen(
              isFromMenu: false,
              currentIndex: 2,
            ));
        break;
      case "store_coach":
        Get.to(() => const StoreMainScreen(
              isFromMenu: false,
              currentIndex: 3,
            ));
        break;

      case "store_coach_journey360":
        Get.to(() => const StoreMainScreen(
              isFromMenu: false,
            ));
        break;

      case "create_manual_goal":
        Get.to(() => const AddGoalScreen(
              isEdit: false,
            ));
        break;

      case "share_insight":
        var result = await Get.toNamed(RouteHelper.getCreatePostRoute());
        if (result != null && result == true) {
          _streamController.getInsightFeed(true);
        }
        break;

      case "development_menu_list":
        Get.to(() => const DevelopmentScreen());
        break;

      case "show_overlay_tour":
        Navigator.pop(context);

        _profileSharedPrefService.isShowOverlayView.value = true;
        // _profileSharedPrefService.isOverlayStarted.value = true;

        Future.delayed(const Duration(seconds: 1), () {
          _profileSharedPrefService
              .showOverLay(AppConstants.profileOverLayIndex);
        });
        break;

      case "gettingstartedvideo":
        Map<String, dynamic> jsonData = {
          "data": [
            {"nav_key": "gettingstartedvideo", "is_selected": 0}
          ],
        };
        bool? res = await _dashboardController.updateToViewQuickLinks(
            quickLinksPopup: [], defaultJsonData: jsonData);

        if (res != null && res == true) {
          Navigator.pop(Get.context!);
        }

        break;

      default:
    }
  }
}
