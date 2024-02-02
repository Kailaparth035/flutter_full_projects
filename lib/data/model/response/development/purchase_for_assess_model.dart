class AssementInstruction {
  String? isPurchase;
  int? status;
  List<String>? listOfSubTitles;
  String? title2;
  String? title1;
  String? subTitle1;
  String? subTitle;
  List<Button>? buttons;

  AssementInstruction({
    this.isPurchase,
    this.status,
    this.listOfSubTitles,
    this.title2,
    this.title1,
    this.subTitle1,
    this.subTitle,
    this.buttons,
  });

  factory AssementInstruction.fromJson(Map<String, dynamic> json) =>
      AssementInstruction(
        isPurchase: json["is_purchase"],
        status: json["status"],
        listOfSubTitles: json["list_of_sub_titles"] == null
            ? []
            : List<String>.from(json["list_of_sub_titles"]!.map((x) => x)),
        title2: json["title_2"],
        title1: json["title_1"],
        subTitle1: json["sub_title_1"],
        subTitle: json["sub_title"],
        buttons: json["buttons"] == null
            ? []
            : List<Button>.from(
                json["buttons"]!.map((x) => Button.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_purchase": isPurchase,
        "status": status,
        "list_of_sub_titles": listOfSubTitles == null
            ? []
            : List<dynamic>.from(listOfSubTitles!.map((x) => x)),
        "title_2": title2,
        "title_1": title1,
        "sub_title_1": subTitle1,
        "sub_title": subTitle,
        "buttons": buttons == null
            ? []
            : List<dynamic>.from(buttons!.map((x) => x.toJson())),
      };
}

class Button {
  String? videoLink;
  String? buttonTitle;
  String? planKey;
  String? isEnableDisable;
  String? buttonTitleUrl;

  Button({
    this.videoLink,
    this.buttonTitle,
    this.planKey,
    this.isEnableDisable,
    this.buttonTitleUrl,
  });

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        videoLink: json["video_link"],
        buttonTitle: json["button_title"],
        planKey: json["plan_key"],
        isEnableDisable: json["is_enable_disable"],
        buttonTitleUrl: json["button_title_url"],
      );

  Map<String, dynamic> toJson() => {
        "video_link": videoLink,
        "button_title": buttonTitle,
        "plan_key": planKey,
        "is_enable_disable": isEnableDisable,
        "button_title_url": buttonTitleUrl,
      };
}
