// To parse this JSON data, do
//
//     final coursesListModel = coursesListModelFromJson(jsonString);

import 'dart:convert';

CoursesListModel coursesListModelFromJson(String str) =>
    CoursesListModel.fromJson(json.decode(str));

String coursesListModelToJson(CoursesListModel data) =>
    json.encode(data.toJson());

class CoursesListModel {
  int? status;
  CoursesListData? data;
  String? message;

  CoursesListModel({
    this.status,
    this.data,
    this.message,
  });

  factory CoursesListModel.fromJson(Map<String, dynamic> json) =>
      CoursesListModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : CoursesListData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CoursesListData {
  List<Course>? courses;
  String? userId;
  CoursesListData({
    this.courses,
    this.userId,
  });

  factory CoursesListData.fromJson(Map<String, dynamic> json) =>
      CoursesListData(
        userId: json["user_id"]?.toString(),
        courses: json["courses"] == null
            ? []
            : List<Course>.from(
                json["courses"]!.map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "courses": courses == null
            ? []
            : List<dynamic>.from(courses!.map((x) => x.toJson())),
      };
}

class Course {
  String? courseLink;
  String? courseLinkOpen;
  String? photo;
  int? courseId;
  String? course;
  String? description;
  String? type;
  String? status;
  String? score;
  String? launchBtn;
  String? launchLink;
  String? launchIsEnable;

  int? isShowPrice;
  String? price;
  int? isShowPresenter;
  String? presenter;

  int? isAddToCartShow;
  int? isGlobalCourse;
  String? courseType;

  String? shortDesc;
  String? longDesc;

  Course({
    this.courseLink,
    this.courseLinkOpen,
    this.photo,
    this.courseId,
    this.course,
    this.description,
    this.type,
    this.status,
    this.score,
    this.launchBtn,
    this.launchLink,
    this.launchIsEnable,
    this.isShowPrice,
    this.price,
    this.isShowPresenter,
    this.presenter,
    this.isAddToCartShow,
    this.isGlobalCourse,
    this.courseType,
    this.shortDesc,
    this.longDesc,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseLink: json["course_link"],
        courseLinkOpen: json["course_link_open"],
        photo: json["photo"],
        courseId: json["course_id"],
        course: json["course"],
        description: json["description"],
        type: json["type"],
        status: json["status"],
        score: json["score"],
        launchBtn: json["launch_btn"],
        launchLink: json["launch_link"],
        launchIsEnable: json["launch_is_enable"]?.toString(),
        isShowPrice: json["is_show_price"],
        price: json["price"]?.toString(),
        isShowPresenter: json["is_show_presenter"],
        presenter: json["presenter"],
        isAddToCartShow: json["is_add_to_cart_show"],
        isGlobalCourse: json["is_global_course"],
        courseType: json["course_type"],
        shortDesc: json["short_desc"],
        longDesc: json["long_desc"],
      );

  Map<String, dynamic> toJson() => {
        "course_link": courseLink,
        "course_link_open": courseLinkOpen,
        "photo": photo,
        "course_id": courseId,
        "course": course,
        "description": description,
        "type": type,
        "status": status,
        "score": score,
        "launch_btn": launchBtn,
        "launch_link": launchLink,
        "launch_is_enable": launchIsEnable,
        "is_show_price": isShowPrice,
        "price": price,
        "is_show_presenter": isShowPresenter,
        "presenter": presenter,
        "is_add_to_cart_show": isAddToCartShow,
        "is_global_course": isGlobalCourse,
        "course_type": courseType,
        "short_desc": shortDesc,
        "long_desc": longDesc
      };
}
