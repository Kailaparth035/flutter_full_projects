import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/my_mentors_list_model.dart';
import 'package:aspirevue/data/repository/my_connections_repo.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class MyMentorsController extends GetxController {
  final MyConnectionRepo myConnectionRepo;

  MyMentorsController({required this.myConnectionRepo});
  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  List<MyMentorsData> _list = [];

  // get local properties
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMsg => _errorMsg;

  List<MyMentorsData> get dataList => _list;

  Future<void> getMyMentorsList(Map<String, dynamic> map) async {
    _isLoading = true;

    try {
      Response response = await myConnectionRepo.getMentorsList(map);
      if (response.statusCode == 200) {
        _isLoading = false;

        _list = [];
        MyMentorsListModel modelData =
            MyMentorsListModel.fromJson(response.body);
        _isError = false;
        _errorMsg = "";
        if (modelData.data != null) {
          if (modelData.data!.isNotEmpty) {
            modelData.data?.forEach((element) {
              _list.add(element);
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
      showCustomSnackBar(error.toString());
    } finally {
      _isLoading = false;
    }
    update();
  }
}
