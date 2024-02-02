import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/screens/menu/development/modules/cognitive/cognitive_aspirevue_training_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/cognitive/cognitive_assess_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/cognitive/cognitive_goal_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/cognitive/cognitive_self_reflection_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/traits/traits_elearning_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CognitiveModuleScreen extends StatefulWidget {
  const CognitiveModuleScreen(
      {super.key,
      this.tabName,
      required this.userId,
      required this.userRole,
      required this.isShowLearning});
  final String? tabName;
  final String userId;
  final UserRole userRole;
  final bool isShowLearning;
  @override
  State<CognitiveModuleScreen> createState() => _CognitiveModuleScreenState();
}

class _CognitiveModuleScreenState extends State<CognitiveModuleScreen>
    with TickerProviderStateMixin {
  TabController? _controller;
  List<DevelopmetTabModel> _titleList = [];

  @override
  void initState() {
    _titleList = [
      DevelopmetTabModel(
        isEnable: widget.userRole == UserRole.self ? true : false,
        title: AppConstants.selfReflection,
      ),
      DevelopmetTabModel(
        isEnable: widget.userRole == UserRole.self ? true : false,
        title: AppConstants.assess,
      ),
      DevelopmetTabModel(
        isEnable:
            widget.userRole == UserRole.self ? widget.isShowLearning : false,
        title: AppConstants.eLearning,
      ),
      DevelopmetTabModel(
        isEnable: widget.userRole == UserRole.self ? true : true,
        title: AppConstants.aspireVueTargeting,
      ),
      DevelopmetTabModel(
        isEnable: widget.userRole == UserRole.self ? true : true,
        title: AppConstants.goalAchievement,
      ),
    ];

    _titleList =
        _titleList.where((element) => element.isEnable == true).toList();

    _controller = TabController(
        length: _titleList.where((element) => element.isEnable == true).length,
        vsync: this,
        initialIndex:
            CommonController.getWidgetIndex(widget.tabName, _titleList),
        animationDuration: const Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Widget _getViewWidget(String title) {
    switch (title) {
      case AppConstants.selfReflection:
        return CognitiveSelfReflectionWidget(
          userId: widget.userId,
        );
      case AppConstants.assess:
        return CognitiveAssessWidget(
          userId: widget.userId,
        );

      case AppConstants.aspireVueTargeting:
        return CognitiveAspirevueTrainingWidget(
          userId: widget.userId,
        );

      case AppConstants.eLearning:
        return TraitsElearningWidget(
          styleId: AppConstants.cognitiveId,
          userId: widget.userId,
        );
      case AppConstants.goalAchievement:
        return CognitiveGoalWidget(
          userId: widget.userId,
        );

      default:
        return const Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: AppString.cognitive,
            bgColor: AppColors.white,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: _buildView(),
      ),
    );
  }

  DefaultTabController _buildView() {
    return DefaultTabController(
      length: _titleList
          .where((element) => element.isEnable == true)
          .toList()
          .length,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonController().buildTabbar(_controller, _titleList),
            5.sp.sbh,
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  ..._titleList
                      .where((element) => element.isEnable == true)
                      .map((e) => _getViewWidget(e.title)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
