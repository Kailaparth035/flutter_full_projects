import 'package:aspirevue/controller/development/emotions_controller.dart';
import 'package:aspirevue/data/model/response/development/emotions_reputaions_user_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/emotions/emotions_reputaion_view_more_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_widget_for_reputation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EmotionsReputaionWidget extends StatefulWidget {
  const EmotionsReputaionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<EmotionsReputaionWidget> createState() =>
      _EmotionsReputaionWidgetState();
}

class _EmotionsReputaionWidgetState extends State<EmotionsReputaionWidget> {
  final _emotionsController = Get.find<EmotionsController>();
  bool _isViewMore = false;

  @override
  void initState() {
    super.initState();
    _emotionsController.getReputationFeedbackUserListUri(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<EmotionsController>(builder: (emotionsController) {
      if (emotionsController.isLoadingReputationUser) {
        return const Center(child: CustomLoadingWidget());
      }
      if (emotionsController.isErrorReputationUser ||
          emotionsController.dataReputationUser == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              emotionsController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: emotionsController.isErrorReputationUser
                ? emotionsController.errorMsgReputationUser
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildConditionForPurchase(
            emotionsController.dataReputationUser!);
      }
    });
  }

  Widget _buildConditionForPurchase(EmotionsReputaionUserData data) {
    return Stack(children: [
      data.isShowPurchaseView == "1"
          ? const PurchaseWidgetForReputation()
          : _buildView(data),
      data.isJourneyLicensePurchased == 0
          ? PurchasePopupWidget(
              text: data.journeyLicensePurchaseText.toString(),
            )
          : 0.sbh
    ]);
  }

  Widget _buildView(EmotionsReputaionUserData emotionsUserData) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          setState(() {
            _isViewMore = false;
          });
          return _emotionsController.getReputationFeedbackUserListUri(
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
                    title: emotionsUserData.text.toString()),
                20.sp.sbh,
                buildRates(emotionsUserData.count.toString()),
                20.sp.sbh,
                ...emotionsUserData.userList!.map(
                  (e) => userListTileWithInviteAndRemindButton(
                    data: e,
                    styleId: emotionsUserData.styleId.toString(),
                    userId: emotionsUserData.userId.toString(),
                    onReaload: (val) async {
                      await _emotionsController
                          .getReputationFeedbackUserListUri(val, widget.userId);
                    },
                  ),
                ),
                buildInviteOtherTile(
                    list: emotionsUserData.inviteOption!,
                    firstText:
                        "* Add people to my community in order to gather feedback.",
                    btnTitle: "Invite others",
                    onTap: () {}),
                10.sp.sbh,
                _isViewMore
                    ? EmotionsReputaionViewmoreWidget(
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
