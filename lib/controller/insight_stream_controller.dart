import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/comment_list_model.dart';
import 'package:aspirevue/data/model/response/feeling_list_model.dart';
import 'package:aspirevue/data/model/response/follower_count_model.dart';
import 'package:aspirevue/data/model/response/global_search_model.dart';
import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/data/model/response/other_user_model.dart';
import 'package:aspirevue/data/model/response/post_detail_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/model/response/user_search_list_model.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/insight_feed_model.dart';
import '../data/repository/insight_stream_repo.dart';

class InsightStreamController extends GetxController {
  final InsightStreamRepo insightStreamRepo;

  InsightStreamController({required this.insightStreamRepo});

  bool _isLoadingInsightStream = false;
  bool _isErrorInsightStream = false;
  String _errorMsgInsightStream = "";
  List<Record> _insightFeedList = [];

  bool get isLoadingInsightStream => _isLoadingInsightStream;
  bool get isErrorInsightStream => _isErrorInsightStream;
  String get errorMsgInsightStream => _errorMsgInsightStream;
  List<Record> get insightFeedList => _insightFeedList;

  void setLoading(bool value) {
    _isLoadingInsightStream = value;
    update();
  }

  removePostFromList(String postId) {
    _insightFeedList.removeWhere((element) => element.id.toString() == postId);
    update();
  }

  final int pageCount = 10;
  int pageNumber = 1;
  bool isLoadMoreRunning = false;
  bool isnotMoreData = false;

  Future<void> getInsightFeed(bool isInit) async {
    if (isInit) {
      _insightFeedList = [];
      _isLoadingInsightStream = true;
      isnotMoreData = false;
      pageNumber = 1;
      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    } else {
      isLoadMoreRunning = true;
      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    }

    Map<String, dynamic> map = {
      "count": pageCount.toString(),
      "pagenum": pageNumber.toString(),
    };
    try {
      Response response = await insightStreamRepo.insightFeed(map);
      if (response.statusCode == 200) {
        InsightFeedModel insightFeedModel =
            InsightFeedModel.fromJson(response.body);
        if (insightFeedModel.data != null) {
          if (insightFeedModel.data?.record != null) {
            if (insightFeedModel.data!.record!.isNotEmpty) {
              insightFeedModel.data?.record?.forEach((element) {
                _insightFeedList.add(element);
              });
            } else {
              isnotMoreData = true;
            }
            _updateInsightStreamErrorState(false, "");
          } else {
            _updateInsightStreamErrorState(true, AppString.somethingWentWrong);
          }
        } else {
          _updateInsightStreamErrorState(true, AppString.somethingWentWrong);
        }
      } else if (response.statusCode == 401) {
        throw AppString.unAuthorizedAccess;
      } else {
        _updateInsightStreamErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateInsightStreamErrorState(true, error.toString());
    } finally {
      _isLoadingInsightStream = false;
      isLoadMoreRunning = false;
      update();
    }
  }

  _updateInsightStreamErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgInsightStream = error;
    } else {
      _errorMsgInsightStream = "";
    }
    _isErrorInsightStream = isError;
    update();
  }

  // ============= save rating ================

  Future<ResponseModel> addStarRating(String postId, String value) async {
    Map<String, dynamic> requestPrm = {
      "post_id": postId,
      "value": value,
    };
    ResponseModel responseModel;
    Response response = await insightStreamRepo.addStarRating(requestPrm);
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

  setRating(String postId, Response respose, String count) {
    List<Record> records = _insightFeedList
        .where((element) => element.id.toString() == postId.toString())
        .toList();

    if (records.isNotEmpty) {
      int index = _insightFeedList.indexOf(records.first);

      _insightFeedList[index].postStarRatingAvg =
          respose.body['avg'].toString();

      _insightFeedList[index].postStarRatingCount =
          respose.body['count'].toString();

      _insightFeedList[index].postStarRating = count;

      update();
    }
  }

  // ======================= save Post ========================
  Future<ResponseModel> savePost(
      String postId, int valueToUpdateInApi, int valueToUpdateInLocal) async {
    Map<String, dynamic> requestPrm = {
      "savetype": valueToUpdateInApi.toString().trim(),
      "postId": postId.trim(),
    };
    ResponseModel responseModel;
    Response response = await insightStreamRepo.savePost(requestPrm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  setSavedPost(String postId, int valueToUpdateInLocal) {
    List<Record> records = _insightFeedList
        .where((element) => element.id.toString() == postId.toString())
        .toList();

    if (records.isNotEmpty) {
      int index = _insightFeedList.indexOf(records.first);
      _insightFeedList[index].isPostSaved = valueToUpdateInLocal;
      update();
    }
  }

  // ======================= hide Post ========================
  Future<ResponseModel> hidePost(String postId) async {
    Map<String, dynamic> requestPrm = {
      "postId": postId,
    };
    ResponseModel responseModel;
    Response response = await insightStreamRepo.hidePost(requestPrm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  setHidePost(String postId) {
    List<Record> records = _insightFeedList
        .where((element) => element.id.toString() == postId.toString())
        .toList();

    if (records.isNotEmpty) {
      int index = _insightFeedList.indexOf(records.first);
      _insightFeedList.removeAt(index);
      update();
    }
  }

  // ======================= hide Post ========================

  Future<ResponseModel> hideAllPost(String userId) async {
    Map<String, dynamic> requestPrm = {
      "user_id": userId,
    };
    ResponseModel responseModel;
    Response response = await insightStreamRepo.hideAllPost(requestPrm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  setHideAllPost(String userId) {
    List<Record> records = _insightFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _insightFeedList.indexOf(item);
        _insightFeedList.removeAt(index);
      }
      update();
    }
  }

  // ======================= followUnfollowUser ========================
  Future<ResponseModel> followUnfollowUser(
      String userId, int isFollowed) async {
    Map<String, dynamic> requestPrm = {
      "action_type": isFollowed == 1 ? "F" : "U",
      "user_id": userId,
    };
    ResponseModel responseModel;
    Response response = await insightStreamRepo.followUnfollowUser(requestPrm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  setFollowUnFollow(String userId, int isFollowed) {
    List<Record> records = _insightFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _insightFeedList.indexOf(item);
        _insightFeedList[index].isUserFollowed = isFollowed;
      }
      update();
    }
  }

  // ======================= blockUnBlock ========================

  Future<ResponseModel> blockUnBlock(String userId, int isBlocked) async {
    Map<String, dynamic> requestPrm = {
      "action_type": isBlocked == 1 ? "B" : "U",
      "user_id": userId,
    };
    ResponseModel responseModel;
    Response response = await insightStreamRepo.blockUnblock(requestPrm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  setBlockUnblock(String userId, int isBlocked) {
    List<Record> records = _insightFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _insightFeedList.indexOf(item);
        _insightFeedList[index].isUserBlocked = isBlocked;
      }
      update();
    }
  }

  // ======================= report post ========================

  Future<ResponseModel> reportPost(Map<String, dynamic> requestPrm) async {
    ResponseModel responseModel;
    Response response = await insightStreamRepo.reportPost(requestPrm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> sharePost(Map<String, dynamic> requestPrm) async {
    ResponseModel responseModel;
    Response response = await insightStreamRepo.sharePost(requestPrm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> addAsColleague(String userId) async {
    Map<String, String> prm = {"user_id": userId};
    ResponseModel responseModel;
    Response response = await insightStreamRepo.addAsColleague(prm);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  setAddAsCollegue(String userId) {
    List<Record> records = _insightFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _insightFeedList.indexOf(item);
        _insightFeedList[index].isUseAsGlobal = 0;
      }
      update();
    }
  }

  Future<CommentDataMain?> getCommentDetail(String postId) async {
    try {
      Map<String, String> prm = {"post_id": postId};
      Response response = await insightStreamRepo.getCommentDetail(prm);
      if (response.statusCode == 200) {
        CommentListModel organizationChartModel =
            CommentListModel.fromJson(response.body);

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

  Future<ResponseModel> addComment(
      {required List<File> imageFileList,
      required List<String> parameterName,
      required Map<String, dynamic> map}) async {
    ResponseModel responseModel;
    Response response = await insightStreamRepo.addComment(
        map: map, imageFileList: imageFileList, parameterName: parameterName);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<List<SearchData>> searchUserHashtagList(String search) async {
    try {
      Map<String, String> prm = {"search": search};
      Response response = await insightStreamRepo.searchUserHashtagList(prm);
      if (response.statusCode == 200) {
        GlobalSearchModel organizationChartModel =
            GlobalSearchModel.fromJson(response.body);

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

  Future<List<PeopleUserData>> getPeopleUserList(String search) async {
    try {
      if (search == "") {
        return [];
      }
      Map<String, String> prm = {"search": search};
      Response response = await insightStreamRepo.getPeopleUserList(prm);
      if (response.statusCode == 200) {
        PeopleUserListModel data = PeopleUserListModel.fromJson(response.body);

        return data.data!;
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

  Future<OtherUserData?> getOtherUserProfileDetail(String userId) async {
    Map<String, dynamic> map = {"user_id": userId};

    Response response = await insightStreamRepo.getOtherUserProfileDetail(map);
    if (response.statusCode == 200) {
      OtherUserModel objectiveNoteList = OtherUserModel.fromJson(response.body);
      return objectiveNoteList.data!;
    } else {
      showCustomSnackBar(response.statusText);
      throw response.statusText.toString();
    }
  }

  Future<FeelingListData> getFeelingList() async {
    Map<String, dynamic> map = {};

    Response response = await insightStreamRepo.getFeelingList(map);
    if (response.statusCode == 200) {
      FeelingListModel data = FeelingListModel.fromJson(response.body);

      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  Future<ResponseModel> uploadMediaForPost(
      {required List<File> imageFileList,
      required List<String> parameterName,
      required Map<String, dynamic> map}) async {
    ResponseModel responseModel;
    Response response = await insightStreamRepo.uploadMediaForPost(
        map: map, imageFileList: imageFileList, parameterName: parameterName);
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

  Future<ResponseModel> createPost(Map<String, dynamic> requestPrm) async {
    ResponseModel responseModel;
    try {
      Response response = await insightStreamRepo.createPost(requestPrm);
      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, response.body['message']);
      } else if (response.statusCode == 1) {
        responseModel = ResponseModel(false, response.statusText);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
      return responseModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> removePost(String postId) async {
    Map<String, dynamic> map = {"share_postId": postId};
    ResponseModel responseModel;
    Response response = await insightStreamRepo.removePost(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<List<HashtagData>> getHashtags() async {
    Map<String, dynamic> map = {};

    Response response = await insightStreamRepo.getHashtags(map);
    if (response.statusCode == 200) {
      HashTagListModel data = HashTagListModel.fromJson(response.body);

      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  Future<PostDetailData> getPostDetailData(String postId) async {
    Map<String, dynamic> map = {"post_id": postId};

    Response response = await insightStreamRepo.getPostDetailData(map);
    if (response.statusCode == 200) {
      PostDetailModel data = PostDetailModel.fromJson(response.body);

      if (data.data != null) {
        return data.data!;
      } else {
        throw AppString.somethingWentWrong;
      }
    } else {
      throw response.statusText.toString();
    }
  }

  int followerCount = 0;

  Future<bool?> getFollowersCount() async {
    try {
      Map<String, String> prm = {};
      Response response = await insightStreamRepo.getFollowersCount(prm);
      if (response.statusCode == 200) {
        FolloweCountModel data = FolloweCountModel.fromJson(response.body);

        if (data.status == 200) {
          followerCount = data.data!.followerCount!;
          return true;
        } else {
          showCustomSnackBar(data.message);
          return null;
        }
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
}
