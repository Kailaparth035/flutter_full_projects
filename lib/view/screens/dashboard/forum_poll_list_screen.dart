import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_dropdown_for_message.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/forum_poll_listing_shimmer_widget.dart';
import 'package:aspirevue/view/screens/dashboard/widget/forum_poll_listtile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ForumPollListScreen extends StatefulWidget {
  const ForumPollListScreen({
    super.key,
  });

  @override
  State<ForumPollListScreen> createState() => _ForumPollListScreenState();
}

class _ForumPollListScreenState extends State<ForumPollListScreen> {
  final _insightStreamController = Get.find<InsightStreamController>();
  final _dashboardController = Get.find<DashboardController>();

  bool _isHashTagLoading = false;
  final _scrollcontroller = ScrollController();

  DropListModel _ddHashTagList = DropListModel([]);
  DropDownOptionItemMenu _ddHashTagValue =
      DropDownOptionItemMenu(id: null, title: AppString.selectHashtag);

  final DropListModel _ddFilterList = DropListModel([
    DropDownOptionItemMenu(id: null, title: AppString.responseFilter),
    DropDownOptionItemMenu(id: "1", title: AppString.alreadyAnswered),
    DropDownOptionItemMenu(id: "2", title: AppString.notAnsweredYet),
  ]);
  DropDownOptionItemMenu _ddFilterValue =
      DropDownOptionItemMenu(id: null, title: AppString.responseFilter);

  @override
  void initState() {
    super.initState();
    _getHashtagList();
    _scrollcontroller.addListener(_loadMore);
    loadData();
  }

  Future<void> loadData() async {
    _dashboardController.showAllForumPolls(
      true,
      search: _ddHashTagValue.id ?? "",
      filter: _ddFilterValue.id ?? "",
    );
  }

  void _loadMore() async {
    if (!_dashboardController.isnotMoreDataFPP) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_dashboardController.isLoadingFPP == false &&
            _dashboardController.isLoadMoreRunningFPP == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _dashboardController.pageNumberFPP += 1;
          await _dashboardController.showAllForumPolls(
            false,
            search: _ddHashTagValue.id ?? "",
            filter: _ddFilterValue.id ?? "",
          );
        }
      }
    }
  }

  Future _getHashtagList() async {
    try {
      if (mounted) {
        setState(() {
          _isHashTagLoading = true;
        });
      }
      List<HashtagData> result = await _insightStreamController.getHashtags();

      List<DropDownOptionItemMenu> hashtagList = [];
      hashtagList.add(
          DropDownOptionItemMenu(id: null, title: AppString.selectHashtag));
      for (var item in result) {
        hashtagList.add(DropDownOptionItemMenu(
            id: item.id.toString(), title: "#${item.title.toString()}"));
      }
      if (mounted) {
        setState(() {
          _ddHashTagList = DropListModel(hashtagList);
        });
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isHashTagLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppConstants.appBarHeight),
        child: AppbarWithBackButton(
          bgColor: AppColors.white,
          appbarTitle: AppString.forumPolls,
          onbackPress: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          _buildView(),
          _isHashTagLoading
              ? Container(
                  color: AppColors.black.withOpacity(0.1),
                  child: const Center(
                    child: CustomLoadingWidget(),
                  ),
                )
              : 0.sbh
        ],
      ),
    );
  }

  Widget _buildView() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.sp.sbh,
          _buildTitle(AppString.forumPolls),
          10.sp.sbh,
          _buildHasTagDD(),
          10.sp.sbh,
          _buildFilterDD(),
          Expanded(
            child: GetBuilder<DashboardController>(builder: (controller) {
              return _buildListing(controller);
            }),
          )
        ],
      ),
    );
  }

  Widget _buildListing(DashboardController controller) {
    return controller.isLoadingFPP == true
        ? const ForumPollListingShimmerWidget(count: 2)
        : controller.isErrorFPP == true
            ? Center(
                child: CustomErrorWidget(
                    onRetry: () {
                      loadData();
                    },
                    text: controller.errorMsgFPP),
              )
            : controller.listFPP.isEmpty
                ? Center(
                    child: CustomErrorWidget(
                        width: 20.sp,
                        isNoData: true,
                        onRetry: () {
                          loadData();
                        },
                        text: controller.errorMsgFPP),
                  )
                : RefreshIndicator(
                    onRefresh: () {
                      return loadData();
                    },
                    child: SingleChildScrollView(
                      controller: _scrollcontroller,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ...controller.listFPP.map(
                            (e) {
                              int index = controller.listFPP.indexOf(e);
                              bool isLast =
                                  index + 1 == controller.listFPP.length;

                              return ForumPollsListileWidget(
                                data: e,
                                isLast: isLast,
                                isLoadingLast: controller.isLoadMoreRunningFPP,
                              );
                            },
                          ),
                          AppConstants.screenHorizontalPadding.sbh
                        ],
                      ),
                    ),
                  );
  }

  CustomDropListForMessage _buildFilterDD() {
    return CustomDropListForMessage(
      _ddFilterValue.title,
      _ddFilterValue,
      _ddFilterList,
      (optionItem) {
        if (mounted) {
          setState(() {
            _ddFilterValue = optionItem;
          });
        }

        loadData();
      },
      fontSize: 12.sp,
      bgColor: AppColors.labelColor12,
      borderColor: AppColors.labelColor,
    );
  }

  Widget _buildHasTagDD() {
    return CustomDropListForMessage(
      _ddHashTagValue.title,
      _ddHashTagValue,
      _ddHashTagList,
      (optionItem) {
        if (mounted) {
          setState(() {
            _ddHashTagValue = optionItem;
          });
        }

        loadData();
      },
      fontSize: 12.sp,
      bgColor: AppColors.labelColor12,
      borderColor: AppColors.labelColor,
    );
  }

  Widget _buildTitle(String title) {
    return CustomText(
      text: title,
      textAlign: TextAlign.start,
      color: AppColors.labelColor8,
      fontFamily: AppString.manropeFontFamily,
      fontSize: 13.sp,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
