import 'package:aspirevue/data/api/api_client.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevelopmentRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  DevelopmentRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> existdevelopmentMenu(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.existdevelopmentMenuUri, map);
  }

  Future<Response> getSelfReflectDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getSelfReflectDetailsUri, map);
  }

  Future<Response> getAssessDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getAssessmentDetailsUri, map);
  }

  Future<Response> getTargetingDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getTargetingDetailsUri, map);
  }

  Future<Response> getGoalAchievementsDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getGoalAchievementsDetailsUri, map);
  }

  Future<Response> getReputationFeedbackDetails(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getReputationFeedbackDetailsUri, map);
  }

  Future<Response> updateSelfReflectDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.updateSelfReflectDetailsUri, map);
  }

  Future<Response> inviteUserReputation(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.inviteUserReputationUri, map);
  }

  Future<Response> shareWithSupervisor(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.shareWithSupervisorUri, map);
  }

  Future<Response> enableGoal(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.enableGoalUri, map);
  }

  Future<Response> getGoalPopupDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getGoalPopupDetailsUri, map);
  }

  Future<Response> saveGoalPopupDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveGoalPopupDetailsUri, map);
  }

  Future<Response> geGoalSelectorDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.geGoalSelectorDetailsUri, map);
  }

  Future<Response> eLearningDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.eLearningDetailsUri, map);
  }

  Future<Response> getCompReflectDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getCompReflectDetailsUri, map);
  }

  Future<Response> courseDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.courseDetailsUri, map);
  }

  Future<Response> saveCourseQuestionAnswer(Map<String, dynamic> map) async {
    return await apiClient
        .postData(AppConstants.saveCourseQuestionAnswerUri, map, isJson: true);
  }

  Future<Response> updateCompentencyDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.updateCompentencyDetailsUri, map);
  }

  Future<Response> getGraphDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getGraphDetailsUri, map);
  }

  Future<Response> getGraphCompentencyDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getGraphCompentencyDetailsUri, map);
  }

  Future<Response> updateGoalButton(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateGoalButtonUri, map);
  }

  Future<Response> getmyJourney(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getmyJourneyUri, map);
  }

  Future<Response> enableRecognize(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.enableRecognizeUri, map);
  }

  Future<Response> getBadgeLegendPopup(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getBadgeLegendPopupUri, map);
  }

  Future<Response> emotionGraph(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.emotionGraphUri, map);
  }

  Future<Response> developmentLeftMenuList(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.developmentLeftMenuListUri, map);
  }

  Future<Response> resetSurveyDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.resetSurveyDetailsUri, map);
  }

  Future<Response> myJourneyGrowthChart(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.myJourneyGrowthChartUri, map);
  }

  Future<Response> getProgressTrackingChart(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getProgressTrackingChartUri, map);
  }

  Future<Response> updateImportantData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateImportantDataUri, map);
  }

  Future<Response> getEmotionReminder(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getEmotionReminderUri, map);
  }

  Future<Response> saveEmotionReminder(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveEmotionReminderUri, map);
  }

  Future<Response> clearEmotionData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.clearEmotionDataUri, map);
  }

  Future<Response> getProgressTrackingDropdownOptions(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getProgressTrackingDropdownOptionsUri, map);
  }

  Future<Response> journeyCertificateDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.journeyCertificateDetailsUri, map);
  }

  Future<Response> getReputationFeedbackUserList(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getReputationFeedbackUserListUri, map);
  }

  Future<Response> getReputationFeedbackSliderList(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getReputationFeedbackSliderListUri, map);
  }
}
