import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/offers_list_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/offer_listtile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AlertDialogForOffers extends StatefulWidget {
  const AlertDialogForOffers({
    super.key,
    required this.isPreCart,
  });

  final bool isPreCart;

  @override
  State<AlertDialogForOffers> createState() => _AlertDialogForOffersState();
}

class _AlertDialogForOffersState extends State<AlertDialogForOffers> {
  final _storeController = Get.find<StoreController>();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    _storeController.getOffers(true, widget.isPreCart);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      // onWillPop: () {
      //   return Future.value(true);
      // },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.sp))),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
        content: Container(
          constraints: BoxConstraints(maxHeight: context.getWidth),
          width: context.getWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildTitle(), _buildConditionView()],
            ),
          ),
        ),
      ),
    );
  }

  _buildConditionView() {
    return GetBuilder<StoreController>(builder: (storeController) {
      if (storeController.isLoadingStoreOffers) {
        return const Center(child: CustomLoadingWidget());
      }
      if (storeController.isErrorStoreOffers ||
          storeController.storeOffersData.isEmpty) {
        return Center(
          child: CustomErrorWidget(
            isNoData: storeController.isErrorStoreOffers == false,
            onRetry: () {
              _loadData();
            },
            isShowCustomMessage: true,
            text: storeController.isErrorStoreOffers == false
                ? "No Offers found!"
                : storeController.errorMsgStoreOffers,
          ),
        );
      } else {
        return _buildView(storeController.storeOffersData);
      }
    });
  }

  _buildView(List<OfferData> offers) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...offers.map(
            (e) => OfferListTileWidget(data: e, isPreCart: widget.isPreCart),
          )
        ]);
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
            color: AppColors.labelColor8,
            text: "Offers for you",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(2.sp),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.labelColor15.withOpacity(0.5)),
              child: Icon(
                Icons.close,
                weight: 3,
                size: 12.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
