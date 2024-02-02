import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/dailyq_history_model.dart';
import 'package:aspirevue/data/model/response/edit_objective_model.dart';
import 'package:aspirevue/data/model/response/followes_model.dart';
import 'package:aspirevue/data/model/response/goal_messages_model.dart';
import 'package:aspirevue/data/model/response/goals_list_model.dart';
import 'package:aspirevue/data/model/response/manage_follower_model.dart';
import 'package:aspirevue/data/model/response/reminder_option_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/repository/my_connections_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class MyGoalController extends GetxController {
  final MyConnectionRepo myConnectionRepo;
  MyGoalController({required this.myConnectionRepo});

  // pagination prms

  int pageNo = 1;
  int pageCount = 10;

  bool isLoading1 = false;
  bool isLoadMoreRunning = false;
  bool isnotMoreData = false;

  bool isError1 = false;
  String errorMessage = "";

  List<GoalsData>? goalList = [];

  Future<void> getMyGoal(
    bool isInit,
  ) async {
    if (isInit) {
      goalList = [];
      isnotMoreData = false;
      isLoading1 = true;

      pageNo = 1;
    } else {
      isLoadMoreRunning = true;
    }
    try {
      update();
    } catch (e) {
      debugPrint(e.toString());
    }

    Map<String, dynamic> map = {
      "pagenum": pageNo.toString(),
      "count": pageCount.toString()
    };
    try {
      Response response = await myConnectionRepo.getMyGoalsListing(map);

      if (response.statusCode == 200) {
        GoalsListModel model = GoalsListModel.fromJson(response.body);

        if (model.data != null) {
          isError1 = false;

          if (model.data!.isNotEmpty) {
            if (isInit) {
              goalList = [];
            }

            for (var item in model.data!) {
              goalList!.add(item);
            }
          } else {
            isnotMoreData = true;
          }
        } else {
          isError1 = true;
          errorMessage = AppString.noDataFound;
        }
      } else {
        isError1 = true;
        errorMessage = response.statusText.toString();
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      isError1 = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      errorMessage = error.toString();
      showCustomSnackBar(error.toString());
    } finally {
      isLoading1 = false;
      isLoadMoreRunning = false;
    }
    update();
  }

  Future<ResponseModel> addEditMyGoal(Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.createGoal(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<List<GoalFollowersData>> getGoalFollowers(
      Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.getGoalFollowers(map);
      if (response.statusCode == 200) {
        GoalFollowersModel organizationChartModel =
            GoalFollowersModel.fromJson(response.body);

        return organizationChartModel.data!;
      } else {
        showCustomSnackBar(response.statusText);

        return [];
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
      return [];
    }
  }

  Future<EditObjectiveData?> getGoalObjectiveDetail(
      Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.getGoalObjectiveDetail(map);
      if (response.statusCode == 200) {
        EditObjectiveModel organizationChartModel =
            EditObjectiveModel.fromJson(response.body);

        return organizationChartModel.data!;
      } else {
        showCustomSnackBar(response.statusText);
        return null;
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
      return null;
    }
  }

  Future<Response> getGoalDetails(Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.goalDetails(map);
      if (response.statusCode == 200) {
        return response;
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    }
  }

  // ================ update goal ====================

  Future<ResponseModel> updateGoalDetails(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.updateGoalDetails(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // archive goal
  Future<ResponseModel> archiveGoal(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.archiveGoal(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

// goal message
  Future<List<GoalMessage>?> getGoalMessages(Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.getGoalMessages(map);
      if (response.statusCode == 200) {
        GoalMessagesModel organizationChartModel =
            GoalMessagesModel.fromJson(response.body);
        return organizationChartModel.data;
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    }
  }

  Future<ResponseModel> sendGoalMessage(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.sendGoalMessage(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> saveDailyQ(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.saveDailyQ(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

// manage Follower
  Future<ManageFollowerData> getGoalFeedback(Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.getGoalFeedback(map);
      if (response.statusCode == 200) {
        ManageFollowerModel data = ManageFollowerModel.fromJson(response.body);

        if (data.data == null) {
          throw AppString.somethingWentWrong;
        } else {
          return data.data!;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    }
  }

// remaining
  Future<ResponseModel> saveFollowers(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.saveFollowers(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> deleteFollowers(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.deleteFollowers(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<List<DailyQData>> getDailyqHistory(Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.getDailyqHistory(map);
      if (response.statusCode == 200) {
        DailyQHistoryModel data = DailyQHistoryModel.fromJson(response.body);

        if (data.data == null) {
          throw AppString.somethingWentWrong;
        } else {
          return data.data!;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    }
  }

  Future<ResponseModel> saveGatherFeedback(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.saveGatherFeedback(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> deleteEvent(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.deleteEvent(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ReminderOptionData> getGoalReminder(Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.getGoalReminder(map);
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
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    }
  }

  Future<ResponseModel> saveGoalReminder(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.saveGoalReminder(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // Future<List<ProgressTrackingOptionData>>
  //     getProgressTrackingDropdownOptions() async {
  //   try {
  //     Response response =
  //         await myConnectionRepo.getProgressTrackingDropdownOptions({});
  //     if (response.statusCode == 200) {
  //       ProgressTrackingOptionModel organizationChartModel =
  //           ProgressTrackingOptionModel.fromJson(response.body);
  //       if (organizationChartModel.data != null) {
  //         return organizationChartModel.data!;
  //       } else {
  //         return [];
  //       }
  //     } else {
  //       showCustomSnackBar(response.statusText);
  //       return [];
  //     }
  //   } catch (e) {
  //     String error = CommonController().getValidErrorMessage(e.toString());
  //     showCustomSnackBar(error.toString());
  //     return [];
  //   }
  // }
}
