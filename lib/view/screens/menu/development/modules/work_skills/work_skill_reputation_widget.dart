import 'package:aspirevue/controller/development/work_skill_controller.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_user_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/work_skills/work_skill_view_more_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_widget_for_reputation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WorkSkillReputaionWidget extends StatefulWidget {
  const WorkSkillReputaionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<WorkSkillReputaionWidget> createState() =>
      _WorkSkilReputaionWidgetState();
}

class _WorkSkilReputaionWidgetState extends State<WorkSkillReputaionWidget> {
  final _workSkillController = Get.find<WorkSkillController>();
  bool _isViewMore = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    _workSkillController.getReputationFeedbackUserListUri(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<WorkSkillController>(builder: (workSkillController) {
      if (workSkillController.isLoadingReputation) {
        return const Center(child: CustomLoadingWidget());
      }
      if (workSkillController.isErrorReputation ||
          workSkillController.dataReputation == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              workSkillController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: workSkillController.isErrorReputation
                ? workSkillController.errorMsgReputation
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildConditionForPurchase(workSkillController.dataReputation!);
      }
    });
  }

  Widget _buildConditionForPurchase(WorkSkillReputaionUserData data) {
    return Stack(
      children: [
        data.isShowPurchaseView == "1"
            ? const PurchaseWidgetForReputation()
            : _buildView(data),
        data.isJourneyLicensePurchased == 0
            ? PurchasePopupWidget(
                text: data.journeyLicensePurchaseText.toString(),
              )
            : 0.sbh
      ],
    );
    // return data.isShowPurchaseView == "1"
    //     ? const PurchaseWidgetForReputation()
    //     : _buildView(data);
  }

  Widget _buildView(WorkSkillReputaionUserData dataReputation) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () async {
          await _workSkillController.getReputationFeedbackUserListUri(
              true, widget.userId);
          setState(() {
            _isViewMore = false;
          });
        },
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          physics: const AlwaysScrollableScrollPhysics(),
          primary: true,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DevelopmentSelfReflectTitleWidget(
                    title: dataReputation.text.toString()),
                20.sp.sbh,
                buildRates(dataReputation.count.toString()),
                20.sp.sbh,
                ...dataReputation.userList!.map(
                  (e) => userListTileWithInviteAndRemindButton(
                    data: e,
                    styleId: dataReputation.styleId.toString(),
                    userId: dataReputation.userId.toString(),
                    onReaload: (val) async {
                      await _workSkillController
                          .getReputationFeedbackUserListUri(val, widget.userId);
                    },
                  ),
                ),
                buildInviteOtherTile(
                    list: dataReputation.inviteOption!,
                    firstText:
                        "* Add people to my community in order to gather feedback.",
                    btnTitle: "Invite others",
                    onTap: () {}),
                10.sp.sbh,
                _isViewMore
                    ? WorkSkillViewMoreWidget(
                        userId: widget.userId,
                      )
                    : buildViewMoreButtonWidget(onTap: () {
                        setState(() {
                          _isViewMore = !_isViewMore;
                        });
                      })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
