import 'package:aspirevue/controller/development/character_strengths_controller.dart';
import 'package:aspirevue/data/model/response/development/work_skill_reputation_user_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/character_strengths/character_strengths_view_more_reputation_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_widget_for_reputation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CharacterStrengthReputaionWidget extends StatefulWidget {
  const CharacterStrengthReputaionWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<CharacterStrengthReputaionWidget> createState() =>
      _CharacterStrengthReputaionWidgetState();
}

class _CharacterStrengthReputaionWidgetState
    extends State<CharacterStrengthReputaionWidget> {
  final _characterStrengthsController =
      Get.find<CharacterStrengthsController>();
  bool _isViewMore = false;
  @override
  void initState() {
    super.initState();
    _characterStrengthsController.getReputationFeedbackUserListUri(
        true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<CharacterStrengthsController>(
        builder: (characterStrengthsController) {
      if (characterStrengthsController.isLoadingReputationUser) {
        return const Center(child: CustomLoadingWidget());
      }
      if (characterStrengthsController.isErrorReputationUser ||
          characterStrengthsController.dataReputationUser == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              characterStrengthsController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: characterStrengthsController.isErrorReputationUser
                ? characterStrengthsController.errorMsgReputationUser
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildConditionForPurchase(
            characterStrengthsController.dataReputationUser!);
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
  }

  Widget _buildView(WorkSkillReputaionUserData reputationUserData) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _characterStrengthsController.getReputationFeedbackUserListUri(
              true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DevelopmentSelfReflectTitleWidget(
                    title: reputationUserData.text.toString()),
                20.sp.sbh,
                buildRates(reputationUserData.count.toString()),
                20.sp.sbh,
                ...reputationUserData.userList!.map(
                  (e) => userListTileWithInviteAndRemindButton(
                    data: e,
                    styleId: reputationUserData.styleId.toString(),
                    userId: reputationUserData.userId.toString(),
                    onReaload: (val) async {
                      await _characterStrengthsController
                          .getReputationFeedbackUserListUri(val, widget.userId);
                    },
                  ),
                ),
                buildInviteOtherTile(
                    list: reputationUserData.inviteOption!,
                    firstText:
                        "* Add people to my community in order to gather feedback.",
                    btnTitle: "Invite others",
                    onTap: () {}),
                10.sp.sbh,
                _isViewMore
                    ? CharacterStrengthViewMoreReputaionWidget(
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
