import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/growth_community_list_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/repository/my_connections_repo.dart';
import 'package:aspirevue/util/permission_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class GrowthCommunityController extends GetxController {
  final MyConnectionRepo myConnectionRepo;
  GrowthCommunityController({required this.myConnectionRepo});

  List<Contact?> _contacts = [];
  List<String> _contactsString = [];

  List<Contact?> _contactsMain = [];
  List<String> _contactsStringMain = [];

  bool _isLoadingContact = false;
  // bool _isError = false;
  String _errorMsg = "";

  // get local properties
  // bool get isLoading => _isLoading;
  bool get isLoadingContact => _isLoadingContact;
  // bool get isError => _isError;
  String get errorMsg => _errorMsg;

  List<Contact?> get contacts => _contacts;
  List<Contact?> get contactsMain => _contactsMain;

  List<String> get contactsString => _contactsString;
  List<String> get contactsStringMain => _contactsStringMain;

  loadContacts() async {
    try {
      if (await FlutterContacts.requestPermission()) {
        _isLoadingContact = true;
        update();
        List<Contact> contacts1 = await FlutterContacts.getContacts();
        _contacts = contacts1;
        _contactsString = _contacts.map((e) => e!.displayName).toList();
        _contactsMain = _contacts;
        _contactsStringMain = _contactsString;
        showCustomSnackBar("${contacts.length} ${AppString.contactsImported}",
            isError: false);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      _isLoadingContact = false;
      update();
    }
  }

  Future<bool?> syncContacts() async {
    String sucessMessage = "";
    bool isError = false;
    try {
      bool? isPermitGranted =
          await PermissionUtils.takePermission(Permission.contacts);

      if (isPermitGranted == null || isPermitGranted == false) {
        return null;
      }
      if (await FlutterContacts.requestPermission()) {
        _isLoadingContact = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }

        List<Contact> contacts1 =
            await FlutterContacts.getContacts(withProperties: true);

        List<List<Contact>> dividedList = chunkList(contacts1, 200);

        if (dividedList.isNotEmpty) {
          for (var mainContactlist in dividedList) {
            var jsonList = [];

            for (var item in mainContactlist) {
              if (item.phones.isNotEmpty && item.phones.first.number != "") {
                var obj = {
                  "first_name": item.name.first,
                  "last_name": item.name.last,
                  "phone": item.phones.first.number,
                  "email": item.emails.isNotEmpty
                      ? item.emails.first.address != ""
                          ? item.emails.first.address
                          : ""
                      : "",
                };

                jsonList.add(obj);
              }
            }

            Response response = await myConnectionRepo.importContacts(jsonList);

            if (response.statusCode == 200) {
              sucessMessage = response.body['message'];
            } else if (response.statusCode == 1) {
              showCustomSnackBar(
                response.statusText,
              );
              isError = true;
            } else {
              showCustomSnackBar(
                response.body['message'],
              );
              isError = true;
            }
          }
          if (isError == false) {
            showCustomSnackBar(sucessMessage, isError: false);
            return true;
          } else {
            return null;
          }
        }
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      _isLoadingContact = false;
      update();
    }
    return null;
  }

  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    List<List<T>> dividedList = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      dividedList.add(list.sublist(i, end));
    }
    return dividedList;
  }

  syncContactOneByOne() {}

  Future<ResponseModel> inviteContact(String contactId) async {
    Map<String, dynamic> map = {
      "contact_id": contactId,
    };
    ResponseModel responseModel;
    Response response = await myConnectionRepo.inviteContact(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  filterData(String text) {
    _isLoadingContact = true;
    update();
    Future.delayed(const Duration(seconds: 1), () {
      _contacts = _contactsMain
          .where((element) =>
              element!.displayName.toLowerCase().contains(text.toLowerCase()))
          .toList();
      _contactsString = _contactsStringMain
          .where(
              (element) => element.toLowerCase().contains(text.toLowerCase()))
          .toList();
      _isLoadingContact = false;
      update();
    });
  }

  // ============= pagination prms
  int pageNo = 1;
  int pageCount = 10;

  bool isLoading1 = false;
  bool isLoadMoreRunning = false;
  bool isnotMoreData = false;
  bool isError1 = false;
  String errorMessage = "";
  int communityCount = 0;

  List<GrowthCommunityListData>? userCommunityList = [];

  Future<void> getGrowthCommunityUserWithPagination(
      bool isInit, String searchText) async {
    if (isInit) {
      userCommunityList = [];
      isnotMoreData = false;
      isLoading1 = true;
      pageNo = 1;
      communityCount = 0;
    } else {
      isLoadMoreRunning = true;
    }
    try {
      update();
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }
    Map<String, dynamic> map = {
      "pagenum": pageNo.toString(),
      "search": searchText,
      "count": pageCount.toString()
    };
    try {
      Response response = await myConnectionRepo.getGrowthCommunityList(map);

      if (response.statusCode == 200) {
        GrowthCommunityListModel model =
            GrowthCommunityListModel.fromJson(response.body);

        if (model.data != null && model.data!.list != null) {
          communityCount = model.data!.count ?? 0;
          if (model.data!.list!.isNotEmpty) {
            if (isInit) {
              userCommunityList = [];
            }
            for (var item in model.data!.list!) {
              userCommunityList!.add(item);
            }
          } else {
            isnotMoreData = true;
          }

          _updateErrorState(false, "");
        } else {
          _updateErrorState(true, AppString.noDataFound);
        }
      } else {
        _updateErrorState(true, response.statusText.toString());
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
      _updateErrorState(true, error.toString());
    } finally {
      isLoading1 = false;
      isLoadMoreRunning = false;
    }
    update();
  }

  _updateErrorState(bool isError, String error) {
    if (isError) {
      _errorMsg = error;
    } else {
      _errorMsg = "";
    }
    isError1 = isError;
    update();
  }

  Future<ResponseModel> userFollowUnfollow(String userId, String type) async {
    Map<String, dynamic> map = {"user_id": userId, "follow_type": type};
    ResponseModel responseModel;
    Response response = await myConnectionRepo.userFollowUnfollow(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  setFollowUnFollow(String userId, String updatedValue) {
    var item = userCommunityList!.where((element) => element.userId == userId);
    if (item.isNotEmpty) {
      int index = userCommunityList!.indexOf(item.first);
      userCommunityList![index].isFollow = updatedValue;
      update();
    }
  }

  setPromoteToCollegue(
    String id,
  ) {
    var item =
        userCommunityList!.where((element) => element.id.toString() == id);
    if (item.isNotEmpty) {
      int index = userCommunityList!.indexOf(item.first);
      userCommunityList![index].isPromoteToColleague = "Pending";
      update();
    }
  }

  Future<ResponseModel> promoteToGlobalColleague(String userId) async {
    Map<String, dynamic> map = {
      "user_id": userId,
    };
    ResponseModel responseModel;
    Response response = await myConnectionRepo.promoteToGlobalColleague(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // ======================== contacts prms ================================

  // ============= pagination prms
  int pageNoContacts = 1;
  int pageCountContacts = 10;

  bool isLoadingContacts = false;
  bool isLoadMoreRunningContacts = false;
  bool isnotMoreDataContacts = false;

  bool isErrorContacts = false;
  String errorMessageContacts = "";
  int contactTotlaCount = 0;

  List<GrowthCommunityListData>? userCommunityListContacts = [];

  updateContactList(String contactId) {
    var item = userCommunityListContacts!
        .where((element) => element.id.toString() == contactId);
    if (item.isNotEmpty) {
      int index = userCommunityListContacts!.indexOf(item.first);
      userCommunityListContacts![index].isInvited = 1;

      update();
    }
  }

  Future<void> getContactsWithPagination(bool isInit, String searchText) async {
    if (isInit) {
      userCommunityListContacts = [];
      isnotMoreDataContacts = false;
      isLoadingContacts = true;
      pageNoContacts = 1;
      contactTotlaCount = 0;
    } else {
      isLoadMoreRunningContacts = true;
    }
    try {
      update();
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }
    Map<String, dynamic> map = {
      "pagenum": pageNoContacts.toString(),
      "search": searchText,
      "count": pageCountContacts.toString()
    };
    try {
      Response response = await myConnectionRepo.getContactListUri(map);

      if (response.statusCode == 200) {
        GrowthCommunityListModel model =
            GrowthCommunityListModel.fromJson(response.body);

        if (model.data != null && model.data!.list != null) {
          contactTotlaCount = model.data!.count ?? 0;
          _updateErrorStateContacts(false, "");
          if (model.data!.list!.isNotEmpty) {
            if (isInit) {
              userCommunityListContacts = [];
            }
            for (var item in model.data!.list!) {
              userCommunityListContacts!.add(item);
            }
          } else {
            isnotMoreDataContacts = true;
          }
        } else {
          _updateErrorStateContacts(true, AppString.noDataFound);
        }
      } else {
        _updateErrorStateContacts(true, response.statusText.toString());
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);

      _updateErrorStateContacts(true, error.toString());
    } finally {
      isLoadingContacts = false;
      isLoadMoreRunningContacts = false;
    }
    update();
  }

  _updateErrorStateContacts(bool isError, String error) {
    if (isError) {
      errorMessageContacts = error;
    } else {
      errorMessageContacts = "";
    }
    isErrorContacts = isError;
    update();
  }
}
