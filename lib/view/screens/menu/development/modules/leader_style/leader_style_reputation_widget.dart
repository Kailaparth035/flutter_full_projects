import 'package:aspirevue/controller/development/leader_style_controller.dart';
import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/leader_style/leader_style_view_more_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_widget_for_reputation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LeaderStyleReputaionWidget extends StatefulWidget {
  const LeaderStyleReputaionWidget({
    super.key,
    required this.userId,
  });

  final String userId;
  @override
  State<LeaderStyleReputaionWidget> createState() =>
      _LeaderStyleReputaionWidgetState();
}

class _LeaderStyleReputaionWidgetState
    extends State<LeaderStyleReputaionWidget> {
  final _leaderStyleController = Get.find<LeaderStyleController>();
  bool _isViewMore = false;

  @override
  void initState() {
    super.initState();
    _leaderStyleController.getReputationFeedbackUserListUri(
        true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<LeaderStyleController>(builder: (leaderStyleController) {
      if (leaderStyleController.isLoadingReputationUser) {
        return const Center(child: CustomLoadingWidget());
      }
      if (leaderStyleController.isErrorReputationUser ||
          leaderStyleController.dataReputationUser == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              leaderStyleController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: leaderStyleController.isErrorReputationUser
                ? leaderStyleController.errorMsgReputationUser
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildConditionForPurchase(
            leaderStyleController.dataReputationUser!);
      }
    });
  }

  Widget _buildConditionForPurchase(ReputationUserData data) {
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

  Widget _buildView(ReputationUserData reputaionUserData) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _leaderStyleController.getReputationFeedbackUserListUri(
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
                    title: reputaionUserData.text.toString()),
                20.sp.sbh,
                buildRates(reputaionUserData.count.toString()),
                20.sp.sbh,
                ...reputaionUserData.userList!.map(
                  (e) => userListTileWithInviteAndRemindButton(
                    data: e,
                    styleId: reputaionUserData.styleId.toString(),
                    userId: reputaionUserData.userId.toString(),
                    onReaload: (val) async {
                      await _leaderStyleController
                          .getReputationFeedbackUserListUri(val, widget.userId);
                    },
                  ),
                ),
                buildInviteOtherTile(
                  list: reputaionUserData.inviteOption!,
                  firstText:
                      "* Add people to my community in order to gather feedback.",
                  btnTitle: "Invite others",
                  onTap: () {},
                ),
                10.sp.sbh,
                _isViewMore
                    ? LeaderStyleViewMoreRepurationWidget(
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
