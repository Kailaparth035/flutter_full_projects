import 'package:aspirevue/view/base/alert_dialogs/custom_alert_dialog_for_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static takePermission(Permission permissionType) async {
    var status = await permissionType.status;
    if (status.isDenied) {
      // Here just ask for the permission for the first time
      PermissionStatus result = await permissionType.request();
      if (result.isGranted) {
        return true;
      }
      if (result.isDenied) {
        await getConfirmationAndAskPermission(permissionType);
      }
      return false;
    } else if (status.isPermanentlyDenied) {
      // showCustomSnackBar('Please grant permission from setting');
      // await Future.delayed(const Duration(seconds: 2), () async {
      //   await openAppSettings();
      // });
      await getConfirmationAndAskPermission(permissionType);
      return false;
    } else {
      return true;
    }
  }

  static getConfirmationAndAskPermission(Permission permissionType) async {
    var res = await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return ConfirmAlertDialLog(
          isShowOnlyTitle: false,
          isShowOkButton: true,
          // title:
          //     "Please Go To Setting and enable ${permissionType.toString().substring(11)} Permission",
          title :"Grant settings permissions to access ${permissionType.toString().substring(11)}"
        );
      },
    );

    if (res != null && res == true) {
      await openAppSettings();
    }
  }
}
