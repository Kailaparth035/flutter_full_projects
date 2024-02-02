import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/data/model/response/enterprise/news_details_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_appbar_with_backbutton.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_loading_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/comment_widget.dart';
import 'package:aspirevue/view/screens/insight_stream/widget/write_comment_widget.dart';
import 'package:aspirevue/view/screens/menu/store/widgets/store_common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key, required this.newsId});
  final String newsId;
  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final _enterpriseController = Get.find<EnterpriseController>();

  @override
  void initState() {
    _enterpriseController.newsDetails(true, widget.newsId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonController.getAnnanotaion(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppConstants.appBarHeight),
          child: AppbarWithBackButton(
            bgColor: AppColors.white,
            appbarTitle: "Latest News",
            onbackPress: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: AppColors.white,
        body: _buildMainView(),
      ),
    );
  }

  Widget _buildMainView() {
    return GetBuilder<EnterpriseController>(builder: (storeController) {
      if (storeController.isLoadingNewsDetails) {
        return const Center(child: CustomLoadingWidget());
      }
      if (storeController.isErrorNewsDetails ||
          storeController.newsDetailsData == null) {
        return Center(
          child: CustomErrorWidget(
            isNoData: storeController.isErrorNewsDetails == false,
            onRetry: () {
              storeController.newsDetails(true, widget.newsId);
            },
            text: storeController.errorMsgNewsDetails,
          ),
        );
      } else {
        return _buildView(storeController.newsDetailsData!);
      }
    });
  }

  Widget _buildView(NewsDetailsData newsDetails) {
    return RefreshIndicator(
      onRefresh: () async =>
          await _enterpriseController.newsDetails(false, widget.newsId),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppConstants.screenHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(newsDetails.photo.toString()),
              _buildDescription(
                newsDetails.title.toString(),
                newsDetails.description.toString(),
              ),
              15.sp.sbh,
              CustomText(
                text: "Add Comments",
                textAlign: TextAlign.start,
                color: AppColors.labelColor14,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
              buildDivider(),
              5.sp.sbh,
              newsDetails.commentInputEnable == 1
                  ? Column(
                      children: [
                        WriteCommentWidget(
                          isNewsComment: true,
                          isOnlyTextComment: true,
                          postId: newsDetails.id.toString(),
                          parentCommentId: null,
                          onAddComment: () async {
                            await _enterpriseController.newsDetails(
                                false, widget.newsId);
                          },
                        ),
                        5.sp.sbh
                      ],
                    )
                  : 0.sbh,
              ...newsDetails.commentHtml!.map(
                (e) => CommentWidget(
                    isBlockedUser: newsDetails.commentInputEnable != 1,
                    isNewsComment: true,
                    isOnlyTextComment: true,
                    data: e,
                    postId: newsDetails.id.toString(),
                    onAddComment: () async {
                      await _enterpriseController.newsDetails(
                          false, widget.newsId);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDescription(String title, String desc) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          border: Border(
        left: BorderSide(color: AppColors.labelColor),
        right: BorderSide(color: AppColors.labelColor),
        bottom: BorderSide(color: AppColors.labelColor),
      )),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 5.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: title,
              textAlign: TextAlign.start,
              color: AppColors.labelColor8,
              fontFamily: AppString.manropeFontFamily,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
            5.sp.sbh,
            Html(
              data: desc,
              style: {
                "*": Style(
                  color: AppColors.labelColor15,
                  fontFamily: AppString.manropeFontFamily,
                  padding: HtmlPaddings.all(0),
                  margin: Margins.all(0),
                  fontSize: FontSize(9.sp),
                ),
              },
            )
            // CustomText(
            //   text: desc,
            //   textAlign: TextAlign.start,
            //   color: AppColors.labelColor5,
            //   fontFamily: AppString.manropeFontFamily,
            //   fontSize: 10.sp,
            //   fontWeight: FontWeight.w400,
            // ),
          ],
        ),
      ),
    );
  }

  CustomImage _buildImage(String image) {
    return CustomImage(
      height: 120.sp,
      width: double.infinity,
      image: image,
      fit: BoxFit.cover,
    );
  }
}
