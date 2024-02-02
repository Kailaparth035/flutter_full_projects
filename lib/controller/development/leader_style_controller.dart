import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/leader_style_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/leader_style_self_reflect_mode.dart';
import 'package:aspirevue/data/model/response/development/leader_style_target_model.dart';
import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LeaderStyleController extends GetxController {
  final DevelopmentController developmentController;
  LeaderStyleController({required this.developmentController});

  // ========================= relf Reflact =========================
  // Local Properties
  bool _isLoadingSelfReflact = true;
  bool _isErrorSelfReflact = false;
  String _errorMsgSelfReflact = "";
  LeaderStyleSelfReflectDetailsData? _dataSelfReflact;

  // Get Properties
  bool get isLoadingSelfReflact => _isLoadingSelfReflact;
  bool get isErrorSelfReflact => _isErrorSelfReflact;
  String get errorMsgSelfReflact => _errorMsgSelfReflact;
  LeaderStyleSelfReflectDetailsData? get dataSelfReflact => _dataSelfReflact;

  getSelfReflactData(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.leaderStyleId,
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
          map, DevelopmentType.leaderStyle);

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

  // ========================= Assess =========================
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
  List get titleListAssess => _titleListAssess;

  getAssessData(String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.leaderStyleId,
    };
    try {
      _isLoadingAssess = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
      var response = await developmentController.getAssessDetails(
          map, DevelopmentType.leaderStyle);

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
        {
          "title": _dataAssess!.type3.toString(),
          "color": AppColors.labelColor56,
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

  // ========================= Target =========================
  // Local Properties
  bool _isLoadingTarget = true;
  bool _isErrorTarget = false;
  String _errorMsgTarget = "";
  LeaderStyleTargetDataList? _dataTarget;

  bool _isSharedTargating = false;

  // Get Properties
  bool get isLoadingTarget => _isLoadingTarget;
  bool get isErrorTarget => _isErrorTarget;
  String get errorMsgTarget => _errorMsgTarget;
  LeaderStyleTargetDataList? get dataTarget => _dataTarget;

  bool get isSharedTargating => _isSharedTargating;

  updateShareStatus() {
    _isSharedTargating = !_isSharedTargating;
    update();
  }

  getTargetData(String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.leaderStyleId,
    };
    try {
      _isLoadingTarget = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
      var response = await developmentController.getTargetingDetails(
          map, DevelopmentType.leaderStyle);

      _dataTarget = response;
      _isErrorTarget = false;
      _isSharedTargating = dataTarget!.shareWithSupervisor.toString() == "1";
      _errorMsgTarget = "";
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
      "style_id": AppConstants.leaderStyleId,
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

  // ========================= Reputaion user data =========================
  // Local Properties
  bool _isLoadingReputationUser = true;
  bool _isErrorReputationUser = false;
  String _errorMsgReputationUser = "";
  ReputationUserData? _dataReputationUser;

  // Get Properties
  bool get isLoadingReputationUser => _isLoadingReputationUser;
  bool get isErrorReputationUser => _isErrorReputationUser;
  String get errorMsgReputationUser => _errorMsgReputationUser;
  ReputationUserData? get dataReputationUser => _dataReputationUser;

  getReputationFeedbackUserListUri(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.leaderStyleId,
    };
    try {
      if (isShowLoading == true) {
        _isLoadingReputationUser = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      var response = await developmentController.getReputationFeedbackUserList(
          map, DevelopmentType.leaderStyle);

      _isErrorReputationUser = false;
      _errorMsgReputationUser = "";
      _dataReputationUser = response;
    } catch (e) {
      _isErrorReputationUser = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgReputationUser = error.toString();
    } finally {
      if (isShowLoading == true) {
        _isLoadingReputationUser = false;
      }
      update();
    }
  }

  // ========================= Reputaion slider data =========================
  // Local Properties
  bool _isLoadingReputationSlider = true;
  bool _isErrorReputationSlider = false;
  String _errorMsgReputationSlider = "";
  LeaderStyleReputaionSliderData? _dataReputationSlider;

  // Get Properties
  bool get isLoadingReputationSlider => _isLoadingReputationSlider;
  bool get isErrorReputationSlider => _isErrorReputationSlider;
  String get errorMsgReputationSlider => _errorMsgReputationSlider;
  LeaderStyleReputaionSliderData? get dataReputationSlider =>
      _dataReputationSlider;

  getReputationFeedbackSliderList(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.leaderStyleId,
    };
    try {
      if (isShowLoading == true) {
        _isLoadingReputationSlider = true;
      }
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }

      var response = await developmentController
          .getReputationFeedbackSliderList(map, DevelopmentType.leaderStyle);

      _isErrorReputationSlider = false;
      _errorMsgReputationSlider = "";
      _dataReputationSlider = response;
    } catch (e) {
      _isErrorReputationSlider = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgReputationSlider = error.toString();
    } finally {
      if (isShowLoading == true) {
        _isLoadingReputationSlider = false;
      }
      update();
    }
  }
}
