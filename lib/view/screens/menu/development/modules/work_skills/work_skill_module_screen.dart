import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/screens/menu/development/modules/traits/traits_elearning_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/work_skills/work_skill_goal_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/work_skills/work_skill_reputation_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/work_skills/work_skill_self_reflection_widget.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WorkSkillModuleScreen extends StatefulWidget {
  const WorkSkillModuleScreen(
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
  State<WorkSkillModuleScreen> createState() => _WorkSkillModuleScreenState();
}

class _WorkSkillModuleScreenState extends State<WorkSkillModuleScreen>
    with TickerProviderStateMixin {
  TabController? _controller;
  List<DevelopmetTabModel> _tabList = [];

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  int currentIndex = 0;
  @override
  void initState() {
    _tabList = [
      DevelopmetTabModel(
        isEnable: widget.userRole == UserRole.self ? true : false,
        title: AppConstants.selfReflection,
      ),
      DevelopmetTabModel(
        isEnable: true,
        title: AppConstants.reputation,
      ),
      DevelopmetTabModel(
        isEnable:
            widget.userRole == UserRole.self ? widget.isShowLearning : false,
        title: AppConstants.eLearning,
      ),
      DevelopmetTabModel(
        isEnable: true,
        title: AppConstants.goalAchievement,
      ),
    ];

    _tabList = _tabList.where((element) => element.isEnable == true).toList();

    _controller = TabController(
        length: _tabList.where((element) => element.isEnable == true).length,
        vsync: this,
        initialIndex: CommonController.getWidgetIndex(widget.tabName, _tabList),
        animationDuration: const Duration(seconds: 1));

    super.initState();
  }

  Widget _getViewWidget(String title) {
    switch (title) {
      case AppConstants.selfReflection:
        return WorkSkillSelfReflectionWidget(
          userId: widget.userId,
        );
      case AppConstants.reputation:
        return WorkSkillReputaionWidget(
          userId: widget.userId,
        );
      case AppConstants.eLearning:
        return TraitsElearningWidget(
          userId: widget.userId,
          styleId: AppConstants.workSkillId,
        );
      case AppConstants.goalAchievement:
        return WorkSkillGoalWidget(
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
            appbarTitle: AppString.workSkills,
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

  Widget _buildView() {
    return DefaultTabController(
      length:
          _tabList.where((element) => element.isEnable == true).toList().length,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonController().buildTabbar(_controller, _tabList),
            5.sp.sbh,
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  ..._tabList
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
