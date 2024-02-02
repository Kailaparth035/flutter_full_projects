import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/coach_details_model.dart';
import 'package:aspirevue/data/model/response/my_coaches_list_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/repository/my_connections_repo.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class MyCoachesController extends GetxController {
  final MyConnectionRepo myConnectionRepo;

  MyCoachesController({required this.myConnectionRepo});

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  List<MyCoachesData> _coachList = [];

  // get local properties
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMsg => _errorMsg;

  List<MyCoachesData> get coachList => _coachList;

  Future<void> getMyCoachesList(Map<String, dynamic> map) async {
    _isLoading = true;
    update();

    try {
      Response response = await myConnectionRepo.getMyCoachesList(map);
      if (response.statusCode == 200) {
        _isLoading = false;

        _coachList = [];
        MyCoachesListModel modelData =
            MyCoachesListModel.fromJson(response.body);
        _isError = false;
        _errorMsg = "";
        if (modelData.data != null) {
          if (modelData.data!.isNotEmpty) {
            modelData.data?.forEach((element) {
              _coachList.add(element);
            });
          }
        }
      } else {
        _isError = true;
        _errorMsg = response.statusText.toString();
        _isLoading = false;
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      _isError = true;
      _isLoading = false;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsg = error.toString();

      showCustomSnackBar(e.toString());
    } finally {
      _isLoading = false;
    }
    update();
  }

  Future<CoachDetailsData?> getCoachMentorMenteeDetailsUri(
      Map<String, dynamic> map) async {
    try {
      Response response =
          await myConnectionRepo.getCoachMentorMenteeDetailsUri(map);
      if (response.statusCode == 200) {
        CoachDetailsModel userListModel =
            CoachDetailsModel.fromJson(response.body);

        return userListModel.data;
      } else {
        showCustomSnackBar(response.statusText);
        throw response.statusText.toString();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponseModel> updateSignatureItem(Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.updateSignatureItem(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> updateCoachMentorMenteeActionItem(
      Map<String, dynamic> map) async {
    ResponseModel responseModel;

    try {
      Response response =
          await myConnectionRepo.updateCoachMentorMenteeActionItem(map);

      if (response.statusCode == 200) {
        responseModel = ResponseModel(true, response.body['message']);
      } else if (response.statusCode == 1) {
        responseModel = ResponseModel(false, response.statusText);
      } else {
        responseModel = ResponseModel(false, response.body['message']);
      }
      return responseModel;
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      return responseModel = ResponseModel(false, error.toString());
    }
  }
}
