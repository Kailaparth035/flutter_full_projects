import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/data/model/response/insight_feed_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/repository/insight_stream_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HashTagController extends GetxController {
  final InsightStreamRepo insightStreamRepo;
  HashTagController({required this.insightStreamRepo});

  bool _isLoadingHashTag = false;
  bool _isErrorHashTag = false;
  String _errorMsgHashTag = "";
  List<HashtagData> _hashtagList = [];

  bool get isLoadingHashTag => _isLoadingHashTag;
  bool get isErrorHashTag => _isErrorHashTag;
  String get errorMsgHashTag => _errorMsgHashTag;
  List<HashtagData> get hashtagList => _hashtagList;

  Future<void> followedHashtagList() async {
    _isLoadingHashTag = true;
    try {
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
    Map<String, dynamic> map = {};
    try {
      Response response = await insightStreamRepo.followedHashtagList(map);
      if (response.statusCode == 200) {
        HashTagListModel data = HashTagListModel.fromJson(response.body);
        _hashtagList = data.data!;
      } else {
        _updateHashtag(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateHashtag(true, error.toString());
    } finally {
      _isLoadingHashTag = false;
      update();
    }
  }

  _updateHashtag(bool isError, String error) {
    if (isError) {
      _errorMsgHashTag = error;
    } else {
      _errorMsgHashTag = "";
    }
    _isErrorHashTag = isError;
    update();
  }

  // ========================== all hashtag list ==========================

  // bool _isLoadingHashTagList = false;
  // bool _isErrorHashTagList = false;
  // String _errorMsgHashTagList = "";
  List<HashtagData> _hashtagListAll = [];

  // bool get isLoadingHashTagList => _isLoadingHashTagList;
  // bool get isErrorHashTagList => _isErrorHashTagList;
  // String get errorMsgHashTagList => _errorMsgHashTagList;
  List<HashtagData> get hashtagListAll => _hashtagListAll;

  Future<void> getHashtags() async {
    _isLoadingHashTag = true;
    try {
      update();
    } catch (e) {
      debugPrint(e.toString());
    }
    Map<String, dynamic> map = {};
    try {
      Response response = await insightStreamRepo.getHashtags(map);
      if (response.statusCode == 200) {
        HashTagListModel data = HashTagListModel.fromJson(response.body);
        _hashtagListAll = data.data!;
      } else {
        _updateHashtagList(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateHashtagList(true, error.toString());
    } finally {
      _isLoadingHashTag = false;
      update();
    }
  }

  _updateHashtagList(bool isError, String error) {
    if (isError) {
      _errorMsgHashTag = error;
    } else {
      _errorMsgHashTag = "";
    }
    _isErrorHashTag = isError;
    update();
  }
  // ========================== hastag insight stream ==========================

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  List<Record> _hashTagFeedList = [];

  bool get isLoadingHashtagStream => _isLoading;

  bool get isErrorHashtagStream => _isError;

  String get errorMsgHashtagStream => _errorMsg;

  List<Record> get hashTagFeedList => _hashTagFeedList;

  void setLoading(bool value) {
    _isLoading = value;
    update();
  }

  final int pageCountHashTagFeedStream = 10;
  int pageNumberHashTagFeedStream = 1;
  bool isLoadMoreRunningHashTagFeedStream = false;
  bool isnotMoreDataHashTagFeedStream = false;

  bool userFollwedHastag = false;
  updateFollowFlag(value) {
    userFollwedHastag = value;
    update();
  }

  bool displayFollowUnfollowBtn = false;
  bool followUnfollowBtnDisable = false;
  String hashtagId = "";
  Future<void> getHashTagListing(bool isInit, String hashtag) async {
    if (isInit) {
      _hashTagFeedList = [];
      _isLoading = true;
      isnotMoreDataHashTagFeedStream = false;
      pageNumberHashTagFeedStream = 1;
      try {
        update();
      } catch (e) {
        debugPrint("====> error =======> $e");
      }
    } else {
      isLoadMoreRunningHashTagFeedStream = true;
      update();
    }

    Map<String, dynamic> map = {
      "count": pageCountHashTagFeedStream.toString(),
      "pagenum": pageNumberHashTagFeedStream.toString(),
      "hashtag": hashtag,
    };
    try {
      Response response = await insightStreamRepo.getHashTagListing(map);
      if (response.statusCode == 200) {
        InsightFeedModel data = InsightFeedModel.fromJson(response.body);
        if (data.data != null) {
          if (data.data?.record != null) {
            if (data.data!.record!.isNotEmpty) {
              userFollwedHastag = data.data!.userFollwedHastag == 1;
              displayFollowUnfollowBtn =
                  data.data!.displayFollowUnfollowBtn == 1;
              followUnfollowBtnDisable =
                  data.data!.followUnfollowBtnDisable == 1;

              hashtagId = data.data!.hashtagId!;

              data.data?.record?.forEach((element) {
                _hashTagFeedList.add(element);
              });
            } else {
              isnotMoreDataHashTagFeedStream = true;
            }
            _updateHashtagStreamErrorState(false, "");
          } else {
            _updateHashtagStreamErrorState(true, AppString.somethingWentWrong);
          }
        } else {
          _updateHashtagStreamErrorState(true, AppString.somethingWentWrong);
        }
      } else {
        _updateHashtagStreamErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateHashtagStreamErrorState(true, error);
    } finally {
      _isLoading = false;
      isLoadMoreRunningHashTagFeedStream = false;
      update();
    }
  }

  _updateHashtagStreamErrorState(bool isError, String error) {
    if (isError) {
      _errorMsg = error;
    } else {
      _errorMsg = "";
    }
    _isError = isError;
    update();
  }

  setSavedPost(String postId, int valueToUpdateInLocal) {
    List<Record> records = _hashTagFeedList
        .where((element) => element.id.toString() == postId.toString())
        .toList();

    if (records.isNotEmpty) {
      int index = _hashTagFeedList.indexOf(records.first);
      _hashTagFeedList[index].isPostSaved = valueToUpdateInLocal;
      update();
    }
  }

  setFollowUnFollow(String userId, int isFollowed) {
    List<Record> records = _hashTagFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _hashTagFeedList.indexOf(item);
        _hashTagFeedList[index].isUserFollowed = isFollowed;
      }
      update();
    }
  }

  setAddAsCollegue(String userId) {
    List<Record> records = _hashTagFeedList
        .where((element) => element.userId.toString() == userId.toString())
        .toList();

    if (records.isNotEmpty) {
      for (var item in records) {
        int index = _hashTagFeedList.indexOf(item);
        _hashTagFeedList[index].isUseAsGlobal = 0;
      }
      update();
    }
  }

  setRating(String postId, Response respose, String count) {
    List<Record> records = _hashTagFeedList
        .where((element) => element.id.toString() == postId.toString())
        .toList();

    if (records.isNotEmpty) {
      int index = _hashTagFeedList.indexOf(records.first);

      _hashTagFeedList[index].postStarRatingAvg =
          respose.body['avg'].toString();

      _hashTagFeedList[index].postStarRatingCount =
          respose.body['count'].toString();

      _hashTagFeedList[index].postStarRating = count;

      update();
    }
  }

  Future<ResponseModel> followHashtag(Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await insightStreamRepo.followHashtag(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }
}
