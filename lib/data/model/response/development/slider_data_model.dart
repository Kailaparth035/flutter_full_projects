class SliderData {
  int? areaId;
  String? areaName;
  String? leftMeaning;
  String? rightMeaning;
  String? styleId;
  String? idealScale;
  String? markingType;
  String? radioCount;
  String? stylrParentId;
  String? emotionType;
  String? peersIdealScale;
  String? superIdealScale;
  String? reportIdealScale;
  String? selfIdealScale;
  String? isMarked;
  String? radioType;
  String? scoreReflect;
  String? reflectId;
  String? surveyStatus;
  String? areaSection;
  String? feelingCount;
  String? reaslScale;
  String? reputScale;
  String? assessScale;
  String? discoveryScale;
  String? parentassessScale;
  String? score;
  String? ratingType;

  String? subObjIWill;

  SliderData({
    this.areaId,
    this.areaName,
    this.leftMeaning,
    this.rightMeaning,
    this.styleId,
    this.idealScale,
    this.markingType,
    this.radioCount,
    this.stylrParentId,
    this.emotionType,
    this.peersIdealScale,
    this.superIdealScale,
    this.reportIdealScale,
    this.selfIdealScale,
    this.isMarked,
    this.radioType,
    this.scoreReflect,
    this.reflectId,
    this.surveyStatus,
    this.areaSection,
    this.feelingCount,
    this.reaslScale,
    this.reputScale,
    this.assessScale,
    this.discoveryScale,
    this.parentassessScale,
    this.score,
    this.ratingType,
    this.subObjIWill,
  });

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        areaId: json["AreaId"],
        areaName: json["AreaName"]?.toString(),
        leftMeaning: json["LeftMeaning"]?.toString(),
        rightMeaning: json["RightMeaning"]?.toString(),
        styleId: json["style_id"]?.toString(),
        idealScale: json["IdealScale"]?.toString(),
        markingType: json["marking_type"]?.toString(),
        radioCount: json["radio_count"]?.toString(),
        stylrParentId: json["StylrParentId"]?.toString(),
        emotionType: json["emotion_type"]?.toString(),
        peersIdealScale: json["PeersIdealScale"]?.toString(),
        superIdealScale: json["SuperIdealScale"]?.toString(),
        reportIdealScale: json["ReportIdealScale"]?.toString(),
        selfIdealScale: json["SelfIdealScale"]?.toString(),
        isMarked: json["is_marked"]?.toString(),
        radioType: json["radio_type"]?.toString(),
        scoreReflect: json["score_reflect"]?.toString(),
        reflectId: json["reflect_id"]?.toString(),
        surveyStatus: json["survey_status"]?.toString(),
        areaSection: json["AreaSection"]?.toString(),
        feelingCount: json["feeling_count"]?.toString(),
        reaslScale: json["reaslScale"]?.toString(),
        reputScale: json["reputScale"]?.toString(),
        assessScale: json["assessScale"]?.toString(),
        discoveryScale: json["discoveryScale"]?.toString(),
        parentassessScale: json["parentassessScale"]?.toString(),
        score: json["score"]?.toString(),
        ratingType: json["rating_type"]?.toString(),
        subObjIWill: json["sub_obj_i_will"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "AreaId": areaId,
        "AreaName": areaName,
        "AreaSection": areaSection,
        "LeftMeaning": leftMeaning,
        "RightMeaning": rightMeaning,
        "style_id": styleId,
        "IdealScale": idealScale,
        "marking_type": markingType,
        "radio_count": radioCount,
        "StylrParentId": stylrParentId,
        "emotion_type": emotionType,
        "PeersIdealScale": peersIdealScale,
        "SuperIdealScale": superIdealScale,
        "ReportIdealScale": reportIdealScale,
        "SelfIdealScale": selfIdealScale,
        "is_marked": isMarked,
        "radio_type": radioType,
        "score_reflect": scoreReflect,
        "reflect_id": reflectId,
        "survey_status": surveyStatus,
        "feeling_count": feelingCount,
        "reaslScale": reaslScale,
        "reputScale": reputScale,
        "assessScale": assessScale,
        "discoveryScale": discoveryScale,
        "parentassessScale": parentassessScale,
        "score": score,
        "sub_obj_i_will": subObjIWill
      }..removeWhere((key, value) => value == null);
}
