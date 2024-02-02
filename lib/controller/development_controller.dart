import 'dart:async';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/development/badge_legend_model.dart';
import 'package:aspirevue/data/model/response/development/behaviors_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/comp_goal_details_model.dart';
import 'package:aspirevue/data/model/response/development/comp_reflect_details_model.dart';
import 'package:aspirevue/data/model/response/development/comp_targatting_details_model.dart';
import 'package:aspirevue/data/model/response/development/course_details_model.dart';
import 'package:aspirevue/data/model/response/development/courses_list_model.dart';
import 'package:aspirevue/data/model/response/development/development_menulist_model.dart';
import 'package:aspirevue/data/model/response/development/emotion_graph_model.dart';
import 'package:aspirevue/data/model/response/development/emotions_assess_model.dart';
import 'package:aspirevue/data/model/response/development/emotions_reputaions_user_model.dart';
import 'package:aspirevue/data/model/response/development/emotions_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/emotions_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/goal_details_popup_model.dart';
import 'package:aspirevue/data/model/response/development/goals_remain_model.dart';
import 'package:aspirevue/data/model/response/development/graph_details_model.dart';
import 'package:aspirevue/data/model/response/development/leader_style_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/leader_style_self_reflect_mode.dart';
import 'package:aspirevue/data/model/response/development/leader_style_target_model.dart';
import 'package:aspirevue/data/model/response/development/my_journey_graph_model.dart';
import 'package:aspirevue/data/model/response/development/my_journey_model.dart';
import 'package:aspirevue/data/model/response/development/progress_tracking_chart_model.dart';
import 'package:aspirevue/data/model/response/development/reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';
import 'package:aspirevue/data/model/response/development/risk_factor_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/showcase_journey_model.dart';
import 'package:aspirevue/data/model/response/development/traits_assess_model.dart';
import 'package:aspirevue/data/model/response/development/traits_goal_model.dart';
import 'package:aspirevue/data/model/response/development/traits_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/values_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_goal_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_slider_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_user_model.dart';
import 'package:aspirevue/data/model/response/development/work_skill_self_reflect_model.dart';
import 'package:aspirevue/data/model/response/progress_tracking_options_model.dart';
import 'package:aspirevue/data/model/response/reminder_option_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/model/response/shortcut_menu_exists_model.dart';

import 'package:aspirevue/data/repository/development_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevelopmentController extends GetxController {
  final DevelopmentRepo developmentRepo;
  DevelopmentController({required this.developmentRepo});

  //  ===================== development module display or not ============================

  RxBool isShowDevelopmentModule = false.obs;
  RxBool isShowMyCoachModule = false.obs;
  RxBool isShowReferAndEarnMenu = false.obs;

  RxBool isShowingJourneyPopup = false.obs;

  updateJourneyPopup(bool val) {
    isShowingJourneyPopup(val);
  }

  Future<bool?> existdevelopmentMenu() async {
    Map<String, dynamic> map = {};
    try {
      Response response = await developmentRepo.existdevelopmentMenu(map);

      if (response.statusCode != null && response.statusCode == 200) {
        ShortCutMenuExistModel data =
            ShortCutMenuExistModel.fromJson(response.body);

        isShowDevelopmentModule.value = data.data!.developmentMenu == 1;
        isShowMyCoachModule.value = data.data!.mycoachMenu == 1;
        isShowReferAndEarnMenu.value = data.data!.isShowReferAndEarnMenu == 1;
      }
    } catch (e) {
      debugPrint("====> 1 ${e.toString()}");
    }
    return null;
  }

  // ============================ self reflaction  ==================================

  Future<dynamic> getReflectDetails(
      Map<String, String> prm, DevelopmentType type) async {
    try {
      Response response = await developmentRepo.getSelfReflectDetails(prm);
      if (response.statusCode == 200) {
        return _getSelfReflactModel(type, response);
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw e.toString();
    }
  }

  _getSelfReflactModel(DevelopmentType type, Response response) {
    dynamic model;
    if (type == DevelopmentType.workSkills ||
        type == DevelopmentType.characterStrengths) {
      model = WorkSkillSelfReflectDetailsModel.fromJson(response.body);
    }
    if (type == DevelopmentType.traits) {
      model = TraitsSelfReflectDetailsModel.fromJson(response.body);
    }

    if (type == DevelopmentType.values1 || type == DevelopmentType.cognitive) {
      model = ValuesSelfReflectDetailsModel.fromJson(response.body);
    }

    if (type == DevelopmentType.cognitive) {
      model = RiskFactorSelfReflectDetailsModel.fromJson(response.body);
    }

    if (type == DevelopmentType.riskFactors) {
      model = RiskFactorSelfReflectDetailsModel.fromJson(response.body);
    }

    if (type == DevelopmentType.behaviors) {
      model = BehaviorSelfReflectDetailsModel.fromJson(response.body);
    }
    if (type == DevelopmentType.leaderStyle) {
      model = LeaderStyleSelfReflectDetailsModel.fromJson(response.body);
    }
    if (type == DevelopmentType.emotions) {
      model = EmotionsSelfReflectDetailsModel.fromJson(response.body);
    }
    if (model.data != null) {
      return model.data!;
    } else {
      throw AppString.somethingWentWrong;
    }
  }

  // ============================ assessment  ==================================

  Future<dynamic> getAssessDetails(
      Map<String, String> prm, DevelopmentType type) async {
    try {
      Response response = await developmentRepo.getAssessDetails(prm);
      if (response.statusCode == 200) {
        dynamic model;

        if (type == DevelopmentType.emotions) {
          model = EmotionsAssesModel.fromJson(response.body);
        } else {
          model = TraitAssesModel.fromJson(response.body);
        }

        if (model.data != null) {
          return model.data!;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  // ============================ Aspirevue Target  ==================================

  Future<dynamic> getTargetingDetails(
      Map<String, String> prm, DevelopmentType type) async {
    try {
      Response response = await developmentRepo.getTargetingDetails(prm);
      if (response.statusCode == 200) {
        dynamic model;

        if (type == DevelopmentType.emotions) {
          model = EmotionsAssesModel.fromJson(response.body);
        } else if (type == DevelopmentType.leaderStyle) {
          model = LeaderStyleTargetModel.fromJson(response.body);
        } else {
          model = TraitAssesModel.fromJson(response.body);
        }

        if (model.data != null) {
          return model.data!;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  //============================ Courses list ==================================
  Future<dynamic> eLearningDetails(
    Map<String, String> prm,
  ) async {
    try {
      Response response = await developmentRepo.eLearningDetails(prm);
      if (response.statusCode == 200) {
        CoursesListModel model = CoursesListModel.fromJson(response.body);

        if (model.data != null) {
          return model.data!;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  // ============================ goal ==================================
  Future<dynamic> getGoalAchievementsDetails(
      Map<String, String> prm, DevelopmentType type) async {
    try {
      Response response = await developmentRepo.getGoalAchievementsDetails(prm);
      if (response.statusCode == 200) {
        dynamic model;

        if (type == DevelopmentType.workSkills) {
          model = WorkskillGoalModel.fromJson(response.body);
        } else if (type == DevelopmentType.goal ||
            type == DevelopmentType.values1 ||
            type == DevelopmentType.leaderStyle) {
          model = TraitsGoalModel.fromJson(response.body);
        } else {
          model = WorkskillGoalModel.fromJson(response.body);
        }

        if (model.data != null) {
          return model.data;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  // ============================ reputation ==================================
  // Future<dynamic> getReputationFeedbackDetails(
  //     Map<String, String> prm, DevelopmentType type) async {
  //   try {
  //     Response response =
  //         await developmentRepo.getReputationFeedbackDetails(prm);
  //     if (response.statusCode == 200) {
  //       dynamic model;

  //       if (type == DevelopmentType.traits ||
  //           type == DevelopmentType.riskFactors) {
  //         model = ReputationModel.fromJson(response.body);
  //       } else if (type == DevelopmentType.workSkills) {
  //         model = WorkSkillReputaionModel.fromJson(response.body);
  //       } else if (type == DevelopmentType.leaderStyle) {
  //         model = LeaderStyleReputaionModel.fromJson(response.body);
  //       } else if (type == DevelopmentType.emotions) {
  //         model = EmotionsReputaionModel.fromJson(response.body);
  //       } else {
  //         model = ReputationModel.fromJson(response.body);
  //       }

  //       if (model.data != null) {
  //         return model.data;
  //       } else {
  //         throw AppString.somethingWentWrong;
  //       }
  //     } else {
  //       showCustomSnackBar(response.statusText);
  //       throw response.statusText.toString();
  //     }
  //   } catch (e) {
  //     String error = CommonController().getValidErrorMessage(e.toString());
  //     showCustomSnackBar(error);
  //     throw error.toString();
  //   }
  // }

  Future<dynamic> getReputationFeedbackUserList(
      Map<String, String> prm, DevelopmentType type) async {
    try {
      Response response =
          await developmentRepo.getReputationFeedbackUserList(prm);
      if (response.statusCode == 200) {
        dynamic model;

        if (type == DevelopmentType.traits ||
            type == DevelopmentType.riskFactors) {
          model = ReputationUserModel.fromJson(response.body);
        } else if (type == DevelopmentType.workSkills) {
          model = WorkSkillReputaionUserModel.fromJson(response.body);
        } else if (type == DevelopmentType.leaderStyle) {
          // model = LeaderStyleReputaionModel.fromJson(response.body);
          model = ReputationUserModel.fromJson(response.body);
        } else if (type == DevelopmentType.emotions) {
          model = EmotionsReputationUserModel.fromJson(response.body);
        } else {
          model = ReputationUserModel.fromJson(response.body);
        }

        if (model.data != null) {
          return model.data;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  Future<dynamic> getReputationFeedbackSliderList(
      Map<String, String> prm, DevelopmentType type) async {
    try {
      Response response =
          await developmentRepo.getReputationFeedbackSliderList(prm);
      if (response.statusCode == 200) {
        dynamic model;

        if (type == DevelopmentType.traits ||
            type == DevelopmentType.riskFactors) {
          model = ReputationSliderModel.fromJson(response.body);
        } else if (type == DevelopmentType.workSkills) {
          model = WorkSkillReputaionSliderModel.fromJson(response.body);
        } else if (type == DevelopmentType.leaderStyle) {
          model = LeaderStyleReputaionSliderModel.fromJson(response.body);
          // model = ReputationSliderModel.fromJson(response.body);
        } else if (type == DevelopmentType.emotions) {
          model = EmotionsReputaionSliderModel.fromJson(response.body);
        } else {
          model = ReputationSliderModel.fromJson(response.body);
        }

        if (model.data != null) {
          return model.data;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  // ============================ update self reflaction ==================================

  bool isReset = false;

  resetData() {
    isReset = true;
    update();
    Future.delayed(const Duration(seconds: 1), () {
      isReset = false;
      update();
    });
  }

  Timer? searchOnStoppedTyping;

  onDelayHandler(Function callback) {
    const duration = Duration(milliseconds: 200);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel();
    }
    searchOnStoppedTyping = Timer(duration, () {
      callback();
    });
    update();
  }

  Future<ResponseModel> updateSelfReflectDetails(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response =
        await developmentRepo.updateSelfReflectDetails(jsonData);

    if (response.statusCode == 200) {
      responseModel =
          ResponseModel(true, response.body['message'], responseT: response);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<bool?> updateSelfReflaction({
    required String styleId,
    required String userId,
    required String areaId,
    required String ratingType,
    required String markingType,
    required String stylrParentId,
    required String isMarked,

    // required SliderData sliderDdata,
    required String newScore,
    required Future Function(bool) onReaload,
    required String type,
    String? radioType,
    String? subObjIWill,
  }) async {
    Map<String, dynamic> jsonData = {
      "style_id": styleId,
      "user_id": userId,
      "area_id": areaId,
      "rating_type": ratingType,
      "marking_type": markingType,
      "style_parent_id":
          stylrParentId == "null" || stylrParentId == "" ? "0" : stylrParentId,
      "score": newScore,
      "is_marked": isMarked,
      "type": type,
      "radio_type": radioType ?? "",
      "sub_obj_i_will": subObjIWill ?? ""
    };

    try {
      buildLoading(Get.context!);
      var response = await updateSelfReflectDetails(jsonData);
      if (response.isSuccess == true) {
        await onReaload(false);
        // showCustomSnackBar(response.message, isError: false);
        return true;
      } else {
        showCustomSnackBar(response.message);
        resetData();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);

      resetData();
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  updateImportantDataUri({
    required String userId,
    required String text,
    required Future Function(bool) onReaload,
  }) async {
    Map<String, dynamic> jsonData = {
      "user_id": userId,
      "important_text": text,
    };

    try {
      buildLoading(Get.context!);

      Response response = await developmentRepo.updateImportantData(jsonData);

      if (response.statusCode == 200) {
        await onReaload(false);
        showCustomSnackBar(response.body['message'], isError: false);
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  Future<ReminderOptionData> getEmotionReminder(
      Map<String, dynamic> map) async {
    try {
      Response response = await developmentRepo.getEmotionReminder(map);
      if (response.statusCode == 200) {
        ReminderOptionModel data = ReminderOptionModel.fromJson(response.body);

        if (data.data == null) {
          throw AppString.somethingWentWrong;
        } else {
          return data.data!;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      throw message;
    }
  }

  Future<ResponseModel> saveEmotionReminder(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await developmentRepo.saveEmotionReminder(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  inviteUserReputation({
    required String firstName,
    required String lastName,
    required String email,
    required String toUser,
    required String fromUser,
    required String styleId,
    required Future Function(bool) onReaload,
  }) async {
    Map<String, dynamic> jsonData = {
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "to_user": toUser,
      "for_user_id": fromUser,
      "style_id": styleId,
    };

    try {
      buildLoading(Get.context!);

      Response response = await developmentRepo.inviteUserReputation(jsonData);

      if (response.statusCode == 200) {
        await onReaload(false);
        showCustomSnackBar(response.body['message'], isError: false);
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);

      resetData();
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  Future<bool?> shareWithSupervisor({
    required String styleId,
    required String userId,
    required String assessId,
  }) async {
    Map<String, dynamic> jsonData = {
      "style_id": styleId,
      "user_id": userId,
      "assess_id": assessId,
    };

    try {
      buildLoading(Get.context!);

      Response response = await developmentRepo.shareWithSupervisor(jsonData);

      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  Future<dynamic> enableGoal({
    required String styleId,
    required String areaId,
    required String toUser,
    required String goalSelector,
    required String markingType,
    required String dailyToBe,
    required String behaviorDesc,
    required String suggesstedObj,
    required String difference,
    required String isPrioritize,
    required BuildContext context,
    required bool isPriore,
    required String area,
  }) async {
    Map<String, dynamic> jsonData = {
      "style_id": styleId,
      "area_id": areaId,
      "to_user": toUser,
      "score": difference,
      "goal_selector": goalSelector,
      "marking_type": markingType,
      "scale_id": "0",
      "daily_to_be": dailyToBe,
      "behavior_desc": behaviorDesc,
      "suggessted_obj": suggesstedObj,
      "is_prioritize": isPrioritize,
      "start_current_score": styleId == "9" ? area : "0",
    };

    try {
      buildLoading(Get.context!);

      Response response = await developmentRepo.enableGoal(jsonData);

      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);

        if (isPriore) {
          return true;
        } else {
          return response.body['id'].toString();
        }
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  enableRecognize(
      {required String styleId,
      required String areaId,
      required String toUser,
      required String score,
      required String isRecognize,
      required String scaleId,
      required BuildContext context}) async {
    Map<String, dynamic> jsonData = {
      "style_id": styleId,
      "area_id": areaId,
      "to_user": toUser,
      "score": score,
      "scale_id": scaleId,
      "is_recognize": isRecognize
    };

    try {
      buildLoading(Get.context!);

      Response response = await developmentRepo.enableRecognize(jsonData);

      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  Future<dynamic> updateGoalButton(
      {required String userId,
      required String positionDetail,
      required String positionId,
      required String corecompetencyId,
      required String goalselector,
      required String recognizeButton,
      required String type,
      required String focusId,
      required BuildContext context,
      required bool isPriore}) async {
    Map<String, dynamic> jsonData = {
      "user_id": userId,
      "position_detail": positionDetail,
      "position_id": positionId,
      "corecompetency_id": corecompetencyId,
      "goalselector": goalselector,
      "recognizeButton": recognizeButton,
      "type": type,
      "focusId": focusId,
      "developmentId": "0"
    };

    try {
      buildLoading(Get.context!);

      Response response = await developmentRepo.updateGoalButton(jsonData);

      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        if (isPriore) {
          return true;
        } else {
          return response.body['data']['id'].toString();
        }
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  Future<GoalDetailsPopupData?> getGoalPopupDetails({
    required String goalId,
    required String styleId,
  }) async {
    try {
      Map<String, dynamic> prm = {"goal_id": goalId, "style_id": styleId};
      buildLoading(Get.context!);
      Response response = await developmentRepo.getGoalPopupDetails(prm);
      if (response.statusCode == 200) {
        GoalDetailsPopupModel model =
            GoalDetailsPopupModel.fromJson(response.body);

        if (model.data != null) {
          return model.data!;
        } else {
          showCustomSnackBar(AppString.somethingWentWrong);
        }
      } else {
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  Future<bool?> saveGoalPopupDetails({
    required String goalId,
    required String actionPlan,
    required String targetDate,
    required String objSituationalCue,
    required String isChecked,
    required String styleId,
  }) async {
    try {
      Map<String, dynamic> prm = {
        "goal_id": goalId,
        "style_id": styleId,
        "action_plan": actionPlan,
        "target_date": targetDate,
        "obj_situational_cue": objSituationalCue,
        "is_checked": isChecked,
      };
      buildLoading(Get.context!);
      Response response = await developmentRepo.saveGoalPopupDetails(prm);
      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  Future<GoalSelectorDetailsData?> geGoalSelectorDetails(
    Map<String, String> prm,
  ) async {
    try {
      Response response = await developmentRepo.geGoalSelectorDetails(prm);
      if (response.statusCode == 200) {
        var model = GoalSelectorDetailsModel.fromJson(response.body);

        if (model.data != null) {
          return model.data!;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());

      throw error.toString();
    }
  }

  // ============================ competancy ==================================

  Future<dynamic> getCompReflectDetails(
      Map<String, String> prm, CompetencyType type) async {
    try {
      Response response = await developmentRepo.getCompReflectDetails(prm);
      if (response.statusCode == 200) {
        dynamic model;

        if (type == CompetencyType.selfReflact) {
          model = CompReflectDetailsModel.fromJson(response.body);
        } else if (type == CompetencyType.targating) {
          model = CompTargattingDetailsModel.fromJson(response.body);
        } else {
          model = CompGoalDetailsModel.fromJson(response.body);
        }

        if (model.data != null) {
          return model.data;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  Future<CourseDetailsData?> courseDetails(
      String userId, String courseId) async {
    Map<String, dynamic> map = {"user_id": userId, "course_id": courseId};

    Response response = await developmentRepo.courseDetails(map);
    if (response.statusCode == 200) {
      CourseDetailsModel objectiveNoteList =
          CourseDetailsModel.fromJson(response.body);
      return objectiveNoteList.data!;
    } else {
      showCustomSnackBar(response.statusText);
      throw response.statusText.toString();
    }
  }

  Future<bool?> saveCourseQuestionAnswer(
      {required Map<String, dynamic> map}) async {
    try {
      buildLoading(Get.context!);
      Response response = await developmentRepo.saveCourseQuestionAnswer(map);
      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  updateCompentencyDetails({
    required String styleId,
    required String userId,
    required String positionDetail,
    required String positionId,
    required String scoringType,
    required String corecompetencyId,
    required String newScore,
    required Future Function(bool) onReaload,
    required String sliderType,
  }) async {
    Map<String, dynamic> jsonData = {
      "slider_type": sliderType,
      "user_id": userId,
      "style_id": styleId,
      "score": double.parse(newScore).round().toString(),
      "position_detail": positionDetail,
      "position_id": positionId,
      "scoring_type": scoringType,
      "corecompetency_id": corecompetencyId,
      "type": sliderType == "rangeSlider"
          ? "0"
          : sliderType == "new_rangeSlider"
              ? "1"
              : "2",
    };

    try {
      buildLoading(Get.context!);

      Response response =
          await developmentRepo.updateCompentencyDetails(jsonData);

      if (response.statusCode == 200) {
        await onReaload(false);

        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
        resetData();
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
        resetData();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);

      resetData();
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  // ============================ getGraphDetails ==================================

  Future<GraphDetailsData?> getGraphDetails(
    Map<String, String> prm,
  ) async {
    try {
      Response response = await developmentRepo.getGraphDetails(prm);
      if (response.statusCode == 200) {
        GraphDetailsModel model = GraphDetailsModel.fromJson(response.body);

        if (model.data != null) {
          return model.data;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  Future<GraphDetailsData?> getGraphCompentencyDetails(
    Map<String, String> prm,
  ) async {
    try {
      Response response = await developmentRepo.getGraphCompentencyDetails(prm);
      if (response.statusCode == 200) {
        GraphDetailsModel model = GraphDetailsModel.fromJson(response.body);

        if (model.data != null) {
          return model.data;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  Future<MyJourneyData?> getmyJourney(
    Map<String, String> prm,
  ) async {
    try {
      Response response = await developmentRepo.getmyJourney(prm);
      if (response.statusCode == 200) {
        MyJourneyModel model = MyJourneyModel.fromJson(response.body);

        if (model.data != null) {
          return model.data;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      throw error.toString();
    }
  }

  Future<BadgeLegendPopupData?> getBadgeLegendPopup(
      Map<String, dynamic> map) async {
    Response response = await developmentRepo.getBadgeLegendPopup(map);
    if (response.statusCode == 200) {
      BadgeLegendPopupModel data =
          BadgeLegendPopupModel.fromJson(response.body);
      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  Future<List<ShowcaseJourneyData>> journeyCertificateDetails(
      Map<String, dynamic> map) async {
    Response response = await developmentRepo.journeyCertificateDetails(map);
    if (response.statusCode == 200) {
      ShowcaseJourneyModel data = ShowcaseJourneyModel.fromJson(response.body);
      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  // development menu listing
  bool isLoadingMenu = true;
  bool isErrorMenu = false;
  String errorMsgMenu = "";

  Future<DevelopmentLeftMenuListData?> getDevelopmentList(String userId) async {
    Map<String, String> map = {
      "user_id": userId,
    };
    try {
      isLoadingMenu = true;

      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }

      Response response = await developmentRepo.developmentLeftMenuList(map);
      if (response.statusCode == 200) {
        DevelopmentLeftMenuListModel model =
            DevelopmentLeftMenuListModel.fromJson(response.body);

        if (model.data != null) {
          isErrorMenu = false;
          errorMsgMenu = "";
          return model.data;
        } else {
          isErrorMenu = true;
          errorMsgMenu = AppString.somethingWentWrong;
        }
      } else {
        isErrorMenu = true;
        errorMsgMenu = response.statusText.toString();
      }
    } catch (e) {
      isErrorMenu = true;
      String error = CommonController().getValidErrorMessage(e.toString());

      errorMsgMenu = error.toString();
    } finally {
      isLoadingMenu = false;
      update();
    }
    return null;
  }

  Future<EmotionGraphData?> emotionGraph(Map<String, dynamic> map) async {
    Response response = await developmentRepo.emotionGraph(map);
    if (response.statusCode == 200) {
      EmotionGraphModel data = EmotionGraphModel.fromJson(response.body);
      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  resetSurveyDetails({
    required String styleId,
    required String userId,
    required Function onReload,
  }) async {
    Map<String, dynamic> jsonData = {
      "user_id": userId,
      "style_id": styleId,
    };

    try {
      buildLoading(Get.context!);

      Response response = await developmentRepo.resetSurveyDetails(jsonData);

      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        onReload();
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  Future<MyJourneyGrowthChartData?> myJourneyGrowthChart(
      Map<String, dynamic> map) async {
    Response response = await developmentRepo.myJourneyGrowthChart(map);
    if (response.statusCode == 200) {
      MyJourneyGrowthChartModel data =
          MyJourneyGrowthChartModel.fromJson(response.body);
      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  Future<ProgressTrakingChartData?> getProgressTrackingChart(
      Map<String, dynamic> map) async {
    Response response = await developmentRepo.getProgressTrackingChart(map);
    if (response.statusCode == 200) {
      ProgressTrakingChartModel data =
          ProgressTrakingChartModel.fromJson(response.body);
      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  Future<bool?> clearEmotionData({
    required String id,
  }) async {
    try {
      Map<String, dynamic> prm = {
        "id": id,
      };
      buildLoading(Get.context!);
      Response response = await developmentRepo.clearEmotionData(prm);
      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }
// =========================   progress tracking   =======================

  RxList<DropDownOptionItemMenu> prograssTrackingDDList =
      <DropDownOptionItemMenu>[].obs;
  Rx<DropDownOptionItemMenu> prograssTrackingDDValue =
      DropDownOptionItemMenu(id: "", title: "").obs;

  final List<DropDownOptionItemMenu> ddList2 = [
    DropDownOptionItemMenu(id: "2", title: "Weekly (Recent 6 Weeks)"),
    DropDownOptionItemMenu(id: "3", title: "Monthly"),
  ];

  final List<DropDownOptionItemMenu> ddList3 = [
    DropDownOptionItemMenu(id: "2", title: "Weekly (Recent 6 Weeks)"),
    DropDownOptionItemMenu(id: "3", title: "Monthly"),
    DropDownOptionItemMenu(id: "4", title: "Yearly"),
  ];

  Rx<DropDownOptionItemMenu> dropDownTwoValue =
      DropDownOptionItemMenu(id: "2", title: "Weekly (Recent 6 Weeks)").obs;

  _addOption(DropDownOptionItemMenu value) {
    prograssTrackingDDList.add(value);
  }

  selectOption(DropDownOptionItemMenu option) {
    prograssTrackingDDValue.value = option;
    if ((prograssTrackingDDValue.value.title.toLowerCase() ==
            "performance reviews") ||
        (prograssTrackingDDValue.value.title.toLowerCase() ==
            "workplace performance")) {
    } else {
      if (dropDownTwoValue.value.title == "Yearly") {
        dropDownTwoValue.value = ddList2.first;
      }
    }
    getProgressTrackings(true);
  }

  selectOptionTwo(DropDownOptionItemMenu option) {
    dropDownTwoValue.value = option;
    getProgressTrackings(true);
  }

  Future<void> getProgressTrackingOptionTests() async {
    try {
      Response response =
          await developmentRepo.getProgressTrackingDropdownOptions({});
      if (response.statusCode == 200) {
        ProgressTrackingOptionModel model =
            ProgressTrackingOptionModel.fromJson(response.body);

        if (model.data != null) {
          prograssTrackingDDList.value = [];

          for (var element in model.data!) {
            _addOption(DropDownOptionItemMenu(
                id: element.value.toString(), title: element.title.toString()));
          }

          if (model.data!.isNotEmpty) {
            prograssTrackingDDValue.value = DropDownOptionItemMenu(
                id: model.data!.first.value.toString(),
                title: model.data!.first.title.toString());
          }
          return;
        } else {}
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
    update();
  }

  // Local Properties
  bool _isLoadingProgressTracking = false;
  bool _isErrorProgressTracking = false;
  String _errorMsgProgressTracking = "";
  ProgressTrakingChartData? _progressTracking;

  // Get Properties
  bool get isLoadingProgressTracking => _isLoadingProgressTracking;
  bool get isErrorProgressTracking => _isErrorProgressTracking;
  String get errorMsgProgressTracking => _errorMsgProgressTracking;
  ProgressTrakingChartData? get progressTracking => _progressTracking;

  Future<void> getProgressTrackings(bool isShowLoading) async {
    Map<String, dynamic> map = {
      "user_id":
          Get.find<ProfileSharedPrefService>().profileData.value.id.toString(),
      "chart_type": dropDownTwoValue.value.id,
      "review_type": prograssTrackingDDValue.value.id.toString(),
    };
    if (isShowLoading) {
      _isLoadingProgressTracking = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    try {
      ProgressTrakingChartData? data = await getProgressTrackingChart(map);
      _progressTracking = data;
      _updateProgressTrackingrState(false, "");
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateProgressTrackingrState(true, message);
    } finally {
      _isLoadingProgressTracking = false;
    }
    update();
  }

  _updateProgressTrackingrState(bool isError, String error) {
    if (isError) {
      _errorMsgProgressTracking = error;
    } else {
      _errorMsgProgressTracking = "";
    }
    _isErrorProgressTracking = isError;
    update();
  }
}
