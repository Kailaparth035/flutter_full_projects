import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/store_controller.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_buttom_2.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/store/store_first_page.dart';
import 'package:aspirevue/view/screens/menu/store/store_second_page.dart';
import 'package:aspirevue/view/screens/menu/store/store_third_page.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/time_line_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen(
      {super.key,
      required this.isFromMenu,
      this.onBackPress,
      this.currentIndex});
  final bool isFromMenu;
  final Function? onBackPress;
  final int? currentIndex;
  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  final _storeController = Get.find<StoreController>();
  @override
  void initState() {
    super.initState();
    if (widget.currentIndex != null) {
      _currentIndex = widget.currentIndex!;
    }
    if (widget.isFromMenu == true) {
      if (_storeController.storeData == null) {
        _storeController.getStoreDetails(true);
      }
    } else {
      _storeController.getStoreDetails(true);
    }
  }

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 1,
      onPopInvoked: (val) {
        if (_currentIndex == 1) {
        } else {
          setState(() {
            _currentIndex -= 1;
          });
        }
      },
      child: CommonController.getAnnanotaion(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: AppbarWithBackButton(
              bgColor: AppColors.white,
              appbarTitle: "Store",
              onbackPress: () {
                if (widget.isFromMenu) {
                  widget.onBackPress!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          backgroundColor: AppColors.white,
          body: _buildMainView(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton:
              GetBuilder<StoreController>(builder: (storeController) {
            if (storeController.isLoadingStore == true ||
                storeController.isErrorStore == true) {
              return 0.sbh;
            } else {
              return buildFloatingActionButton(
                  isShowCancelPromo: false, currentIndex: _currentIndex);
            }
          }),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        ),
      ),
    );
  }

  Widget _buildMainView() {
    return GetBuilder<StoreController>(builder: (storeController) {
      if (storeController.isLoadingStore) {
        return const Center(child: CustomLoadingWidget());
      }
      if (storeController.isErrorStore || storeController.storeData == null) {
        return Center(
          child: CustomErrorWidget(
            isNoData: storeController.isErrorStore == false,
            onRetry: () {
              storeController.getStoreDetails(true);
            },
            text: storeController.errorMsgStore,
          ),
        );
      } else {
        return _buildView(storeController.storeData!);
      }
    });
  }

  Widget _buildView(StoreDetailData data) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(data.walletAmount.toString()),
          _buildDivider(),
          5.sp.sbh,
          TimeLineForStore(
              currentIndex: _currentIndex,
              callback: (value) {
                setState(() {
                  _currentIndex = value;
                });
              }),
          Expanded(
            child: _currentIndex == 1
                ? StoreFirstPage(
                    onNext: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                  )
                : _currentIndex == 2
                    ? StoreSecondPage(
                        onNext: (bool isNext) {
                          if (isNext) {
                            setState(() {
                              _currentIndex += 1;
                            });
                          } else {
                            setState(() {
                              _currentIndex -= 1;
                            });
                          }
                        },
                      )
                    : StoreThirdPage(onNext: (int isNext) {
                        setState(() {
                          _currentIndex = isNext;
                        });
                      }),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String walletAmount) {
    return Row(
      children: [
        Expanded(
          child: CustomText(
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
            color: AppColors.labelColor14,
            text: "Order Summary",
            textAlign: TextAlign.start,
            fontFamily: AppString.manropeFontFamily,
          ),
        ),
        2.sp.sbw,
        walletAmount == "0" || walletAmount == ""
            ? 0.sbh
            : CustomButton2(
                buttonText: "\$$walletAmount",
                buttonColor: AppColors.secondaryColor,
                radius: 3.sp,
                padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 7.sp),
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                onPressed: () {}),
      ],
    );
  }

  Divider _buildDivider() {
    return const Divider(
      color: AppColors.labelColor,
      thickness: 1,
    );
  }
}
