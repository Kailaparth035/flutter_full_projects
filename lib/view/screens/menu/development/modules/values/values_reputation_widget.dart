import 'package:aspirevue/controller/development/values_controller.dart';
import 'package:aspirevue/data/model/response/development/reputation_user_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_slideup_and_fade_widget.dart';
import 'package:aspirevue/view/screens/menu/development/modules/values/values_view_more_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/common_development.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_self_reflect_title_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_popup_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/purchase_widget_for_reputation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ValuesReputaionWidget extends StatefulWidget {
  const ValuesReputaionWidget({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<ValuesReputaionWidget> createState() => _ValuesReputaionWidgetState();
}

class _ValuesReputaionWidgetState extends State<ValuesReputaionWidget> {
  final _valuesController = Get.find<ValuesController>();
  bool _isViewMore = false;

  @override
  void initState() {
    super.initState();
    _valuesController.getReputationFeedbackUserListUri(true, widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return _buildMainView();
  }

  Widget _buildMainView() {
    return GetBuilder<ValuesController>(builder: (valuesController) {
      if (valuesController.isLoadingReputationUser) {
        return const Center(child: CustomLoadingWidget());
      }
      if (valuesController.isErrorReputationUser ||
          valuesController.dataReputationUser == null) {
        return Center(
          child: CustomErrorWidget(
            width: 40.w,
            onRetry: () {
              valuesController.getReputationFeedbackUserListUri(
                  true, widget.userId);
            },
            text: valuesController.isErrorReputationUser
                ? valuesController.errorMsgReputationUser
                : AppString.somethingWentWrong,
          ),
        );
      } else {
        return _buildConditionForPurchase(valuesController.dataReputationUser!);
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

  Widget _buildView(ReputationUserData dataReputationUser) {
    return CustomSlideUpAndFadeWidget(
      child: RefreshIndicator(
        onRefresh: () {
          return _valuesController.getReputationFeedbackUserListUri(
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
                    title: dataReputationUser.text.toString()),
                20.sp.sbh,
                buildRates(dataReputationUser.count.toString()),
                20.sp.sbh,
                ...dataReputationUser.userList!.map(
                  (e) => userListTileWithInviteAndRemindButton(
                    data: e,
                    styleId: dataReputationUser.styleId.toString(),
                    userId: dataReputationUser.userId.toString(),
                    onReaload: (val) async {
                      // await widget.onReaload(val);

                      await _valuesController.getReputationFeedbackUserListUri(
                          val, widget.userId);
                    },
                  ),
                ),
                buildInviteOtherTile(
                    list: dataReputationUser.inviteOption!,
                    firstText:
                        "* Add people to my community in order to gather feedback.",
                    btnTitle: "Invite others",
                    onTap: () {}),
                10.sp.sbh,
                _isViewMore
                    ? ValuesViewMoreWidget(
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
