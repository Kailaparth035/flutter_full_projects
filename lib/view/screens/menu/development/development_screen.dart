import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/data/model/card_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/util/svg_icons.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/global_journey_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/behaviors/behaviors_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/character_strengths/character_strengths_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/cognitive/cognitive_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/compentency/compentency_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/emotions/emotions_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/leader_style/leader_style_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/risk_fectors/risk_fectors_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/traits/traits_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/values/values_module_screen.dart';
import 'package:aspirevue/view/screens/menu/development/modules/work_skills/work_skill_module_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/journey/my_journy_screen.dart';
import 'package:aspirevue/view/screens/menu/my_connection/workplace_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

class DevelopmentScreen extends StatefulWidget {
  const DevelopmentScreen({super.key, this.userId});
  final String? userId;
  @override
  State<DevelopmentScreen> createState() => _DevelopmentScreenState();
}

class _DevelopmentScreenState extends State<DevelopmentScreen> {
  List<CardModel?> _menuList = [];

  @override
  void initState() {
    super.initState();

    _getMenuList();
  }

  _getMenuList() async {
    var res = await Get.find<DevelopmentController>().getDevelopmentList(
        widget.userId ??
            Get.find<ProfileSharedPrefService>().loginData.value.id.toString());
    if (res != null) {
      _menuList = [
        res.journeyShow == "1"
            ? CardModel(
                icon: SvgImage.myJourneyIc,
                heading: widget.userId == null
                    ? AppString.myJourneySummary
                    : "Their Journey Summary",
                badge: '0',
                id: '0',
                onTap: () {
                  if (widget.userId != null) {
                    Get.to(() => MyJournyScreen(
                          userId: widget.userId!,
                          userRole: UserRole.supervisor,
                        ));
                  } else {
                    Get.to(() => MyJournyScreen(
                          userRole: UserRole.self,
                          userId: Get.find<ProfileSharedPrefService>()
                              .loginData
                              .value
                              .id
                              .toString(),
                        ));
                  }
                })
            : null,
        CardModel(
            icon: SvgImage.workskillIc,
            heading: AppString.workSkills,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(WorkSkillModuleScreen(
                  isShowLearning: false,
                  userId: widget.userId!,
                  userRole: UserRole.supervisor,
                ));
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.workSkills,
                  userId: Get.find<ProfileSharedPrefService>()
                      .loginData
                      .value
                      .id
                      .toString(),
                ));
              }
            }),
        res.compentencyShow == "1"
            ? CardModel(
                icon: SvgImage.compentencyIc,
                heading: AppString.competencies,
                badge: '0',
                id: '0',
                onTap: () {
                  if (widget.userId != null) {
                    Get.to(CompetencyModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
                  } else {
                    Get.to(GlobalJourneyScreen(
                      userRole: UserRole.self,
                      developmentType: DevelopmentType.competencies,
                      userId: widget.userId ??
                          Get.find<ProfileSharedPrefService>()
                              .loginData
                              .value
                              .id
                              .toString(),
                    ));
                  }
                })
            : null,
        CardModel(
            icon: SvgImage.traitsIc,
            heading: AppString.traits,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(TraitsModuleScreen(
                  isShowLearning: false,
                  userId: widget.userId!,
                  userRole: UserRole.supervisor,
                ));
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.traits,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            }),
        CardModel(
            icon: SvgImage.valuesIc,
            heading: AppString.values,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(() => ValuesModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
                // Get.to();
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.values1,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            }),
        CardModel(
            icon: SvgImage.riskFactorIc,
            heading: AppString.riskFactors,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(() => RiskFectorsModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
                // Get.to();
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.riskFactors,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            }),
        CardModel(
            icon: SvgImage.leaderStyleIc,
            heading: AppString.leaderStyle,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(() => LeaderStyleModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.leaderStyle,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            }),
        CardModel(
            icon: SvgImage.characterStrengthIc,
            heading: AppString.characterStrengths,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(() => CharacterStrengthsModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.characterStrengths,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            }),
        CardModel(
            icon: SvgImage.emotionsIc,
            heading: AppString.emotions,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(() => EmotionsModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.emotions,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            }),
        CardModel(
            icon: SvgImage.cognitiveIc,
            heading: AppString.cognitive,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(() => CognitiveModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.cognitive,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            }),
        CardModel(
            icon: SvgImage.behaviourIc,
            heading: AppString.behaviors,
            badge: '0',
            id: '0',
            onTap: () {
              if (widget.userId != null) {
                Get.to(() => BehaviorsModuleScreen(
                      isShowLearning: false,
                      userId: widget.userId!,
                      userRole: UserRole.supervisor,
                    ));
              } else {
                Get.to(GlobalJourneyScreen(
                  userRole: UserRole.self,
                  developmentType: DevelopmentType.behaviors,
                  userId: widget.userId ??
                      Get.find<ProfileSharedPrefService>()
                          .loginData
                          .value
                          .id
                          .toString(),
                ));
              }
            })
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.development,

            // leftPadding: 10.sp,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.backgroundColor1,
        body:
            GetBuilder<DevelopmentController>(builder: (developmentController) {
          return developmentController.isLoadingMenu
              ? const Center(
                  child: CustomLoadingWidget(),
                )
              : developmentController.isErrorMenu
                  ? Center(
                      child: CustomErrorWidget(
                        onRetry: () {
                          _getMenuList();
                        },
                        text: developmentController.errorMsgMenu,
                      ),
                    )
                  : _buildView();
        }),
      ),
    );
  }

  SafeArea _buildView() {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenHorizontalPadding,
                    vertical: 10.sp),
                color: AppColors.labelColor12,
                child: AlignedGridView.count(
                  crossAxisCount: context.isTablet ? 3 : 2,
                  shrinkWrap: true,
                  mainAxisSpacing: 10.sp,
                  crossAxisSpacing: 10.sp,
                  primary: false,
                  itemCount: _menuList
                      .where((element) => element != null)
                      .toList()
                      .length,
                  itemBuilder: (context, index) => WorkplaceCards(
                    object: _menuList
                        .where((element) => element != null)
                        .toList()[index],
                  ),
                ),
              ),
              30.sp.sbh,
            ],
          ),
        ),
      ),
    );
  }
}

class DevelopmentCardModel {
  String icon;
  String title;

  Function onTap;

  DevelopmentCardModel({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
