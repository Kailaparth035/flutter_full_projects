import 'dart:io';
import 'package:flutter/material.dart';

class DropDownOptionItemMenu {
  final String? id;
  final String title;
  final String? sortName;
  final String? subTitle;
  final String? icon;

  DropDownOptionItemMenu({
    required this.id,
    required this.title,
    this.sortName,
    this.icon,
    this.subTitle,
  });
}

class DropListModel {
  DropListModel(this.listOptionItems);
  List<DropDownOptionItemMenu> listOptionItems;
}

class DropListModel1 {
  DropListModel1(this.listOptionItems);
  final List<OptionItemForMultiSelect> listOptionItems;
}

class OptionItemForMultiSelect {
  final String? id;
  final String title;

  bool isChecked;
  OptionItemForMultiSelect({
    required this.id,
    required this.title,
    required this.isChecked,
  });
}

class KeyResultModel {
  String? id;
  TextEditingController asAvidenceTextController;
  TextEditingController percentCompleteTextController;
  String targetDate;
  double sliderValue;
  DropDownOptionItemMenu? selectedItem;
  KeyResultModel({
    required this.id,
    required this.asAvidenceTextController,
    required this.percentCompleteTextController,
    required this.targetDate,
    required this.selectedItem,
    required this.sliderValue,
  });
}

class PopUpModel {
  String title;
  String subTitle;
  String image;
  Function onTap;
  PopUpModel({
    required this.title,
    required this.subTitle,
    required this.image,
    required this.onTap,
  });
}

class ButtonModelForPost {
  final String title;
  final Color color;
  final String? icon;
  final Function onTap;
  ButtonModelForPost(
      {required this.onTap,
      required this.title,
      required this.color,
      this.icon});
}

class FilePickerModel {
  final File file;
  final File? thumbnailFile;
  final String type;

  FilePickerModel({
    required this.file,
    this.thumbnailFile,
    required this.type,
  });
}
