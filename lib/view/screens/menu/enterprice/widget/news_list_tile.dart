import 'package:aspirevue/data/model/response/enterprise/enterprise_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/images.dart';
import 'package:aspirevue/util/sized_box_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_image.dart';
import 'package:aspirevue/view/base/custom_text.dart';
import 'package:aspirevue/view/screens/menu/enterprice/news_detail_screen.dart';
import 'package:aspirevue/view/screens/menu/enterprice/widget/read_more_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NewsListTileWidget extends StatelessWidget {
  const NewsListTileWidget({super.key, required this.news});
  final EnterpriseNews news;
  @override
  Widget build(BuildContext context) {
    return _buildNewListTile(news, context);
  }

  _buildNewListTile(EnterpriseNews news, context) {
    return InkWell(
      onTap: () {
        Get.to(() => NewsDetailsScreen(
              newsId: news.id.toString(),
            ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 9.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.labelColor,
          ),
          borderRadius: BorderRadius.circular(7.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.sp, vertical: 5.sp),
              child: CustomText(
                text: news.title.toString(),
                textAlign: TextAlign.start,
                color: AppColors.labelColor8,
                fontFamily: AppString.manropeFontFamily,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            _buildImageAndDescription(news),
            10.sp.sbh
          ],
        ),
      ),
    );
  }

  Widget _buildImageAndDescription(EnterpriseNews news) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomImage(
              height: 120.sp,
              image: news.photo.toString(),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReadMoreWidget(
                      text: news.description.toString(),
                      onTap: () {
                        Get.to(() => NewsDetailsScreen(
                              newsId: news.id.toString(),
                            ));
                      }),
                  5.sp.sbh,
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -0.5.sp),
                        child: Image.asset(
                          AppImages.calendarGreyIc,
                          height: 8.5.sp,
                        ),
                      ),
                      CustomText(
                        text: " ${news.createdDate.toString()}",
                        textAlign: TextAlign.start,
                        color: AppColors.labelColor2,
                        fontFamily: AppString.manropeFontFamily,
                        fontSize: 8.5.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
