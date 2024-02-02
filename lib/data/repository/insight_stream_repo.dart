import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class InsightStreamRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  InsightStreamRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> insightFeed(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.insightFeedUri, map);
  }

  Future<Response> getHashTagListing(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getHashTagListingUri, map);
  }

  Future<Response> addStarRating(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.addStarRatingUri, map);
  }

  Future<Response> savePost(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.savePostUri, map);
  }

  Future<Response> hidePost(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.hidePostUri, map);
  }

  Future<Response> hideAllPost(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.hideAllPostUri, map);
  }

  Future<Response> followUnfollowUser(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.followUnfollowUserUri, map);
  }

  Future<Response> blockUnblock(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.blockUnblockUri, map);
  }

  Future<Response> reportPost(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.reportPostUri, map);
  }

  Future<Response> sharePost(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.sharePostUri, map);
  }

  Future<Response> getCommentDetail(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getCommentDetailUri, map);
  }

  Future<Response> addAsColleague(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.addAsColleagueUri, map);
  }

  Future<Response> addComment(
      {required List<File> imageFileList,
      required List<String> parameterName,
      required Map<String, dynamic> map}) async {
    return await apiClient.httpPostWithImageUploadMultipleArray(
        AppConstants.addCommentUri, imageFileList, map,
        parameterName: parameterName);
  }

  Future<Response> followedHashtagList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.followedHashtagListUri, map);
  }

  Future<Response> searchUserHashtagList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.searchUserHashtagListUri, map);
  }

  Future<Response> getOtherUserProfileDetail(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getOtherUserProfileDetailUri, map);
  }

  Future<Response> getOtherUserInsightFeeds(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.getOtherUserInsightFeedsUri, map);
  }

  Future<Response> myInsightFeedList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.myInsightFeedListUri, map);
  }

  Future<Response> savedPostDetail(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.savedPostDetailUri, map);
  }

  Future<Response> getPeopleUserList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getPeopleUserListUri, map);
  }

  Future<Response> getFeelingList(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getFeelingListUri, map);
  }

  Future<Response> uploadMediaForPost(
      {required List<File> imageFileList,
      required List<String> parameterName,
      required Map<String, dynamic> map}) async {
    return await apiClient.httpPostWithImageUploadMultipleArray(
        AppConstants.uploadPostImageVideoFilesUri, imageFileList, map,
        parameterName: parameterName);
  }

  Future<Response> createPost(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.createPostUri, map,
        isJson: true);
  }

  Future<Response> removePost(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.removePostUri, map);
  }

  Future<Response> getHashtags(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getHashtagsUri, map);
  }

  Future<Response> getPostDetailData(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getCreatePostDetailUri, map);
  }

  Future<Response> followHashtag(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.followHashtagUri, map);
  }

  Future<Response> getFollowersCount(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getFollowersCountUri, map);
  }
}
