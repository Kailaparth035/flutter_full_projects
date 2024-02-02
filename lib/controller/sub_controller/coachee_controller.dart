import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/coachee_list_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/repository/my_connections_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class CoacheeController extends GetxController {
  final MyConnectionRepo myConnectionRepo;
  CoacheeController({required this.myConnectionRepo});

  bool _isLoading = false;
  bool _isLoadMoreRunning = false;
  bool _isError = false;

  bool _isnotMoreData = false;
  String _errorMsg = "";
  List<CoacheeData> _dataList = [];

  int _pageNo = 1;
  final int _pageCount = 10;

  // get all properties
  int get pageNo => _pageNo;
  int get pageCount => _pageCount;
  bool get isnotMoreData => _isnotMoreData;
  bool get isLoading => _isLoading;
  bool get isLoadMoreRunning => _isLoadMoreRunning;
  bool get isError => _isError;
  String get errorMsg => _errorMsg;
  List<CoacheeData> get dataList => _dataList;

  // set properties
  set setpageNo(value) {
    _pageNo = value;
  }

  set setisLoadMoreRunning(value) {
    _isLoadMoreRunning = value;
  }

  Future<void> getGrowthCoacheeListWithPagination(
      bool isInit, String searchText, String type) async {
    if (isInit) {
      _dataList = [];
      _isnotMoreData = false;
      _isLoading = true;

      _pageNo = 1;
    } else {
      _isLoadMoreRunning = true;
    }
    update();
    Map<String, dynamic> map = {
      "type": type,
      "pagenum": pageNo.toString(),
      "search": searchText,
      "count": pageCount.toString()
    };
    try {
      Response response = await myConnectionRepo.getCoacheeList(map);

      if (response.statusCode == 200) {
        CoacheeListModel model = CoacheeListModel.fromJson(response.body);

        if (model.data != null) {
          _isError = false;

          if (model.data!.isNotEmpty) {
            if (isInit) {
              _dataList = [];
            }

            for (var item in model.data!) {
              _dataList.add(item);
            }
          } else {
            _isnotMoreData = true;
          }
        } else {
          _isError = true;
          _errorMsg = AppString.noDataFound;
        }
      } else {
        _isError = true;
        _errorMsg = response.statusText.toString();
        showCustomSnackBar(response.statusText);
      }
    } catch (e) {
      _isError = true;

      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsg = error.toString();
      showCustomSnackBar(error.toString());
    } finally {
      _isLoading = false;
      _isLoadMoreRunning = false;
      update();
    }
  }

  Future<ResponseModel> updateCoacheeActiveArchive(
      Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await myConnectionRepo.updateCoacheeActiveArchive(map);
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
