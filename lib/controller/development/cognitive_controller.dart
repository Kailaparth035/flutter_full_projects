import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/risk_factor_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CognitiveController extends GetxController {
  final DevelopmentController developmentController;
  CognitiveController({required this.developmentController});

  // ========================= relf Reflact =========================
  // Local Properties
  bool _isLoadingSelfReflact = true;
  bool _isErrorSelfReflact = false;
  String _errorMsgSelfReflact = "";
  RiskFactorSelfReflectDetailsData? _dataSelfReflact;

  // Get Properties
  bool get isLoadingSelfReflact => _isLoadingSelfReflact;
  bool get isErrorSelfReflact => _isErrorSelfReflact;
  String get errorMsgSelfReflact => _errorMsgSelfReflact;
  RiskFactorSelfReflectDetailsData? get dataSelfReflact => _dataSelfReflact;

  getSelfReflactData(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.cognitiveId,
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
          map, DevelopmentType.cognitive);

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

  // ========================= Assess Data =========================
  // Local Properties
  bool _isLoadingAssess = true;
  bool _isErrorAssess = false;
  String _errorMsgAssess = "";
  TraitAssesData? _dataAssess;
  List _titleListAssess = [];

  // Get Properties
  bool get isLoadingAssess => _isLoadingAssess;
  bool get isErrorAssess => _isErrorAssess;
  String get errorMsgAssess => _errorMsgAssess;
  TraitAssesData? get dataAssess => _dataAssess;
  List get titleListAsssess => _titleListAssess;

  getAssessData(String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.cognitiveId,
    };
    try {
      _isLoadingAssess = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }

      var response = await developmentController.getAssessDetails(
          map, DevelopmentType.cognitive);

      _dataAssess = response;
      _isErrorAssess = false;
      _errorMsgAssess = "";
      _titleListAssess = [
        {
          "title": _dataAssess!.type1.toString(),
          "color": AppColors.labelColor62,
        },
        {
          "title": _dataAssess!.type2.toString(),
          "color": AppColors.labelColor57,
        },
      ];
    } catch (e) {
      _isErrorAssess = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgAssess = error.toString();
    } finally {
      _isLoadingAssess = false;
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

  getTargetingDetails(String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.cognitiveId,
    };
    try {
      _isLoadingTarget = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
      var response = await developmentController.getTargetingDetails(
          map, DevelopmentType.traits);

      _dataTarget = response;
      _isErrorTarget = false;
      _errorMsgTarget = "";
      _isSharedTargating = dataTarget!.shareWithSupervisor.toString() == "1";
      _titleListTarget = [
        {
          "title": _dataTarget!.type1.toString(),
          "color": AppColors.backgroundColor4,
        },
        {
          "title": _dataTarget!.type3.toString(),
          "color": AppColors.labelColor62,
        },
        {
          "title": _dataTarget!.type2.toString(),
          "color": AppColors.labelColor57,
        },
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
      "style_id": AppConstants.cognitiveId,
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
          map, DevelopmentType.goal);

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
