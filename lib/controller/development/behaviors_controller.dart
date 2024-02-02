import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/behaviors_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BehaviorsController extends GetxController {
  final DevelopmentController developmentController;
  BehaviorsController({required this.developmentController});

  // ========================= relf Reflact =========================
  // Local Properties
  bool _isLoadingSelfReflact = true;
  bool _isErrorSelfReflact = false;
  String _errorMsgSelfReflact = "";
  BehaviorSelfReflectDetailsData? _dataSelfReflact;

  // Get Properties
  bool get isLoadingSelfReflact => _isLoadingSelfReflact;
  bool get isErrorSelfReflact => _isErrorSelfReflact;
  String get errorMsgSelfReflact => _errorMsgSelfReflact;
  BehaviorSelfReflectDetailsData? get dataSelfReflact => _dataSelfReflact;

  getSelfReflactData(bool isShowLoading, String userId,
      {String? tabType}) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.behaviousId,
      "tabType": tabType ?? ""
    };
    try {
      if (isShowLoading == true) {
        _isLoadingSelfReflact = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      var response = await developmentController.getReflectDetails(
          map, DevelopmentType.behaviors);

      _isErrorSelfReflact = false;
      _errorMsgSelfReflact = "";
      _dataSelfReflact = response;
    } catch (e) {
      _isErrorSelfReflact = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgSelfReflact = error.toString();
    } finally {
      if (isShowLoading == true) {
        _isLoadingSelfReflact = false;
      }
      update();
    }
  }

  // ========================= TarGetting =========================
  // Local Properties
  bool _isLoadingTarget = true;
  bool _isErrorTarget = false;
  String _errorMsgTarget = "";
  TraitAssesData? _dataTarget;
  List _titleListTarget = [];

  bool _isSharedTargating = false;

  // Get Properties
  bool get isLoadingTarget => _isLoadingTarget;
  bool get isErrorTarget => _isErrorTarget;
  String get errorMsgTarget => _errorMsgTarget;
  TraitAssesData? get dataTarget => _dataTarget;

  List get titleListTarget => _titleListTarget;
  bool get isSharedTargating => _isSharedTargating;

  updateShareStatus() {
    _isSharedTargating = !_isSharedTargating;
    update();
  }

  getTargetingDetails(
    String userId,
  ) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.behaviousId,
    };
    try {
      _isLoadingTarget = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
      var response = await developmentController.getTargetingDetails(
          map, DevelopmentType.behaviors);

      _dataTarget = response;
      _isErrorTarget = false;
      _errorMsgTarget = "";
      _isSharedTargating = dataTarget!.shareWithSupervisor.toString() == "1";
      _titleListTarget = [
        {
          "title": "My Target",
          "color": AppColors.backgroundColor4,
        }
      ];
    } catch (e) {
      _isErrorTarget = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgTarget = error.toString();
    } finally {
      _isLoadingTarget = false;
      update();
    }
  }

  // ========================= Goal =========================
  // Local Properties
  bool _isLoadingGoal = true;
  bool _isErrorGoal = false;
  String _errorMsgGoal = "";
  TraitsGoalData? _dataGoal;

  // Get Properties
  bool get isLoadingGoal => _isLoadingGoal;
  bool get isErrorGoal => _isErrorGoal;
  String get errorMsgGoal => _errorMsgGoal;
  TraitsGoalData? get dataGoal => _dataGoal;

  getGoalData(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.behaviousId,
    };
    try {
      if (isShowLoading) {
        _isLoadingGoal = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        buildLoading(Get.context!);
      }

      var response = await developmentController.getGoalAchievementsDetails(
          map, DevelopmentType.leaderStyle);

      _isErrorGoal = false;
      _errorMsgGoal = "";
      _dataGoal = response;
    } catch (e) {
      _isErrorGoal = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgGoal = error.toString();
    } finally {
      if (isShowLoading) {
        _isLoadingGoal = false;
      } else {
        Navigator.pop(Get.context!);
      }
      update();
    }
  }
}
