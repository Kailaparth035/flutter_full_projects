import 'package:aspirevue/controller/development/risk_factor_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/risk_fectors/risk_factor_view_more_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_widget_for_reputation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class RiskFectorReputaionWidget extends StatefulWidget {
  const RiskFectorReputaionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<RiskFectorReputaionWidget> createState() =>
      _RiskFectorReputaionWidgetState();
}

class _RiskFectorReputaionWidgetState extends State<RiskFectorReputaionWidget> {
  final _riskFactorController = Get.find<RiskFactorController>();
  bool _isViewMore = false;

  @override
  void initState() {
    super.initState();
    _riskFactorController.getReputationFeedbackUserListUri(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<RiskFactorController>(builder: (riskFactorController) {
      if (riskFactorController.isLoadingReputationUser) {
        return const Center(child: CustomLoadingWidget());
      }
      if (riskFactorController.isErrorReputationUser ||
          riskFactorController.dataReputationUser == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              riskFactorController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: riskFactorController.isErrorReputationUser
                ? riskFactorController.errorMsgReputationUser
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildConditionForPurchase(
            riskFactorController.dataReputationUser!);
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
    // return data.isShowPurchaseView == "1"
    //     ? const PurchaseWidgetForReputation()
    //     : _buildView(data);
  }

  Widget _buildView(ReputationUserData dataReputation) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _riskFactorController.getReputationFeedbackUserListUri(
              true, widget.userId);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(AppConstants.screenHorizontalPadding),
            child: GetBuilder<DevelopmentController>(builder: (controller) {
              return Column(
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
                        await _riskFactorController
                            .getReputationFeedbackUserListUri(
                                val, widget.userId);
                      },
                    ),
                  ),
                  buildInviteOtherTile(
                    list: dataReputation.inviteOption!,
                    firstText:
                        "* Add people to my community in order to gather feedback.",
                    btnTitle: "Invite others",
                    onTap: () {},
                  ),
                  10.sp.sbh,
                  _isViewMore
                      ? RiskFactorViewmoreWidget(
                          userId: widget.userId,
                        )
                      : buildViewMoreButtonWidget(onTap: () {
                          setState(() {
                            _isViewMore = !_isViewMore;
                          });
                        })
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
