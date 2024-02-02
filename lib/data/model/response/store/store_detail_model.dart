// To parse this JSON data, do
//
//     final storeDetailsModel = storeDetailsModelFromJson(jsonString);

import 'dart:convert';

StoreDetailsModel storeDetailsModelFromJson(String str) =>
    StoreDetailsModel.fromJson(json.decode(str));

String storeDetailsModelToJson(StoreDetailsModel data) =>
    json.encode(data.toJson());

class StoreDetailsModel {
  int? status;
  StoreDetailData? data;
  String? message;

  StoreDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory StoreDetailsModel.fromJson(Map<String, dynamic> json) =>
      StoreDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : StoreDetailData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class StoreDetailData {
  String? walletAmount;
  String? creditAmount;

  String? subscriptionType;
  String? session;
  String? promoVerify;
  String? promocode;
  String? feedbackHours;
  String? coachId;

  List<ActiveLicense>? activeLicenses;
  List<SubscriptionList>? subscriptionList;
  List<Package>? packages;
  List<BatteryBuilder>? batteryBuilder;
  List<IndividualTest>? individualTest;
  List<AssessmentReport>? assessmentReport;
  List<CoachUser>? coachUsers;

  String? isMakePayment;
  String? isCoachRequired;
  String? bannerImage;

  StoreDetailData(
      {this.subscriptionType,
      this.session,
      this.promoVerify,
      this.promocode,
      this.feedbackHours,
      this.activeLicenses,
      this.subscriptionList,
      this.packages,
      this.batteryBuilder,
      this.individualTest,
      this.assessmentReport,
      this.coachUsers,
      this.walletAmount,
      this.creditAmount,
      this.coachId,
      this.isMakePayment,
      this.isCoachRequired,
      this.bannerImage});

  factory StoreDetailData.fromJson(Map<String, dynamic> json) =>
      StoreDetailData(
        coachId: json["coach_id"]?.toString(),
        walletAmount: json["wallet_amount"]?.toString(),
        creditAmount: json["credit_amount"]?.toString(),
        subscriptionType: json["subscription_type"],
        session: json["session"],
        promoVerify: json["promo_verify"],
        promocode: json["promocode"],
        feedbackHours: json["feedback_hours"],
        activeLicenses: json["Active_Licenses"] == null
            ? []
            : List<ActiveLicense>.from(
                json["Active_Licenses"]!.map((x) => ActiveLicense.fromJson(x))),
        subscriptionList: json["subscription_list"] == null
            ? []
            : List<SubscriptionList>.from(json["subscription_list"]!
                .map((x) => SubscriptionList.fromJson(x))),
        packages: json["packages"] == null
            ? []
            : List<Package>.from(
                json["packages"]!.map((x) => Package.fromJson(x))),
        batteryBuilder: json["battery_builder"] == null
            ? []
            : List<BatteryBuilder>.from(json["battery_builder"]!
                .map((x) => BatteryBuilder.fromJson(x))),
        individualTest: json["individual_test"] == null
            ? []
            : List<IndividualTest>.from(json["individual_test"]!
                .map((x) => IndividualTest.fromJson(x))),
        assessmentReport: json["assessment_report"] == null
            ? []
            : List<AssessmentReport>.from(json["assessment_report"]!
                .map((x) => AssessmentReport.fromJson(x))),
        coachUsers: json["coach_users"] == null
            ? []
            : List<CoachUser>.from(
                json["coach_users"]!.map((x) => CoachUser.fromJson(x))),
        isMakePayment: json["is_make_payment"],
        isCoachRequired: json["is_Coach_required"],
        bannerImage: json["banner_image"],
      );

  Map<String, dynamic> toJson() => {
        "subscription_type": subscriptionType,
        "session": session,
        "promo_verify": promoVerify,
        "promocode": promocode,
        "feedback_hours": feedbackHours,
        "Active_Licenses": activeLicenses == null
            ? []
            : List<dynamic>.from(activeLicenses!.map((x) => x.toJson())),
        "subscription_list": subscriptionList == null
            ? []
            : List<dynamic>.from(subscriptionList!.map((x) => x.toJson())),
        "packages": packages == null
            ? []
            : List<dynamic>.from(packages!.map((x) => x.toJson())),
        "battery_builder": batteryBuilder == null
            ? []
            : List<dynamic>.from(batteryBuilder!.map((x) => x.toJson())),
        "individual_test": individualTest == null
            ? []
            : List<dynamic>.from(individualTest!.map((x) => x.toJson())),
        "assessment_report": assessmentReport == null
            ? []
            : List<dynamic>.from(assessmentReport!.map((x) => x.toJson())),
        "coach_users": coachUsers == null
            ? []
            : List<dynamic>.from(coachUsers!.map((x) => x.toJson())),
      };
}

class ActiveLicense {
  String? id;
  String? productName;
  String? type;

  ActiveLicense({
    this.id,
    this.productName,
    this.type,
  });

  factory ActiveLicense.fromJson(Map<String, dynamic> json) => ActiveLicense(
        id: json["id"]?.toString(),
        productName: json["product_name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "type": type,
      };
}

class AssessmentReport {
  String? name;
  String? description;
  String? price;
  String? priceLabel;
  String? id;
  String? isShow;
  String? isChecked;
  String? isDisable;
  String? isPurchase;
  String? isPurchaseText;
  String? type;
  String? productId;
  String? product;

  AssessmentReport({
    this.name,
    this.description,
    this.price,
    this.priceLabel,
    this.id,
    this.isShow,
    this.isChecked,
    this.isDisable,
    this.isPurchase,
    this.isPurchaseText,
    this.type,
    this.productId,
    this.product,
  });

  factory AssessmentReport.fromJson(Map<String, dynamic> json) =>
      AssessmentReport(
        name: json["name"],
        description: json["description"],
        price: json["price"],
        priceLabel: json["price_label"],
        id: json["id"]?.toString(),
        isShow: json["is_show"],
        isChecked: json["is_checked"],
        isDisable: json["is_disable"],
        isPurchase: json["is_purchase"],
        isPurchaseText: json["is_purchase_text"],
        type: json["type"],
        productId: json["product_id"]?.toString(),
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "price": price,
        "id": id,
        "is_show": isShow,
        "is_checked": isChecked,
        "is_disable": isDisable,
        "is_purchase": isPurchase,
        "is_purchase_text": isPurchaseText,
        "type": type,
        "product_id": productId,
        "product": product,
      };
}

class BatteryBuilder {
  String? productName;
  String? description;
  String? price;
  String? priceLabel;

  String? id;
  String? productId;
  String? totalTime;
  String? isToggleChecked;
  String? isChecked;
  String? isToggleShow;
  String? isPurchase;
  String? isPurchaseTxt;
  String? product;
  String? type;
  String? isToggleDisable;

  BatteryBuilder({
    this.productName,
    this.description,
    this.price,
    this.priceLabel,
    this.id,
    this.productId,
    this.totalTime,
    this.isToggleChecked,
    this.isChecked,
    this.isToggleShow,
    this.isPurchase,
    this.isPurchaseTxt,
    this.product,
    this.type,
    this.isToggleDisable,
  });

  factory BatteryBuilder.fromJson(Map<String, dynamic> json) => BatteryBuilder(
        productName: json["product_name"],
        description: json["description"],
        price: json["price"]?.toString(),
        priceLabel: json["price_label"]?.toString(),
        id: json["id"]?.toString(),
        productId: json["product_id"]?.toString(),
        totalTime: json["total_time"]?.toString(),
        isToggleChecked: json["is_toggle_checked"],
        isChecked: json["is_checked"],
        isToggleShow: json["is_toggle_show"],
        isPurchase: json["is_purchase"],
        isPurchaseTxt: json["is_purchase_txt"],
        product: json["product"],
        type: json["type"],
        isToggleDisable: json["is_toggle_disable"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "description": description,
        "price": price,
        "id": id,
        "product_id": productId,
        "total_time": totalTime,
        "is_toggle_checked": isToggleChecked,
        "is_checked": isChecked,
        "is_toggle_show": isToggleShow,
        "is_purchase": isPurchase,
        "is_purchase_txt": isPurchaseTxt,
        "product": product,
        "type": type,
        "is_toggle_disable": isToggleDisable,
      };
}

class CoachUser {
  String? coachName;
  String? coachId;
  String? photo;
  bool? isExpanded;

  CoachUser({this.coachName, this.coachId, this.photo, this.isExpanded});

  factory CoachUser.fromJson(Map<String, dynamic> json) => CoachUser(
        coachName: json["coach_name"],
        coachId: json["coach_id"]?.toString(),
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "coach_name": coachName,
        "coach_id": coachId,
        "photo": photo,
      };
}

class IndividualTest {
  String? id;
  String? productName;
  String? type;
  String? productId;
  String? feedbackDescription;
  String? videoUrl;
  String? lastPrice;
  String? price;
  String? priceLabel;
  String? isShow;
  String? isChecked;
  String? isDisable;
  String? isPurchase;
  String? isPurchaseText;
  String? product;

  IndividualTest({
    this.id,
    this.productName,
    this.type,
    this.productId,
    this.feedbackDescription,
    this.videoUrl,
    this.lastPrice,
    this.price,
    this.priceLabel,
    this.isShow,
    this.isChecked,
    this.isDisable,
    this.isPurchase,
    this.isPurchaseText,
    this.product,
  });

  factory IndividualTest.fromJson(Map<String, dynamic> json) => IndividualTest(
        id: json["id"]?.toString(),
        productName: json["product_name"],
        type: json["type"],
        productId: json["product_id"]?.toString(),
        feedbackDescription: json["feedback_description"],
        videoUrl: json["video_url"],
        lastPrice: json["last_price"],
        price: json["price"],
        priceLabel: json["price_label"],
        isShow: json["is_show"],
        isChecked: json["is_checked"],
        isDisable: json["is_disable"],
        isPurchase: json["is_purchase"],
        isPurchaseText: json["is_purchase_text"],
        product: json["product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "type": type,
        "product_id": productId,
        "feedback_description": feedbackDescription,
        "video_url": videoUrl,
        "last_price": lastPrice,
        "price": price,
        "is_show": isShow,
        "is_checked": isChecked,
        "is_disable": isDisable,
        "is_purchase": isPurchase,
        "is_purchase_text": isPurchaseText,
        "product": product,
      };
}

class Package {
  String? description;
  String? productId;
  String? type;
  String? product;
  String? packageType;
  String? productName;
  String? price;
  String? priceLabel;
  String? isActionShow;
  String? isActionChecked;
  String? isChecked;
  String? isActionEnable;
  String? isPurchase;
  String? text;
  String? totalTime;

  Package({
    this.description,
    this.productId,
    this.type,
    this.product,
    this.packageType,
    this.productName,
    this.price,
    this.priceLabel,
    this.isActionShow,
    this.isActionChecked,
    this.isChecked,
    this.isActionEnable,
    this.isPurchase,
    this.text,
    this.totalTime,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        description: json["description"],
        productId: json["product_id"]?.toString(),
        type: json["type"],
        product: json["product"],
        packageType: json["package_type"],
        productName: json["product_name"],
        price: json["price"],
        priceLabel: json["price_label"],
        isActionShow: json["is_action_show"],
        isActionChecked: json["is_action_checked"],
        isChecked: json["is_checked"],
        isActionEnable: json["is_action_enable"],
        isPurchase: json["is_purchase"],
        text: json["text"],
        totalTime: json["total_time"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "product_id": productId,
        "type": type,
        "product": product,
        "package_type": packageType,
        "product_name": productName,
        "price": price,
        "is_action_show": isActionShow,
        "is_action_checked": isActionChecked,
        "is_checked": isChecked,
        "is_action_enable": isActionEnable,
        "is_purchase": isPurchase,
        "text": text,
        "total_time": totalTime,
      };
}

class SubscriptionList {
  String? growthOption;
  String? id;
  String? tooltipDesc;
  String? availableTo;
  String? price;
  String? priceLabel;
  String? autoRenewShow;
  String? autoRenewChecked;
  String? renewalDate;
  String? isShow;
  String? isChecked;
  String? productId;
  String? product;
  String? text;
  String? type;
  String? isPurchase;

  SubscriptionList({
    this.growthOption,
    this.id,
    this.tooltipDesc,
    this.availableTo,
    this.price,
    this.priceLabel,
    this.autoRenewShow,
    this.autoRenewChecked,
    this.renewalDate,
    this.isShow,
    this.isChecked,
    this.productId,
    this.product,
    this.text,
    this.type,
    this.isPurchase,
  });

  factory SubscriptionList.fromJson(Map<String, dynamic> json) =>
      SubscriptionList(
        growthOption: json["growth_option"],
        id: json["id"]?.toString(),
        tooltipDesc: json["tooltip_desc"],
        availableTo: json["available_to"],
        price: json["price"],
        priceLabel: json["price_label"],
        autoRenewShow: json["auto_renew_show"],
        autoRenewChecked: json["auto_renew_checked"],
        renewalDate: json["renewal_date"],
        isShow: json["is_show"],
        isChecked: json["is_checked"],
        productId: json["product_id"],
        product: json["product"],
        text: json["text"],
        type: json["type"],
        isPurchase: json["is_purchase"],
      );

  Map<String, dynamic> toJson() => {
        "growth_option": growthOption,
        "id": id,
        "tooltip_desc": tooltipDesc,
        "available_to": availableTo,
        "price": price,
        "auto_renew_show": autoRenewShow,
        "auto_renew_checked": autoRenewChecked,
        "renewal_date": renewalDate,
        "is_show": isShow,
        "is_checked": isChecked,
        "product_id": productId,
        "product": product,
        "text": text,
        "type": type,
        "is_purchase": isPurchase,
      };
}
