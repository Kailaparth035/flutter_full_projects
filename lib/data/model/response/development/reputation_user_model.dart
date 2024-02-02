import 'dart:convert';

ReputationUserModel reputaionModelFromJson(String str) =>
    ReputationUserModel.fromJson(json.decode(str));

String reputaionModelToJson(ReputationUserModel data) =>
    json.encode(data.toJson());

class ReputationUserModel {
  int? status;
  ReputationUserData? data;
  String? message;

  ReputationUserModel({
    this.status,
    this.data,
    this.message,
  });

  factory ReputationUserModel.fromJson(Map<String, dynamic> json) =>
      ReputationUserModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ReputationUserData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ReputationUserData {
  String? styleId;
  String? userId;
  String? text;
  String? count;
  List<ReputationUserList>? userList;
  List<String>? inviteOption;

  String? isShowPurchaseView;
  String? isEnableSlider;
  String? relationWithLoginUser;

  int? isJourneyLicensePurchased;
  String? journeyLicensePurchaseText;

  ReputationUserData({
    this.styleId,
    this.userId,
    this.text,
    this.count,
    this.userList,
    this.inviteOption,
    this.isShowPurchaseView,
    this.isEnableSlider,
    this.relationWithLoginUser,
    this.isJourneyLicensePurchased,
    this.journeyLicensePurchaseText,
  });

  factory ReputationUserData.fromJson(Map<String, dynamic> json) =>
      ReputationUserData(
        styleId: json["style_id"],
        userId: json["user_id"],
        text: json["text"]?.toString(),
        count: json["count"]?.toString(),
        userList: json["user_list"] == null
            ? []
            : List<ReputationUserList>.from(
                json["user_list"]!.map((x) => ReputationUserList.fromJson(x))),
        inviteOption: json["invite_option"] == null
            ? []
            : List<String>.from(json["invite_option"]!.map((x) => x)),
        isShowPurchaseView: json["is_show_purchase_view"]?.toString(),
        isEnableSlider: json["is_enable_slider"]?.toString(),
        relationWithLoginUser: json["relation_with_loginUser"]?.toString(),
        isJourneyLicensePurchased: json["is_journey_license_purchased"] ?? 0,
        journeyLicensePurchaseText:
            json["journey_license_purchase_text"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "style_id": styleId,
        "user_id": userId,
        "text": text,
        "count": count,
        "user_list": userList == null
            ? []
            : List<dynamic>.from(userList!.map((x) => x.toJson())),
      };
}

class ReputationUserList {
  String? id;
  String? photo;
  String? nameInitial;
  String? name;
  String? position;
  String? email;
  String? relation;
  String? invitedDate;

  String? isShowInviteBtn;
  String? isEnableInviteBtn;
  String? isShowRemindBtn;
  String? isEnableRemindBtn;

  String? isShowMailBtn;
  String? isEnableMailBtn;

  String? mailContent;
  String? link;
  String? isInviteBtn;
  String? mailInviteeName;

  ReputationUserList(
      {this.id,
      this.photo,
      this.nameInitial,
      this.name,
      this.position,
      this.email,
      this.relation,
      this.invitedDate,
      this.isShowInviteBtn,
      this.isEnableInviteBtn,
      this.isShowRemindBtn,
      this.isEnableRemindBtn,
      this.isShowMailBtn,
      this.isEnableMailBtn,
      this.mailContent,
      this.link,
      this.isInviteBtn,
      this.mailInviteeName});

  factory ReputationUserList.fromJson(Map<String, dynamic> json) =>
      ReputationUserList(
        id: json["id"]?.toString(),
        photo: json["photo"]?.toString(),
        nameInitial: json["name_initial"]?.toString(),
        name: json["name"]?.toString(),
        position: json["position"]?.toString(),
        email: json["email"]?.toString(),
        relation: json["relation"]?.toString(),
        invitedDate: json["invited_date"]?.toString(),
        isShowInviteBtn: json["is_show_invite_btn"]?.toString(),
        isEnableInviteBtn: json["is_enable_invite_btn"]?.toString(),
        isShowRemindBtn: json["is_show_remind_btn"]?.toString(),
        isEnableRemindBtn: json["is_enable_remind_btn"]?.toString(),
        isShowMailBtn: json["is_show_mail_btn"]?.toString(),
        isEnableMailBtn: json["is_enable_mail_btn"]?.toString(),
        mailContent: json["mail_content"]?.toString(),
        link: json["link"]?.toString(),
        isInviteBtn: json["is_invite_btn"]?.toString(),
        mailInviteeName: json["mail_invitee_name"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "photo": photo,
        "name_initial": nameInitial,
        "name": name,
        "position": position,
        "email": email,
        "relation": relation,
        "invited_date": invitedDate,
        "is_show_invite_btn": isShowInviteBtn,
        "is_enable_invite_btn": isEnableInviteBtn,
        "is_show_remind_btn": isShowRemindBtn,
        "is_enable_remind_btn": isEnableRemindBtn,
        "is_show_mail_btn": isShowMailBtn,
        "is_enable_mail_btn": isEnableMailBtn,
        "mail_content": mailContent,
        "link": link,
      };
}
