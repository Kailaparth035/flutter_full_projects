import 'package:get/get.dart';

class ResponseModel {
  final bool? _isSuccess;
  final String? _message;
  final Response? responseT;

  ResponseModel(this._isSuccess, this._message, {this.responseT});

  String? get message => _message;
  bool? get isSuccess => _isSuccess;
  Response? get response => responseT;
}
