import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/badge_list_model.dart';
import 'package:aspirevue/data/model/response/goals_list_model.dart';
import 'package:aspirevue/data/model/response/my_connection_user_model.dart';
import 'package:aspirevue/data/model/response/objective_note_list_model.dart';
import 'package:aspirevue/data/model/response/organization_chart_model.dart';
import 'package:aspirevue/data/model/response/organization_user_list_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/model/response/role_responsibility_model.dart';
import 'package:aspirevue/data/model/response/user_about_model.dart';
import 'package:aspirevue/data/repository/my_connections_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyConnectionController extends GetxController {
  final MyConnectionRepo myConnectionRepo;

  MyConnectionController({required this.myConnectionRepo});

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";
  List<MyConnectionUserListData> _userList = [];

  // get local properties
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMsg => _errorMsg;

  List<MyConnectionUserListData> get userList => _userList;

  Future<void> getMyConnections(Map<String, dynamic> map) async {
    _isLoading = true;
    try {
      update();
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }

    try {
      Response response = await myConnectionRepo.getConnections(map);
      if (response.statusCode == 200) {
        _isLoading = false;

        _userList = [];
        MyconnectionUserListModel insightFeedModel =
            MyconnectionUserListModel.fromJson(response.body);
        _isError = false;
        _errorMsg = "";
        if (insightFeedModel.data != null) {
          if (insightFeedModel.data!.isNotEmpty) {
            insightFeedModel.data?.forEach((element) {
              _userList.add(element);
            });
          }
        }
      } else {
        _isError = true;
        _errorMsg = response.statusText.toString();
        _isLoading = false;
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      _isError = true;
      _isLoading = false;

      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsg = error.toString();
      showCustomSnackBar(error.toString());
    } finally {
      _isLoading = false;
    }
    update();
  }

  Future<void> getColleaguesData(Map<String, dynamic> map) async {
    _isLoading = true;
    update();

    try {
      Response response = await myConnectionRepo.getColleaguesData(map);
      if (response.statusCode == 200) {
        _isLoading = false;

        _userList = [];
        MyconnectionUserListModel insightFeedModel =
            MyconnectionUserListModel.fromJson(response.body);
        _isError = false;
        _errorMsg = "";
        if (insightFeedModel.data != null) {
          if (insightFeedModel.data!.isNotEmpty) {
            insightFeedModel.data?.forEach((element) {
              _userList.add(element);
            });
          }
        }
      } else {
        _isError = true;
        _errorMsg = response.statusText.toString();
        _isLoading = false;
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      _isError = true;
      _isLoading = false;

      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsg = error.toString();
      showCustomSnackBar(error.toString());
    } finally {
      _isLoading = false;
    }
    update();
  }

  Future<void> getInfluenceList(Map<String, dynamic> map) async {
    _isLoading = true;
    update();

    try {
      Response response = await myConnectionRepo.getInfluenceList(map);
      if (response.statusCode == 200) {
        _isLoading = false;

        _userList = [];
        MyconnectionUserListModel insightFeedModel =
            MyconnectionUserListModel.fromJson(response.body);
        _isError = false;
        _errorMsg = "";
        if (insightFeedModel.data != null) {
          if (insightFeedModel.data!.isNotEmpty) {
            insightFeedModel.data?.forEach((element) {
              _userList.add(element);
            });
          }
        }
      } else {
        _isError = true;
        _errorMsg = response.statusText.toString();
        _isLoading = false;
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      _isError = true;
      _isLoading = false;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsg = error.toString();
      showCustomSnackBar(error.toString());
    } finally {
      _isLoading = false;
    }
    update();
  }

  Future<List<OrganizarionChartData>> getGrowthChart(
      Map<String, dynamic> map) async {
    try {
      Response response = await myConnectionRepo.getOrganizationChart(map);
      if (response.statusCode == 200) {
        OrganizationChartModel organizationChartModel =
            OrganizationChartModel.fromJson(response.body);

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

  Future<List<OrganizationUser>?> getGrowthUserList(
      Map<String, dynamic> map) async {
    Response response = await myConnectionRepo.getOrganizationUser(map);
    if (response.statusCode == 200) {
      OrganizationUserListModel userListModel =
          OrganizationUserListModel.fromJson(response.body);

      return userListModel.data;
    } else {
      showCustomSnackBar(response.statusText);
      return [];
    }
  }

  Future<UserAboutData?> getUserAboutData(Map<String, dynamic> map) async {
    Response response = await myConnectionRepo.getUserAboutData(map);
    if (response.statusCode == 200) {
      UserAboutModel userListModel = UserAboutModel.fromJson(response.body);

      return userListModel.data;
    } else {
      showCustomSnackBar(response.statusText);
      throw response.statusText.toString();
    }
  }

  Future<ResponseModel> removeAsCommunityUser(String userId) async {
    Map<String, dynamic> map = {"user_id": userId};
    ResponseModel responseModel;
    Response response = await myConnectionRepo.removeAsCommunityUser(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> createColleague(Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.createColleague(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> removeAsColleagueUser(String userId) async {
    Map<String, dynamic> map = {"user_id": userId};
    ResponseModel responseModel;
    Response response = await myConnectionRepo.removeAsColleagueUser(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ObjectiveNoteListData?> getObjectiveNoteList(
      Map<String, dynamic> map) async {
    Response response = await myConnectionRepo.getObjectiveNoteList(map);
    if (response.statusCode == 200) {
      ObjectiveNoteListModel objectiveNoteList =
          ObjectiveNoteListModel.fromJson(response.body);
      return objectiveNoteList.data;
    } else {
      showCustomSnackBar(response.statusText);
      throw response.statusText.toString();
    }
  }

  Future<List<GoalsData>?> getGoalsList(String userId) async {
    Map<String, dynamic> map = {"user_id": userId};

    Response response = await myConnectionRepo.getGoalsList(map);
    if (response.statusCode == 200) {
      GoalsListModel objectiveNoteList = GoalsListModel.fromJson(response.body);
      return objectiveNoteList.data!;
    } else {
      showCustomSnackBar(response.statusText);
      throw response.statusText.toString();
    }
  }

  Future<List<RolesAndResponsibilityData>> getMenteeRoleResponsibility(
      String userId) async {
    Map<String, dynamic> map = {"mentee_id": userId};

    Response response = await myConnectionRepo.getMenteeRoleResponsibility(map);
    if (response.statusCode == 200) {
      RolesAndResponsibilityModel objectiveNoteList =
          RolesAndResponsibilityModel.fromJson(response.body);
      return objectiveNoteList.data!;
    } else {
      showCustomSnackBar(response.statusText);
      throw response.statusText.toString();
    }
  }

  Future<ResponseModel> sendMessage(Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.sendMessage(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<List<BadgeData>> getAssessmentBadgesDetail(
      Map<String, dynamic> map) async {
    Response response = await myConnectionRepo.getAssessmentBadgesDetail(map);
    if (response.statusCode == 200) {
      BadgeListModel data = BadgeListModel.fromJson(response.body);
      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }
}
