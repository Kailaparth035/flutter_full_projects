import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CommonModel {
  CommonModel({
    int? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  CommonModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  int? _status;
  String? _message;
  CommonModel copyWith({
    int? status,
    String? message,
  }) =>
      CommonModel(
        status: status ?? _status,
        message: message ?? _message,
      );
  int? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }
}

class SliderModel {
  SliderModel({
    required this.title,
    required this.color,
    required this.value,
    required this.isEnable,
    this.interval = 1,
    this.returnValue,
    this.max,
  });

  final String title;
  final Color color;
  final double value;
  final bool isEnable;
  final double interval;
  final Function(double)? returnValue;
  final double? max;
}

class DevelopmetTabModel {
  DevelopmetTabModel({
    required this.title,
    required this.isEnable,
    this.widget,
  });

  final String title;
  final bool isEnable;
  final Widget? widget;
}

class WistiaSliderModel {
  WistiaSliderModel({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;
}

class PermissionModel {
  PermissionModel({
    required this.permission,
    required this.isGranted,
    required this.name,
  });

  final Permission permission;
  final bool isGranted;
  final String name;
}

class OnbordingModel {
  OnbordingModel({
    required this.image,
    required this.title,
    required this.subTitle,
    required this.subTitleList,
  });

  final String image;
  final String title;
  final String subTitle;
  final List<String> subTitleList;
}

class PushNotification {
  PushNotification({
    required this.title,
    required this.body,
    required this.type,
    required this.data,
  });

  String? title;
  String? body;
  String? type;
  dynamic data;
}
