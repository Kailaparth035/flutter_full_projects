import 'package:aspirevue/data/api/api_client.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterpriseRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  EnterpriseRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getEnterpriseDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getEnterpriseDetailsUri, map);
  }

  Future<Response> newsListing(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.newsListingUri, map);
  }

  Future<Response> newsDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.newsDetailsUri, map);
  }

  Future<Response> enterpriseCourseDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.enterpriseCourseDetailsUri, map);
  }

  Future<Response> saveQuizQuestionAnswer(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.saveQuizQuestionAnswerUri, map,
        isJson: true);
  }

  Future<Response> addToCartCourse(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.addToCartCourseUri, map);
  }

  Future<Response> followEnterprise(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.followEnterpriseUri, map);
  }

  Future<Response> addNewsComment(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.addNewsCommentUri, map);
  }
}
