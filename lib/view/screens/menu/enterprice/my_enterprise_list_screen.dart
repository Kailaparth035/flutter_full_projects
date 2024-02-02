import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/data/model/response/enterprise/enterprise_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/menu/enterprice/widget/news_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class MyEnterpriseListingScreen extends StatefulWidget {
  const MyEnterpriseListingScreen({super.key, required this.enterpriseId});
  final String enterpriseId;
  @override
  State<MyEnterpriseListingScreen> createState() =>
      _MyEnterpriseListingScreenState();
}

class _MyEnterpriseListingScreenState extends State<MyEnterpriseListingScreen> {
  final _scrollcontroller = ScrollController();
  final _enterPriseController = Get.find<EnterpriseController>();
  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollcontroller.addListener(_loadMore);
  }

  Future<void> _loadData() async {
    _enterPriseController.newsListing(true, widget.enterpriseId);
  }

  void _loadMore() async {
    if (!_enterPriseController.isnotMoreDataNews) {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        if (_enterPriseController.isLoadingNews == false &&
            _enterPriseController.isLoadMoreRunningNews == false &&
            _scrollcontroller.position.extentAfter < 300) {
          _enterPriseController
              .setPageNumber(_enterPriseController.pageNumber + 1);
          await _enterPriseController.newsListing(false, widget.enterpriseId);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            appbarTitle: "My Enterprise",
            bgColor: AppColors.white,
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding),
          child: _buildMainView(),
        ),
      ),
    );
  }

  _buildMainView() {
    return GetBuilder<EnterpriseController>(builder: (enterPriseController) {
      return enterPriseController.isLoadingNews == true
          ? const Center(child: CustomLoadingWidget())
          : enterPriseController.isErrorNews == true
              ? Center(
                  child: CustomErrorWidget(
                      onRetry: () {
                        enterPriseController.newsListing(
                            true, widget.enterpriseId);
                      },
                      text: enterPriseController.errorMsgNews),
                )
              : _buildView(enterPriseController);
    });
  }

  Widget _buildView(EnterpriseController enterPriseController) {
    return RefreshIndicator(
      onRefresh: () =>
          enterPriseController.newsListing(true, widget.enterpriseId),
      child: SingleChildScrollView(
        controller: _scrollcontroller,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            buildTitleWithBorder(
              "Latest News",
              Column(
                children: [
                  _buildListView(enterPriseController.newsList),
                  10.sp.sbh,
                  enterPriseController.isLoadMoreRunningNews
                      ? const Center(
                          child: CustomLoadingWidget(),
                        )
                      : 0.sbh
                ],
              ),
            ),
            10.sp.sbh,
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<EnterpriseNews> news) {
    if (news.isEmpty) {
      return Center(
        child: CustomNoDataFoundWidget(
          topPadding: 0,
          height: 50.sp,
        ),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: news.length,
        itemBuilder: (context, index) {
          return NewsListTileWidget(news: news[index]);
        },
      );
    }
  }
}
