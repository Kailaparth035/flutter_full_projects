import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/data/model/response/store/store_user_details.model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_expandable_widget.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/development/widgets/development_table_widget.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/store_common_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class CoachBoxWidget extends StatefulWidget {
  const CoachBoxWidget(
      {super.key,
      required this.data,
      required this.isSelected,
      required this.onExpand});
  final CoachUser data;
  final bool isSelected;
  final Function(String) onExpand;
  @override
  State<CoachBoxWidget> createState() => _CoachBoxWidgetState();
}

class _CoachBoxWidgetState extends State<CoachBoxWidget> {
  var storeController = Get.find<StoreController>();
  final TextEditingController _sessionTextController = TextEditingController();
  bool _isLoadingStoreUser = false;
  bool _isErrorStoreUser = false;
  String _errorMsgStoreUser = "";
  StoreUserDetailData? _storeUserData;

  bool _isExpanded = false;

  @override
  void didUpdateWidget(oldWidget) {
    if (_isExpanded != widget.isSelected) {
      setState(() {
        _isExpanded = widget.isSelected;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  _callApi(bool isShowLoading) async {
    try {
      if (isShowLoading) {
        setState(() {
          _isLoadingStoreUser = true;
        });
      }

      var res = await storeController
          .getCoachDetailsForOffer(widget.data.coachId.toString());

      setState(() {
        _storeUserData = res;
        _sessionTextController.text = _storeUserData!.sessionValue.toString();
      });
    } catch (e) {
      updateStoreUser(true, e.toString());
    } finally {
      if (isShowLoading) {
        setState(() {
          _isLoadingStoreUser = false;
        });
      }
    }
  }

  updateStoreUser(bool isError, String error) {
    setState(() {
      if (isError) {
        _errorMsgStoreUser = error;
      } else {
        _errorMsgStoreUser = "";
      }
      _isErrorStoreUser = isError;
    });
  }

  @override
  void initState() {
    _isExpanded = widget.isSelected;
    if (widget.isSelected) {
      _callApi(true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.5.sp),
          border: Border.all(
            color: AppColors.primaryColor,
            width: 0.8,
          ),
        ),
        child: CustomExpandableWidget(
          isOpened: _isExpanded,
          mainWidget: buildUserCard(
              widget.data.coachName.toString(), widget.data.photo.toString()),
          childWidget: _buildMainView(),
          onExpand: (bool isExpand) {
            if (isExpand == true) {
              setState(() {
                if (_storeUserData != null) {
                  _sessionTextController.text =
                      _storeUserData!.sessionValue.toString();
                }
                widget.onExpand(widget.data.coachId.toString());
              });
            }
            if (isExpand == true && _storeUserData == null) {
              _callApi(true);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMainView() {
    if (_isLoadingStoreUser) {
      return const Center(child: CustomLoadingWidget());
    }
    if (_isErrorStoreUser || _storeUserData == null) {
      return Padding(
        padding: EdgeInsets.only(top: 15.sp),
        child: Center(
          child: CustomErrorWidget(
            isNoData: _isErrorStoreUser == false,
            onRetry: () {
              _callApi(true);
            },
            text: _errorMsgStoreUser,
          ),
        ),
      );
    } else {
      return _buildCoachDetailView();
    }
  }

  _buildCoachDetailView() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.sp.sbh,
          buildTitle1("Bio"),
          3.sp.sbh,
          buildSubTitle1(parseHtmlString(_storeUserData!.bio.toString())),
          10.sp.sbh,
          buildTitle1("Coach Details"),
          3.sp.sbh,
          buildCoachListTile(
              AppImages.emailIc1, "Email", _storeUserData!.email.toString(),
              callback: (storeController) {}, onTapOutSide: () {}),
          buildCoachListTile(
              AppImages.earthIc, "Country", _storeUserData!.country.toString(),
              callback: (storeController) {}, onTapOutSide: () {}),
          buildCoachListTile(
              AppImages.earthIc, "State", _storeUserData!.state.toString(),
              callback: (storeController) {}, onTapOutSide: () {}),
          10.sp.sbh,
          buildTitle1("Specialties"),
          3.sp.sbh,
          buildSubTitle1(_storeUserData!.specialties.toString()),
          10.sp.sbh,
          buildTitle1("Booking"),
          3.sp.sbh,
          _buildBookingList(_storeUserData!.hourlyRate.toString()),
          _storeUserData!.sessionList!.isNotEmpty
              ? Column(
                  children: [
                    buildSubTitle1(
                        "Invest in your success and save \$ by purchasing additional coaching hours in advance."),
                    10.sp.sbh,
                    DevelopmentTableWidget(
                      title1: "Session",
                      title2: "Price",
                      title3: "Discount Price",
                      flax1: 3,
                      flax2: 2,
                      flax3: 3,
                      list: [
                        ..._storeUserData!.sessionList!.map(
                          (e) => {
                            "title1": e.title.toString(),
                            "title2": "\$${e.price.toString()}",
                            "title3": "\$${e.discountPrice.toString()}",
                          },
                        )
                      ],
                    ),
                    10.sp.sbh,
                  ],
                )
              : 0.sbh,
          5.sp.sbh,
          Align(
            alignment: Alignment.center,
            child: CustomButton2(
                buttonText: AppString.save,
                buttonColor: AppColors.labelColor40,
                radius: 15.sp,
                padding:
                    EdgeInsets.symmetric(vertical: 5.sp, horizontal: 17.sp),
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                onPressed: () {
                  CommonController.hideKeyboard(Get.context!);
                  if (_sessionTextController.text.isEmpty) {
                    showCustomSnackBar("Session value can't be blank",
                        statusMessage: "Validation Error",
                        color: AppColors.labelColor14);
                  } else {
                    _sessionValueUpdate(
                      storeController: storeController,
                      productId: "0",
                      type: _storeUserData!.type.toString(),
                      price: _storeUserData!.price.toString(),
                      isChecked: "1",
                      productType: _storeUserData!.product.toString(),
                      session: _sessionTextController.text,
                      promocode: _storeUserData!.promocode.toString(),
                      promoVerify: _storeUserData!.promoVerify.toString(),
                      feedbackHours: "0",
                      coachId: _storeUserData!.coachId.toString(),
                    );
                  }
                }),
          ),
          10.sp.sbh,
        ],
      ),
    );
  }

  Row _buildBookingList(String hourlyRate) {
    return Row(
      children: [
        Expanded(
          child: buildCoachListTile(
            AppImages.dollarIC,
            "Hourly Rate  ",
            "\$$hourlyRate",
            callback: (storeController) {},
            onTapOutSide: () {},
          ),
        ),
        Expanded(
          child: buildCoachListTile(AppImages.timeCircleIc, "Session", "",
              textController: _sessionTextController,
              isshowTextBox: true, callback: (storeController) {
            CommonController.hideKeyboard(context);
          }, onTapOutSide: () {}),
        )
      ],
    );
  }

  _sessionValueUpdate({
    required StoreController storeController,
    required String productId,
    required String type,
    required String price,
    required String isChecked,
    required String productType,
    required String session,
    required String promocode,
    required String promoVerify,
    required String feedbackHours,
    required String coachId,
  }) async {
    var res = await storeController.addToCardDetail(
        onReload: (loading) async {
          await storeController.getStoreUserDetails(coachId, false);
          await storeController.getCartDetailsUri(false, "make_payment");
        },
        productId: productId,
        type: type,
        price: price,
        isChecked: isChecked,
        productType: productType,
        session: session,
        promoCode: promocode,
        promoVerify: promoVerify,
        feedbackHours: feedbackHours,
        coachId: coachId,
        isShowSucessMessage: true,
        pageType: "make_payment");

    if (res == null) {
      _sessionTextController.clear();
    } else {
      Navigator.pop(Get.context!);
    }
  }
}
