import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/development/course_details_model.dart';
import 'package:aspirevue/data/model/response/enterprise/enterprise_model.dart';
import 'package:aspirevue/data/model/response/enterprise/news_details_model.dart';
import 'package:aspirevue/data/model/response/enterprise/news_list_model.dart';
import 'package:aspirevue/data/repository/enterprise_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterpriseController extends GetxController {
  final EnterpriseRepo enterPriseRepo;
  EnterpriseController({required this.enterPriseRepo});

  bool _isLoadingEnterPrise = false;
  bool _isErrorEnterPrise = false;
  String _errorMsgEnterPrise = "";
  EnterPriseData? _enterPriseData;

  bool get isLoadingEnterPrise => _isLoadingEnterPrise;
  bool get isErrorEnterPrise => _isErrorEnterPrise;
  String get errorMsgEnterPrise => _errorMsgEnterPrise;
  EnterPriseData? get enterPriseData => _enterPriseData;

  Future<void> getEnterPriseDetails(
      bool isShowLoading, String enterpriseId) async {
    if (isShowLoading) {
      _isLoadingEnterPrise = true;
      update();
    }

    try {
      Response response = await enterPriseRepo.getEnterpriseDetails({
        "enterprise_id": enterpriseId,
      });
      if (response.statusCode == 200) {
        EnterPriseModel data = EnterPriseModel.fromJson(response.body);
        _enterPriseData = data.data!;
        _updateEnterPrise(false, "");
      } else {
        _updateEnterPrise(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateEnterPrise(true, error);
    } finally {
      if (isShowLoading) {
        _isLoadingEnterPrise = false;
      }
      update();
    }
  }

  _updateEnterPrise(bool isError, String error) {
    if (isError) {
      _errorMsgEnterPrise = error;
    } else {
      _errorMsgEnterPrise = "";
    }
    _isErrorEnterPrise = isError;
    update();
  }

// ------------------ news listing code with pagination ------------------

  bool _isLoadingNews = false;
  bool _isErrorNews = false;
  String _errorMsgNews = "";
  List<EnterpriseNews> _newsList = [];

  bool get isLoadingNews => _isLoadingNews;
  bool get isErrorNews => _isErrorNews;
  String get errorMsgNews => _errorMsgNews;
  List<EnterpriseNews> get newsList => _newsList;
  final int pageCount = 10;
  int _pageNumber = 1;

  bool _isLoadMoreRunningNews = false;
  bool _isnotMoreDataNews = false;

  bool get isLoadMoreRunningNews => _isLoadMoreRunningNews;
  bool get isnotMoreDataNews => _isnotMoreDataNews;
  int get pageNumber => _pageNumber;

  setPageNumber(int newPageNumber) {
    _pageNumber = newPageNumber;
    update();
  }

  Future<void> newsListing(bool isInit, String enterPriseId) async {
    if (isInit) {
      _newsList = [];
      _isLoadingNews = true;
      _isnotMoreDataNews = false;
      _pageNumber = 1;
      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    } else {
      _isLoadMoreRunningNews = true;
      update();
    }

    Map<String, dynamic> map = {
      "enterprise_id": enterPriseId,
      "count": pageCount.toString(),
      "pagenum": _pageNumber.toString(),
    };
    try {
      Response response = await enterPriseRepo.newsListing(map);
      if (response.statusCode == 200) {
        NewsListModel insightFeedModel = NewsListModel.fromJson(response.body);
        if (insightFeedModel.data != null) {
          if (insightFeedModel.data != null) {
            if (insightFeedModel.data!.isNotEmpty) {
              insightFeedModel.data?.forEach((element) {
                _newsList.add(element);
              });
            } else {
              _isnotMoreDataNews = true;
            }
            _updateNewsErrorState(false, "");
          } else {
            _updateNewsErrorState(true, AppString.somethingWentWrong);
          }
        } else {
          _updateNewsErrorState(true, AppString.somethingWentWrong);
        }
      } else if (response.statusCode == 401) {
        throw AppString.unAuthorizedAccess;
      } else {
        _updateNewsErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateNewsErrorState(true, error.toString());
    } finally {
      _isLoadingNews = false;
      _isLoadMoreRunningNews = false;
      update();
    }
  }

  _updateNewsErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgNews = error;
    } else {
      _errorMsgNews = "";
    }
    _isErrorNews = isError;
    update();
  }

  // ---------------------------- News Details Data ----------------------------

  bool _isLoadingNewsDetails = false;
  bool _isErrorNewsDetails = false;
  String _errorMsgNewsDetails = "";
  NewsDetailsData? _newsDetailsData;

  bool get isLoadingNewsDetails => _isLoadingNewsDetails;
  bool get isErrorNewsDetails => _isErrorNewsDetails;
  String get errorMsgNewsDetails => _errorMsgNewsDetails;
  NewsDetailsData? get newsDetailsData => _newsDetailsData;

  Future<void> newsDetails(bool isShowLoading, String newsId) async {
    if (isShowLoading) {
      _isLoadingNewsDetails = true;
      try {
        await Future.delayed(const Duration(milliseconds: 1)); // use await
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    }

    try {
      Response response = await enterPriseRepo.newsDetails({
        "news_id": newsId,
      });
      if (response.statusCode == 200) {
        NewsDetailsModel data = NewsDetailsModel.fromJson(response.body);
        _newsDetailsData = data.data!;
        _updateNewsDetails(false, "");
      } else {
        _updateNewsDetails(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateNewsDetails(true, error);
    } finally {
      if (isShowLoading) {
        _isLoadingNewsDetails = false;
      }
      update();
    }
  }

  _updateNewsDetails(bool isError, String error) {
    if (isError) {
      _errorMsgNewsDetails = error;
    } else {
      _errorMsgNewsDetails = "";
    }
    _isErrorNewsDetails = isError;
    update();
  }

  // ---------------------------- Course Details ----------------------------

  Future<CourseDetailsData?> enterpriseCourseDetails(
      String courseId, String courseType) async {
    Map<String, dynamic> map = {
      "course_id": courseId,
      "course_type": courseType // (0 => enterprise, 1 => global)
    };

    try {
      Response response = await enterPriseRepo.enterpriseCourseDetails(map);
      if (response.statusCode == 200) {
        CourseDetailsModel objectiveNoteList =
            CourseDetailsModel.fromJson(response.body);
        return objectiveNoteList.data!;
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
      throw e.toString();
    }
  }

  Future<bool?> saveQuizQuestionAnswer(
      {required Map<String, dynamic> map}) async {
    try {
      buildLoading(Get.context!);
      Response response = await enterPriseRepo.saveQuizQuestionAnswer(map);
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

  Future<bool?> addToCartCourse({required Map<String, dynamic> map}) async {
    try {
      buildLoading(Get.context!);
      Response response = await enterPriseRepo.addToCartCourse(map);
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

  Future<bool?> followEnterprise({required Map<String, dynamic> map}) async {
    try {
      // buildLoading(Get.context!);
      Response response = await enterPriseRepo.followEnterprise(map);
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
      // Navigator.pop(Get.context!);
    }
    return null;
  }

  Future<bool?> addNewsComment({
    required Map<String, dynamic> map,
    required Function onReload,
  }) async {
    try {
      buildLoading(Get.context!);
      Response response = await enterPriseRepo.addNewsComment(map);
      if (response.statusCode == 200) {
        await onReload();
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
}
