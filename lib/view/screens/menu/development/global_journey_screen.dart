import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/graph_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_future_builder.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/my_connection/widgets/journy_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class GlobalJourneyScreen extends StatefulWidget {
  const GlobalJourneyScreen(
      {super.key,
      required this.developmentType,
      required this.userId,
      required this.userRole});
  final DevelopmentType developmentType;
  final String userId;
  final UserRole userRole;
  @override
  State<GlobalJourneyScreen> createState() => _GlobalJourneyStateScreen();
}

class _GlobalJourneyStateScreen extends State<GlobalJourneyScreen> {
  late Future<GraphDetailsData?> _futureCall;
  final _developmentController = Get.find<DevelopmentController>();

  @override
  void initState() {
    _reFreshData();
    super.initState();
  }

  _reFreshData() async {
    setState(() {
      String id = _getId();

      if (widget.developmentType == DevelopmentType.competencies) {
        _futureCall = _developmentController.getGraphCompentencyDetails(
            {"user_id": widget.userId, "style_id": id});
      } else {
        _futureCall = _developmentController
            .getGraphDetails({"user_id": widget.userId, "style_id": id});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: _getAppbarTitle(),
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        body: FutureBuildWidget(
          onRetry: () {
            _reFreshData();
          },
          future: _futureCall,
          child: (GraphDetailsData? data) {
            return _buildMainView(data);
          },
        ),
      ),
    );
  }

  String _getId() {
    if (widget.developmentType == DevelopmentType.workSkills) {
      return AppConstants.workSkillId;
    } else if (widget.developmentType == DevelopmentType.competencies) {
      return AppConstants.compentencyId;
    } else if (widget.developmentType == DevelopmentType.traits) {
      return AppConstants.traitsId;
    } else if (widget.developmentType == DevelopmentType.values1) {
      return AppConstants.valuesId;
    } else if (widget.developmentType == DevelopmentType.riskFactors) {
      return AppConstants.riskFactorsId;
    } else if (widget.developmentType == DevelopmentType.leaderStyle) {
      return AppConstants.leaderStyleId;
    } else if (widget.developmentType == DevelopmentType.characterStrengths) {
      return AppConstants.characterStengthID;
    } else if (widget.developmentType == DevelopmentType.emotions) {
      return AppConstants.emotionsId;
    } else if (widget.developmentType == DevelopmentType.cognitive) {
      return AppConstants.cognitiveId;
    } else if (widget.developmentType == DevelopmentType.behaviors) {
      return AppConstants.behaviousId;
    } else {
      return "";
    }
  }

  _getAppbarTitle() {
    if (widget.developmentType == DevelopmentType.workSkills) {
      return AppString.workSkills;
    } else if (widget.developmentType == DevelopmentType.competencies) {
      return AppString.competencies;
    } else if (widget.developmentType == DevelopmentType.traits) {
      return AppString.traits;
    } else if (widget.developmentType == DevelopmentType.values1) {
      return AppString.values;
    } else if (widget.developmentType == DevelopmentType.riskFactors) {
      return AppString.riskFactors;
    } else if (widget.developmentType == DevelopmentType.leaderStyle) {
      return AppString.leaderStyle;
    } else if (widget.developmentType == DevelopmentType.characterStrengths) {
      return AppString.characterStrengths;
    } else if (widget.developmentType == DevelopmentType.emotions) {
      return AppString.emotions;
    } else if (widget.developmentType == DevelopmentType.cognitive) {
      return AppString.cognitive;
    } else if (widget.developmentType == DevelopmentType.behaviors) {
      return AppString.behaviors;
    } else {
      '';
    }
  }

  SafeArea _buildMainView(GraphDetailsData? data) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildJournyTimeLine(data),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildJournyTimeLine(GraphDetailsData? data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.labelColor9.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10.sp),
      ),
      child: Column(
        children: [
          _buildJournyTimeListChild1(),
          const Divider(
            height: 1,
            color: AppColors.labelColor,
            thickness: 1,
          ),
          _buildJournyListTile2(data),
          const Divider(
            height: 1,
            color: AppColors.labelColor,
            thickness: 1,
          ),
          // 5.sp.sbh,
          JournyTimeLineChart(
              userRole: widget.userRole,
              userId: widget.userId,
              timelinedetails: data!.timelinedetails,
              developmentType: widget.developmentType)
        ],
      ),
    );
  }

  Column _buildJournyListTile2(GraphDetailsData? data) {
    return Column(
      children: [
        _buildUserListTile(data),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.sp.sbw,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.sp),
                  color: AppColors.labelColor25,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icStar,
                      height: 16.sp,
                    ),
                    10.sp.sbw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CustomText(
                              text: AppString.totalJourneyPoints,
                              textAlign: TextAlign.start,
                              color: AppColors.primaryColor,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          3.sp.sbh,
                          CustomText(
                            text: data!.totalJourneyPoints.toString(),
                            textAlign: TextAlign.start,
                            color: AppColors.white,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            10.sp.sbw,
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 5.sp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.sp),
                  color: AppColors.labelColor25,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.icTime,
                      height: 16.sp,
                    ),
                    10.sp.sbw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: CustomText(
                              text: AppString.journeyStarted,
                              textAlign: TextAlign.start,
                              color: AppColors.primaryColor,
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          3.sp.sbh,
                          CustomText(
                            text: "${data.totalJourneyTime.toString()} Min",
                            textAlign: TextAlign.start,
                            color: AppColors.white,
                            fontFamily: AppString.manropeFontFamily,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            10.sp.sbw,
          ],
        ),
        10.sp.sbh,
      ],
    );
  }

  Widget _buildUserListTile(GraphDetailsData? data) {
    return InkWell(
      onTap: () {
        // _navigate();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.sp),
        child: Row(
          children: [
            10.sp.sbw,
            CircleAvatar(
              backgroundColor: AppColors.labelColor27,
              radius: 20.sp,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                padding: EdgeInsets.all(1.sp),
                child: CircleAvatar(
                  backgroundColor: AppColors.white,
                  radius: 18.sp,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: CustomImage(
                      height: 60.sp,
                      width: 60.sp,
                      image: data!.photo.toString(),
                      // fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text:
                          "${data.firstName} ${data.lastName}’s ${_getType()}",
                      textAlign: TextAlign.start,
                      color: AppColors.labelColor8,
                      fontFamily: AppString.manropeFontFamily,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    // SizedBox(
                    //   height: 2.sp,
                    // ),
                    // CustomText(
                    //   text: AppString.completedSelfreflect,
                    //   textAlign: TextAlign.start,
                    //   color: AppColors.labelColor15,
                    //   maxLine: 3,
                    //   fontFamily: AppString.manropeFontFamily,
                    //   fontSize: 11.sp,
                    //   fontWeight: FontWeight.normal,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildJournyTimeListChild1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: AppString.journeyTimeline,
                textAlign: TextAlign.start,
                color: AppColors.labelColor25,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              // Image.asset(
              //   AppImages.icHorizontalMenu,
              //   width: 25.sp,
              // )
            ],
          ),
          5.sp.sbh,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(
              //   AppImages.icExlamation,
              //   width: 13.sp,
              // ),
              // 3.sp.sbw,
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "${AppString.trackyourprogressasyoudevelopyour} ${_getType()}",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontFamily: AppString.manropeFontFamily,
                          fontWeight: FontWeight.w500,
                          color: AppColors.hintColor,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _getType() {
    if (widget.developmentType == DevelopmentType.workSkills) {
      return AppString.workSkills;
    } else if (widget.developmentType == DevelopmentType.competencies) {
      return AppString.competencies;
    } else if (widget.developmentType == DevelopmentType.traits) {
      return AppString.traits;
    } else if (widget.developmentType == DevelopmentType.values1) {
      return AppString.values;
    } else if (widget.developmentType == DevelopmentType.riskFactors) {
      return AppString.riskFactors;
    } else if (widget.developmentType == DevelopmentType.leaderStyle) {
      return AppString.leaderStyle;
    } else if (widget.developmentType == DevelopmentType.characterStrengths) {
      return AppString.characterStrengths;
    } else if (widget.developmentType == DevelopmentType.emotions) {
      return AppString.emotions;
    } else if (widget.developmentType == DevelopmentType.cognitive) {
      return AppString.cognitive;
    } else if (widget.developmentType == DevelopmentType.behaviors) {
      return AppString.behaviors;
    } else {
      return "";
    }
  }

  // _navigate() {
  //   if (widget.developmentType == DevelopmentType.workSkills) {
  //     Get.to(() => WorkSkillModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.competencies) {
  //     Get.to(() => CompetencyModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.traits) {
  //     Get.to(() => TraitsModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.values1) {
  //     Get.to(() => ValuesModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.riskFactors) {
  //     Get.to(() => RiskFectorsModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.leaderStyle) {
  //     Get.to(() => LeaderStyleModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.characterStrengths) {
  //     Get.to(() => CharacterStrengthsModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.emotions) {
  //     Get.to(() => EmotionsModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.cognitive) {
  //     Get.to(() => CognitiveModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else if (widget.developmentType == DevelopmentType.behaviors) {
  //     Get.to(() => BehaviorsModuleScreen(
  //           userId: widget.userId,
  //           userRole: UserRole.self,
  //         ));
  //   } else {}
  // }
}
