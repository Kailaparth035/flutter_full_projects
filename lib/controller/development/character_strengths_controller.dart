import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/work_skill_goal_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_user_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_self_reflect_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CharacterStrengthsController extends GetxController {
  final DevelopmentController developmentController;
  CharacterStrengthsController({required this.developmentController});

  // ========================= relf Reflact =========================
  // Local Properties
  bool _isLoadingSelfReflact = true;
  bool _isErrorSelfReflact = false;
  String _errorMsgSelfReflact = "";
  WorkSkillSelfReflectDetailsData? _dataSelfReflact;

  // Get Properties
  bool get isLoadingSelfReflact => _isLoadingSelfReflact;
  bool get isErrorSelfReflact => _isErrorSelfReflact;
  String get errorMsgSelfReflact => _errorMsgSelfReflact;
  WorkSkillSelfReflectDetailsData? get dataSelfReflact => _dataSelfReflact;

  getSelfReflactData(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.characterStengthID,
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
          map, DevelopmentType.characterStrengths);

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

  // ========================= Goal =========================
  // Local Properties
  bool _isLoadingGoal = true;
  bool _isErrorGoal = false;
  String _errorMsgGoal = "";
  WorkskillGoalData? _dataGoal;

  // Get Properties
  bool get isLoadingGoal => _isLoadingGoal;
  bool get isErrorGoal => _isErrorGoal;
  String get errorMsgGoal => _errorMsgGoal;
  WorkskillGoalData? get dataGoal => _dataGoal;

  getGoalAchievementsDetails(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.characterStengthID,
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
          map, DevelopmentType.workSkills);

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
  WorkSkillReputaionUserData? _dataReputationUser;

  // Get Properties
  bool get isLoadingReputationUser => _isLoadingReputationUser;
  bool get isErrorReputationUser => _isErrorReputationUser;
  String get errorMsgReputationUser => _errorMsgReputationUser;
  WorkSkillReputaionUserData? get dataReputationUser => _dataReputationUser;

  getReputationFeedbackUserListUri(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.characterStengthID,
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
          map, DevelopmentType.workSkills);

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

  //  =========================Reputaion slider data ==========================
  List _titleList = [];
  List get titleList => _titleList;

  // Local Properties
  bool _isLoadingReputationSlider = true;
  bool _isErrorReputationSlider = false;
  String _errorMsgReputationSlider = "";
  WorkSkillReputaionSliderData? _dataReputationSlider;

  // Get Properties
  bool get isLoadingReputationSlider => _isLoadingReputationSlider;
  bool get isErrorReputationSlider => _isErrorReputationSlider;
  String get errorMsgReputationSlider => _errorMsgReputationSlider;
  WorkSkillReputaionSliderData? get dataReputationSlider =>
      _dataReputationSlider;

  getReputationFeedbackSliderList(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.characterStengthID,
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
          .getReputationFeedbackSliderList(map, DevelopmentType.workSkills);

      _isErrorReputationSlider = false;
      _errorMsgReputationSlider = "";
      _dataReputationSlider = response;
      _titleList = [
        {
          "title": _dataReputationSlider!.type1,
          "color": AppColors.labelColor56,
        },
        {
          "title": _dataReputationSlider!.type2,
          "color": AppColors.labelColor57,
        },
        {
          "title": "${_dataReputationSlider!.type3} ",
          "color": AppColors.labelColor59,
        },
        {
          "title": _dataReputationSlider!.type4,
          "color": AppColors.labelColor58,
        },
        {
          "title": _dataReputationSlider!.type5,
          "color": AppColors.labelColor60,
        },
      ];
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
