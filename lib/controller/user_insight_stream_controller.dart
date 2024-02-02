import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/data/repository/insight_stream_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserInsightStreamController extends GetxController {
  final InsightStreamRepo insightStreamRepo;
  UserInsightStreamController({required this.insightStreamRepo});

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  String _currentUserId = "";

  List<Record> _userFeedList = [];

  bool get isLoadinguserStream => _isLoading;

  bool get isErroruserStream => _isError;

  String get errorMsguserStream => _errorMsg;

  List<Record> get userTagFeedList => _userFeedList;

  void setLoading(bool value) {
    _isLoading = value;
    update();
  }

  setUserId(user, UserInsightStreamEnumType streamType) {
    _currentUserId = user;
    // _currentStreamType = streamType;
    update();
  }

// manage flag when user will change stream type

  List streamTypeHistory = [];
  addStreamType(userId, UserInsightStreamEnumType streamType) {
    streamTypeHistory.add({
      "user_id": userId,
      "stream": streamType,
    });
    update();
  }

  onNavigateBack() {
    if (streamTypeHistory.isNotEmpty) {
      streamTypeHistory.removeLast();
      update();

      if (streamTypeHistory.isNotEmpty) {
        var data = streamTypeHistory.last;
        getOtherUserInsightFeeds(
          true,
          data["user_id"],
          stramType: data["stream"],
        );
      }
    }
  }

  checkCurrentUser(String useridTocheck, UserInsightStreamEnumType streamType) {
    if (useridTocheck != _currentUserId) {
      getOtherUserInsightFeeds(true, useridTocheck, stramType: streamType);
    }
  }

  removePostFromList(String postId) {
    _userFeedList.removeWhere((element) => element.id.toString() == postId);
    update();
  }

  final int pageCountuserFeedStream = 10;
  int pageNumberuserFeedStream = 1;
  bool isLoadMoreRunninguserFeedStream = false;
  bool isnotMoreDatauserFeedStream = false;

  Future<void> getOtherUserInsightFeeds(bool isInit, String userId,
      {required UserInsightStreamEnumType stramType}) async {
    if (_isLoading == false) {
      if (isInit) {
        _userFeedList = [];
        _isLoading = true;
        isnotMoreDatauserFeedStream = false;
        pageNumberuserFeedStream = 1;
        try {
          update();
        } catch (e) {
          debugPrint("====> error =======> $e");
        }
      } else {
        isLoadMoreRunninguserFeedStream = true;
        update();
      }

      Map<String, dynamic> map = {
        "count": pageCountuserFeedStream.toString(),
        "pagenum": pageNumberuserFeedStream.toString(),
      };
      try {
        late Response response;
        if (stramType == UserInsightStreamEnumType.currentUser) {
          response = await insightStreamRepo.myInsightFeedList(map);
        } else if (stramType == UserInsightStreamEnumType.otherUser) {
          map['user_id'] = userId;
          response = await insightStreamRepo.getOtherUserInsightFeeds(map);
        } else {
          response = await insightStreamRepo.savedPostDetail(map);
        }

        if (response.statusCode == 200) {
          InsightFeedModel data = InsightFeedModel.fromJson(response.body);
          if (data.data != null) {
            if (data.data?.record != null) {
              if (data.data!.record!.isNotEmpty) {
                data.data?.record?.forEach((element) {
                  _userFeedList.add(element);
                });
              } else {
                isnotMoreDatauserFeedStream = true;
              }
              _updateuserStreamErrorState(false, "");
            } else {
              _updateuserStreamErrorState(true, AppString.somethingWentWrong);
            }
          } else {
            _updateuserStreamErrorState(true, AppString.somethingWentWrong);
          }
        } else {
          _updateuserStreamErrorState(true, response.statusText.toString());
        }
      } catch (e) {
        String error = CommonController().getValidErrorMessage(e.toString());
        _updateuserStreamErrorState(true, error.toString());
      } finally {
        _isLoading = false;
        isLoadMoreRunninguserFeedStream = false;
        setUserId(userId, stramType);
        addStreamType(userId, stramType);
        update();
      }
    }
  }

  _updateuserStreamErrorState(bool isError, String error) {
    if (isError) {
      _errorMsg = error;
    } else {
      _errorMsg = "";
    }
    _isError = isError;
    update();
  }

  setSavedPost(String postId, int valueToUpdateInLocal) {
    List<Record> records = _userFeedList
        .where((element) => element.id.toString() == postId.toString())
        .toList();

    if (records.isNotEmpty) {
      int index = _userFeedList.indexOf(records.first);
      _userFeedList[index].isPostSaved = valueToUpdateInLocal;
      update();
    }
  }

  setFollowUnFollow(String userId, int isFollowed) {
    List<Record> records = _userFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _userFeedList.indexOf(item);
        _userFeedList[index].isUserFollowed = isFollowed;
      }
      update();
    }
  }

  setAddAsCollegue(String userId) {
    List<Record> records = _userFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _userFeedList.indexOf(item);
        _userFeedList[index].isUseAsGlobal = 0;
      }
      update();
    }
  }

  setRating(String postId, Response respose, String count) {
    List<Record> records = _userFeedList
        .where((element) => element.id.toString() == postId.toString())
        .toList();

    if (records.isNotEmpty) {
      int index = _userFeedList.indexOf(records.first);

      _userFeedList[index].postStarRatingAvg = respose.body['avg'].toString();

      _userFeedList[index].postStarRatingCount =
          respose.body['count'].toString();

      _userFeedList[index].postStarRating = count;
      update();
    }
  }

  setBlockUnblock(String userId, int isBlocked) {
    List<Record> records = _userFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _userFeedList.indexOf(item);
        _userFeedList[index].isUserBlocked = isBlocked;
      }
      update();
    }
  }
}
