import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class MainRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  MainRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> insightFeed(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.insightFeedUri, map);
  }

  Future<Response> getMyworkplaceMenuList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getWorkplaceMenuListUri, map);
  }

  Future<Response> getAllCountries(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getAllCountriesUri, map);
  }

  Future<Response> getStateTimeZoneList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getStateTimeZoneListUri, map);
  }

  Future<Response> getMyProfile(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getMyProfileUri, map);
  }

  Future<Response> updatePersonalInfo(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updatePersonalInfoUri, map);
  }

  Future<Response> changePassword(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.changePasswordUri, map);
  }

  Future<Response> getNotificationSettings(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getNotificationSettingsUri, map);
  }

  Future<Response> updateNotificationSettings(
      Map<String, dynamic> jsonData) async {
    return await apiClient.postData(
        AppConstants.updateNotificationSettingsUri, jsonData,
        isJson: true);
  }

  Future<Response> getPrivacySettings(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getPrivacySettingsUri, map);
  }

  Future<Response> updatePrivacySettings(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updatePrivacySettingsUri, map);
  }

  Future<Response> uploadCoverPicture(File image) async {
    return await apiClient.httpPostWithImageUploadMultiple(
        AppConstants.uploadCoverPictureUri, [image], {},
        parameterName: ['coverimagebase64']);
  }

  Future<Response> uploadProfilePicture(File image) async {
    return await apiClient.httpPostWithImageUploadMultiple(
        AppConstants.uploadProfilePictureUri, [image], {},
        parameterName: ['Image']);
  }

  Future<Response> getConnectionSettings(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getConnectionSettingsUri, map);
  }

  Future<Response> updateConnectionSettings(Map<String, dynamic> map) async {
    return await apiClient
        .postData(AppConstants.updateConnectionSettingsUri, map, isJson: true);
  }

  Future<Response> getSignature(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getSignatureUri, map);
  }

  Future<Response> updateSignature(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateSignatureUri, map);
  }

  Future<Response> getIntegrationData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getIntegrationDataUri, map);
  }

  Future<Response> updateIntegrationData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateIntegrationDataUri, map);
  }

  Future<Response> getAssignedTests(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getAssignedTestsUri, map);
  }

  Future<Response> saveAssessmentLink(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveAssessmentLinkUri, map);
  }

  Future<Response> getHabitJournalBulletsDetail(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getHabitJournalBulletsDetailUri, map);
  }

  Future<Response> saveHabitBullet(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveHabitBulletUri, map);
  }

  Future<Response> saveJournalData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveJournalDataUri, map);
  }

  Future<Response> deleteHabitJournalReminder(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.deleteHabitJournalReminderUri, map);
  }

  Future<Response> getDailyqHabitJournalHistory(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getDailyqHabitJournalHistoryUri, map);
  }

  Future<Response> getdailyqhabitJournaleminder(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getdailyqhabitJournaleminderUri, map);
  }

  Future<Response> savedailyqhabitJournaleminder(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.savedailyqhabitJournaleminderUri, map);
  }

  Future<Response> getActionItems(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getActionItemsUri, map);
  }

  Future<Response> deleteReceiveFeedbackUser(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.deleteReceiveFeedbackUserUri, map);
  }

  Future<Response> getForumPollQuestionAnswer(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getForumPollQuestionAnswerUri, map);
  }

  Future<Response> showAllForumPolls(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.showAllForumPollsUri, map);
  }

  Future<Response> addAnswer(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.addAnswerUri, map);
  }

  Future<Response> viewResponse(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.viewResponseUri, map);
  }

  Future<Response> viewQuestionAnswerDetail(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.viewQuestionAnswerDetailUri, map);
  }

  Future<Response> suggestQuestion(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.suggestQuestionUri, map);
  }

  Future<Response> addRemoveReminderTag(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.addRemoveReminderTagUri, map);
  }

  Future<Response> getDashboardVideoQuickLinkDetails(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getDashboardVideoQuickLinkDetailsUri, map);
  }

  Future<Response> updateToViewQuickLinks(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateToViewQuickLinksUri, map,
        isJson: true);
  }

  Future<Response> myLearning(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.myLearningUri, map);
  }

  Future<Response> updateMyChecklist(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateMyChecklistUri, map);
  }

  Future<Response> saveSupportData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveSupportDataUri, map);
  }

  Future<Response> getWelcomeHashtags(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getWelcomeHashtagsUri, map);
  }

  Future<Response> getCommonData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getCommonDataUri, map);
  }

  Future<Response> allowNotification(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.allowNotificationUri, map);
  }

  Future<Response> notificationList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.notificationListUri, map);
  }

  Future<Response> clearAll(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.clearAllUri, map);
  }

  Future<Response> readAll(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.readAllUri, map);
  }

  Future<Response> archiveInbox(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.archiveInboxUri, map);
  }

  Future<Response> updateUserDeviceToken(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateUserDeviceTokenUri, map);
  }

  Future<Response> updateTourOverlayFlag(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateTourOverlayFlagUri, map);
  }

  Future<Response> acceptDeclineGlobalInvitation(
      Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.acceptDeclineGlobalInvitationUri, map);
  }
}
