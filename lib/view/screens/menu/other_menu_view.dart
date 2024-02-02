import 'package:aspirevue/controller/auth_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:aspirevue/view/base/custom_drop_list.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/screens/menu/enterprice/enterprice_main_screen.dart';
import 'package:aspirevue/view/screens/menu/store/referal_screen.dart';
import 'package:aspirevue/view/screens/menu/support_screen.dart';
import 'package:aspirevue/view/screens/profile/change_password_screen.dart';
import 'package:aspirevue/view/screens/profile/integration_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/my_connection_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/my_signature_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/notification_setting_screen.dart';
import 'package:aspirevue/view/screens/profile/personal_info_screen.dart';
import 'package:aspirevue/view/screens/profile/privacy_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class OtherMenuView extends StatefulWidget {
  const OtherMenuView({super.key});

  @override
  State<OtherMenuView> createState() => _OtherMenuViewState();
}

class _OtherMenuViewState extends State<OtherMenuView> {
  final _developmentController = Get.find<DevelopmentController>();
  DropListModel mainMenuList2 = DropListModel([]);
  DropDownOptionItemMenu optionMenuItem2 =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            2.h.sbh,
            GetBuilder<DashboardController>(builder: (dashboardController) {
              return CustomDropList(
                AppImages.menuShortcutMyConnection,
                "My Profile",
                dashboardController.optionMenuItem,
                dashboardController.mainMenuList,
                (optionItem) {
                  if (optionItem.sortName != null &&
                      optionItem.sortName == "EnterPrise") {
                    Get.to(() => EnterpriceScreen(
                        enterpriseId: optionItem.id.toString()));
                  } else {
                    _profileNavigation(optionItem.id.toString());
                  }
                },
              );
            }),
            0.5.h.sbh,
            _developmentController.isShowReferAndEarnMenu.value == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropList(
                        AppImages.menuShortcutPollForums,
                        "Refer And Earn",
                        optionMenuItem2,
                        mainMenuList2,
                        (optionItem) {},
                        onTap: () {
                          Get.to(() => const ReferalScreen());
                        },
                      ),
                      0.5.h.sbh,
                    ],
                  )
                : 0.sbh,
            CustomDropList(
              AppImages.supportIc,
              AppString.menuSupport,
              optionMenuItem2,
              mainMenuList2,
              (optionItem) {},
              onTap: () {
                Get.to(() => const SupportScreen());
              },
            ),
            0.5.h.sbh,
            CustomDropList(
              AppImages.logoutIc,
              AppString.logOut,
              optionMenuItem2,
              mainMenuList2,
              (optionItem) {
                optionMenuItem2 = optionItem;
                setState(() {});
              },
              onTap: () {
                _logout();
                // CommonController.ratingApp();
              },
            ),
            0.5.h.sbh,
          ],
        ),
      ),
    );
  }

  _profileNavigation(String id) {
    if (id == "1") {
      Get.to(() => const PersonalInfoScreen());
    }
    if (id == "2") {
      Get.to(() => const ChangePasswordScreen());
    }
    if (id == "3") {
      Get.to(() => const PrivacySettingScreen());
    }
    if (id == "4") {
      Get.to(() => const NotificationSettingScreen());
    }
    if (id == "5") {
      Get.to(() => const MyConnectionSettingScreen());
    }
    if (id == "6") {
      Get.to(() => const IntegrationSettingScreen());
    }
    if (id == "7") {
      Get.to(() => const SignatureSettingScreen());
    }

    if (id == "7") {
      Get.to(() => const SignatureSettingScreen());
    }
  }

  _logout() async {
    var res = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmAlertDialLog(
          title: AppString.areYouSureWantLogOut,
        );
      },
    );
    if (res != null) {
      var map = <String, dynamic>{};
      var mainController = Get.find<MainController>();
      mainController.addToStackAndNavigate(AppConstants.todayIndex);
      var sharedPrefServiceController = Get.find<ProfileSharedPrefService>();
      buildLoading(Get.context!);
      Get.find<AuthController>()
          .logout(map, sharedPrefServiceController)
          .then((status) async {
        if (status.isSuccess == true) {
          showCustomSnackBar(status.message, isError: false);
          Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
        } else {
          Navigator.pop(Get.context!);
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
