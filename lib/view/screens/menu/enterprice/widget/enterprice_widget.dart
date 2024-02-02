import 'dart:math';

import 'package:aspirevue/controller/enterprise_controller.dart';
import 'package:aspirevue/data/model/response/enterprise/enterprise_model.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/common_widget.dart';
import 'package:aspirevue/view/base/custom_gradient_text.dart';
import 'package:aspirevue/view/base/loading_and_error/custom_error_widget.dart';
import 'package:aspirevue/view/screens/menu/enterprice/my_enterprise_list_screen.dart';
import 'package:aspirevue/view/screens/menu/enterprice/widget/news_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class EnterpriseNewsWidget extends StatefulWidget {
  const EnterpriseNewsWidget(
      {super.key,
      required this.isFromDetailsScreen,
      required this.enterpriseId});
  final bool isFromDetailsScreen;
  final String enterpriseId;
  @override
  State<EnterpriseNewsWidget> createState() => _EnterpriseNewsWidgetState();
}

class _EnterpriseNewsWidgetState extends State<EnterpriseNewsWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EnterpriseController>(builder: (enterPriseController) {
      return Column(
        children: [
          buildTitleWithBorder(
            "Latest News",
            Column(
              children: [
                _buildListView(enterPriseController.enterPriseData!.news!),
                widget.isFromDetailsScreen ||
                        enterPriseController.enterPriseData!.news!.isEmpty ||
                        enterPriseController.enterPriseData!.newsViewMoreLink ==
                            0
                    ? 0.sbh
                    : GestureDetector(
                        onTap: () {
                          Get.to(() => MyEnterpriseListingScreen(
                                enterpriseId: widget.enterpriseId,
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomGradientText(
                              fontWeight: FontWeight.w700,
                              text: "View More",
                              fontFamily: AppString.manropeFontFamily,
                              fontSize: 11.sp,
                            ),
                            Transform.translate(
                              offset: Offset(0, 1.sp),
                              child: Image.asset(
                                AppImages.arrowDownGradientIc,
                                height: 18.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                widget.isFromDetailsScreen ? 0.sbh : 10.sp.sbh,
              ],
            ),
          ),
          10.sp.sbh,
        ],
      );
    });
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
        itemCount: widget.isFromDetailsScreen == true
            ? news.length
            : min(news.length, 2),
        itemBuilder: (context, index) {
          return NewsListTileWidget(news: news[index]);
        },
      );
    }
  }
}
