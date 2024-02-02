// To parse this JSON data, do
//
//     final enterPriseModel = enterPriseModelFromJson(jsonString);

import 'dart:convert';

import 'package:aspirevue/data/model/response/development/courses_list_model.dart';

EnterPriseModel enterPriseModelFromJson(String str) =>
    EnterPriseModel.fromJson(json.decode(str));

String enterPriseModelToJson(EnterPriseModel data) =>
    json.encode(data.toJson());

class EnterPriseModel {
  int? status;
  EnterPriseData? data;
  String? message;

  EnterPriseModel({
    this.status,
    this.data,
    this.message,
  });

  factory EnterPriseModel.fromJson(Map<String, dynamic> json) =>
      EnterPriseModel(
        status: json["status"],
        data:
            json["data"] == null ? null : EnterPriseData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class EnterPriseData {
  int? id;
  String? userId;
  String? name;
  String? displayName;
  String? logo;
  String? coverLogo;
  String? aboutInfo;
  String? wistiaTitle;
  String? wistiaEmbedCode;
  String? youtubeEmbedCode;
  int? companyId;
  String? followBtnText;
  String? followBtnActionText;
  int? followBtnDisable;
  int? followerCount;
  int? isShowCourseSection;
  int? isShowNewsSection;
  int? isShowChannelSection;
  int? isShowFilterListSection;
  List<Course>? courses;
  List<EnterpriseNews>? news;
  int? newsViewMoreLink;
  List<JobBoard>? jobBoards;

  EnterPriseData({
    this.id,
    this.userId,
    this.name,
    this.displayName,
    this.logo,
    this.coverLogo,
    this.aboutInfo,
    this.wistiaTitle,
    this.wistiaEmbedCode,
    this.youtubeEmbedCode,
    this.companyId,
    this.followBtnText,
    this.followBtnActionText,
    this.followBtnDisable,
    this.followerCount,
    this.isShowCourseSection,
    this.isShowNewsSection,
    this.isShowChannelSection,
    this.isShowFilterListSection,
    this.courses,
    this.news,
    this.newsViewMoreLink,
    this.jobBoards,
  });

  factory EnterPriseData.fromJson(Map<String, dynamic> json) => EnterPriseData(
        id: json["id"],
        userId: json['user_id']?.toString(),
        name: json["name"],
        displayName: json["display_name"],
        logo: json["logo"],
        coverLogo: json["cover_logo"],
        aboutInfo: json["about_info"],
        wistiaTitle: json["wistia_title"],
        wistiaEmbedCode: json["wistia_embed_code"],
        youtubeEmbedCode: json["youtube_embed_code"],
        companyId: json["company_id"],
        followBtnText: json["follow_btn_text"],
        followBtnActionText: json["follow_btn_action_text"],
        followBtnDisable: json["follow_btn_disable"],
        followerCount: json["follower_count"],
        isShowCourseSection: json["is_show_course_section"],
        isShowNewsSection: json["is_show_news_section"],
        isShowChannelSection: json["is_show_channel_section"],
        isShowFilterListSection: json["is_show_filter_list_section"],
        courses: json["courses"] == null
            ? []
            : List<Course>.from(
                json["courses"]!.map((x) => Course.fromJson(x))),
        news: json["news"] == null
            ? []
            : List<EnterpriseNews>.from(
                json["news"]!.map((x) => EnterpriseNews.fromJson(x))),
        newsViewMoreLink: json["news_view_more_link"],
        jobBoards: json["job_boards"] == null
            ? []
            : List<JobBoard>.from(
                json["job_boards"]!.map((x) => JobBoard.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "display_name": displayName,
        "logo": logo,
        "cover_logo": coverLogo,
        "about_info": aboutInfo,
        "wistia_title": wistiaTitle,
        "wistia_embed_code": wistiaEmbedCode,
        "youtube_embed_code": youtubeEmbedCode,
        "company_id": companyId,
        "follow_btn_text": followBtnText,
        "follow_btn_action_text": followBtnActionText,
        "follow_btn_disable": followBtnDisable,
        "follower_count": followerCount,
        "is_show_course_section": isShowCourseSection,
        "is_show_news_section": isShowNewsSection,
        "is_show_channel_section": isShowChannelSection,
        "is_show_filter_list_section": isShowFilterListSection,
        "courses": courses == null
            ? []
            : List<dynamic>.from(courses!.map((x) => x.toJson())),
        "news": news == null
            ? []
            : List<dynamic>.from(news!.map((x) => x.toJson())),
        "news_view_more_link": newsViewMoreLink,
        "job_boards": jobBoards == null
            ? []
            : List<dynamic>.from(jobBoards!.map((x) => x.toJson())),
      };
}

class JobBoard {
  String? title;
  String? description;
  List<EnterpriseRecord>? records;

  JobBoard({
    this.title,
    this.description,
    this.records,
  });

  factory JobBoard.fromJson(Map<String, dynamic> json) => JobBoard(
        title: json["title"],
        description: json["description"],
        records: json["records"] == null
            ? []
            : List<EnterpriseRecord>.from(
                json["records"]!.map((x) => EnterpriseRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "records": records == null
            ? []
            : List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class EnterpriseRecord {
  String? datePosted;
  String? position;
  String? division;
  String? location;
  String? description;

  EnterpriseRecord({
    this.datePosted,
    this.position,
    this.division,
    this.location,
    this.description,
  });

  factory EnterpriseRecord.fromJson(Map<String, dynamic> json) =>
      EnterpriseRecord(
        datePosted: json["date_posted"],
        position: json["position"],
        division: json["division"],
        location: json["location"],
        description: json["desc_text"],
      );

  Map<String, dynamic> toJson() => {
        "date_posted": datePosted,
        "position": position,
        "division": division,
        "location": location,
        "desc_text": description,
      };
}

class EnterpriseNews {
  int? id;
  int? enterpriseId;
  String? photo;
  String? title;
  String? description;
  String? createdDate;
  String? slug;
  EnterpriseNews({
    this.id,
    this.enterpriseId,
    this.photo,
    this.title,
    this.description,
    this.createdDate,
    this.slug,
  });

  factory EnterpriseNews.fromJson(Map<String, dynamic> json) => EnterpriseNews(
        id: json["id"],
        enterpriseId: json["enterprise_id"],
        photo: json["photo"],
        title: json["title"],
        description: json["description"],
        createdDate: json["created_date"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "enterprise_id": enterpriseId,
        "photo": photo,
        "title": title,
        "description": description,
        "created_date": createdDate,
      };
}
