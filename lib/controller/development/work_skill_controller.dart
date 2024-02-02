import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/courses_list_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_goal_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_user_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_self_reflect_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkSkillController extends GetxController {
  final DevelopmentController developmentController;
  WorkSkillController({required this.developmentController});

  // ========================= Reputaion user data =========================
  // Local Properties
  bool _isLoadingReputation = true;
  bool _isErrorReputation = false;
  String _errorMsgReputation = "";
  WorkSkillReputaionUserData? _dataReputation;

  // Get Properties
  bool get isLoadingReputation => _isLoadingReputation;
  bool get isErrorReputation => _isErrorReputation;
  String get errorMsgReputation => _errorMsgReputation;
  WorkSkillReputaionUserData? get dataReputation => _dataReputation;

  Future<bool?> getReputationFeedbackUserListUri(
      bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.workSkillId,
    };
    try {
      if (isShowLoading == true) {
        _isLoadingReputation = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      var response = await developmentController.getReputationFeedbackUserList(
          map, DevelopmentType.workSkills);

      _isErrorReputation = false;
      _errorMsgReputation = "";
      _dataReputation = response;

      return true;
    } catch (e) {
      _isErrorReputation = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgReputation = error.toString();
    } finally {
      if (isShowLoading == true) {
        _isLoadingReputation = false;
      }
      update();
    }
    return null;
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
      "style_id": AppConstants.workSkillId,
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

  //  ========================= self reflact ==========================
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
      "style_id": AppConstants.workSkillId,
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
          map, DevelopmentType.workSkills);

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

  Future<bool?> getGoalAchievementsDetails(
      bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": AppConstants.workSkillId,
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
      return true;
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
    return null;
  }

  // ============== courses =================

  // Local Properties
  bool _isLoadingCourses = true;
  bool _isErrorCourses = false;
  String _errorMsgCourses = "";
  CoursesListData? _dataCourses;

  // Get Properties
  bool get isLoadingCourses => _isLoadingCourses;
  bool get isErrorCourses => _isErrorCourses;
  String get errorMsgCourses => _errorMsgCourses;
  CoursesListData? get dataCourses => _dataCourses;

  getCoursesData({required String userId, required String styleId}) async {
    Map<String, String> map = {
      "user_id": userId,
      "style_id": styleId,
    };
    try {
      _isLoadingCourses = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
      var response = await developmentController.eLearningDetails(map);

      _dataCourses = response;
      _isErrorCourses = false;
      _errorMsgCourses = "";
    } catch (e) {
      _isErrorCourses = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgCourses = error.toString();
    } finally {
      _isLoadingCourses = false;
      update();
    }
  }
}
