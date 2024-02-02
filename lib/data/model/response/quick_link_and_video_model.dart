// To parse this JSON data, do
//
//     final quickLinkAndVideoModel = quickLinkAndVideoModelFromJson(jsonString);

import 'dart:convert';

QuickLinkAndVideoModel quickLinkAndVideoModelFromJson(String str) =>
    QuickLinkAndVideoModel.fromJson(json.decode(str));

String quickLinkAndVideoModelToJson(QuickLinkAndVideoModel data) =>
    json.encode(data.toJson());

class QuickLinkAndVideoModel {
  int? status;
  QuickLinkAndVideoData? data;
  String? message;

  QuickLinkAndVideoModel({
    this.status,
    this.data,
    this.message,
  });

  factory QuickLinkAndVideoModel.fromJson(Map<String, dynamic> json) =>
      QuickLinkAndVideoModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : QuickLinkAndVideoData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class QuickLinkAndVideoData {
  List<VideoForDashboard>? videos;
  List<QuickLink>? quickLinks;

  List<QuickLinksPopup>? quickLinksPopup;
  int? isShowDailyqSection;
  int? isShowBullet;
  int? isShowJournal;
  String? learnMoreUrl;
  List<StepCheckboxModel>? myChecklists;
  int? isShowMyChecklist;

  List<MyEnterprise>? myEnterprise;

  List<HelpVideo>? helpVideos;

  QuickLinkAndVideoData(
      {this.videos,
      this.quickLinks,
      this.isShowDailyqSection,
      this.isShowBullet,
      this.isShowJournal,
      this.learnMoreUrl,
      this.quickLinksPopup,
      this.myChecklists,
      this.isShowMyChecklist,
      this.helpVideos,
      this.myEnterprise});

  factory QuickLinkAndVideoData.fromJson(Map<String, dynamic> json) =>
      QuickLinkAndVideoData(
        videos: json["videos"] == null
            ? []
            : List<VideoForDashboard>.from(
                json["videos"]!.map((x) => VideoForDashboard.fromJson(x))),
        quickLinks: json["quick_links"] == null
            ? []
            : List<QuickLink>.from(
                json["quick_links"]!.map((x) => QuickLink.fromJson(x))),
        quickLinksPopup: json["quick_links_popup"] == null
            ? []
            : List<QuickLinksPopup>.from(json["quick_links_popup"]!
                .map((x) => QuickLinksPopup.fromJson(x))),
        isShowDailyqSection: json["is_show_dailyq_section"],
        isShowBullet: json["is_show_bullet"],
        isShowJournal: json["is_show_journal"],
        learnMoreUrl: json["learn_more_url"],
        isShowMyChecklist: json["is_show_my_checklist"],
        myChecklists: json["my_checklists"] == null
            ? []
            : List<StepCheckboxModel>.from(json["my_checklists"]!
                .map((x) => StepCheckboxModel.fromJson(x))),
        helpVideos: json["help_videos"] == null
            ? []
            : List<HelpVideo>.from(
                json["help_videos"]!.map((x) => HelpVideo.fromJson(x))),
        myEnterprise: json["my_enterprise"] == null
            ? []
            : List<MyEnterprise>.from(
                json["my_enterprise"]!.map((x) => MyEnterprise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "videos":
            videos == null ? [] : List<dynamic>.from(videos!.map((x) => x)),
        "quick_links": quickLinks == null
            ? []
            : List<dynamic>.from(quickLinks!.map((x) => x.toJson())),
        "quick_links_popup": quickLinksPopup == null
            ? []
            : List<dynamic>.from(quickLinksPopup!.map((x) => x.toJson())),
      };
}

class QuickLink {
  String? title;
  String? icon;
  int? isShowBadge;
  String? navKey;
  String? refernceId;
  String? linkUrl;

  QuickLink(
      {this.title,
      this.icon,
      this.isShowBadge,
      this.navKey,
      this.refernceId,
      this.linkUrl});

  factory QuickLink.fromJson(Map<String, dynamic> json) => QuickLink(
        title: json["title"],
        icon: json["icon"],
        isShowBadge: json["is_show_badge"],
        navKey: json["nav_key"],
        refernceId: json["refernce_id"],
        linkUrl: json["link_url"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
        "is_show_badge": isShowBadge,
        "nav_key": navKey,
        "refernce_id": refernceId,
      };
}

class QuickLinksPopup {
  String? title;
  String? icon;
  String? navKey;
  int? isSelected;

  QuickLinksPopup({
    this.title,
    this.icon,
    this.navKey,
    this.isSelected,
  });

  factory QuickLinksPopup.fromJson(Map<String, dynamic> json) =>
      QuickLinksPopup(
        title: json["title"],
        icon: json["icon"],
        navKey: json["nav_key"],
        isSelected: json["is_selected"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "icon": icon,
        "nav_key": navKey,
        "is_selected": isSelected,
      };

  QuickLinksPopup clone() {
    return QuickLinksPopup.fromJson(json.decode(json.encode(toJson())));
  }
}

class VideoForDashboard {
  String? videoLink;

  VideoForDashboard({
    this.videoLink,
  });

  factory VideoForDashboard.fromJson(Map<String, dynamic> json) =>
      VideoForDashboard(
        videoLink: json["video_link"],
      );

  Map<String, dynamic> toJson() => {
        "video_link": videoLink,
      };
}

class StepCheckboxModel {
  int? id;
  String? title;
  int? isChecked;
  String? navKey;

  StepCheckboxModel({
    this.id,
    this.title,
    this.isChecked,
    this.navKey,
  });

  factory StepCheckboxModel.fromJson(Map<String, dynamic> json) =>
      StepCheckboxModel(
        id: json["id"],
        title: json["title"],
        isChecked: json["is_checked"],
        navKey: json["nav_key"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "is_checked": isChecked,
        "nav_key": navKey,
      };
}

class HelpVideo {
  String? navKey;
  String? videoLink;

  HelpVideo({
    this.navKey,
    this.videoLink,
  });

  factory HelpVideo.fromJson(Map<String, dynamic> json) => HelpVideo(
        navKey: json["nav_key"],
        videoLink: json["video_link"],
      );

  Map<String, dynamic> toJson() => {
        "nav_key": navKey,
        "video_link": videoLink,
      };
}

class MyEnterprise {
  int? id;
  String? title;

  MyEnterprise({
    this.id,
    this.title,
  });

  factory MyEnterprise.fromJson(Map<String, dynamic> json) => MyEnterprise(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
