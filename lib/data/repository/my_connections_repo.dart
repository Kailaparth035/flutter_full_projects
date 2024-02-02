import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class MyConnectionRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  MyConnectionRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getConnections(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.myconnectionUserListUri, map);
  }

  Future<Response> getOrganizationChart(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getUserOrganizationChartUri, map);
  }

  Future<Response> getOrganizationUser(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.searchOrganizationUserUri, map);
  }

  Future<Response> getUserAboutData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getUserAboutInfoUri, map);
  }

  Future<Response> getObjectiveNoteList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getObjectiveNoteListUri, map);
  }

  Future<Response> sendMessage(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.sendMessageUri, map);
  }

  Future<Response> getGoalsList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getGoalDataUri, map);
  }

  Future<Response> removeAsCommunityUser(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.removeAsCommunityUserUri, map);
  }

  Future<Response> removeAsColleagueUser(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.removeAsColleagueUri, map);
  }

  Future<Response> getColleaguesData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getColleaguesListUri, map);
  }

  Future<Response> getInfluenceList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getInfluenceListUri, map);
  }

  Future<Response> getGrowthCommunityList(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getGrowthCommunityListUri, map);
  }

  Future<Response> getContactListUri(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getContactListUri, map);
  }

  Future<Response> userFollowUnfollow(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.userFollowUnfollowUri, map);
  }

  Future<Response> promoteToGlobalColleague(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.promoteToGlobalColleagueUri, map);
  }

  Future<Response> getMyCoachesList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getMyCoachesListUri, map);
  }

  Future<Response> getMentorsList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getMentorsListUri, map);
  }

  Future<Response> getMenteesList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getMenteesListUri, map);
  }

  Future<Response> getCoachMentorMenteeDetailsUri(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getCoachMentorMenteeDetailsUri, map);
  }

  Future<Response> updateSignatureItem(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateSignatureItemUri, map);
  }

  Future<Response> createColleague(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.createColleagueUri, map);
  }

  Future<Response> getMenteeRoleResponsibility(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getMenteeRoleResponsibilityUri, map);
  }

  Future<Response> getGoalFollowers(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getGoalFollowersUri, map);
  }

  Future<Response> getMyGoalsListing(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getMyGoalsListingUri, map);
  }

  Future<Response> updateCoachMentorMenteeActionItem(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.updateCoachMentorMenteeActionItemUri, map);
  }

  Future<Response> createGoal(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.createGoalUri, map,
        isJson: true);
  }

  Future<Response> goalDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.goalDetailsUri, map);
  }

  Future<Response> updateGoalDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateGoalDetailsUri, map,
        isJson: true);
  }

  Future<Response> archiveGoal(Map<String, dynamic> map) async {
    return await apiClient.postData(
      AppConstants.archiveGoalUri,
      map,
    );
  }

  Future<Response> getGoalMessages(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getGoalMessagesUri, map);
  }

  Future<Response> sendGoalMessage(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.sendGoalMessageUri, map);
  }

  Future<Response> getCoacheeList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getCoacheeListUri, map);
  }

  Future<Response> updateCoacheeActiveArchive(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.updateCoacheeActiveArchiveUri, map);
  }

  Future<Response> saveDailyQ(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveDailyQUri, map);
  }

  Future<Response> getGoalFeedback(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getGoalFeedbackUri, map);
  }

//  remaining
  Future<Response> saveFollowers(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveFollowersUri, map,
        isJson: true);
  }

  Future<Response> deleteFollowers(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.deleteFollowersUri, map);
  }

  Future<Response> getDailyqHistory(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getDailyqHistoryUri, map);
  }

  Future<Response> saveGatherFeedback(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveGatherFeedbackUri, map,
        isJson: true);
  }

  Future<Response> deleteEvent(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.deleteEventUri, map);
  }

  Future<Response> getGoalObjectiveDetail(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getGoalObjectiveDetailUri, map);
  }

  Future<Response> getGoalReminder(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getGoalReminderUri, map);
  }

  Future<Response> saveGoalReminder(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveGoalReminderUri, map);
  }

  Future<Response> getAssessmentBadgesDetail(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getAssessmentBadgesDetailUri, map);
  }

  Future<Response> importContacts(List<dynamic> map) async {
    return await apiClient.postDataWithList(AppConstants.importContactsUri, map,
        isJson: true);
  }

  Future<Response> inviteContact(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.inviteContactUri, map);
  }
}
